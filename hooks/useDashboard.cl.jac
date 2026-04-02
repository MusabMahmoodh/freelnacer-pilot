sv import from ..services.dashboardService { get_dashboard_stats }

def:pub useDashboard() -> dict {
    has stats: dict = {};
    has loading: bool = True;
    has error: str = "";

    async def load_stats() -> None {
        loading = True;
        error = "";
        try {
            result = await get_dashboard_stats();
            if result {
                stats = result;
            }
        } except Exception as e {
            error = "Failed to load dashboard stats";
        }
        loading = False;
    }

    return {
        "stats": stats,
        "loading": loading,
        "error": error,
        "loadStats": load_stats
    };
}
