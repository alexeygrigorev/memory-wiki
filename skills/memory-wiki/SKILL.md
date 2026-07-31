---
name: memory-wiki
description: Create and operate a project-scoped research wiki that turns a human seed into an evidence-grounded writing guideline or software implementation plan. Use when Codex needs to research a substantial article, technical document, product decision, feature, or code change; reuse personal notes or external sources; preserve research across sessions; query and grow a plain-file wiki; critique a plan; or lint research provenance before writing or implementation.
---

# Memory Wiki

Turn broad, mostly read-only sources into a small living context layer for one concrete deliverable. Preserve human intent, reveal context progressively, and separate research from execution.

## Choose the operation

- **Initialize**: Run `python3 scripts/init_project.py <project-dir> --mode writing|building --title "..."` from this skill directory.
- **Research**: Read the seed, retrieve sources, and create or extend the wiki.
- **Query**: Answer a question through progressive disclosure and persist reusable findings.
- **Distill**: Compile the relevant research into `guideline.md`.
- **Critique**: Run objective reflection, then grill subjective choices with the user.
- **Lint**: Run `python3 scripts/lint_project.py <project-dir>` before approval or execution.
- **Render/implement**: Proceed only after the project reaches `approved`.

Read [references/artifact-contract.md](references/artifact-contract.md) before changing a project workspace. For writing work, also read [references/writing.md](references/writing.md). For software work, also read [references/building.md](references/building.md).

## Preserve boundaries

1. Treat configured resource archives and target repositories as read-only during research.
2. Preserve `seed.md` as the immutable statement of initial human intent.
3. Write research derivatives only inside the current project workspace.
4. Separate facts, quotations, human views, agent inferences, and unresolved claims.
5. Keep source-level provenance through distillation.
6. Do not publish prose or modify a target repository until the user approves `guideline.md`.
7. Return only deliberately approved lessons to long-lived memory.

## Research

1. Read `project.yaml`, `seed.md`, and `sources/index.yaml`.
2. Turn the seed into explicit research questions. Preserve must-use sources and constraints.
3. Search personal sources first, then trusted or user-supplied sources, then the public web when gaps remain.
4. Record candidate metadata and a short relevance summary before reading full text.
5. Rank candidates against the seed. Prefer authority, diversity, recency when relevant, and direct evidence.
6. Snapshot or reference only selected sources. Never use a fixed source count as a success condition.
7. Create source pages with claim-level provenance and derivatives only when they improve retrieval.
8. Update the index, overview, synthesis, open questions, and append-only log.
9. Stop when important questions are supported, disagreements are represented, another round adds little, and remaining gaps are explicit.

Use sub-agents only when the user explicitly requests delegation or the active environment instructions permit it. Give each delegated researcher a bounded question and require source URLs plus uncertainty.

## Query through progressive disclosure

1. Read `seed.md` and `sources/index.yaml` first.
2. Select likely source summaries or synthesis pages from metadata.
3. Follow their links to concepts, comparisons, entities, or notes.
4. Open raw source material only when summaries cannot settle the question.
5. Answer with provenance and state uncertainty.
6. If the answer is reusable, save it under `wiki/notes/`, link it from the relevant pages, and append the operation to `log.md`.

Do not load the entire wiki merely because it fits in context.

## Distill and critique

Build `guideline.md` as a self-contained production handoff. Include the reasoning, evidence, decisions, constraints, counterarguments, and unresolved items that execution needs. Do not require the production pass to rediscover research.

Then:

1. Run **reflection** for checkable failures: missing sections, unsupported claims, broken provenance, contradictions, unmet constraints, and unaddressed open questions.
2. Record results in `critique.md` and revise the guideline.
3. Run **grilling** with the user for subjective decisions. Ask focused questions about meaning, tradeoffs, narrative, voice, or product judgment.
4. Record approvals and rejected alternatives.
5. Set status to `approved` only after explicit user approval and a clean lint result.

## Finish the selected mode

- In writing mode, render from the approved guideline without reopening the argument. Optimize for voice and clarity, keep reasoning low when the harness supports it, and retain a private provenance report. Follow `references/writing.md`.
- In building mode, inspect the live repository again before editing, implement the approved plan, verify acceptance criteria, and record departures from the plan. Follow `references/building.md`.

## Validate

Run:

```bash
python3 scripts/lint_project.py <project-dir>
```

Treat errors as blocking. Treat warnings as items requiring either a fix or an explicit entry in `critique.md`.
