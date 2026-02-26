# reviewing-plans

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that reviews design documents and implementation plans before they proceed to the next stage. Two-stage gate: reviews the design before a plan is written from it, then reviews the plan against the design before execution begins.

## The Problem

When using the [superpowers](https://github.com/obra/superpowers) workflow (design → plan → execution), there's no formal review gate between stages:

1. You brainstorm a design (`superpowers:brainstorming`)
2. You create a plan (`superpowers:writing-plans`)
3. You execute it (`superpowers:subagent-driven-development` or `superpowers:executing-plans`)
4. **Issues surface during implementation** — missing requirements, scope creep, underspecified tasks, contradictions between plan and design

The review happens too late. By the time you discover the design was vague or the plan missed a requirement, you've already built the wrong thing.

## The Solution

`reviewing-plans` adds a two-stage review gate:

```
design → REVIEW → plan → REVIEW → execution
```

Each review presents findings grouped by severity, then the human decides what to act on. After changes, the human can request another full review pass or proceed.

### Stage 1: Design Review

Reviews the design for readiness to become a plan:
- Architecture soundness — are choices justified?
- Edge cases — what happens when things fail?
- Specificity — could a developer write tasks from this?
- Alternatives — were other approaches considered?

### Stage 2: Plan Review Against Design

Cross-references the plan against the design:
- Requirement coverage — does every design requirement have a task?
- Scope integrity — does every task map to a requirement?
- Task sizing — can a subagent complete each task?
- Dependencies — are they explicit?
- Assumptions — does the plan contradict the design?

### The Loop

```
Review (design or plan)
        ↓
Present ALL findings (Blocker/Warning/Suggestion)
        ↓
Human: accept/modify/reject per finding
        ↓
Apply changes
        ↓
Human: another review pass or proceed?
    ┌───┴───┐
  another   proceed
  pass        ↓
    │      next stage
    └──→ full re-review from start
```

### Key Design Decisions

**Present everything, human decides.** The skill does not filter findings by perceived importance. Agents editorialize ("this is probably fine") — the skill prevents that. Every finding is presented, the human decides severity.

**Two questions in sequence.** After findings: "accept/modify/reject?" After changes: "another pass or proceed?" Both are mandatory. Skipping either breaks the gate.

**Full re-review, not abbreviated.** When the human requests another pass, the review starts from scratch. No "just check the changes" — that misses interaction effects between fixes.

**Coverage tables for plan review.** Stage 2 starts with a requirement↔task coverage table before diving into findings. Makes gaps and scope creep immediately visible.

## Where It Fits in the Superpowers Workflow

This skill is a standalone review gate. It doesn't orchestrate other skills — it's invoked between them:

```
superpowers:brainstorming → superpowers:writing-plans
                                ↑
                        reviewing-plans (stage 1: review design)

superpowers:writing-plans → superpowers:subagent-driven-development
                                ↑
                        reviewing-plans (stage 2: review plan against design)
```

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — **required** (not compatible with Codex or other agents)
- [superpowers](https://github.com/obra/superpowers) — the workflow this skill gates (brainstorming, writing-plans, subagent-driven-development)

> **Claude Code only.** The skill's structured output format and human-in-the-loop gating depend on Claude Code's interactive session model.

## Installation

Symlink into your Claude Code personal skills directory:

```bash
ln -s /path/to/agent-skills/reviewing-plans ~/.claude/skills/reviewing-plans
```

Or copy if you prefer a standalone install:

```bash
mkdir -p ~/.claude/skills/reviewing-plans
cp SKILL.md ~/.claude/skills/reviewing-plans/
```

The skill will be available as `reviewing-plans` in all Claude Code sessions.

## Usage

```
/reviewing-plans
```

Invoke when you have a design doc ready for planning, or a plan ready for execution.

## License

MIT
