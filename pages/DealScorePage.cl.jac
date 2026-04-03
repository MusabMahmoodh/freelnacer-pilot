import from "@jac/runtime" { useNavigate }
import from ..hooks.useDealScore { useDealScore }

def:pub page() -> JsxElement {
    nav = useNavigate();
    deal = useDealScore();

    res = deal["result"] or {};
    score = res["score"] or -1;
    swipe = res["swipe"] or "";
    verdict = res["verdict"] or "Run a score to see the verdict.";
    win_likelihood = res["win_likelihood"] or 0;
    red_flags = res["red_flags"] or [];
    green_flags = res["green_flags"] or [];
    next_steps = res["next_steps"] or [];
    job_posting = deal["jobPosting"] or "";
    deal_title = deal["dealTitle"] or "";
    is_loading = deal["loading"];
    is_saving = deal["saving"];
    err = deal["error"] or "";
    deals = deal["deals"] or [];
    deals_loading = deal["dealsLoading"];

    async can with entry {
        await deal["loadDeals"]();
    }

    # Badge class
    badge_cls = "bg-muted text-muted-foreground";
    if score >= 80 {
        badge_cls = "bg-emerald-500/15 text-emerald-300 border border-emerald-400/25";
    } elif score >= 55 {
        badge_cls = "bg-blue-500/15 text-blue-300 border border-blue-400/25";
    } elif score >= 0 {
        badge_cls = "bg-red-500/15 text-red-300 border border-red-400/25";
    }

    # Score bar class
    bar_cls = "h-full bg-red-500";
    if score >= 80 {
        bar_cls = "h-full bg-emerald-500";
    } elif score >= 55 {
        bar_cls = "h-full bg-blue-500";
    }

    # Risk label
    risk_label = "\u2014";
    if score >= 80 { risk_label = "Low"; }
    elif score >= 55 { risk_label = "Medium"; }
    elif score >= 0 { risk_label = "High"; }

    # Score label
    score_label = "Paste a post";
    if score >= 0 {
        score_label = "Score: " + str(score) + "/100";
    }

    win_str = "\u2014";
    if score >= 0 {
        win_str = str(win_likelihood) + "%";
    }

    score_pct = str(score) + "%" if score >= 0 else "0%";

    def go_back() -> None { nav("/projects"); }
    def handle_clear() -> None { deal["handleClear"](); }
    def handle_score() -> None { deal["handleScore"](job_posting); }
    def handle_save() -> None { deal["handleSave"](deal_title, job_posting); }
    def on_input(e: any) -> None { deal["setJobPosting"](e.target.value); }
    def on_title(e: any) -> None { deal["setDealTitle"](e.target.value); }

    def render_red_flag(flag: str, idx: int) -> JsxElement {
        return <div className="text-sm text-red-300">{flag}</div>;
    }

    def render_green_flag(flag: str, idx: int) -> JsxElement {
        return <div className="text-sm text-emerald-300">{flag}</div>;
    }

    def render_step(step: str, idx: int) -> JsxElement {
        return <li>{step}</li>;
    }

    def get_deal_badge(d_score: int) -> str {
        if d_score >= 80 {
            return "bg-emerald-500/15 text-emerald-300 border border-emerald-400/25";
        } elif d_score >= 55 {
            return "bg-blue-500/15 text-blue-300 border border-blue-400/25";
        }
        return "bg-red-500/15 text-red-300 border border-red-400/25";
    }

    def render_deal(d: dict, idx: int) -> JsxElement {
        d_score = d["score"] or 0;
        d_badge = get_deal_badge(d_score);
        d_id = d["id"] or "";

        def do_delete() -> None {
            deal["handleDelete"](d_id);
        }

        return (
            <div className="pp-card p-4 flex items-center justify-between gap-4" key={d_id}>
                <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-3">
                        <div className="font-semibold text-sm truncate">{d["title"] or "Untitled"}</div>
                        <div className={"px-2 py-0.5 rounded-full text-xs font-semibold shrink-0 " + d_badge}>
                            {str(d_score) + "/100"}
                        </div>
                    </div>
                    <div className="mt-1 flex items-center gap-3 text-xs text-muted-foreground">
                        <span>{d["swipe"] or ""}</span>
                        <span>{d["risk_level"] or ""} risk</span>
                        <span>{d["scored_at"] or ""}</span>
                    </div>
                </div>
                <button
                    className="pp-btn-ghost text-xs text-red-400 hover:text-red-300"
                    type="button"
                    onClick={do_delete}
                >
                    Remove
                </button>
            </div>
        );
    }

    return (
        <div className="px-6 py-8">
            <div className="flex items-start justify-between gap-4">
                <div>
                    <h1 className="text-2xl font-semibold tracking-tight">Smart Deal Score</h1>
                    <p className="text-sm text-muted-foreground mt-1">
                        Paste a job post. Get an instant read on risk, clarity, and how worth-it it is.
                    </p>
                </div>
                <button className="pp-btn-ghost" type="button" onClick={go_back}>
                    Back to Projects
                </button>
            </div>

            <div className="mt-6 grid grid-cols-1 lg:grid-cols-2 gap-6">
                <div className="pp-card p-5">
                    <div className="flex items-center justify-between">
                        <h2 className="text-base font-semibold tracking-tight">Job posting</h2>
                        <div className="flex items-center gap-2">
                            <button className="pp-btn-ghost" type="button" onClick={handle_clear} disabled={is_loading}>
                                Clear
                            </button>
                            <button className="pp-btn-primary" type="button" onClick={handle_score} disabled={is_loading}>
                                {is_loading and "Scoring..." or "Score it"}
                            </button>
                        </div>
                    </div>

                    <input
                        className="pp-input mt-4"
                        placeholder="Deal title (optional)"
                        value={deal_title}
                        onChange={on_title}
                    />

                    <textarea
                        className="pp-input mt-3 min-h-[220px] resize-none"
                        placeholder="Paste the full job post here..."
                        value={job_posting}
                        onChange={on_input}
                    />

                    {err and (
                        <div className="mt-3 text-sm text-red-300">{err}</div>
                    )}

                    <div className="mt-4 text-xs text-muted-foreground">
                        Mock scoring: flags vague scope, unclear budget, and 'quick/simple' language.
                    </div>
                </div>

                <div className="pp-card p-5">
                    <div className="flex items-center justify-between gap-3">
                        <h2 className="text-base font-semibold tracking-tight">Result</h2>
                        <div className="flex items-center gap-2">
                            <div className={"px-3 py-1.5 rounded-full text-xs font-semibold " + badge_cls}>
                                {score_label}
                            </div>
                            {score >= 0 and (
                                <button
                                    className="pp-btn-primary text-xs"
                                    type="button"
                                    onClick={handle_save}
                                    disabled={is_saving}
                                >
                                    {is_saving and "Saving..." or "Save Deal"}
                                </button>
                            )}
                        </div>
                    </div>

                    <div className="mt-4">
                        <div className="text-2xl font-bold">{swipe or "\u2014"}</div>
                        {score >= 0 and (
                            <div className="mt-3">
                                <div className="h-2 bg-white/5 rounded-full border border-border overflow-hidden">
                                    <div className={bar_cls} style={{"width": score_pct}} />
                                </div>
                            </div>
                        )}
                        <div className="mt-2 text-sm text-muted-foreground">
                            {verdict}
                        </div>
                    </div>

                    <div className="mt-5 grid grid-cols-2 gap-3">
                        <div className="pp-stat-card">
                            <div className="text-xs text-muted-foreground">Win likelihood</div>
                            <div className="mt-1 text-lg font-semibold">{win_str}</div>
                        </div>
                        <div className="pp-stat-card">
                            <div className="text-xs text-muted-foreground">Risk level</div>
                            <div className="mt-1 text-lg font-semibold">{risk_label}</div>
                        </div>
                    </div>

                    <div className="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <div className="text-sm font-semibold">Red flags</div>
                            <div className="mt-2 flex flex-col gap-2">
                                {[render_red_flag(red_flags[i], i) for i in range(len(red_flags))]}
                                {not red_flags and (
                                    <div className="text-sm text-muted-foreground">None detected.</div>
                                )}
                            </div>
                        </div>
                        <div>
                            <div className="text-sm font-semibold">Green flags</div>
                            <div className="mt-2 flex flex-col gap-2">
                                {[render_green_flag(green_flags[i], i) for i in range(len(green_flags))]}
                                {not green_flags and (
                                    <div className="text-sm text-muted-foreground">No strong positives yet.</div>
                                )}
                            </div>
                        </div>
                    </div>

                    <div className="mt-6">
                        <div className="text-sm font-semibold">Suggested next steps</div>
                        <ul className="mt-2 flex flex-col gap-2 list-disc pl-5 text-sm text-muted-foreground">
                            {[render_step(next_steps[i], i) for i in range(len(next_steps))]}
                            {not next_steps and (
                                <li>Score a posting to get tailored suggestions.</li>
                            )}
                        </ul>
                    </div>
                </div>
            </div>

            <div className="mt-8">
                <h2 className="text-lg font-semibold tracking-tight">Saved Deals</h2>
                <p className="text-sm text-muted-foreground mt-1">
                    Your scored and saved deals for quick reference.
                </p>

                <div className="mt-4 flex flex-col gap-3">
                    {deals_loading and (
                        <div className="text-sm text-muted-foreground">Loading deals...</div>
                    )}
                    {not deals_loading and not deals and (
                        <div className="pp-card p-6 text-center text-sm text-muted-foreground">
                            No saved deals yet. Score a job posting and click "Save Deal" to add one.
                        </div>
                    )}
                    {not deals_loading and [render_deal(deals[i], i) for i in range(len(deals))]}
                </div>
            </div>
        </div>
    );
}
