const Groq = require('groq-sdk');

class AIService {
    constructor() {
        this.groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
    }

    async solveMathProblem(userPrompt) {
        const systemInstructions = `
            You are Axiom, a 13-year veteran STEM tutor. 
            Solve the user's math problem. 
            You MUST respond in strict JSON format with two keys:
            1. "text_solution": A step-by-step explanation using LaTeX for formulas.
            2. "spatial_data": A JSON object for Unity with "shape", "dimensions", and "color".

            Example for 'Volume of a cube with side 3':
            {
                "text_solution": "Step 1: Formula is V = s^3. \\nStep 2: V = 3^3 = 27.",
                "spatial_data": { "shape": "CUBE", "size": 3, "color": "#00FF00" }
            }
        `;

        try {
            const completion = await this.groq.chat.completions.create({
                messages: [
                    { role: "system", content: systemInstructions },
                    { role: "user", content: userPrompt }
                ],
                model: "llama3-8b-8192",
                response_format: { type: "json_object" } // Forces JSON output
            });

            return JSON.parse(completion.choices[0].message.content);
        } catch (error) {
            console.error("Axiom AI Error:", error);
            throw new Error("AI_SOLVER_FAILED");
        }
    }
}

module.exports = new AIService();
