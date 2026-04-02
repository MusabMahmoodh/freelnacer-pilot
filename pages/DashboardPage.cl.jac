import from "@jac/runtime" { jacLogout, useNavigate }
import from ..hooks.usePitch { usePitch }


def:pub page() -> JsxElement {
    data = usePitch();

    job_desc = data["job_desc"] or "";
    tone = data["tone"] or "professional";

    loading = data["loading"];
    error = data["error"] or "";

    proposal = data["proposal"] or "";
    pricing = data["pricing"] or "";
    follow_up = data["follow_up"] or "";
    score = data["success_score"] or 0;

    navigate = useNavigate();

    has copied_key: str = "";

    def handle_logout() -> None {
        jacLogout();
        navigate("/login");
    }

    def handle_desc(e: any) -> None {
        data["reset"]();
        data["setJobDesc"](e);
    }

    def set_tone(next_tone: str) -> None {
        data["reset"]();
        data["setTone"](next_tone);
    }

    def handle_tone_professional() -> None { set_tone("professional"); }
    def handle_tone_friendly() -> None { set_tone("friendly"); }
    def handle_tone_premium() -> None { set_tone("premium"); }

    def handle_clear() -> None { data["reset"](); }

    async def handle_generate(e: any) -> None {
        e.preventDefault();
        await data["generate"]();
    }

    async def copy_text(key: str, text: str) -> None {
        if not text { return; }
        try {
            await globalThis.navigator.clipboard.writeText(text);
            copied_key = key;
        } except Exception as e {
            copied_key = "";
        }
    }

    async def handle_copy_proposal() -> None { await copy_text("proposal", proposal); }
    async def handle_copy_pricing() -> None { await copy_text("pricing", pricing); }
    async def handle_copy_follow_up() -> None { await copy_text("follow_up", follow_up); }

    def score_label(s: int) -> str {
        if s >= 85 { return "Excellent"; }
        if s >= 72 { return "Strong"; }
        if s >= 60 { return "Good"; }
        return "Needs polish";
    }

    def score_color(s: int) -> str {
        if s >= 85 { return "bg-emerald-500/15 text-emerald-200 border-emerald-400/25"; }
        if s >= 72 { return "bg-violet-500/15 text-violet-200 border-violet-400/25"; }
        if s >= 60 { return "bg-sky-500/15 text-sky-200 border-sky-400/25"; }
        return "bg-amber-500/15 text-amber-200 border-amber-400/25";
    }

    def render_output_card(title: str, body: str, key: str, on_copy: any) -> JsxElement {
        return (
            <div className="pp-card p-5">
                <div className="flex items-start justify-between gap-3 mb-3">
                    <div>
                        <h3 className="text-sm font-semibold tracking-tight">{title}</h3>
                        <p className="text-xs text-muted-foreground mt-0.5">Ready to paste. Edit 1–2 lines to match your voice.</p>
                    </div>
                    <button
                        className="pp-btn-ghost"
                        type="button"
                        onClick={on_copy}
                        disabled={not body}
                    >
                        {(copied_key == key) and "Copied" or "Copy"}
                    </button>
                </div>
                <div className="whitespace-pre-wrap text-sm leading-relaxed text-foreground/95">
                    {body or ""}
                </div>
            </div>
        );
    }

    def render_skeleton() -> JsxElement {
        return (
            <div className="grid grid-cols-1 gap-4">
                <div className="pp-card p-5">
                    <div className="pp-skeleton h-4 w-40 mb-3" />
                    <div className="pp-skeleton h-3 w-64 mb-4" />
                    <div className="pp-skeleton h-3 w-full mb-2" />
                    <div className="pp-skeleton h-3 w-[92%] mb-2" />
                    <div className="pp-skeleton h-3 w-[86%]" />
                </div>
                <div className="pp-card p-5">
                    <div className="pp-skeleton h-4 w-44 mb-3" />
                    <div className="pp-skeleton h-3 w-56 mb-4" />
                    <div className="pp-skeleton h-3 w-[70%]" />
                </div>
                <div className="pp-card p-5">
                    <div className="pp-skeleton h-4 w-48 mb-3" />
                    <div className="pp-skeleton h-3 w-60 mb-4" />
                    <div className="pp-skeleton h-3 w-full mb-2" />
                    <div className="pp-skeleton h-3 w-[88%]" />
                </div>
            </div>
        );
    }

    has tone_help: dict = {
        "professional": "Clear, direct, and confident.",
        "friendly": "Warm, collaborative, and approachable.",
        "premium": "High-trust, outcomes-first, positioned as a partner.",
    };

    return (
        <div className="min-h-screen w-full pp-bg">
            <div className="max-w-[72rem] mx-auto px-5 py-10">
                <div className="flex items-start justify-between gap-6 mb-8">
                    <div>
                        <div className="flex items-center gap-3">
                            <div className="h-10 w-10 rounded-2xl bg-violet-500/20 border border-violet-400/25 flex items-center justify-center">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M12 2l3 7 7 3-7 3-3 7-3-7-7-3 7-3 3-7z" stroke="currentColor" strokeWidth="2" strokeLinejoin="round" />
                                </svg>
                            </div>
                            <div>
                                <h1 className="text-2xl font-semibold tracking-tight">PitchPerfect AI</h1>
                                <p className="text-sm text-muted-foreground">Generate proposals that feel custom — in under 30 seconds.</p>
                            </div>
                        </div>
                        <div className="flex flex-wrap items-center gap-2 mt-4">
                            <span className="pp-pill">Proposal</span>
                            <span className="pp-pill">Pricing range</span>
                            <span className="pp-pill">Follow-up</span>
                            <span className="pp-pill">Success score</span>
                        </div>
                    </div>
                    <button className="pp-btn-ghost" onClick={handle_logout} type="button">Sign out</button>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div className="pp-card p-6">
                        <div className="flex items-start justify-between gap-4 mb-5">
                            <div>
                                <h2 className="text-base font-semibold tracking-tight">Job description</h2>
                                <p className="text-sm text-muted-foreground mt-1">Paste the client post. We’ll craft a tailored pitch with a strong close.</p>
                            </div>
                            <div className={"pp-pill " + score_color(score)}>
                                <span className="font-semibold">{str(score)}%</span>
                                <span className="ml-2">{score_label(score)}</span>
                            </div>
                        </div>

                        <form onSubmit={handle_generate} className="flex flex-col gap-4">
                            <textarea
                                className="pp-input min-h-[220px] resize-none"
                                value={job_desc}
                                onChange={handle_desc}
                                placeholder="Paste the job description here…\n\nTip: include budget, timeline, and any required tools/stack."
                                disabled={loading}
                            />

                            <div className="flex flex-col gap-3">
                                <div className="flex items-center justify-between">
                                    <div>
                                        <p className="text-xs font-medium uppercase tracking-[0.08em] text-muted-foreground">Tone</p>
                                        <p className="text-xs text-muted-foreground mt-1">{tone_help[tone] or ""}</p>
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <button
                                            type="button"
                                            className={(tone == "professional") and "pp-btn-primary" or "pp-btn-ghost"}
                                            onClick={handle_tone_professional}
                                            disabled={loading}
                                        >Professional</button>
                                        <button
                                            type="button"
                                            className={(tone == "friendly") and "pp-btn-primary" or "pp-btn-ghost"}
                                            onClick={handle_tone_friendly}
                                            disabled={loading}
                                        >Friendly</button>
                                        <button
                                            type="button"
                                            className={(tone == "premium") and "pp-btn-primary" or "pp-btn-ghost"}
                                            onClick={handle_tone_premium}
                                            disabled={loading}
                                        >Premium</button>
                                    </div>
                                </div>

                                <div className="flex items-center gap-3">
                                    <button className="pp-btn-primary" type="submit" disabled={loading}>
                                        {loading and "Generating…" or "Generate proposal"}
                                    </button>
                                    <button
                                        className="pp-btn-ghost"
                                        type="button"
                                        onClick={handle_clear}
                                        disabled={loading}
                                    >Clear outputs</button>
                                </div>

                                {error and (
                                    <div className="rounded-[var(--radius-md)] border border-red-400/25 bg-red-500/10 px-4 py-3 text-sm text-red-200">
                                        {error}
                                    </div>
                                )}
                            </div>
                        </form>
                    </div>

                    <div className="flex flex-col gap-4">
                        {loading and render_skeleton() or (
                            <div className="grid grid-cols-1 gap-4">
                                {render_output_card("Personalized proposal", proposal, "proposal", handle_copy_proposal)}
                                <div className="pp-card p-5">
                                    <div className="flex items-start justify-between gap-3 mb-3">
                                        <div>
                                            <h3 className="text-sm font-semibold tracking-tight">Suggested pricing</h3>
                                            <p className="text-xs text-muted-foreground mt-0.5">A confident range that matches the scope.</p>
                                        </div>
                                        <button
                                            className="pp-btn-ghost"
                                            type="button"
                                            onClick={handle_copy_pricing}
                                            disabled={not pricing}
                                        >
                                            {(copied_key == "pricing") and "Copied" or "Copy"}
                                        </button>
                                    </div>
                                    <div className="text-lg font-semibold">{pricing}</div>
                                    <p className="text-xs text-muted-foreground mt-2">Optional: offer a discovery call + milestone plan to increase close rate.</p>
                                </div>
                                {render_output_card("Follow-up message", follow_up, "follow_up", handle_copy_follow_up)}
                            </div>
                        )}
                    </div>
                </div>

                <div className="mt-8 text-xs text-muted-foreground">
                    Mock AI is enabled for this preview. Swap the backend implementation to f"by llm()" when you’re ready.
                </div>
            </div>
        </div>
    );
}
