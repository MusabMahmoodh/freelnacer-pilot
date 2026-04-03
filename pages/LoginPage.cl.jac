import from "@jac/runtime" { useNavigate, jacLogin, jacSignup }

def:pub page() -> JsxElement {
    has is_login: bool = True;
    has username: str = "";
    has password: str = "";
    has error: str = "";
    has loading: bool = False;

    navigate = useNavigate();

    async def handle_submit(e: any) -> None {
        e.preventDefault();
        loading = True;
        error = "";
        try {
            if is_login {
                login_res = await jacLogin(username, password);
                if login_res {
                    navigate("/dashboard");
                } else {
                    error = "Invalid username or password";
                }
            } else {
                signup_res = await jacSignup(username, password);
                if signup_res {
                    login_after_signup = await jacLogin(username, password);
                    if login_after_signup {
                        navigate("/dashboard");
                    } else {
                        error = "Account created — please sign in";
                    }
                } else {
                    error = "Signup failed. Username may already be taken.";
                }
            }
        } except Exception as e {
            error = "Authentication error. Please try again.";
        }
        loading = False;
    }

    def handle_username(e: any) -> None {
        username = e.target.value;
    }

    def handle_password(e: any) -> None {
        password = e.target.value;
    }

    def toggle_mode() -> None {
        is_login = not is_login;
        error = "";
    }

    return (
        <div className="min-h-screen w-full pp-bg flex items-center justify-center px-4">
            <div className="w-full max-w-md">
                <div className="text-center mb-8">
                    <div className="flex items-center justify-center gap-3 mb-4">
                        <div className="h-10 w-10 rounded-2xl bg-blue-500/15 border border-blue-400/25 flex items-center justify-center">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 2l3 7 7 3-7 3-3 7-3-7-7-3 7-3 3-7z" stroke="currentColor" strokeWidth="2" strokeLinejoin="round" />
                            </svg>
                        </div>
                        <h1 className="text-2xl font-semibold tracking-tight">Freelancer HQ</h1>
                    </div>
                    <h2 className="text-lg font-medium">{"Welcome back" if is_login else "Create account"}</h2>
                    <p className="text-sm text-muted-foreground mt-1">{"Sign in to continue" if is_login else "Get started for free"}</p>
                </div>
                <div className="pp-card p-6">
                    {error and (
                        <div className="rounded-[var(--radius-md)] border border-red-400/25 bg-red-500/10 px-4 py-3 text-sm text-red-200 mb-5">
                            {error}
                        </div>
                    )}
                    <form
                        onSubmit={handle_submit}
                        className="flex flex-col gap-4"
                    >
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Username</label>
                            <input
                                className="pp-input"
                                type="text"
                                value={username}
                                onChange={handle_username}
                                placeholder="Enter your username"
                                required={True}
                                autoComplete="username"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-muted-foreground mb-2">Password</label>
                            <input
                                className="pp-input"
                                type="password"
                                value={password}
                                onChange={handle_password}
                                placeholder="••••••••"
                                required={True}
                                autoComplete="current-password"
                            />
                        </div>
                        <button
                            className="pp-btn-primary w-full h-12 mt-1"
                            type="submit"
                            disabled={loading}
                        >
                            {(
                                ("Signing in..." if is_login else "Signing up...")
                                if loading
                                else ("Sign in" if is_login else "Sign up")
                            )}
                        </button>
                    </form>
                    <div className="text-center text-sm text-muted-foreground mt-5">
                        {"Don't have an account? " if is_login else "Already have an account? "}
                        <button
                            type="button"
                            className="text-primary font-medium hover:underline"
                            onClick={toggle_mode}
                        >
                            {"Sign up" if is_login else "Sign in"}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
