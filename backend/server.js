const express = require('express');
const { OpenAI } = require('openai');
const app = express();

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

app.post('/api/v1/voice-command', async (req, res) => {
    try {
        // High-performance streaming logic for AI response
        const completion = await openai.chat.completions.create({
            model: "gpt-4o",
            messages: [{ role: "user", content: "Action required: Analyze voice intent." }],
            stream: true,
        });

        res.setHeader('Content-Type', 'text/event-stream');
        for await (const chunk of completion) {
            res.write(chunk.choices[0]?.delta?.content || "");
        }
        res.end();
    } catch (error) {
        console.error("Architectural Error in Voice Pipeline:", error);
        res.status(500).json({ status: "error", code: "VOICE_PIPELINE_FAILED" });
    }
});

app.listen(3000, () => console.log('Astra Backend running on port 3000'));
