# Project: freelnacer-pilot — Smart Deal Score
## Status: IN PROGRESS

## Plan
1. [x] Add mock backend endpoint `score_deal(job_posting)`
2. [x] Add client hook `useDealScore` to call endpoint
3. [x] Add `DealScorePage` UI (paste job post → score card)
4. [x] Wire route + AppShell nav
5. [ ] Validate: `jac start --dev main.jac` + `browser_validate`
6. [ ] Interactive test: paste sample → click Score → see result

## Files
- services/dealScoreService.sv.jac — mock scoring logic
- hooks/useDealScore.cl.jac — client state + call
- pages/DealScorePage.cl.jac — UI
- index.cl.jac — route
- components/AppShell.cl.jac — nav link
- main.jac — register endpoint

## Issues
- 

## Learnings
- 

## Last Action
Implemented mock Smart Deal Score backend + UI and wired into router/nav. Next: start server and browser_validate.
