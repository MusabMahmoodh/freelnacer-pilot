import from "@jac/runtime" { jacLogout, useNavigate, useLocation, Outlet }

def:pub AppShell() -> JsxElement {
    navigate = useNavigate();
    location = useLocation();

    current_path = location.pathname;

    def handle_logout() -> None {
        jacLogout();
        navigate("/login");
    }

    def go_dashboard() -> None { navigate("/dashboard"); }
    def go_projects() -> None { navigate("/projects"); }

    def nav_class(path: str) -> str {
        if current_path == path or (path == "/projects" and current_path.startsWith("/projects")) {
            return "pp-nav-item-active";
        }
        return "pp-nav-item";
    }

    return (
        <div className="min-h-screen w-full pp-bg flex">
            <aside className="pp-sidebar">
                <div className="px-5 py-6 border-b border-border">
                    <div className="flex items-center gap-3">
                        <div className="h-9 w-9 rounded-xl bg-blue-500/15 border border-blue-400/25 flex items-center justify-center">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 2l3 7 7 3-7 3-3 7-3-7-7-3 7-3 3-7z" stroke="currentColor" strokeWidth="2" strokeLinejoin="round" />
                            </svg>
                        </div>
                        <div>
                            <h1 className="text-base font-semibold tracking-tight">PitchPerfect AI</h1>
                            <p className="text-xs text-muted-foreground">Freelancer Assistant</p>
                        </div>
                    </div>
                </div>

                <nav className="flex-1 px-3 py-4 flex flex-col gap-1">
                    <button type="button" className={nav_class("/dashboard")} onClick={go_dashboard}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <rect x="3" y="3" width="7" height="9" />
                            <rect x="14" y="3" width="7" height="5" />
                            <rect x="14" y="12" width="7" height="9" />
                            <rect x="3" y="16" width="7" height="5" />
                        </svg>
                        Dashboard
                    </button>
                    <button type="button" className={nav_class("/projects")} onClick={go_projects}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                        </svg>
                        Projects
                    </button>
                </nav>

                <div className="px-3 pb-4">
                    <button type="button" className="pp-nav-item w-full" onClick={handle_logout}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                            <polyline points="16 17 21 12 16 7" />
                            <line x1="21" y1="12" x2="9" y2="12" />
                        </svg>
                        Sign out
                    </button>
                </div>
            </aside>

            <main className="ml-64 flex-1 min-h-screen">
                <Outlet />
            </main>
        </div>
    );
}
