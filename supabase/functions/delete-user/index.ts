// supabase/functions/delete-user/index.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// 这些环境变量名要和 “secrets set” 保持一致
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const ANON_KEY      = Deno.env.get('SUPABASE_ANON_KEY')!   // 平常用的公钥
const SERVICE_ROLE  = Deno.env.get('SERVICE_ROLE_KEY')!     // ✅ 只能存在服务端/函数中使用

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 })
  }

  const authHeader = req.headers.get('Authorization') ?? ''
  if (!authHeader.startsWith('Bearer ')) {
    return new Response('Missing token', { status: 401 })
  }

  // ① 用“用户 JWT”绑定的 client 拿当前 user
  const userClient = createClient(SUPABASE_URL, ANON_KEY, {
    global: { headers: { Authorization: authHeader } },
    auth:   { persistSession: false },
  })
  const { data: { user }, error } = await userClient.auth.getUser()
  if (error || !user) {
    return new Response('Unauthorized', { status: 401 })
  }

  // ② 用 “service role” 的 admin client 来删除
  const admin = createClient(SUPABASE_URL, SERVICE_ROLE, {
    auth: { persistSession: false },
  })
  const { error: delErr } = await admin.auth.admin.deleteUser(user.id)
  if (delErr) {
    return new Response(`Delete failed: ${delErr.message}`, { status: 500 })
  }

  return new Response('ok', { status: 200 })
})
