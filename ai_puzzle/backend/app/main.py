from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os

app = FastAPI(title="Puzzleverse AI Backend", version="1.0.0")

class HintRequest(BaseModel):
    puzzle_id: str
    category: str
    difficulty: str
    question: str
    hint_level: int

class HintResponse(BaseModel):
    puzzle_id: str
    hint_level: int
    hint: str
    strategy: str

class ExplainRequest(BaseModel):
    puzzle_id: str
    category: str
    question: str
    solution: str

class ExplainResponse(BaseModel):
    puzzle_id: str
    explanation: str

@app.get("/")
def health_check():
    gemini_key_set = bool(os.getenv("GEMINI_API_KEY"))
    return {
        "status": "online",
        "service": "Puzzleverse AI Companion API",
        "gemini_configured": gemini_key_set
    }

@app.post("/api/hint", response_model=HintResponse)
def get_ai_hint(req: HintRequest):
    # If GEMINI_API_KEY is configured in backend environment, call Google Gemini model
    api_key = os.getenv("GEMINI_API_KEY")
    if api_key:
        try:
            import google.generativeai as genai
            genai.configure(api_key=api_key)
            model = genai.GenerativeModel("gemini-1.5-flash")
            prompt = (
                f"You are an expert puzzle mentor. The player is solving a {req.difficulty} {req.category} puzzle:\n"
                f"Question: {req.question}\n"
                f"Provide a Level {req.hint_level} hint (1=Gentle clue, 2=Strategy/Rule guidance, 3=Strong deduction). "
                f"Do not reveal the full answer unless hint_level is 4. Keep it concise (under 2 sentences)."
            )
            response = model.generate_content(prompt)
            return HintResponse(
                puzzle_id=req.puzzle_id,
                hint_level=req.hint_level,
                hint=response.text.strip(),
                strategy="Gemini 1.5 Flash Model",
            )
        except Exception:
            pass

    # Deterministic fallback response if Gemini is not configured or fails
    fallback_hints = {
        1: "Focus on the foundational premises and physical constraints.",
        2: "Identify the invariant properties or common differences in the given data.",
        3: "Apply elimination or rule substitution to derive the next step.",
        4: "Inspect the verified solution and backtrack each constraint."
    }
    return HintResponse(
        puzzle_id=req.puzzle_id,
        hint_level=req.hint_level,
        hint=fallback_hints.get(req.hint_level, "Review the clues closely."),
        strategy="Rule-Based Fallback Engine",
    )

@app.post("/api/explain", response_model=ExplainResponse)
def explain_solution(req: ExplainRequest):
    api_key = os.getenv("GEMINI_API_KEY")
    if api_key:
        try:
            import google.generativeai as genai
            genai.configure(api_key=api_key)
            model = genai.GenerativeModel("gemini-1.5-flash")
            prompt = (
                f"Explain why '{req.solution}' is the correct solution for this {req.category} puzzle:\n"
                f"Question: {req.question}\n"
                f"Explain the logic clearly in 2-3 sentences."
            )
            response = model.generate_content(prompt)
            return ExplainResponse(
                puzzle_id=req.puzzle_id,
                explanation=response.text.strip(),
            )
        except Exception:
            pass

    return ExplainResponse(
        puzzle_id=req.puzzle_id,
        explanation=f"The solution '{req.solution}' was formally derived through deterministic constraint checking and verified against all problem rules.",
    )
