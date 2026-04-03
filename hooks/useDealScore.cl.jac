sv import from ..services.dealScoreService { score_deal, get_deals, save_deal, delete_deal }

def:pub useDealScore() -> dict {
    has jobPosting: str = "";
    has dealTitle: str = "";
    has loading: bool = False;
    has saving: bool = False;
    has error: str = "";
    has result: dict = {};
    has deals: list = [];
    has dealsLoading: bool = True;

    async def loadDeals() {
        dealsLoading = True;
        try {
            res = await get_deals();
            if res {
                deals = res;
            }
        } except Exception as e {
            error = "Failed to load deals";
        }
        dealsLoading = False;
    }

    async def handleScore(posting_text: str) -> None {
        error = "";
        result = {};
        if not posting_text or len(posting_text.strip()) < 10 {
            error = "Paste a job posting (at least a couple sentences).";
            return;
        }

        loading = True;
        try {
            res = await score_deal(posting_text);
            if res {
                result = res;
            }
        } except Exception as e {
            error = str(e);
        }
        loading = False;
    }

    async def handleSave(save_title: str, save_posting: str) -> None {
        if not result {
            error = "Score a posting first before saving.";
            return;
        }
        final_title = save_title.strip() if save_title else "";
        if not final_title {
            final_title = save_posting.strip()[:50] + "...";
        }

        saving = True;
        error = "";
        try {
            res = await save_deal(final_title, save_posting, result);
            if res and not ("error" in res) {
                jobPosting = "";
                dealTitle = "";
                result = {};
                saving = False;
                await loadDeals();
                return;
            } else {
                error = "Failed to save deal.";
            }
        } except Exception as e {
            error = str(e);
        }
        saving = False;
    }

    async def handleDelete(deal_id: str) {
        try {
            res = await delete_deal(deal_id);
            if res {
                await loadDeals();
            }
        } except Exception as e {
            error = str(e);
        }
    }

    def handleClear() {
        jobPosting = "";
        dealTitle = "";
        result = {};
        error = "";
    }

    return {
        "jobPosting": jobPosting,
        "setJobPosting": setJobPosting,
        "dealTitle": dealTitle,
        "setDealTitle": setDealTitle,
        "loading": loading,
        "saving": saving,
        "error": error,
        "result": result,
        "deals": deals,
        "dealsLoading": dealsLoading,
        "loadDeals": loadDeals,
        "handleScore": handleScore,
        "handleSave": handleSave,
        "handleDelete": handleDelete,
        "handleClear": handleClear
    };
}
