import from "@jac/runtime" { useNavigate }

def:pub page() -> JsxElement {
    navigate = useNavigate();

    def go_signup() -> None { navigate("/login"); }
    def go_login() -> None { navigate("/login"); }

    return (
        <div className="min-h-screen w-full pp-bg">

            <nav className="max-w-6xl mx-auto px-6 py-5 flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <div className="h-9 w-9 rounded-xl bg-blue-500/15 border border-blue-400/25 flex items-center justify-center">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 2l3 7 7 3-7 3-3 7-3-7-7-3 7-3 3-7z" stroke="currentColor" strokeWidth="2" strokeLinejoin="round" />
                        </svg>
                    </div>
                    <span className="text-base font-semibold tracking-tight">Freelancer HQ</span>
                </div>
                <div className="flex items-center gap-3">
                    <button type="button" className="pp-btn-ghost" onClick={go_login}>Sign in</button>
                    <button type="button" className="pp-btn-primary" onClick={go_signup}>Get Started</button>
                </div>
            </nav>

            <section className="max-w-4xl mx-auto px-6 pt-20 pb-24 text-center">
                <div className="inline-flex items-center gap-2 pp-pill mb-6">
                    <span>AI-powered freelance assistant</span>
                </div>
                <h1 className="text-5xl sm:text-6xl font-bold tracking-tight leading-tight">
                    Stop guessing.<br />Start winning.
                </h1>
                <p className="text-lg text-muted-foreground mt-6 max-w-2xl mx-auto leading-relaxed">
                    Freelancer HQ handles proposals, follow-ups, milestones, invoices, and client mood tracking — so you focus on the work, not the hustle.
                </p>
                <div className="flex items-center justify-center gap-4 mt-10">
                    <button type="button" className="pp-btn-primary h-12 px-8 text-base" onClick={go_signup}>
                        Get Started Free
                    </button>
                    <button type="button" className="pp-btn-ghost h-12 px-8 text-base" onClick={go_login}>
                        Sign in
                    </button>
                </div>
            </section>

            <section className="max-w-5xl mx-auto px-6 pb-24">
                <div className="text-center mb-12">
                    <h2 className="text-2xl font-semibold tracking-tight">The freelancer struggle is real</h2>
                    <p className="text-sm text-muted-foreground mt-2">You're great at your craft. But winning clients? That's a different job.</p>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div className="pp-card p-6">
                        <div className="h-10 w-10 rounded-xl bg-red-500/15 border border-red-400/25 flex items-center justify-center mb-4">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="8" x2="12" y2="12" />
                                <line x1="12" y1="16" x2="12.01" y2="16" />
                            </svg>
                        </div>
                        <h3 className="text-base font-semibold">Generic proposals</h3>
                        <p className="text-sm text-muted-foreground mt-2">You spend 30 minutes writing each one, they all sound the same, and most get ignored.</p>
                    </div>
                    <div className="pp-card p-6">
                        <div className="h-10 w-10 rounded-xl bg-amber-500/15 border border-amber-400/25 flex items-center justify-center mb-4">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
                            </svg>
                        </div>
                        <h3 className="text-base font-semibold">Chasing clients blind</h3>
                        <p className="text-sm text-muted-foreground mt-2">You follow up but have no idea if the client is interested, busy, or already hired someone else.</p>
                    </div>
                    <div className="pp-card p-6">
                        <div className="h-10 w-10 rounded-xl bg-purple-500/15 border border-purple-400/25 flex items-center justify-center mb-4">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <rect x="3" y="3" width="7" height="7" />
                                <rect x="14" y="3" width="7" height="7" />
                                <rect x="3" y="14" width="7" height="7" />
                                <rect x="14" y="14" width="7" height="7" />
                            </svg>
                        </div>
                        <h3 className="text-base font-semibold">No big picture</h3>
                        <p className="text-sm text-muted-foreground mt-2">Proposals in email, invoices in spreadsheets, milestones in your head. Nothing connects.</p>
                    </div>
                </div>
            </section>

            <section className="max-w-5xl mx-auto px-6 pb-24">
                <div className="text-center mb-12">
                    <h2 className="text-2xl font-semibold tracking-tight">One app, your entire workflow</h2>
                    <p className="text-sm text-muted-foreground mt-2">From first contact to final payment — all in one place.</p>
                </div>
                <div className="pp-card p-8">
                    <div className="flex items-center justify-between gap-4">
                        <div className="flex items-center gap-3 flex-1">
                            <div className="pp-pipeline-dot-done" />
                            <span className="text-sm font-medium">Lead</span>
                            <div className="pp-pipeline-line-done flex-1" />
                        </div>
                        <div className="flex items-center gap-3 flex-1">
                            <div className="pp-pipeline-dot-done" />
                            <span className="text-sm font-medium">Proposed</span>
                            <div className="pp-pipeline-line-done flex-1" />
                        </div>
                        <div className="flex items-center gap-3 flex-1">
                            <div className="pp-pipeline-dot-current" />
                            <span className="text-sm font-medium text-emerald-300">Active</span>
                            <div className="pp-pipeline-line flex-1" />
                        </div>
                        <div className="flex items-center gap-3 flex-1">
                            <div className="pp-pipeline-dot" />
                            <span className="text-sm text-muted-foreground">Delivered</span>
                            <div className="pp-pipeline-line flex-1" />
                        </div>
                        <div className="flex items-center gap-3">
                            <div className="pp-pipeline-dot" />
                            <span className="text-sm text-muted-foreground">Paid</span>
                        </div>
                    </div>
                    <p className="text-sm text-muted-foreground mt-6 text-center">Every project moves through a clear pipeline. You always know what's next.</p>
                </div>
            </section>

            <section className="max-w-5xl mx-auto px-6 pb-24">
                <div className="text-center mb-12">
                    <h2 className="text-2xl font-semibold tracking-tight">Everything you need to win more clients</h2>
                    <p className="text-sm text-muted-foreground mt-2">AI does the heavy lifting. You stay in control.</p>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="pp-card p-6">
                        <div className="flex items-center gap-3 mb-4">
                            <div className="h-10 w-10 rounded-xl bg-blue-500/15 border border-blue-400/25 flex items-center justify-center">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                    <polyline points="14 2 14 8 20 8" />
                                </svg>
                            </div>
                            <h3 className="text-base font-semibold">AI Proposals</h3>
                        </div>
                        <p className="text-sm text-muted-foreground">Paste a job description, pick a tone, and get a personalized proposal with pricing in seconds. Not a template — it reads the actual job and writes to it.</p>
                        <div className="flex gap-2 mt-4">
                            <span className="pp-pill">Professional</span>
                            <span className="pp-pill">Friendly</span>
                            <span className="pp-pill">Premium</span>
                        </div>
                    </div>
                    <div className="pp-card p-6">
                        <div className="flex items-center gap-3 mb-4">
                            <div className="h-10 w-10 rounded-xl bg-purple-500/15 border border-purple-400/25 flex items-center justify-center">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </div>
                            <h3 className="text-base font-semibold">Client Mood Tracking</h3>
                        </div>
                        <p className="text-sm text-muted-foreground">AI reads the situation after every follow-up. See who's excited, who's going cold, and get actionable advice on what to do next.</p>
                        <div className="flex gap-3 mt-4">
                            <span className="pp-mood-excited">Excited</span>
                            <span className="pp-mood-interested">Interested</span>
                            <span className="pp-mood-hesitant">Hesitant</span>
                            <span className="pp-mood-cold">Cold</span>
                        </div>
                    </div>
                    <div className="pp-card p-6">
                        <div className="flex items-center gap-3 mb-4">
                            <div className="h-10 w-10 rounded-xl bg-emerald-500/15 border border-emerald-400/25 flex items-center justify-center">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                                </svg>
                            </div>
                            <h3 className="text-base font-semibold">Full Project Pipeline</h3>
                        </div>
                        <p className="text-sm text-muted-foreground">Track every project from lead to payment. Proposals, follow-ups, milestones, and invoices — all in one view. AI suggests milestone breakdowns and handles invoicing.</p>
                        <div className="flex gap-2 mt-4">
                            <span className="pp-badge-lead">lead</span>
                            <span className="pp-badge-proposed">proposed</span>
                            <span className="pp-badge-active">active</span>
                            <span className="pp-badge-delivered">delivered</span>
                            <span className="pp-badge-paid">paid</span>
                        </div>
                    </div>
                    <div className="pp-card p-6">
                        <div className="flex items-center gap-3 mb-4">
                            <div className="h-10 w-10 rounded-xl bg-sky-500/15 border border-sky-400/25 flex items-center justify-center">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M12 20V10" />
                                    <path d="M18 20V4" />
                                    <path d="M6 20v-6" />
                                </svg>
                            </div>
                            <h3 className="text-base font-semibold">Smart Deal Score</h3>
                        </div>
                        <p className="text-sm text-muted-foreground">Paste any job posting and instantly know: is this client worth your time? AI checks for red flags, rates the opportunity, and tells you "jump on it" or "skip it."</p>
                        <div className="flex gap-2 mt-4">
                            <span className="pp-pill">Red flags</span>
                            <span className="pp-pill">Green flags</span>
                            <span className="pp-pill">Win likelihood</span>
                        </div>
                    </div>
                </div>
            </section>

            <section className="max-w-4xl mx-auto px-6 pb-24 text-center">
                <div className="pp-card p-10">
                    <h2 className="text-2xl font-semibold tracking-tight">Ready to win more freelance gigs?</h2>
                    <p className="text-sm text-muted-foreground mt-3 max-w-xl mx-auto">Join freelancers who spend less time on proposals and more time on work that pays.</p>
                    <div className="flex items-center justify-center gap-4 mt-8">
                        <button type="button" className="pp-btn-primary h-12 px-8 text-base" onClick={go_signup}>
                            Get Started Free
                        </button>
                    </div>
                </div>
            </section>

            <footer className="border-t border-border">
                <div className="max-w-6xl mx-auto px-6 py-8 flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="h-7 w-7 rounded-lg bg-blue-500/15 border border-blue-400/25 flex items-center justify-center">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 2l3 7 7 3-7 3-3 7-3-7-7-3 7-3 3-7z" stroke="currentColor" strokeWidth="2" strokeLinejoin="round" />
                            </svg>
                        </div>
                        <span className="text-sm font-medium">Freelancer HQ</span>
                    </div>
                    <p className="text-xs text-muted-foreground">Built with Jac</p>
                </div>
            </footer>
        </div>
    );
}
