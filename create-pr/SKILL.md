---
name: create-pr
description: Create or update pull requests with clear purpose-first context, scoped change summaries, and verification evidence. Use when asked to open a PR, update PR title/body, refresh outdated PR descriptions, or prepare a PR for review.
---

# Create PR

Create or update a pull request so reviewers can quickly understand purpose, scope, and verification.

## Workflow

1. Gather branch and diff context
- Confirm branch: `git branch --show-current`.
- Identify base branch (user-provided or repo default).
- Summarize commits: `git log --oneline origin/<base>..HEAD`.
- Summarize code delta: `git diff --stat origin/<base>...HEAD`.

2. Determine whether to create or update
- Check for existing PR on current branch:
  - `gh pr view --json number,title,body,url,headRefName,baseRefName`
- If PR exists, update it.
- If no PR exists, create one (draft by default unless user asks otherwise).

3. Write purpose-first PR content
Use this structure:
- `Why This PR Exists`: problem and intent.
- `What Changed`: grouped by area/component.
- `What This Sets Up`: follow-on work enabled by this PR.
- `Non-Goals`: explicitly out of scope.
- `Verification`: commands run and outcomes.

4. Apply PR update
- Prefer `gh pr edit <number> --title ... --body-file ...` for existing PRs.
- Use `gh pr create --base <base> --head <branch> --title ... --body-file ...` for new PRs.

5. Validate for reviewer quality
- Ensure claims match actual diff.
- Remove commit-by-commit lists from PR body.
- Remove stale links/references.
- Keep concise and scannable.

6. Report outcome
- Return PR URL, final title, and a short summary of what was updated.

## Rules

- Do not present plans as completed work.
- Mark unrun checks clearly instead of implying they passed.
- Avoid noisy sections (commit dumps, duplicated changelog text).
