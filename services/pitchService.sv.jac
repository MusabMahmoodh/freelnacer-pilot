"""PitchPerfect AI — proposal generation service (mock AI).

Exposes a single endpoint used by the client via f"sv import".
"""

# Public endpoint: positional args only from .cl.jac

def:pub generate_pitch(job_desc: str, tone: str) -> dict {
    jd = (job_desc or "").strip();
    t = (tone or "professional").strip().lower();

    if not jd {
        return {"error": "Please paste a job description."};
    }

    tone_label = "Professional";
    if t == "friendly" {
        tone_label = "Friendly";
    } elif t == "premium" {
        tone_label = "Premium";
    }

    # Lightweight heuristics for a believable score.
    words = len(jd.split());
    has_budget = ("$" in jd) or ("budget" in jd.lower()) or ("rate" in jd.lower());
    has_timeline = ("week" in jd.lower()) or ("month" in jd.lower()) or ("deadline" in jd.lower());
    has_stack = ("api" in jd.lower()) or ("react" in jd.lower()) or ("figma" in jd.lower()) or ("stripe" in jd.lower()) or ("shopify" in jd.lower());

    score = 62;
    if words > 120 { score += 10; }
    if has_budget { score += 10; }
    if has_timeline { score += 8; }
    if has_stack { score += 6; }
    if score > 96 { score = 96; }

    pricing_low = 900;
    pricing_high = 1800;
    if words > 180 {
        pricing_low = 1500;
        pricing_high = 3200;
    } elif words > 90 {
        pricing_low = 1200;
        pricing_high = 2400;
    }
    if t == "premium" {
        pricing_low = int(pricing_low * 1.35);
        pricing_high = int(pricing_high * 1.45);
    }

    proposal = (
        f"Hi there — thanks for sharing the details. I read your post carefully and I can help you ship this with speed and polish.\n\n"
        f"Here’s how I’d approach it (in a way that keeps you in control):\n"
        f"1) Quick alignment call + scope confirmation (15 minutes)\n"
        f"2) Build plan + milestones (so you always know what’s next)\n"
        f"3) Implementation + weekly check-ins\n"
        f"4) QA, handoff, and a short Loom walkthrough\n\n"
        f"Based on your description, I’d start by clarifying: target users, success metrics, and any existing assets (designs, docs, repo access).\n\n"
        f"Tone: {tone_label}. If you’d like, I can also share 2–3 relevant examples and a mini timeline after a quick reply.\n\n"
        f"If this sounds good, what’s your ideal deadline and do you have a preferred budget range?"
    );

    follow_up = (
        f"Quick follow-up — I can start this week. If you share your deadline and any must-have requirements, I’ll reply with a clear milestone plan and a fixed range."
    );

    return {
        "proposal": proposal,
        "pricing": f"${pricing_low}–${pricing_high} (project range)",
        "follow_up": follow_up,
        "success_score": score,
        "tone": t,
    };
}