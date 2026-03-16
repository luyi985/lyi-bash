```instructions
**Copilot Instructions (brief)**

- Purpose: Follow the base rules in `rules/*.mdc` and use `./skills/**/SKILL.md` directly for topic-specific guidance.

- Key points:
	- There is only one `skills` source: `./skills`.
	- Do not create duplicated skill rules under `rules/skills`.
	- When a task matches a topic, read the corresponding `./skills/.../SKILL.md` file directly.

- Example:
	- User: "Type narrowing key points?"
	- Agent: "Use `./skills/type-narrowing/SKILL.md`: prefer explicit type guards, control-flow narrowing, and exhaustive handling for tagged unions."

```
