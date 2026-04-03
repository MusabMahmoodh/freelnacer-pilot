sv import from ..services.projectService { get_projects, create_project }

def:pub useProjects() -> dict {
    has projects: list = [];
    has filter: str = "all";
    has loading: bool = True;
    has error: str = "";
    has show_create: bool = False;
    has creating: bool = False;

    async def load_projects() -> None {
        loading = True;
        error = "";
        try {
            result = await get_projects(filter);
            if result {
                projects = result;
            }
        } except Exception as e {
            error = "Failed to load projects";
        }
        loading = False;
    }

    async def change_filter(new_filter: str) -> None {
        filter = new_filter;
        loading = True;
        try {
            result = await get_projects(new_filter);
            if result {
                projects = result;
            }
        } except Exception as e {
            error = "Failed to filter projects";
        }
        loading = False;
    }

    async def handle_create(title: str, client_name: str, client_email: str, description: str, budget: float, deadline: str) -> dict {
        creating = True;
        try {
            result = await create_project(title, client_name, client_email, description, budget, deadline);
            if result and not ("error" in result) {
                show_create = False;
                creating = False;
                await load_projects();
                return result;
            }
        } except Exception as e {
            error = "Failed to create project";
        }
        creating = False;
        return {};
    }

    def toggle_create() -> None {
        show_create = not show_create;
    }

    return {
        "projects": projects,
        "filter": filter,
        "loading": loading,
        "error": error,
        "show_create": show_create,
        "creating": creating,
        "loadProjects": load_projects,
        "changeFilter": change_filter,
        "createProject": handle_create,
        "toggleCreate": toggle_create
    };
}
