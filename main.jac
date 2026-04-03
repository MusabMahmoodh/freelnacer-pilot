"""Fullstack Starter - Entry Point.

Imports server-side symbols and mounts the client app.
"""

import from service.appService { greet }
import from services.pitchService { generate_pitch }
import from services.projectService {
    get_projects,
    get_project,
    create_project,
    update_project_status,
    generate_proposal,
    generate_follow_up,
    add_follow_up,
    add_milestone,
    toggle_milestone,
    generate_milestones,
    create_invoice,
    update_invoice_status,
    analyze_mood
}
import from services.dashboardService { get_dashboard_stats }
import from services.dealScoreService { score_deal, get_deals, save_deal, delete_deal }

cl import from .index { ClientApp }

cl {
    def:pub app() -> JsxElement {
        return <ClientApp />;
    }
}
