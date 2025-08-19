import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  try {
    const { prompt } = await req.json()

    const resp = await fetch("https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${Deno.env.get("ALIYUN_API_KEY")}`, // 从环境变量读取
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "qwen-max",   // 可以改成 qwen-plus / qwen-turbo
        input: { prompt }
      }),
    })

    const data = await resp.json()
    const reply = data.output?.text ?? "（无回复）"

    return new Response(JSON.stringify({ reply }), {
      headers: { "Content-Type": "application/json" },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 })
  }
})
