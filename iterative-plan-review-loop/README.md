# iterative-plan-review-loop

A reusable skill for running an explicit, bias-reduced plan hardening loop:

```
review (fresh subagent) -> patch (main agent) -> re-review (fresh subagent) -> repeat
```

It is designed for cases where plan quality improves only after multiple review passes.

## Triggering

This skill is manual-only by design.

Invoke it explicitly:

```text
$iterative-plan-review-loop
```

## What It Enforces

- Fresh reviewer subagent every round (no reviewer context reuse)
- Reviewer is review-only (cannot patch)
- Main agent patches between rounds
- Explicit verdict token: `NEEDS_PATCH` or `NO_FINDINGS`
- Stops only on `NO_FINDINGS` or max-iteration cap
- Standardized round logs and unresolved-findings reporting

## Typical Usage

```text
Use $iterative-plan-review-loop on docs/plans/2026-03-04-lazy-service-startup.md. Scope: completeness + sequencing + testability. Max rounds: 5.
```

## Compatibility

- Codex: Yes
- Claude Code: Yes

## License

MIT
