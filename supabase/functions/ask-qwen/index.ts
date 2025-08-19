import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  try {
    const { prompt } = await req.json()

    const resp = await fetch("https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${Deno.env.get("ALIYUN_API_KEY")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "qwen-turbo",   // 推荐测试用 turbo，便宜又快
        messages: [{ role: "user", content: prompt }]
      }),
    })

    const data = await resp.json()
    const reply = data?.choices?.[0]?.message?.content ?? "（无回复）"

    return new Response(JSON.stringify({ reply }), {
      headers: { "Content-Type": "application/json" },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 })
  }
})


