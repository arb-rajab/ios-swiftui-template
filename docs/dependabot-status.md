# Dependabot status

_Last updated: 2026-10-10. Starter template extracted from `notifyhub-ios`; update when the state changes._

## Configuration

- Ecosystems covered: github-actions (`/`) only (no Swift package manifest to scan).
- Grouping: none.
- Schedule: weekly.
- Ignore rules: none.

## State at last update

- Open Dependabot PRs: 0 (each merged or closed only after reading its checks).
- Default-branch CI: green at last check.
- Repository settings (read live 2026-10-10): public, `is_template` true, description set, default branch `main` (the only branch kept), secret scanning, push protection and Dependabot security updates enabled, dependency graph on (SBOM endpoint 200). Non-provider secret patterns and validity checks stay off: GitHub does not offer them on this user-owned public repo.
- Open in the 2026-10-10 loop (set by the repo owner through the API; the session's proxy blocks repository-settings writes): private vulnerability reporting (read: disabled), repository topics (none), `delete_branch_on_merge` (off). Alert state (Dependabot, code scanning, secret scanning) and fork-PR approval are read with the owner's token; see Notes once recorded.

## Time-limited exemptions

- None.

## Notes

- Merge policy (deliberate choice by the repo owner, the same blanket policy as the application repos): every PR, major-version dependency bumps included, is squash-merged as soon as all of its required checks are green, confirmed per PR. This repo is a code showcase with no business or sensitive dependency, so green checks are the only gate. Red, pending or conflicted PRs are fixed or closed instead.
- `main` protection (2026-10-10, read back): pull request required (0 approvals), enforced for admins, force pushes and deletions blocked, "require branches to be up to date" off (`strict` false) on purpose. Nobody pushes to `main` directly; status-log updates go through a PR too.
- Required contexts: `build-and-test`, `Secret scan (gitleaks)`. Nothing else is required on purpose: osv-scanner, npm audit, dependency review and CodeQL depend on a moving advisory database or run only on some events.
- Swift cannot be built in a Linux sandbox; the `macos-15` CI job is the only evidence that a change compiles.

## Deferred (not re-raised each pass)

- Alert reads (Dependabot, code scanning, secret scanning) and Actions settings (fork-PR approval) are blocked for Claude sessions by the proxy; they are read and written with the repo owner's token on their own machine.
- The owner keeps the token's Administration, Contents and Secret scanning permissions and does not rotate it (deliberate, 2026-10-09, reconfirmed 2026-10-10 for the template repos).
