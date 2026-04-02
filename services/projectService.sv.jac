"""Project Service — full lifecycle CRUD with mock AI generation.

All data is mock/hardcoded for now. Each function returns realistic
freelancer project data.
"""

# ── In-memory mock data store ──────────────────────────────────────

glob mock_projects: list = [
    {
        "id": "proj_001",
        "title": "Acme Corp Website Redesign",
        "client_name": "John Davidson",
        "client_email": "john@acmecorp.com",
        "description": "Full redesign of corporate website. Modern React frontend with headless CMS integration, responsive layouts, and SEO optimization. Must support 3 languages.",
        "status": "active",
        "budget": 4200.0,
        "deadline": "2026-04-28",
        "created_at": "2026-03-15",
        "platform": "Upwork",
        "proposal": {
            "text": "Hi John — thanks for sharing the details on the Acme redesign. I've done several corporate site rebuilds with React + headless CMS (Sanity, Strapi) and can deliver a polished, multilingual site within your timeline.\n\nHere's my approach:\n1. Discovery + wireframes (week 1)\n2. Design system + component library (week 2)\n3. CMS integration + i18n setup (week 3)\n4. Content migration + QA (week 4)\n\nI'll send async updates every 2 days and a Loom walkthrough at each milestone.",
            "pricing": "$3,800–$4,600 (project range)",
            "tone": "professional",
            "success_score": 84,
            "generated_at": "2026-03-15"
        },
        "follow_ups": [
            {"id": "fu_001", "message": "Hi John — just following up on my proposal. I'm available to start this week and happy to hop on a quick call to align on scope. Let me know!", "sent_at": "2026-03-17", "sequence": 1},
            {"id": "fu_002", "message": "Hey John — wanted to check in one more time. I've blocked out time in my schedule for this project. If you have any questions about the approach or pricing, I'm happy to discuss.", "sent_at": "2026-03-20", "sequence": 2}
        ],
        "milestones": [
            {"id": "ms_001", "title": "Discovery + wireframes", "due_date": "2026-04-07", "amount": 800.0, "completed": True},
            {"id": "ms_002", "title": "Design system + components", "due_date": "2026-04-14", "amount": 1200.0, "completed": True},
            {"id": "ms_003", "title": "CMS integration + i18n", "due_date": "2026-04-21", "amount": 1200.0, "completed": False},
            {"id": "ms_004", "title": "Content migration", "due_date": "2026-04-25", "amount": 500.0, "completed": False},
            {"id": "ms_005", "title": "QA + handoff", "due_date": "2026-04-28", "amount": 500.0, "completed": False}
        ],
        "invoice": None
    },
    {
        "id": "proj_002",
        "title": "StartupX MVP Development",
        "client_name": "Sarah Mitchell",
        "client_email": "sarah@startupx.io",
        "description": "Build an MVP for a SaaS analytics dashboard. React frontend with Python FastAPI backend, PostgreSQL database, Stripe billing integration, and basic auth.",
        "status": "proposed",
        "budget": 8500.0,
        "deadline": "2026-05-20",
        "created_at": "2026-03-28",
        "platform": "Direct",
        "proposal": {
            "text": "Hey Sarah — love the vision for StartupX. I've shipped 3 similar SaaS dashboards (analytics + billing) and can get your MVP live in under 6 weeks.\n\nMy plan:\n1. API design + auth scaffolding (week 1–2)\n2. Dashboard UI + data visualization (week 3–4)\n3. Stripe integration + billing flows (week 5)\n4. Testing + deploy + handoff (week 6)\n\nI'd suggest starting with a 15-min alignment call to nail down the core metrics you want to track.",
            "pricing": "$7,500–$9,500 (project range)",
            "tone": "friendly",
            "success_score": 78,
            "generated_at": "2026-03-28"
        },
        "follow_ups": [],
        "milestones": [],
        "invoice": None
    },
    {
        "id": "proj_003",
        "title": "GreenLeaf Brand Identity",
        "client_name": "Maria Chen",
        "client_email": "maria@greenleaf.eco",
        "description": "Logo design, brand guidelines, and social media templates for an eco-friendly product line. Need modern, clean aesthetic with earth tones.",
        "status": "lead",
        "budget": 0.0,
        "deadline": "",
        "created_at": "2026-04-01",
        "platform": "Fiverr",
        "proposal": None,
        "follow_ups": [],
        "milestones": [],
        "invoice": None
    },
    {
        "id": "proj_004",
        "title": "TechBlog API Migration",
        "client_name": "Alex Rivera",
        "client_email": "alex@techblog.dev",
        "description": "Migrate REST API from Express to FastAPI. 28 endpoints, PostgreSQL, Redis caching, JWT auth. Need zero-downtime migration strategy.",
        "status": "delivered",
        "budget": 3600.0,
        "deadline": "2026-03-25",
        "created_at": "2026-02-20",
        "platform": "Upwork",
        "proposal": {
            "text": "Hi Alex — great scope doc. I've done 4 Express-to-FastAPI migrations and can handle this cleanly with a parallel-run strategy (both APIs live during transition).\n\nApproach:\n1. Endpoint audit + FastAPI scaffolding (week 1)\n2. Core endpoints migration (week 2–3)\n3. Redis + auth layer (week 4)\n4. Parallel testing + cutover (week 5)\n\nZero-downtime is my default — I'll set up feature flags so you can switch per-endpoint.",
            "pricing": "$3,200–$4,000 (project range)",
            "tone": "professional",
            "success_score": 91,
            "generated_at": "2026-02-20"
        },
        "follow_ups": [
            {"id": "fu_003", "message": "Hi Alex — following up on my proposal for the API migration. Happy to walk through the parallel-run strategy on a call if that would help.", "sent_at": "2026-02-22", "sequence": 1}
        ],
        "milestones": [
            {"id": "ms_006", "title": "Endpoint audit + scaffolding", "due_date": "2026-02-27", "amount": 700.0, "completed": True},
            {"id": "ms_007", "title": "Core endpoints migration", "due_date": "2026-03-13", "amount": 1200.0, "completed": True},
            {"id": "ms_008", "title": "Redis + auth layer", "due_date": "2026-03-20", "amount": 900.0, "completed": True},
            {"id": "ms_009", "title": "Parallel testing + cutover", "due_date": "2026-03-25", "amount": 800.0, "completed": True}
        ],
        "invoice": {
            "id": "inv_001",
            "invoice_number": "INV-2026-004",
            "items": "Endpoint audit: $700, Core migration: $1200, Redis + auth: $900, Testing + cutover: $800",
            "total": 3600.0,
            "status": "sent",
            "issued_date": "2026-03-26",
            "due_date": "2026-04-09",
            "paid_date": ""
        }
    },
    {
        "id": "proj_005",
        "title": "CloudSync Mobile App",
        "client_name": "David Park",
        "client_email": "david@cloudsync.app",
        "description": "React Native mobile app for file sync service. Push notifications, offline support, background uploads.",
        "status": "paid",
        "budget": 6200.0,
        "deadline": "2026-03-10",
        "created_at": "2026-01-15",
        "platform": "Direct",
        "proposal": {
            "text": "Hi David — exciting project. I've built 5 React Native apps with offline-first architecture and can deliver a polished file sync client.\n\nTimeline:\n1. Architecture + push notification setup (week 1–2)\n2. Core sync UI + background uploads (week 3–4)\n3. Offline mode + conflict resolution (week 5–6)\n4. Polish + App Store prep (week 7)\n\nI'll use Expo for fast iteration and WatermelonDB for offline storage.",
            "pricing": "$5,500–$6,800 (project range)",
            "tone": "professional",
            "success_score": 88,
            "generated_at": "2026-01-15"
        },
        "follow_ups": [
            {"id": "fu_004", "message": "Hi David — just checking in on the proposal. I can start next week if the timeline works for you.", "sent_at": "2026-01-17", "sequence": 1}
        ],
        "milestones": [
            {"id": "ms_010", "title": "Architecture + push setup", "due_date": "2026-01-29", "amount": 1500.0, "completed": True},
            {"id": "ms_011", "title": "Core sync UI + uploads", "due_date": "2026-02-12", "amount": 2000.0, "completed": True},
            {"id": "ms_012", "title": "Offline mode + conflicts", "due_date": "2026-02-26", "amount": 1700.0, "completed": True},
            {"id": "ms_013", "title": "Polish + App Store", "due_date": "2026-03-10", "amount": 1000.0, "completed": True}
        ],
        "invoice": {
            "id": "inv_002",
            "invoice_number": "INV-2026-002",
            "items": "Architecture: $1500, Core UI: $2000, Offline mode: $1700, Polish: $1000",
            "total": 6200.0,
            "status": "paid",
            "issued_date": "2026-03-11",
            "due_date": "2026-03-25",
            "paid_date": "2026-03-22"
        }
    }
];


