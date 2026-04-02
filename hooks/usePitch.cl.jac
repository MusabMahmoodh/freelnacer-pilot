sv import from ..services.pitchService { generate_pitch }

# Client data hook for PitchPerfect.

def:pub usePitch() -> dict {
    has job_desc: str = "";
    has tone: str = "professional";

    has loading: bool = False;
    has error: str = "";

    has proposal: str = "";
    has pricing: str = "";
    has follow_up: str = "";
    has success_score: int = 0;

    def reset_outputs() -> None {
        proposal = "";
        pricing = "";
        follow_up = "";
        success_score = 0;
    }

    async def run_generate() -> None {
        error = "";
        reset_outputs();

        jd = (job_desc or "").strip();
        if not jd {
            error = "Paste a job description to generate a proposal.";
            return;
        }

        loading = True;
        try {
            resp = await generate_pitch(jd, tone);
            if resp and ("error" in resp) and resp["error"] {
                error = resp["error"];
            } else {
                proposal = resp["proposal"] or "";
                pricing = resp["pricing"] or "";
                follow_up = resp["follow_up"] or "";
                success_score = resp["success_score"] or 0;
            }
        } except Exception as e {
            error = str(e);
        }
        loading = False;
    }

    def set_job_desc(e: any) -> None {
        job_desc = e.target.value;
    }

    def set_tone(next_tone: str) -> None {
        tone = next_tone;
    }

    return {
        "job_desc": job_desc,
        "tone": tone,
        "loading": loading,
        "error": error,
        "proposal": proposal,
        "pricing": pricing,
        "follow_up": follow_up,
        "success_score": success_score,
        "setJobDesc": set_job_desc,
        "setTone": set_tone,
        "generate": run_generate,
        "reset": reset_outputs,
    };
}