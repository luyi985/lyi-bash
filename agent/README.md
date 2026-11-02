# Shared Agent Instructions

The files in this directory are the source of truth for reusable coding-assistant instructions.

- `AGENTS.md`: pair programming defaults and references to modular standards.
- `docs/standards/`: coding, testing, security, and LLM rules.
- `docs/workflows/sdd.md`: optional, human-reviewed SDD.
- `sync-agent-config.sh`: deploy instructions to supported user-level agent entrypoints.
- `sync-skills.sh`: separate existing skills synchronizer (unchanged).

## Install / update

After cloning or pulling the repository:

```bash
bash agent/sync-agent-config.sh --dry-run
bash agent/sync-agent-config.sh
```

If an existing target differs, the script skips it to avoid overwriting user configuration. Inspect the changes, then use `--force` to replace with a `.bak` backup (the script will refuse to overwrite an existing backup). The script never runs `git pull` automatically.

Supported adapters: Codex (`~/.codex/AGENTS.md`), Claude Code (`~/.claude/CLAUDE.md`), Copilot CLI (`~/.copilot/copilot-instructions.md`), Gemini CLI (`~/.gemini/GEMINI.md`), Cursor (`~/.cursor/rules/shared-agent-instructions.mdc`). Canonical copies live under `~/.agents/`.

Cursor receives a full copy of `AGENTS.md` with `alwaysApply: true` MDC frontmatter. The file is a local user rule under `~/.cursor/rules`, as documented in [Cursor's rules storage guide](https://cursor.com/help/customization/rules#where-are-rules-stored); it does not sync through your Cursor account. On older clients that do not load this directory, paste `~/.agents/AGENTS.md` into Cursor's User Rules settings.

Copilot IDE instructions must be configured separately. Support and loading behaviour may vary by client/version. Restart or reopen the agent to verify that instructions are read.

This setup does not provide hard enforcement of review gates; it provides instructions and a default collaboration policy.