# ── Project CRUD ───────────────────────────────────────────────────

def:pub get_projects(status_filter: str) -> list {
    f = (status_filter or "").strip().lower();
    if f and f != "all" {
        return [p for p in mock_projects if p["status"] == f];
    }
    return mock_projects;
}

def:pub get_project(project_id: str) -> dict {
    for p in mock_projects {
        if p["id"] == project_id {
            return p;
        }
    }
    return {"error": "Project not found"};
}

def:pub create_project(title: str, client_name: str, client_email: str, description: str, budget: float, deadline: str) -> dict {
    new_id = "proj_" + str(len(mock_projects) + 1).zfill(3);
    project = {
        "id": new_id,
        "title": title,
        "client_name": client_name,
        "client_email": client_email,
        "description": description,
        "status": "lead",
        "budget": budget,
        "deadline": deadline,
        "created_at": "2026-04-02",
        "platform": "",
        "proposal": None,
        "follow_ups": [],
        "milestones": [],
        "invoice": None
    };
    mock_projects.append(project);
    return project;
}

def:pub update_project_status(project_id: str, new_status: str) -> dict {
    for p in mock_projects {
        if p["id"] == project_id {
            p["status"] = new_status;
            return p;
        }
    }
    return {"error": "Project not found"};
}


# ── Proposal Generation (mock AI) ─────────────────────────────────

