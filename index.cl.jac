import "./styles/global.css";
import from .pages.LandingPage { page as LandingPage }
import from .pages.LoginPage { page as LoginPage }
import from .pages.DashboardPage { page as DashboardPage }
import from .pages.ProjectsPage { page as ProjectsPage }
import from .pages.ProjectDetailPage { page as ProjectDetailPage }
import from .pages.DealScorePage { page as DealScorePage }
import from .components.AppShell { AppShell }
import from "@jac/runtime" { AuthGuard, Router, Routes, Route, Navigate }

def:pub AuthGuardRoute() -> JsxElement {
    return <>{AuthGuard("/login")}</>;
}

def:pub ClientApp() -> JsxElement {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<LandingPage />} />
                <Route path="/login" element={<LoginPage />} />
                <Route element={<AuthGuardRoute />}>
                    <Route element={<AppShell />}>
                        <Route path="/dashboard" element={<DashboardPage />} />
                        <Route path="/projects" element={<ProjectsPage />} />
                        <Route path="/projects/:id" element={<ProjectDetailPage />} />
                        <Route path="/deal-score" element={<DealScorePage />} />
                    </Route>
                </Route>
            </Routes>
        </Router>
    );
}
