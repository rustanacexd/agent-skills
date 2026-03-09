---
name: ship-learn-next-generic
description: Generate a short execution-first learning iteration from source material, notes, or an existing roadmap. Use only when the user explicitly invokes this skill by name or asks for a Ship-Learn-Next style iteration. Turn theory into a concrete artifact and the next narrow build, analysis, design, or debugging cycle without generating a long passive study plan.
---

# Ship Learn Next Generic

Generate a practical learning loop anchored in execution rather than passive study.

The core model is:

`ship -> learn -> next`

Where:
- `ship` means produce a concrete artifact
- `learn` means extract the concept, tradeoff, and failure mode from the artifact
- `next` means choose the next narrow iteration, not a large long-range plan

## Operating Modes

Choose one mode before planning.

### Foundation Mode

Use when the user is building baseline understanding of a concept or system.

Good outputs:
- a diagram
- a short explanation artifact
- a tiny validation script
- a narrow implementation slice that makes the concept concrete

### Application Mode

Use when the user already has enough context and should execute directly.

Good outputs:
- a narrow feature
- a scoped refactor
- a debugging exercise
- an evaluation harness
- a design writeup tied to a build step

### Mode Selection

Select the mode using these defaults:
- If the user is learning a concept, choose `Foundation`.
- If the user is changing existing code or structure, choose `Application: Refactor`.
- If the user is investigating breakage, instability, or unexpected behavior, choose `Application: Debug`.
- If the user is measuring quality, correctness, regressions, or ranking outputs, choose `Application: Eval`.

If none of those fit cleanly, choose the narrowest mode that still produces a concrete artifact.

When choosing an application mode, also carry the subtype into the output.

## Workflow

### 1. Identify the current unit

Define one narrow iteration only.

The iteration should have:
- one clear goal
- one concrete artifact
- one primary concept or pressure
- a completion bar that can be checked

If the input is a large roadmap, choose the next best iteration instead of expanding the whole roadmap.

### 2. Define what counts as "ship"

Every iteration must end in something concrete.

Examples:
- implemented endpoint
- tiny worker flow
- diagram plus explained tradeoffs
- schema plus seeded query example
- evaluation script
- pattern refactor
- reliability wrapper

Reject outputs that are only:
- reading lists
- theory summaries
- topic catalogs
- vague goals

### 3. Define what counts as "learn"

Each iteration must name:
- what the concept is
- why it exists
- tradeoffs
- common failure mode
- what became clearer after building

### 4. Define what comes "next"

Suggest only the next 1-2 likely iterations.

Do not map a long sequence unless the user explicitly asks for it.

## Guardrails

- Keep iterations narrow.
- Prefer one strong artifact over multiple partial ones.
- Do not generate passive study plans detached from execution.
- Do not treat every iteration as a full project.
- If the user is still in foundation-building mode, allow a concept-first iteration, but still end in a concrete artifact.
- Prefer "good enough to validate" over "fully polished."

## Output Format

Use this structure unless the user asks for something else:

```md
# [Iteration Title]

## Mode
Foundation | Application

## Subtype
None | Refactor | Debug | Eval

## Iteration Goal
[One narrow goal]

## Ship
[Concrete artifact to produce]

## Success Criteria
- [checkable outcome]
- [checkable outcome]
- [checkable outcome]

## What This Teaches
- [concept]
- [tradeoff]
- [failure mode]

## Inputs
- [source notes, docs, repo files, or references]

## Action Steps
1. [step]
2. [step]
3. [step]

## Reflection
- What became clearer?
- What still feels shaky?
- What failed or was harder than expected?
- What should change in the next iteration?

## Next
- [next likely iteration]
- [optional second likely iteration]
```

## Save Behavior

Return the iteration in chat by default.

Save to a file only when:
- the user explicitly asks for a document or file
- the surrounding workflow clearly expects a saved artifact
- the iteration is part of an ongoing tracked series

If saving to a file, use a neutral iteration-based name such as:
- `topic-iteration-01.md`
- `2026-03-09-request-flow-iteration.md`
- `iteration-auth-boundaries.md`

## Style

- Be concrete.
- Be short.
- Optimize for action.
- Prefer execution order over explanation depth.
- If the user provided source material, transform it into the next practical iteration instead of summarizing it at length.