def:pub generate_proposal(project_id: str, tone: str) -> dict {
    project = get_project(project_id);
    if "error" in project {
        return project;
    }

    t = (tone or "professional").strip().lower();
    desc = project["description"] or "";
    client = project["client_name"] or "there";
    words = len(desc.split());

    # Score heuristics
    score = 62;
    if words > 60 { score += 10; }
    if "$" in desc or "budget" in desc.lower() { score += 10; }
    if "week" in desc.lower() or "deadline" in desc.lower() { score += 8; }
    if "api" in desc.lower() or "react" in desc.lower() { score += 6; }
    if score > 96 { score = 96; }

    # Pricing
    pricing_low = 900;
    pricing_high = 1800;
    if words > 80 {
        pricing_low = 1500;
        pricing_high = 3200;
    } elif words > 40 {
        pricing_low = 1200;
        pricing_high = 2400;
    }
    if t == "premium" {
        pricing_low = int(pricing_low * 1.35);
        pricing_high = int(pricing_high * 1.45);
    }
    if project["budget"] > 0 {
        pricing_low = int(project["budget"] * 0.85);
        pricing_high = int(project["budget"] * 1.15);
    }

    greeting = "Hi " + client.split()[0];
    if t == "friendly" {
        greeting = "Hey " + client.split()[0];
    } elif t == "premium" {
        greeting = "Hello " + client.split()[0];
    }

    proposal_text = (
        greeting + " — thanks for sharing the details. I read through the scope carefully and I'm confident I can deliver this with quality and speed.\n\n"
        "Here's how I'd approach it:\n"
        "1) Quick alignment call + scope confirmation (15 min)\n"
        "2) Build plan + milestones so you always know what's next\n"
        "3) Implementation with async updates every 2–3 days\n"
        "4) QA, handoff, and a walkthrough of everything delivered\n\n"
        "I've handled similar projects before and can start within a few days of alignment. "
        "What's your ideal timeline and preferred way to communicate?"
    );

    result = {
        "text": proposal_text,
        "pricing": "$" + str(pricing_low) + "–$" + str(pricing_high) + " (project range)",
        "tone": t,
        "success_score": score,
        "generated_at": "2026-04-02"
    };

    # Save to project
    for p in mock_projects {
        if p["id"] == project_id {
            p["proposal"] = result;
            if p["status"] == "lead" {
                p["status"] = "proposed";
            }
        }
    }

    return result;
}


