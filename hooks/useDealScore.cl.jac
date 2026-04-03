sv import from ..services.dealScoreService { score_deal }

def:pub useDealScore() -> dict {
    has jobPosting: str = "";
    has loading: bool = False;
    has error: str = "";
    has result: dict = {};

    async def handleScore() -> None {
        error = "";
        result = {};
        if not jobPosting or len(jobPosting.strip()) < 10 {
            error = "Paste a job posting (at least a couple sentences).";
            return;
        }

        loading = True;
        try {
            res = await score_deal(jobPosting);
            result = res or {};
        } except Exception as e {
            error = str(e);
        }
        loading = False;
    }

    def handleClear() -> None {
        jobPosting = "";
        result = {};
        error = "";
    }

    return {
        "jobPosting": jobPosting,
        "setJobPosting": setJobPosting,
        "loading": loading,
        "error": error,
        "result": result,
        "handleScore": handleScore,
        "handleClear": handleClear
    };
}
