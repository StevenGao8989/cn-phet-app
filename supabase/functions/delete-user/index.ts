// supabase/functions/delete-user/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 获取 JWT token（仅用于验证用户身份）
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      throw new Error('No authorization header')
    }
    
    const token = authHeader.replace('Bearer ', '')
    
    // 创建两个不同的 Supabase 客户端
    // 1. 用用户 JWT 验证身份
    const userClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: `Bearer ${token}` },
        },
      }
    )

    // 2. 用 service_role 执行删除操作（关键修复）
    const adminClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        global: {
          // 注意：这里不需要用户的 JWT，使用 service_role 的权限
          headers: { 
            'apikey': Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
            'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''}`
          },
        },
      }
    )

    // 验证用户身份（使用用户 JWT）
    const { data: { user }, error: authError } = await userClient.auth.getUser(token)
    if (authError || !user) {
      throw new Error('Invalid token')
    }

    console.log(`Starting deletion for user: ${user.id} (${user.email})`)

    // 先删除用户资料（使用 service_role 权限）
    try {
      const { error: profileError } = await adminClient
        .from('profiles')
        .delete()
        .eq('id', user.id)
      
      if (profileError) {
        console.error('Profile deletion error:', profileError)
        throw new Error(`Profile deletion failed: ${profileError.message}`)
      }
      console.log('Profile deleted successfully')
    } catch (profileError) {
      console.error('Profile deletion failed:', profileError)
      throw new Error(`Profile deletion failed: ${profileError.message}`)
    }

    // 再删除用户账号（使用 service_role 权限）
    try {
      const { error: userError } = await adminClient.auth.admin.deleteUser(user.id)
      if (userError) {
        console.error('User deletion error:', userError)
        throw new Error(`User deletion failed: ${userError.message}`)
      }
      console.log('User account deleted successfully')
    } catch (userError) {
      console.error('User deletion failed:', userError)
      throw new Error(`Failed to delete user: ${userError.message}`)
    }

    return new Response(
      JSON.stringify({ 
        message: 'User deleted successfully',
        userId: user.id,
        email: user.email,
        timestamp: new Date().toISOString()
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200 
      }
    )

  } catch (error) {
    console.error('Error in delete-user function:', error)
    return new Response(
      JSON.stringify({ 
        error: error.message,
        timestamp: new Date().toISOString()
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400 
      }
    )
  }
})
