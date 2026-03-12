const { GoogleGenerativeAI } = require("@google/generative-ai");

class AIService {
    constructor() {
        const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
        // Using Gemini 2.5 Flash-Lite: Extremely fast and free
        this.model = genAI.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    }

    async solveMathProblem(userPrompt) {
        const systemPrompt = `
            You are Axiom, a Senior STEM tutor. Solve the math problem. 
            Respond ONLY in strict JSON with these keys:
            1. "text_solution": Step-by-step LaTeX explanation.
            2. "spatial_data": JSON for Unity with "shape", "size", and "color".
        `;

        try {
            const result = await this.model.generateContent([systemPrompt, userPrompt]);
            const response = await result.response;
            const text = response.text();
            
            // Clean any potential markdown from Gemini's response
            const cleanJson = text.replace(/```json|```/g, "").trim();
            return JSON.parse(cleanJson);
        } catch (error) {
            console.error("Gemini Error:", error);
            throw new Error("AI_SOLVER_LIMIT_EXCEEDED");
        }
    }
}

module.exports = new AIService();