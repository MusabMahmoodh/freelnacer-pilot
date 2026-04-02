import from "@jac/runtime" { useNavigate, useParams, useEffect }
import from ..hooks.useProjectDetail { useProjectDetail }

def:pub page() -> JsxElement {
    data = useProjectDetail();
    navigate = useNavigate();
    params = useParams();

    project = data["project"] or {};
    active_tab = data["activeTab"] or "overview";
    loading = data["loading"];
    action_loading = data["actionLoading"];
    error = data["error"] or "";
    generated_text = data["generatedText"] or "";

    def on_mount() -> None {
        pid = params["id"];
        if pid {
            data["loadProject"](pid);
        }
    }
    useEffect(on_mount, []);

    # ── Form state ──
    has proposal_tone: str = "professional";
    has fu_message: str = "";
    has ms_title: str = "";
    has ms_due: str = "";
    has ms_amount: str = "";
    has inv_items: str = "";
    has inv_total: str = "";
    has inv_due: str = "";
    has copied_field: str = "";

    # ── Extract project values ──
    proj_title = project["title"] or "Project";
    proj_status = project["status"] or "lead";
    proj_client = project["client_name"] or "";
    proj_budget = project["budget"] or 0;
    proj_budget_str = "$" + str(int(proj_budget));
    proj_deadline = project["deadline"] or "";
    proj_desc = project["description"] or "No description provided.";
    proj_platform = project["platform"] or "";
    proj_created = project["created_at"] or "";
    milestones = project["milestones"] or [];
    follow_ups = project["follow_ups"] or [];
    proposal = project["proposal"];
    invoice = project["invoice"];
    ms_done = len([m for m in milestones if m["completed"]]);
    ms_total = len(milestones);
    ms_progress_str = str(ms_done) + "/" + str(ms_total);
    fu_count_str = str(len(follow_ups));

    def go_back() -> None { navigate("/projects"); }

    # ── Tab handlers ──
    def tab_overview() -> None { data["switchTab"]("overview"); }
    def tab_proposal() -> None { data["switchTab"]("proposal"); }
    def tab_followups() -> None { data["switchTab"]("followups"); }
    def tab_milestones() -> None { data["switchTab"]("milestones"); }
    def tab_invoice() -> None { data["switchTab"]("invoice"); }

    def tab_class(t: str) -> str {
        if active_tab == t { return "pp-tab-active"; }
        return "pp-tab";
    }

    def badge_class(status: str) -> str {
        if status == "lead" { return "pp-badge-lead"; }
        if status == "proposed" { return "pp-badge-proposed"; }
        if status == "active" { return "pp-badge-active"; }
        if status == "delivered" { return "pp-badge-delivered"; }
        if status == "paid" { return "pp-badge-paid"; }
        if status == "sent" { return "pp-badge-sent"; }
        if status == "draft" { return "pp-badge-draft"; }
        if status == "overdue" { return "pp-badge-overdue"; }
        return "pp-badge-draft";
    }

    # ── Pipeline visualization ──
    has status_list: list = ["lead", "proposed", "active", "delivered", "paid"];

    def get_status_index(status: str) -> int {
        for i in range(len(status_list)) {
            if status_list[i] == status { return i; }
        }
        return -1;
    }

    def pipeline_dot_class(step: str) -> str {
        current_idx = get_status_index(proj_status);
        step_idx = get_status_index(step);
        if step_idx == current_idx { return "pp-pipeline-dot-current"; }
        if step_idx < current_idx { return "pp-pipeline-dot-done"; }
        return "pp-pipeline-dot";
    }

    def pipeline_line_class(step_idx: int) -> str {
        current_idx = get_status_index(proj_status);
        if step_idx < current_idx { return "pp-pipeline-line-done"; }
        return "pp-pipeline-line";
    }

    # ── Status actions ──
    def mark_active() -> None { data["changeStatus"]("active"); }
    def mark_delivered() -> None { data["changeStatus"]("delivered"); }
    def mark_lost() -> None { data["changeStatus"]("lost"); }

    # ── Proposal handlers ──
    def set_tone_professional() -> None { proposal_tone = "professional"; }
    def set_tone_friendly() -> None { proposal_tone = "friendly"; }
    def set_tone_premium() -> None { proposal_tone = "premium"; }

    async def handle_generate_proposal() -> None {
        await data["generateProposal"](proposal_tone);
    }

    async def handle_copy_proposal() -> None {
        if proposal and proposal["text"] {
            try {
                await globalThis.navigator.clipboard.writeText(proposal["text"]);
                copied_field = "proposal";
            } except Exception as e {
                copied_field = "";
            }
        }
    }

    # ── Follow-up handlers ──
    def on_fu_message(e: any) -> None { fu_message = e.target.value; }

    async def handle_generate_fu() -> None {
        await data["generateFollowUp"]();
    }

    async def handle_send_fu(e: any) -> None {
        e.preventDefault();
        msg = fu_message or generated_text;
        if msg {
            await data["sendFollowUp"](msg);
            fu_message = "";
        }
    }

    # ── Milestone handlers ──
    def on_ms_title(e: any) -> None { ms_title = e.target.value; }
    def on_ms_due(e: any) -> None { ms_due = e.target.value; }
    def on_ms_amount(e: any) -> None { ms_amount = e.target.value; }

    async def handle_add_ms(e: any) -> None {
        e.preventDefault();
        amt = 0.0;
        if ms_amount {
            try { amt = float(ms_amount); }
            except Exception as ex { amt = 0.0; }
        }
        await data["addMilestone"](ms_title, ms_due, amt);
        ms_title = "";
        ms_due = "";
        ms_amount = "";
    }

    async def handle_generate_ms() -> None {
        await data["generateMilestones"]();
    }

    # ── Invoice handlers ──
    def on_inv_items(e: any) -> None { inv_items = e.target.value; }
    def on_inv_total(e: any) -> None { inv_total = e.target.value; }
    def on_inv_due(e: any) -> None { inv_due = e.target.value; }

    async def handle_create_inv(e: any) -> None {
        e.preventDefault();
        total_val = 0.0;
        if inv_total {
            try { total_val = float(inv_total); }
            except Exception as ex { total_val = 0.0; }
        }
        await data["createInvoice"](inv_items, total_val, inv_due);
        inv_items = "";
        inv_total = "";
        inv_due = "";
    }

    def handle_inv_sent() -> None { data["updateInvoice"]("sent"); }
    def handle_inv_paid() -> None { data["updateInvoice"]("paid"); }

    def handle_fill_from_milestones() -> None {
        if milestones {
            items_list = [m["title"] + ": $" + str(int(m["amount"])) for m in milestones];
            inv_items = ", ".join(items_list);
            inv_total = str(int(sum([m["amount"] for m in milestones])));
        }
    }

    # ── Render helpers ──
    def render_pipeline_step(idx: int, step: str) -> JsxElement {
        dot_cls = pipeline_dot_class(step);
        line_cls = pipeline_line_class(idx);
        return (
            <div className="flex items-center gap-2 flex-1">
                <div className={dot_cls} />
                <span className="text-xs text-muted-foreground hidden sm:inline">{step}</span>
                {idx < 4 and (
                    <div className={line_cls} />
                )}
            </div>
        );
    }

    def render_follow_up(fu: dict) -> JsxElement {
        fu_seq = str(fu["sequence"] or 1);
        fu_date = fu["sent_at"] or "";
        fu_msg = fu["message"] or "";
        return (
            <div className="pp-card p-4">
                <div className="flex items-center gap-3 mb-2">
                    <span className="pp-badge-proposed">#{fu_seq}</span>
                    <span className="text-xs text-muted-foreground">{fu_date}</span>
                </div>
                <p className="text-sm">{fu_msg}</p>
            </div>
        );
    }

    def render_milestone(ms: dict) -> JsxElement {
        ms_id = ms["id"] or "";
        ms_name = ms["title"] or "";
        ms_date = ms["due_date"] or "";
        ms_amt = ms["amount"] or 0;
        ms_amt_str = "$" + str(int(ms_amt));
        is_done = ms["completed"];
        check_cls = "h-5 w-5 rounded border flex items-center justify-center shrink-0 ";
        if is_done {
            check_cls = check_cls + "bg-blue-500/30 border-blue-400/40";
        } else {
            check_cls = check_cls + "border-border";
        }
        text_cls = "text-sm font-medium";
        if is_done {
            text_cls = text_cls + " line-through text-muted-foreground";
        }
        def handle_toggle() -> None {
            data["toggleMilestone"](ms_id);
        }
        return (
            <div className="pp-card p-4">
                <div className="flex items-center gap-3">
                    <button type="button" className={check_cls} onClick={handle_toggle}>
                        {is_done and (
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                                <polyline points="20 6 9 17 4 12" />
                            </svg>
                        )}
                    </button>
                    <div className="flex-1 min-w-0">
                        <p className={text_cls}>{ms_name}</p>
                        <p className="text-xs text-muted-foreground mt-0.5">Due {ms_date}</p>
                    </div>
                    {ms_amt > 0 and (
                        <span className="text-sm font-medium shrink-0">{ms_amt_str}</span>
                    )}
                </div>
            </div>
        );
    }

    # ── Loading state ──
    if loading and not project {
        return (
            <div className="px-6 py-8">
                <div className="pp-skeleton h-12 w-64 mb-6" />
                <div className="pp-skeleton h-96" />
            </div>
        );
    }

    if error and not project {
        return (
            <div className="px-6 py-8">
                <button type="button" className="pp-btn-ghost mb-4" onClick={go_back}>Back to Projects</button>
                <div className="pp-card p-8 text-center">
                    <p className="text-sm text-red-300">{error}</p>
                </div>
            </div>
        );
    }

    # ── Tab labels ──
    fu_tab_label = "Follow-ups";
    if follow_ups {
        fu_tab_label = "Follow-ups (" + fu_count_str + ")";
    }
    ms_tab_label = "Milestones";
    if ms_total > 0 {
        ms_tab_label = "Milestones (" + ms_progress_str + ")";
    }

    # Extract proposal values
    prop_text = "";
    prop_pricing = "";
    prop_tone = "";
    prop_score = "";
    if proposal {
        prop_text = proposal["text"] or "";
        prop_pricing = proposal["pricing"] or "";
        prop_tone = proposal["tone"] or "professional";
        prop_score = str(proposal["success_score"] or 0);
    }

    # Extract invoice values
    inv_number = "";
    inv_issued = "";
    inv_due_date = "";
    inv_items_text = "";
    inv_total_val = 0;
    inv_total_str = "";
    inv_status = "";
    inv_paid_date = "";
    if invoice {
        inv_number = invoice["invoice_number"] or "";
        inv_issued = invoice["issued_date"] or "";
        inv_due_date = invoice["due_date"] or "";
        inv_items_text = invoice["items"] or "";
        inv_total_val = invoice["total"] or 0;
        inv_total_str = "$" + str(int(inv_total_val));
        inv_status = invoice["status"] or "";
        inv_paid_date = invoice["paid_date"] or "";
    }

    ms_progress_pct = str(int((ms_done * 100) / ms_total)) + "%" if ms_total > 0 else "0%";

    # ── RENDER ──
    return (
        <div className="px-6 py-8">
            <button type="button" className="pp-btn-ghost mb-4" onClick={go_back}>
                Back to Projects
            </button>

            <div className="flex items-start justify-between gap-4 mb-6">
                <div>
                    <div className="flex items-center gap-3 mb-1">
                        <h1 className="text-2xl font-semibold tracking-tight">{proj_title}</h1>
                        <span className={badge_class(proj_status)}>{proj_status}</span>
                    </div>
                    <div className="flex items-center gap-4 text-sm text-muted-foreground">
                        <span>{proj_client}</span>
                        {proj_budget > 0 and (
                            <span>{proj_budget_str}</span>
                        )}
                        {proj_deadline and (
                            <span>Due {proj_deadline}</span>
                        )}
                    </div>
                </div>
            </div>

            <div className="pp-card p-4 mb-6">
                <div className="flex items-center gap-2">
                    {[render_pipeline_step(i, status_list[i]) for i in range(len(status_list))]}
                </div>
            </div>

            <div className="flex items-center gap-2 mb-6 flex-wrap border-b border-border pb-3">
                <button type="button" className={tab_class("overview")} onClick={tab_overview}>Overview</button>
                <button type="button" className={tab_class("proposal")} onClick={tab_proposal}>Proposal</button>
                <button type="button" className={tab_class("followups")} onClick={tab_followups}>{fu_tab_label}</button>
                <button type="button" className={tab_class("milestones")} onClick={tab_milestones}>{ms_tab_label}</button>
                <button type="button" className={tab_class("invoice")} onClick={tab_invoice}>Invoice</button>
            </div>

            {error and (
                <div className="rounded-[var(--radius-md)] border border-red-400/25 bg-red-500/10 px-4 py-3 text-sm text-red-200 mb-4">
                    {error}
                </div>
            )}

            {active_tab == "overview" and (
                <div className="flex flex-col gap-6">
                    <div className="pp-card p-5">
                        <h3 className="text-sm font-semibold tracking-tight mb-3">Project Details</h3>
                        <p className="text-sm text-muted-foreground whitespace-pre-wrap">{proj_desc}</p>
                        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-4 pt-4 border-t border-border">
                            <div>
                                <p className="text-xs text-muted-foreground">Platform</p>
                                <p className="text-sm font-medium mt-0.5">{proj_platform or "—"}</p>
                            </div>
                            <div>
                                <p className="text-xs text-muted-foreground">Created</p>
                                <p className="text-sm font-medium mt-0.5">{proj_created or "—"}</p>
                            </div>
                            <div>
                                <p className="text-xs text-muted-foreground">Follow-ups</p>
                                <p className="text-sm font-medium mt-0.5">{fu_count_str}</p>
                            </div>
                            <div>
                                <p className="text-xs text-muted-foreground">Milestones</p>
                                <p className="text-sm font-medium mt-0.5">{ms_total > 0 and ms_progress_str or "—"}</p>
                            </div>
                        </div>
                    </div>

                    <div className="pp-card p-5">
                        <h3 className="text-sm font-semibold tracking-tight mb-3">Quick Actions</h3>
                        <div className="flex flex-wrap gap-3">
                            {proj_status == "lead" and (
                                <button className="pp-btn-primary" type="button" onClick={tab_proposal} disabled={action_loading}>
                                    Generate Proposal
                                </button>
                            )}
                            {proj_status == "proposed" and (
                                <button className="pp-btn-primary" type="button" onClick={mark_active} disabled={action_loading}>
                                    Mark Won
                                </button>
                            )}
                            {proj_status == "proposed" and (
                                <button className="pp-btn-ghost" type="button" onClick={tab_followups} disabled={action_loading}>
                                    Send Follow-up
                                </button>
                            )}
                            {proj_status == "proposed" and (
                                <button className="pp-btn-ghost" type="button" onClick={mark_lost} disabled={action_loading}>
                                    Mark Lost
                                </button>
                            )}
                            {proj_status == "active" and (
                                <button className="pp-btn-primary" type="button" onClick={mark_delivered} disabled={action_loading}>
                                    Mark Delivered
                                </button>
                            )}
                            {proj_status == "active" and (
                                <button className="pp-btn-ghost" type="button" onClick={tab_milestones} disabled={action_loading}>
                                    Manage Milestones
                                </button>
                            )}
                            {proj_status == "delivered" and (
                                <button className="pp-btn-primary" type="button" onClick={tab_invoice} disabled={action_loading}>
                                    Create Invoice
                                </button>
                            )}
                            {proj_status == "paid" and (
                                <span className="pp-badge-paid">Project Complete</span>
                            )}
                        </div>
                    </div>
                </div>
            )}

            {active_tab == "proposal" and not proposal and (
                <div className="pp-card p-6">
                    <h3 className="text-sm font-semibold tracking-tight mb-4">Generate Proposal</h3>
                    <p className="text-sm text-muted-foreground mb-4">AI will create a tailored proposal based on the project description.</p>
                    <div className="flex items-center gap-3 mb-4">
                        <span className="text-xs font-medium uppercase tracking-[0.08em] text-muted-foreground">Tone:</span>
                        <button type="button" className={proposal_tone == "professional" and "pp-tab-active" or "pp-tab"} onClick={set_tone_professional}>Professional</button>
                        <button type="button" className={proposal_tone == "friendly" and "pp-tab-active" or "pp-tab"} onClick={set_tone_friendly}>Friendly</button>
                        <button type="button" className={proposal_tone == "premium" and "pp-tab-active" or "pp-tab"} onClick={set_tone_premium}>Premium</button>
                    </div>
                    <button className="pp-btn-primary" type="button" onClick={handle_generate_proposal} disabled={action_loading}>
                        {action_loading and "Generating..." or "Generate Proposal"}
                    </button>
                </div>
            )}

            {active_tab == "proposal" and proposal and (
                <div className="flex flex-col gap-6">
                    <div className="pp-card p-5">
                        <div className="flex items-start justify-between gap-3 mb-3">
                            <div>
                                <h3 className="text-sm font-semibold tracking-tight">Proposal</h3>
                                <p className="text-xs text-muted-foreground mt-0.5">Tone: {prop_tone} | Score: {prop_score}%</p>
                            </div>
                            <button className="pp-btn-ghost" type="button" onClick={handle_copy_proposal}>
                                {copied_field == "proposal" and "Copied" or "Copy"}
                            </button>
                        </div>
                        <div className="whitespace-pre-wrap text-sm leading-relaxed text-foreground/95">
                            {prop_text}
                        </div>
                    </div>
                    <div className="pp-card p-5">
                        <h3 className="text-sm font-semibold tracking-tight mb-2">Suggested Pricing</h3>
                        <p className="text-lg font-semibold">{prop_pricing}</p>
                    </div>
                    <div className="flex gap-3">
                        <button className="pp-btn-ghost" type="button" onClick={handle_generate_proposal} disabled={action_loading}>
                            {action_loading and "Regenerating..." or "Regenerate"}
                        </button>
                    </div>
                </div>
            )}

            {active_tab == "followups" and (
                <div className="flex flex-col gap-6">
                    <div className="pp-card p-5">
                        <h3 className="text-sm font-semibold tracking-tight mb-4">Send Follow-up</h3>
                        <form onSubmit={handle_send_fu} className="flex flex-col gap-3">
                            <textarea
                                className="pp-input min-h-[120px] resize-none"
                                value={fu_message or generated_text}
                                onChange={on_fu_message}
                                placeholder="Write or generate a follow-up message..."
                            />
                            <div className="flex items-center gap-3">
                                <button className="pp-btn-primary" type="submit" disabled={action_loading or (not fu_message and not generated_text)}>
                                    Send Follow-up
                                </button>
                                <button className="pp-btn-ghost" type="button" onClick={handle_generate_fu} disabled={action_loading}>
                                    {action_loading and "Generating..." or "AI Generate"}
                                </button>
                            </div>
                        </form>
                    </div>

                    {follow_ups and (
                        <div>
                            <h3 className="text-sm font-semibold tracking-tight mb-3">Follow-up Timeline</h3>
                            <div className="flex flex-col gap-3">
                                {[render_follow_up(fu) for fu in follow_ups]}
                            </div>
                        </div>
                    )}

                    {not follow_ups and (
                        <div className="pp-card p-6 text-center">
                            <p className="text-sm text-muted-foreground">No follow-ups sent yet. Generate one above.</p>
                        </div>
                    )}
                </div>
            )}

            {active_tab == "milestones" and (
                <div className="flex flex-col gap-6">
                    {ms_total > 0 and (
                        <div className="pp-card p-5">
                            <div className="flex items-center justify-between mb-3">
                                <h3 className="text-sm font-semibold tracking-tight">Progress</h3>
                                <span className="text-sm text-muted-foreground">{ms_progress_str} complete</span>
                            </div>
                            <div className="h-2 rounded-full bg-white/5 border border-border overflow-hidden">
                                <div
                                    className="h-full bg-blue-500/70 transition-all"
                                    style={{"width": ms_progress_pct}}
                                />
                            </div>
                        </div>
                    )}

                    <div className="flex flex-col gap-3">
                        {[render_milestone(ms) for ms in milestones]}
                    </div>

                    <div className="pp-card p-5">
                        <h3 className="text-sm font-semibold tracking-tight mb-4">Add Milestone</h3>
                        <form onSubmit={handle_add_ms} className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                            <input className="pp-input" type="text" value={ms_title} onChange={on_ms_title} placeholder="Milestone title" required={True} />
                            <input className="pp-input" type="date" value={ms_due} onChange={on_ms_due} required={True} />
                            <input className="pp-input" type="number" value={ms_amount} onChange={on_ms_amount} placeholder="Amount ($)" />
                            <div className="sm:col-span-3 flex items-center gap-3">
                                <button className="pp-btn-primary" type="submit" disabled={action_loading}>Add</button>
                                <button className="pp-btn-ghost" type="button" onClick={handle_generate_ms} disabled={action_loading}>
                                    {action_loading and "Generating..." or "AI Suggest Milestones"}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {active_tab == "invoice" and not invoice and (
                <div className="pp-card p-6">
                    <h3 className="text-sm font-semibold tracking-tight mb-4">Create Invoice</h3>
                    <form onSubmit={handle_create_inv} className="flex flex-col gap-4">
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Line Items</label>
                            <textarea
                                className="pp-input min-h-[80px] resize-none"
                                value={inv_items}
                                onChange={on_inv_items}
                                placeholder="e.g. Design: $500, Development: $1500, QA: $300"
                                required={True}
                            />
                        </div>
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-muted-foreground mb-2">Total ($)</label>
                                <input className="pp-input" type="number" value={inv_total} onChange={on_inv_total} placeholder="e.g. 2300" required={True} />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-muted-foreground mb-2">Due Date</label>
                                <input className="pp-input" type="date" value={inv_due} onChange={on_inv_due} required={True} />
                            </div>
                        </div>
                        <div className="flex items-center gap-3">
                            <button className="pp-btn-primary" type="submit" disabled={action_loading}>Create Invoice</button>
                            {ms_total > 0 and (
                                <button className="pp-btn-ghost" type="button" onClick={handle_fill_from_milestones}>
                                    Fill from Milestones
                                </button>
                            )}
                        </div>
                    </form>
                </div>
            )}

            {active_tab == "invoice" and invoice and (
                <div className="pp-card p-5">
                    <div className="flex items-start justify-between gap-4 mb-4">
                        <div>
                            <h3 className="text-base font-semibold tracking-tight">{inv_number}</h3>
                            <p className="text-xs text-muted-foreground mt-0.5">Issued {inv_issued} | Due {inv_due_date}</p>
                        </div>
                        <span className={badge_class(inv_status)}>{inv_status}</span>
                    </div>
                    <div className="border-t border-border pt-4 mb-4">
                        <p className="text-sm text-muted-foreground mb-2">Line Items</p>
                        <p className="text-sm">{inv_items_text}</p>
                    </div>
                    <div className="flex items-center justify-between border-t border-border pt-4">
                        <span className="text-sm font-medium">Total</span>
                        <span className="text-xl font-semibold">{inv_total_str}</span>
                    </div>
                    {inv_paid_date and (
                        <p className="text-xs text-emerald-300 mt-3">Paid on {inv_paid_date}</p>
                    )}
                    <div className="flex items-center gap-3 mt-4">
                        {inv_status == "draft" and (
                            <button className="pp-btn-primary" type="button" onClick={handle_inv_sent} disabled={action_loading}>Mark as Sent</button>
                        )}
                        {inv_status == "sent" and (
                            <button className="pp-btn-primary" type="button" onClick={handle_inv_paid} disabled={action_loading}>Mark as Paid</button>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
