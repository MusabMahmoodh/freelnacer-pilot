"""Dashboard Service — mock stats and AI insights for the freelancer hub."""

import from services.projectService { mock_projects }

def:pub get_dashboard_stats() -> dict {
    projects = mock_projects;

    # Count by status
    active_count = len([p for p in projects if p["status"] == "active"]);
    proposed_count = len([p for p in projects if p["status"] == "proposed"]);
    lead_count = len([p for p in projects if p["status"] == "lead"]);
    delivered_count = len([p for p in projects if p["status"] == "delivered"]);
    paid_count = len([p for p in projects if p["status"] == "paid"]);
    total = len(projects);

    # Revenue from paid projects
    revenue_paid = sum([p["budget"] for p in projects if p["status"] == "paid"]);
    # Revenue from delivered (invoiced but not yet paid)
    revenue_pending = sum([p["budget"] for p in projects if p["status"] == "delivered"]);
    # Active project value
    active_value = sum([p["budget"] for p in projects if p["status"] == "active"]);

    # Win rate: (active + delivered + paid) / (active + delivered + paid + lead + proposed) * 100
    won = active_count + delivered_count + paid_count;
    total_considered = won + proposed_count + lead_count;
    win_rate = int((won / total_considered) * 100) if total_considered > 0 else 0;

    # Pending follow-ups: proposed projects with < 2 follow-ups
    pending_followups = len([
        p for p in projects
        if p["status"] == "proposed" and len(p["follow_ups"]) < 2
    ]);

    # Overdue follow-ups: proposed projects with 0 follow-ups
    overdue_followups = len([
        p for p in projects
        if p["status"] == "proposed" and len(p["follow_ups"]) == 0
    ]);

    # Upcoming deadlines
    upcoming_deadlines = [
        {"title": p["title"], "deadline": p["deadline"], "status": p["status"]}
        for p in projects
        if p["status"] == "active" and p["deadline"]
    ];

    # AI Insights (mock)
    ai_insights = [];

    if overdue_followups > 0 {
        ai_insights.append({
            "type": "warning",
            "icon": "alert",
            "message": str(overdue_followups) + " proposal" + ("s need" if overdue_followups > 1 else " needs") + " a follow-up — response rate drops 40% after 48 hours",
            "action": "Send follow-ups",
            "priority": 1
        });
    }

    ai_insights.append({
        "type": "revenue",
        "icon": "dollar",
        "message": "Projected revenue this month: $" + str(int(revenue_paid + revenue_pending + active_value)) + " across " + str(won + proposed_count) + " projects",
        "action": "View projects",
        "priority": 2
    });

    if win_rate > 0 {
        best_tone = "premium";
        ai_insights.append({
            "type": "analytics",
            "icon": "chart",
            "message": "Your win rate is " + str(win_rate) + "% — " + best_tone + " tone proposals convert 2.1x better than friendly",
            "action": "View analytics",
            "priority": 3
        });
    }

    if active_count > 0 {
        # Find the project with nearest deadline
        active_projects = [p for p in projects if p["status"] == "active" and p["deadline"]];
        if active_projects {
            nearest = active_projects[0];
            ai_insights.append({
                "type": "action",
                "icon": "zap",
                "message": "Next priority: " + nearest["title"] + " — deadline " + nearest["deadline"] + ". " + str(len([m for m in nearest["milestones"] if not m["completed"]])) + " milestones remaining",
                "action": "View project",
                "priority": 4
            });
        }
    }

    # Mood tracking
    engaged_count = len([
        p for p in projects
        if (p["client_mood"] == "excited" or p["client_mood"] == "interested")
        and p["status"] != "paid"
    ]);
    at_risk_count = len([
        p for p in projects
        if (p["client_mood"] == "hesitant" or p["client_mood"] == "cold")
        and p["status"] != "paid" and p["status"] != "delivered"
    ]);

    # Mood insights
    at_risk_projects = [
        p for p in projects
        if (p["client_mood"] == "hesitant" or p["client_mood"] == "cold")
        and (p["status"] == "proposed" or p["status"] == "active")
    ];
    hot_projects = [
        p for p in projects
        if p["client_mood"] == "excited"
        and (p["status"] == "proposed" or p["status"] == "active")
    ];

    if at_risk_projects {
        names = ", ".join([p["client_name"].split()[0] for p in at_risk_projects]);
        ai_insights.append({
            "type": "mood",
            "icon": "heart",
            "message": str(len(at_risk_projects)) + " client" + ("s" if len(at_risk_projects) > 1 else "") + " showing cooling interest (" + names + ") — send a personalized follow-up or adjust your approach",
            "action": "View projects",
            "priority": 2
        });
    }

    if hot_projects {
        names = ", ".join([p["client_name"].split()[0] for p in hot_projects]);
        ai_insights.append({
            "type": "mood",
            "icon": "heart",
            "message": names + " " + ("are" if len(hot_projects) > 1 else "is") + " highly engaged — push for a quick close while momentum is strong",
            "action": "View projects",
            "priority": 3
        });
    }

    # Recent projects (all, sorted by created_at desc — mock already in order)
    recent = [
        {
            "id": p["id"],
            "title": p["title"],
            "client_name": p["client_name"],
            "status": p["status"],
            "budget": p["budget"],
            "deadline": p["deadline"],
            "client_mood": p["client_mood"] or ""
        }
        for p in projects
    ];

    return {
        "active_projects": active_count,
        "proposed_count": proposed_count,
        "lead_count": lead_count,
        "delivered_count": delivered_count,
        "paid_count": paid_count,
        "revenue_paid": revenue_paid,
        "revenue_pending": revenue_pending,
        "active_value": active_value,
        "win_rate": win_rate,
        "pending_followups": pending_followups,
        "total_projects": total,
        "ai_insights": ai_insights,
        "recent_projects": recent,
        "upcoming_deadlines": upcoming_deadlines,
        "engaged_count": engaged_count,
        "at_risk_count": at_risk_count
    };
}
