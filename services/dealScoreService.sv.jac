glob mock_deals: list = [
    {
        "id": "deal_001",
        "title": "React Dashboard Build",
        "job_posting": "Looking for an experienced React developer to build a dashboard with charts, filters, and export features. Budget is $2,500. Timeline: 3 weeks. Must have experience with Recharts or Chart.js. Deliverables include wireframes, source code, and deployment.",
        "score": 86,
        "swipe": "JUMP ON THIS NOW",
        "verdict": "High-quality lead. Clear signals and lower risk.",
        "win_likelihood": 68,
        "risk_level": "Low",
        "red_flags": [],
        "green_flags": [
            "Mentions budget or pricing model.",
            "Mentions timeline/milestones.",
            "Mentions requirements/scope/deliverables."
        ],
        "next_steps": [
            "Ask for budget range and decision timeline.",
            "Request 2\u20133 concrete examples of desired outcomes.",
            "Propose a paid discovery milestone if scope is unclear."
        ],
        "scored_at": "2026-03-28"
    },
    {
        "id": "deal_002",
        "title": "Quick Logo Fix",
        "job_posting": "Need someone to quickly fix our logo, simple job should be easy and done ASAP.",
        "score": 34,
        "swipe": "SKIP THIS",
        "verdict": "Too many red flags. Protect your time.",
        "win_likelihood": 35,
        "risk_level": "High",
        "red_flags": [
            "Very short posting \u2014 likely missing key details.",
            "Uses 'quick/simple/easy' language \u2014 often underestimates scope.",
            "Urgent/ASAP \u2014 may indicate rushed decision-making."
        ],
        "green_flags": [],
        "next_steps": [
            "Ask for budget range and decision timeline.",
            "Request 2\u20133 concrete examples of desired outcomes.",
            "Propose a paid discovery milestone if scope is unclear."
        ],
        "scored_at": "2026-03-30"
    }
];

def:pub get_deals() -> list {
    return mock_deals;
}

def:pub save_deal(title: str, job_posting: str, score_result: dict) -> dict {
    new_id = "deal_" + str(len(mock_deals) + 1).zfill(3);

    score_val = score_result.get("score", 0);
    risk_level = "High";
    if score_val >= 80 {
        risk_level = "Low";
    } elif score_val >= 55 {
        risk_level = "Medium";
    }

    deal = {
        "id": new_id,
        "title": title,
        "job_posting": job_posting,
        "score": score_result.get("score", 0),
        "swipe": score_result.get("swipe", ""),
        "verdict": score_result.get("verdict", ""),
        "win_likelihood": score_result.get("win_likelihood", 0),
        "risk_level": risk_level,
        "red_flags": score_result.get("red_flags", []),
        "green_flags": score_result.get("green_flags", []),
        "next_steps": score_result.get("next_steps", []),
        "scored_at": "2026-04-03"
    };
    mock_deals.insert(0, deal);
    return deal;
}

def:pub delete_deal(deal_id: str) -> dict {
    for (i, d) in enumerate(mock_deals) {
        if d["id"] == deal_id {
            mock_deals.pop(i);
            return {"success": True};
        }
    }
    return {"error": "Deal not found"};
}

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
