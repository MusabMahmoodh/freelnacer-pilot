def:pub score_deal(job_posting: str) -> dict {
    text = (job_posting or "").lower();

    red_flags: list = [];
    green_flags: list = [];

    if not job_posting or len(job_posting.strip()) < 40 {
        red_flags = red_flags + ["Very short posting — likely missing key details."];
    }

    if "quick" in text or "simple" in text or "easy" in text {
        red_flags = red_flags + ["Uses 'quick/simple/easy' language — often underestimates scope."];
    }

    if "urgent" in text or "asap" in text {
        red_flags = red_flags + ["Urgent/ASAP — may indicate rushed decision-making."];
    }

    if "no budget" in text or "budget" in text and ("tbd" in text or "to be decided" in text) {
        red_flags = red_flags + ["Budget unclear or TBD."];
    }

    if "$" in text or "fixed" in text or "hour" in text or "hourly" in text {
        green_flags = green_flags + ["Mentions budget or pricing model."];
    }

    if "milestone" in text or "timeline" in text or "deadline" in text {
        green_flags = green_flags + ["Mentions timeline/milestones."];
    }

    if "requirements" in text or "deliverable" in text or "scope" in text {
        green_flags = green_flags + ["Mentions requirements/scope/deliverables."];
    }

    score: int = 70;
    score = score - (len(red_flags) * 12);
    score = score + (len(green_flags) * 8);

    if score < 0 { score = 0; }
    if score > 100 { score = 100; }

    verdict: str = "";
    swipe: str = "";
    if score >= 80 {
        verdict = "High-quality lead. Clear signals and lower risk.";
        swipe = "JUMP ON THIS NOW";
    } elif score >= 55 {
        verdict = "Decent opportunity, but clarify scope and budget before investing time.";
        swipe = "PROCEED (ASK QUESTIONS)";
    } else {
        verdict = "Too many red flags. Protect your time.";
        swipe = "SKIP THIS";
    }

    win_likelihood: int = 50;
    win_likelihood = win_likelihood + (len(green_flags) * 6) - (len(red_flags) * 5);
    if win_likelihood < 5 { win_likelihood = 5; }
    if win_likelihood > 95 { win_likelihood = 95; }

    return {
        "score": score,
        "swipe": swipe,
        "verdict": verdict,
        "win_likelihood": win_likelihood,
        "red_flags": red_flags,
        "green_flags": green_flags,
        "next_steps": [
            "Ask for budget range and decision timeline.",
            "Request 2–3 concrete examples of desired outcomes.",
            "Propose a paid discovery milestone if scope is unclear."
        ]
    };
}
