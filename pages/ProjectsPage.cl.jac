import from "@jac/runtime" { useNavigate, useEffect }
import from ..hooks.useProjects { useProjects }

def:pub page() -> JsxElement {
    data = useProjects();
    navigate = useNavigate();

    projects = data["projects"] or [];
    filter = data["filter"] or "all";
    loading = data["loading"];
    show_create = data["show_create"];

    def on_mount() -> None {
        data["loadProjects"]();
    }
    useEffect(on_mount, []);

    # Create form state
    has new_title: str = "";
    has new_client: str = "";
    has new_email: str = "";
    has new_desc: str = "";
    has new_budget: str = "";
    has new_deadline: str = "";

    def go_to_project(project_id: str) -> None {
        navigate("/projects/" + project_id);
    }

    def handle_filter_all() -> None { data["changeFilter"]("all"); }
    def handle_filter_lead() -> None { data["changeFilter"]("lead"); }
    def handle_filter_proposed() -> None { data["changeFilter"]("proposed"); }
    def handle_filter_active() -> None { data["changeFilter"]("active"); }
    def handle_filter_delivered() -> None { data["changeFilter"]("delivered"); }
    def handle_filter_paid() -> None { data["changeFilter"]("paid"); }

    def filter_btn_class(f: str) -> str {
        if filter == f { return "pp-tab-active"; }
        return "pp-tab";
    }

    def badge_class(status: str) -> str {
        if status == "lead" { return "pp-badge-lead"; }
        if status == "proposed" { return "pp-badge-proposed"; }
        if status == "active" { return "pp-badge-active"; }
        if status == "delivered" { return "pp-badge-delivered"; }
        if status == "paid" { return "pp-badge-paid"; }
        return "pp-badge-draft";
    }

    def handle_toggle_create() -> None {
        data["toggleCreate"]();
    }

    async def handle_submit_create(e: any) -> None {
        e.preventDefault();
        budget_val = 0.0;
        if new_budget {
            try {
                budget_val = float(new_budget);
            } except Exception as ex {
                budget_val = 0.0;
            }
        }
        result = await data["createProject"](new_title, new_client, new_email, new_desc, budget_val, new_deadline);
        if result and result["id"] {
            new_title = "";
            new_client = "";
            new_email = "";
            new_desc = "";
            new_budget = "";
            new_deadline = "";
            go_to_project(result["id"]);
        }
    }

    def on_title(e: any) -> None { new_title = e.target.value; }
    def on_client(e: any) -> None { new_client = e.target.value; }
    def on_email(e: any) -> None { new_email = e.target.value; }
    def on_desc(e: any) -> None { new_desc = e.target.value; }
    def on_budget(e: any) -> None { new_budget = e.target.value; }
    def on_deadline(e: any) -> None { new_deadline = e.target.value; }

    def render_project_card(proj: dict) -> JsxElement {
        pid = proj["id"] or "";
        title = proj["title"] or "";
        client = proj["client_name"] or "";
        desc = proj["description"] or "";
        status = proj["status"] or "";
        budget = proj["budget"] or 0;
        budget_str = "$" + str(int(budget));
        deadline = proj["deadline"] or "";
        ms_list = proj["milestones"] or [];
        ms_done = len([m for m in ms_list if m["completed"]]);
        ms_total = len(ms_list);
        ms_text = str(ms_done) + "/" + str(ms_total) + " milestones";

        def handle_click() -> None {
            go_to_project(pid);
        }

        return (
            <button
                type="button"
                className="pp-card p-5 text-left w-full hover:bg-card-hover transition-colors"
                onClick={handle_click}
            >
                <div className="flex items-start justify-between gap-4">
                    <div className="min-w-0 flex-1">
                        <div className="flex items-center gap-3 mb-1">
                            <p className="text-base font-semibold truncate">{title}</p>
                            <span className={badge_class(status)}>{status}</span>
                        </div>
                        <p className="text-sm text-muted-foreground">{client}</p>
                    </div>
                    <div className="flex flex-col items-end gap-1 shrink-0">
                        {budget > 0 and (
                            <span className="text-lg font-semibold">{budget_str}</span>
                        )}
                        {deadline and (
                            <span className="text-xs text-muted-foreground">Due {deadline}</span>
                        )}
                        {ms_total > 0 and (
                            <span className="text-xs text-muted-foreground">{ms_text}</span>
                        )}
                    </div>
                </div>
            </button>
        );
    }

    return (
        <div className="px-6 py-8">
            <div className="flex items-center justify-between mb-6">
                <div>
                    <h1 className="text-2xl font-semibold tracking-tight">Projects</h1>
                    <p className="text-sm text-muted-foreground mt-1">Manage your freelance projects from lead to payment.</p>
                </div>
                <button className="pp-btn-primary" type="button" onClick={handle_toggle_create}>
                    New Project
                </button>
            </div>

            {show_create and (
                <div className="pp-card p-6 mb-6">
                    <h2 className="text-base font-semibold tracking-tight mb-4">Create New Project</h2>
                    <form onSubmit={handle_submit_create} className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Project Title</label>
                            <input className="pp-input" type="text" value={new_title} onChange={on_title} placeholder="e.g. Website Redesign" required={True} />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Client Name</label>
                            <input className="pp-input" type="text" value={new_client} onChange={on_client} placeholder="e.g. John Smith" required={True} />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Client Email</label>
                            <input className="pp-input" type="email" value={new_email} onChange={on_email} placeholder="e.g. john@example.com" />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Budget ($)</label>
                            <input className="pp-input" type="number" value={new_budget} onChange={on_budget} placeholder="e.g. 3000" />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Deadline</label>
                            <input className="pp-input" type="date" value={new_deadline} onChange={on_deadline} />
                        </div>
                        <div className="md:col-span-2">
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Description / Job Post</label>
                            <textarea className="pp-input min-h-[100px] resize-none" value={new_desc} onChange={on_desc} placeholder="Paste the job description or describe the project scope..." />
                        </div>
                        <div className="md:col-span-2 flex items-center gap-3">
                            <button className="pp-btn-primary" type="submit" disabled={loading}>
                                {loading and "Creating..." or "Create Project"}
                            </button>
                            <button className="pp-btn-ghost" type="button" onClick={handle_toggle_create}>Cancel</button>
                        </div>
                    </form>
                </div>
            )}

            <div className="flex items-center gap-2 mb-6 flex-wrap">
                <button type="button" className={filter_btn_class("all")} onClick={handle_filter_all}>All</button>
                <button type="button" className={filter_btn_class("lead")} onClick={handle_filter_lead}>Lead</button>
                <button type="button" className={filter_btn_class("proposed")} onClick={handle_filter_proposed}>Proposed</button>
                <button type="button" className={filter_btn_class("active")} onClick={handle_filter_active}>Active</button>
                <button type="button" className={filter_btn_class("delivered")} onClick={handle_filter_delivered}>Delivered</button>
                <button type="button" className={filter_btn_class("paid")} onClick={handle_filter_paid}>Paid</button>
            </div>

            {loading and not projects and (
                <div className="flex flex-col gap-4">
                    <div className="pp-skeleton h-24" />
                    <div className="pp-skeleton h-24" />
                    <div className="pp-skeleton h-24" />
                </div>
            )}

            {not loading and not projects and (
                <div className="pp-card p-8 text-center">
                    <p className="text-sm text-muted-foreground">No projects found. Create your first project to get started.</p>
                </div>
            )}

            <div className="flex flex-col gap-4">
                {[render_project_card(proj) for proj in projects]}
            </div>
        </div>
    );
}
