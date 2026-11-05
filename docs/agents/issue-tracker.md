# Issue tracker: GitHub

Issues and specs live in GitHub Issues at https://github.com/ody09/openemis-core.

## Repository targeting

- Use `gh` for tracker operations. Run from this repository and pass `--repo ody09/openemis-core` explicitly for issue and label commands.
- Before the first write in a session, verify the destination with `gh repo view ody09/openemis-core --json nameWithOwner`. Never publish this project's work to an upstream repository or to the skills author's repository.
- The `github` remote points at the user's repository. Preserve the existing Bitbucket `origin`; do not infer the issue tracker from `origin`.
- Setup does not authorize pushing code, creating issues or comments, merging, or publishing releases. Obtain authorization from the task being performed.
- GitHub CLI currently has a local portable copy at `tmp/engineering-skills-tools/bin/gh.exe`. If `gh` is not on PATH, invoke that executable (PowerShell: `& .\tmp\engineering-skills-tools\bin\gh.exe ...`). Do not commit this temporary tool directory.

## Conventions

- Create an issue: `gh issue create --repo ody09/openemis-core --title "..." --body-file "path/to/body.md"`.
- Read an issue: `gh issue view <number> --repo ody09/openemis-core --json number,title,body,labels,comments`.
- List open issues: `gh issue list --repo ody09/openemis-core --state open --json number,title,body,labels`.
- Comment: `gh issue comment <number> --repo ody09/openemis-core --body-file "path/to/comment.md"`.
- Apply or remove labels: `gh issue edit <number> --repo ody09/openemis-core --add-label "..." --remove-label "..."`.
- Close an issue: post the authorized explanation as a comment, then use `gh issue close <number> --repo ody09/openemis-core`.
- For multiline bodies, write a UTF-8 file with real newlines and pass `--body-file`; do not interpolate the body into shell commands.
- If native sub-issues or dependencies are unavailable, use `Part of #<parent>` and `Blocked by: #<number>` at the top of the child issue, plus a task list in the parent. A child is unblocked when all blockers are closed.

## Pull requests as a triage surface

**PRs as a request surface: no.**

## Skill terminology

- "Publish to the issue tracker": create an authorized GitHub issue in `ody09/openemis-core`.
- "Fetch the relevant ticket": read the GitHub issue using the command above.