# ── Follow-ups (mock AI) ──────────────────────────────────────────

def:pub generate_follow_up(project_id: str, sequence: int) -> dict {
    project = get_project(project_id);
    if "error" in project {
        return project;
    }

    client_first = (project["client_name"] or "there").split()[0];
    seq = sequence or 1;

    if seq == 1 {
        msg = "Hi " + client_first + " — just following up on my proposal. I'm available to start this week and happy to hop on a quick call to discuss any questions about the approach or timeline. Let me know!";
    } elif seq == 2 {
        msg = "Hey " + client_first + " — wanted to check in one more time. I've kept time blocked for this project in my schedule. If there's anything I can clarify about scope, pricing, or process, I'm here. No pressure either way!";
    } else {
        msg = "Hi " + client_first + " — sending a final check-in. If the timing isn't right, totally understand. If things change down the road, feel free to reach out — I'd be happy to help whenever you're ready.";
    }

    return {"message": msg, "sequence": seq};
}

def:pub add_follow_up(project_id: str, message: str) -> dict {
    for p in mock_projects {
        if p["id"] == project_id {
            new_id = "fu_" + str(len(p["follow_ups"]) + 100);
            seq = len(p["follow_ups"]) + 1;
            fu = {
                "id": new_id,
                "message": message,
                "sent_at": "2026-04-02",
                "sequence": seq
            };
            p["follow_ups"].append(fu);
            if p["status"] == "proposed" {
                p["status"] = "proposed";
            }
            return fu;
        }
    }
    return {"error": "Project not found"};
}


# ── Milestones ─────────────────────────────────────────────────────

def:pub add_milestone(project_id: str, title: str, due_date: str, amount: float) -> dict {
    for p in mock_projects {
        if p["id"] == project_id {
            new_id = "ms_" + str(len(p["milestones"]) + 100);
            ms = {
                "id": new_id,
                "title": title,
                "due_date": due_date,
                "amount": amount,
                "completed": False
            };
            p["milestones"].append(ms);
            return ms;
        }
    }
    return {"error": "Project not found"};
}

def:pub toggle_milestone(project_id: str, milestone_id: str) -> dict {
    for p in mock_projects {
        if p["id"] == project_id {
            for ms in p["milestones"] {
                if ms["id"] == milestone_id {
                    ms["completed"] = not ms["completed"];
                    return ms;
                }
            }
        }
    }
    return {"error": "Milestone not found"};
}

def:pub generate_milestones(project_id: str) -> list {
    project = get_project(project_id);
    if "error" in project {
        return [];
    }
    budget = project["budget"] or 3000.0;
    return [
        {"title": "Discovery + planning", "due_date": "2026-04-10", "amount": round(budget * 0.15, 0)},
        {"title": "Core implementation", "due_date": "2026-04-18", "amount": round(budget * 0.40, 0)},
        {"title": "Integration + testing", "due_date": "2026-04-24", "amount": round(budget * 0.30, 0)},
        {"title": "QA + handoff", "due_date": "2026-04-28", "amount": round(budget * 0.15, 0)}
    ];
}


# ── Invoice ────────────────────────────────────────────────────────

def:pub create_invoice(project_id: str, items: str, total: float, due_date: str) -> dict {
    for p in mock_projects {
        if p["id"] == project_id {
            inv_num = "INV-2026-" + str(len(mock_projects) + 10);
            invoice = {
                "id": "inv_" + str(len(mock_projects) + 10),
                "invoice_number": inv_num,
                "items": items,
                "total": total,
                "status": "draft",
                "issued_date": "2026-04-02",
                "due_date": due_date,
                "paid_date": ""
            };
            p["invoice"] = invoice;
            return invoice;
        }
    }
    return {"error": "Project not found"};
}

def:pub update_invoice_status(project_id: str, invoice_id: str, status: str) -> dict {
    for p in mock_projects {
        if p["id"] == project_id and p["invoice"] and p["invoice"]["id"] == invoice_id {
            p["invoice"]["status"] = status;
            if status == "paid" {
                p["invoice"]["paid_date"] = "2026-04-02";
                p["status"] = "paid";
            }
            return p["invoice"];
        }
    }
    return {"error": "Invoice not found"};
}
