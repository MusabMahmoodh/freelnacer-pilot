sv import from ..services.projectService {
    get_project,
    update_project_status,
    generate_proposal,
    generate_follow_up,
    add_follow_up,
    add_milestone,
    toggle_milestone,
    generate_milestones,
    create_invoice,
    update_invoice_status,
    analyze_mood
}

def:pub useProjectDetail() -> dict {
    has project: dict = {};
    has active_tab: str = "overview";
    has loading: bool = True;
    has action_loading: bool = False;
    has error: str = "";
    has generated_text: str = "";
    has mood_analysis: dict = {};
    has generated_mood: str = "";
    has generated_mood_note: str = "";

    async def load_project(project_id: str) -> None {
        loading = True;
        error = "";
        try {
            result = await get_project(project_id);
            if result and not ("error" in result) {
                project = result;
            } else {
                error = "Project not found";
            }
        } except Exception as e {
            error = "Failed to load project";
        }
        loading = False;
    }

    def switch_tab(tab: str) -> None {
        active_tab = tab;
        generated_text = "";
    }

    async def change_status(new_status: str) -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            result = await update_project_status(project["id"], new_status);
            if result and not ("error" in result) {
                project = result;
            }
        } except Exception as e {
            error = "Failed to update status";
        }
        action_loading = False;
    }

    # ── Proposal ──
    async def handle_generate_proposal(tone: str) -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            result = await generate_proposal(project["id"], tone);
            if result and not ("error" in result) {
                project["proposal"] = result;
                if project["status"] == "lead" {
                    project["status"] = "proposed";
                }
            }
        } except Exception as e {
            error = "Failed to generate proposal";
        }
        action_loading = False;
    }

    # ── Follow-ups ──
    async def handle_generate_follow_up() -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            seq = len(project["follow_ups"] or []) + 1;
            result = await generate_follow_up(project["id"], seq);
            if result and result["message"] {
                generated_text = result["message"];
                generated_mood = result["mood"] or "neutral";
                generated_mood_note = result["mood_note"] or "";
            }
        } except Exception as e {
            error = "Failed to generate follow-up";
        }
        action_loading = False;
    }

    async def handle_send_follow_up(message: str) -> None {
        if not project or not project["id"] or not message { return; }
        action_loading = True;
        try {
            mood_val = generated_mood or "neutral";
            mood_note_val = generated_mood_note or "";
            result = await add_follow_up(project["id"], message, mood_val, mood_note_val);
            if result and not ("error" in result) {
                if not project["follow_ups"] {
                    project["follow_ups"] = [];
                }
                project["follow_ups"].append(result);
                generated_text = "";
                generated_mood = "";
                generated_mood_note = "";
                # Update project mood
                project["client_mood"] = result["mood"] or "neutral";
            }
        } except Exception as e {
            error = "Failed to send follow-up";
        }
        action_loading = False;
    }

    async def handle_analyze_mood() -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            result = await analyze_mood(project["id"]);
            if result and not ("error" in result) {
                mood_analysis = result;
            }
        } except Exception as e {
            error = "Failed to analyze mood";
        }
        action_loading = False;
    }

    # ── Milestones ──
    async def handle_add_milestone(title: str, due_date: str, amount: float) -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            result = await add_milestone(project["id"], title, due_date, amount);
            if result and not ("error" in result) {
                if not project["milestones"] {
                    project["milestones"] = [];
                }
                project["milestones"].append(result);
            }
        } except Exception as e {
            error = "Failed to add milestone";
        }
        action_loading = False;
    }

    async def handle_toggle_milestone(milestone_id: str) -> None {
        if not project or not project["id"] { return; }
        try {
            result = await toggle_milestone(project["id"], milestone_id);
            if result and not ("error" in result) {
                for ms in (project["milestones"] or []) {
                    if ms["id"] == milestone_id {
                        ms["completed"] = result["completed"];
                    }
                }
            }
        } except Exception as e {
            error = "Failed to toggle milestone";
        }
    }

    async def handle_generate_milestones() -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            result = await generate_milestones(project["id"]);
            if result and len(result) > 0 {
                for ms in result {
                    await add_milestone(project["id"], ms["title"], ms["due_date"], ms["amount"]);
                }
                # Reload to get updated data
                await load_project(project["id"]);
            }
        } except Exception as e {
            error = "Failed to generate milestones";
        }
        action_loading = False;
    }

    # ── Invoice ──
    async def handle_create_invoice(items: str, total: float, due_date: str) -> None {
        if not project or not project["id"] { return; }
        action_loading = True;
        try {
            result = await create_invoice(project["id"], items, total, due_date);
            if result and not ("error" in result) {
                project["invoice"] = result;
            }
        } except Exception as e {
            error = "Failed to create invoice";
        }
        action_loading = False;
    }

    async def handle_update_invoice(new_status: str) -> None {
        if not project or not project["id"] or not project["invoice"] { return; }
        action_loading = True;
        try {
            result = await update_invoice_status(project["id"], project["invoice"]["id"], new_status);
            if result and not ("error" in result) {
                project["invoice"] = result;
                if new_status == "paid" {
                    project["status"] = "paid";
                }
            }
        } except Exception as e {
            error = "Failed to update invoice";
        }
        action_loading = False;
    }

    def set_generated_text(text: str) -> None {
        generated_text = text;
    }

    return {
        "project": project,
        "activeTab": active_tab,
        "loading": loading,
        "actionLoading": action_loading,
        "error": error,
        "generatedText": generated_text,
        "loadProject": load_project,
        "switchTab": switch_tab,
        "changeStatus": change_status,
        "generateProposal": handle_generate_proposal,
        "generateFollowUp": handle_generate_follow_up,
        "sendFollowUp": handle_send_follow_up,
        "addMilestone": handle_add_milestone,
        "toggleMilestone": handle_toggle_milestone,
        "generateMilestones": handle_generate_milestones,
        "createInvoice": handle_create_invoice,
        "updateInvoice": handle_update_invoice,
        "setGeneratedText": set_generated_text,
        "moodAnalysis": mood_analysis,
        "analyzeMood": handle_analyze_mood
    };
}
