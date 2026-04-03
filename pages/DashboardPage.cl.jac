import from "@jac/runtime" { useNavigate, useEffect }
import from ..hooks.useDashboard { useDashboard }

def:pub page() -> JsxElement {
    data = useDashboard();
    navigate = useNavigate();

    stats = data["stats"] or {};
    loading = data["loading"];

    def on_mount() -> None {
        data["loadStats"]();
    }
    useEffect(on_mount, []);

    # Extract stat values to simple vars for JSX
    active_count = str(stats["active_projects"] or 0);
    proposed_count = str(stats["proposed_count"] or 0);
    lead_count = str(stats["lead_count"] or 0);
    delivered_count = str(stats["delivered_count"] or 0);
    paid_count = str(stats["paid_count"] or 0);
    total_projects = str(stats["total_projects"] or 0);
    revenue_paid = str(int(stats["revenue_paid"] or 0));
    revenue_pending = str(int(stats["revenue_pending"] or 0));
    win_rate = str(stats["win_rate"] or 0);
    pending_fups = str(stats["pending_followups"] or 0);
    engaged_count = str(stats["engaged_count"] or 0);
    at_risk_count = str(stats["at_risk_count"] or 0);
    won_count = str((stats["active_projects"] or 0) + (stats["delivered_count"] or 0) + (stats["paid_count"] or 0));

    ai_insights = stats["ai_insights"] or [];
    recent_projects = stats["recent_projects"] or [];

    def go_projects() -> None { navigate("/projects"); }
    def go_new_project() -> None { navigate("/projects?new=1"); }

    def go_to_project(project_id: str) -> None {
        navigate("/projects/" + project_id);
    }

    def badge_class(status: str) -> str {
        if status == "lead" { return "pp-badge-lead"; }
        if status == "proposed" { return "pp-badge-proposed"; }
        if status == "active" { return "pp-badge-active"; }
        if status == "delivered" { return "pp-badge-delivered"; }
        if status == "paid" { return "pp-badge-paid"; }
        return "pp-badge-draft";
    }

    def insight_icon_class(itype: str) -> str {
        if itype == "warning" { return "pp-insight-icon-warning"; }
        if itype == "revenue" { return "pp-insight-icon-revenue"; }
        if itype == "analytics" { return "pp-insight-icon-analytics"; }
        if itype == "action" { return "pp-insight-icon-action"; }
        if itype == "mood" { return "pp-insight-icon-mood"; }
        return "pp-insight-icon-analytics";
    }

    def render_insight_icon(itype: str) -> JsxElement {
        if itype == "warning" {
            return (
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <circle cx="12" cy="12" r="10" />
                    <line x1="12" y1="8" x2="12" y2="12" />
                    <line x1="12" y1="16" x2="12.01" y2="16" />
                </svg>
            );
        }
        if itype == "revenue" {
            return (
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <line x1="12" y1="1" x2="12" y2="23" />
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
                </svg>
            );
        }
        if itype == "analytics" {
            return (
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <line x1="18" y1="20" x2="18" y2="10" />
                    <line x1="12" y1="20" x2="12" y2="4" />
                    <line x1="6" y1="20" x2="6" y2="14" />
                </svg>
            );
        }
        if itype == "mood" {
            return (
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                </svg>
            );
        }
        return (
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" />
            </svg>
        );
    }

    def render_insight(insight: dict) -> JsxElement {
        itype = insight["type"] or "";
        msg = insight["message"] or "";
        return (
            <div className="pp-insight">
                <div className={insight_icon_class(itype)}>
                    {render_insight_icon(itype)}
                </div>
                <div className="flex-1 min-w-0">
                    <p className="text-sm">{msg}</p>
                </div>
            </div>
        );
    }

    def mood_emoji(m: str) -> str {
        if m == "excited" { return "🔥"; }
        if m == "interested" { return "👍"; }
        if m == "hesitant" { return "🤔"; }
        if m == "cold" { return "❄️"; }
        return "";
    }

    def render_project_card(proj: dict) -> JsxElement {
        pid = proj["id"] or "";
        title = proj["title"] or "";
        client = proj["client_name"] or "";
        status = proj["status"] or "";
        budget = proj["budget"] or 0;
        budget_str = "$" + str(int(budget));
        client_mood = proj["client_mood"] or "";
        mood_icon = mood_emoji(client_mood);
        def handle_click() -> None {
            go_to_project(pid);
        }
        return (
            <button
                type="button"
                className="pp-card p-4 text-left w-full hover:bg-card-hover transition-colors"
                onClick={handle_click}
            >
                <div className="flex items-center justify-between gap-4">
                    <div className="min-w-0 flex-1">
                        <p className="text-sm font-medium truncate">{title}</p>
                        <p className="text-xs text-muted-foreground mt-0.5">{mood_icon and mood_icon + " " or ""}{client}</p>
                    </div>
                    <div className="flex items-center gap-3 shrink-0">
                        {budget > 0 and (
                            <span className="text-sm font-medium">{budget_str}</span>
                        )}
                        <span className={badge_class(status)}>{status}</span>
                    </div>
                </div>
            </button>
        );
    }

    if loading and not stats {
        return (
            <div className="px-6 py-8">
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
                    <div className="pp-skeleton h-28" />
                    <div className="pp-skeleton h-28" />
                    <div className="pp-skeleton h-28" />
                    <div className="pp-skeleton h-28" />
                </div>
                <div className="pp-skeleton h-64" />
            </div>
        );
    }

    return (
        <div className="px-6 py-8">
            <div className="flex items-center justify-between mb-8">
                <div>
                    <h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
                    <p className="text-sm text-muted-foreground mt-1">Your freelance business at a glance.</p>
                </div>
                <button className="pp-btn-primary" type="button" onClick={go_new_project}>
                    New Project
                </button>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
                <div className="pp-stat-card">
                    <p className="text-xs font-medium uppercase tracking-[0.08em] text-muted-foreground">Active Projects</p>
                    <p className="text-3xl font-semibold mt-2">{active_count}</p>
                    <p className="text-xs text-muted-foreground mt-1">{proposed_count} proposed, {lead_count} leads</p>
                </div>
                <div className="pp-stat-card">
                    <p className="text-xs font-medium uppercase tracking-[0.08em] text-muted-foreground">Revenue Earned</p>
                    <p className="text-3xl font-semibold mt-2 text-emerald-300">${revenue_paid}</p>
                    <p className="text-xs text-muted-foreground mt-1">${revenue_pending} pending payment</p>
                </div>
                <div className="pp-stat-card">
                    <p className="text-xs font-medium uppercase tracking-[0.08em] text-muted-foreground">Win Rate</p>
                    <p className="text-3xl font-semibold mt-2">{win_rate}%</p>
                    <p className="text-xs text-muted-foreground mt-1">{won_count} won of {total_projects} total</p>
                </div>
                <div className="pp-stat-card">
                    <p className="text-xs font-medium uppercase tracking-[0.08em] text-muted-foreground">Client Engagement</p>
                    <p className="text-3xl font-semibold mt-2 text-emerald-300">{engaged_count}</p>
                    <p className="text-xs text-muted-foreground mt-1">{at_risk_count} at risk, {pending_fups} need follow-up</p>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-[1fr_380px] gap-6">
                <div>
                    <h2 className="text-base font-semibold tracking-tight mb-4">AI Insights</h2>
                    <div className="flex flex-col gap-3 mb-8">
                        {[render_insight(insight) for insight in ai_insights]}
                        {not ai_insights and (
                            <div className="pp-insight">
                                <p className="text-sm text-muted-foreground">No insights yet. Start by creating your first project.</p>
                            </div>
                        )}
                    </div>

                    <h2 className="text-base font-semibold tracking-tight mb-4">Recent Projects</h2>
                    <div className="flex flex-col gap-3">
                        {[render_project_card(proj) for proj in recent_projects]}
                        {not recent_projects and (
                            <div className="pp-card p-6 text-center">
                                <p className="text-sm text-muted-foreground">No projects yet. Create one to get started.</p>
                            </div>
                        )}
                    </div>
                </div>

                <div>
                    <h2 className="text-base font-semibold tracking-tight mb-4">Pipeline Overview</h2>
                    <div className="pp-card p-5">
                        <div className="flex flex-col gap-4">
                            <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                    <span className="pp-badge-lead">lead</span>
                                    <span className="text-sm text-muted-foreground">New opportunities</span>
                                </div>
                                <span className="text-sm font-semibold">{lead_count}</span>
                            </div>
                            <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                    <span className="pp-badge-proposed">proposed</span>
                                    <span className="text-sm text-muted-foreground">Awaiting response</span>
                                </div>
                                <span className="text-sm font-semibold">{proposed_count}</span>
                            </div>
                            <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                    <span className="pp-badge-active">active</span>
                                    <span className="text-sm text-muted-foreground">In progress</span>
                                </div>
                                <span className="text-sm font-semibold">{active_count}</span>
                            </div>
                            <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                    <span className="pp-badge-delivered">delivered</span>
                                    <span className="text-sm text-muted-foreground">Pending payment</span>
                                </div>
                                <span className="text-sm font-semibold">{delivered_count}</span>
                            </div>
                            <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                    <span className="pp-badge-paid">paid</span>
                                    <span className="text-sm text-muted-foreground">Completed</span>
                                </div>
                                <span className="text-sm font-semibold">{paid_count}</span>
                            </div>
                        </div>
                    </div>

                    <h2 className="text-base font-semibold tracking-tight mt-6 mb-4">Quick Actions</h2>
                    <div className="flex flex-col gap-2">
                        <button className="pp-btn-primary w-full" type="button" onClick={go_new_project}>
                            New Project
                        </button>
                        <button className="pp-btn-ghost w-full" type="button" onClick={go_projects}>
                            View All Projects
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
