# Memory Wiki: From Collected Sources to Grounded Work

Status: discussion draft  
Source: [Paul Iusztin's conversation with Alexey Grigorev](https://www.youtube.com/live/TDP3tIKxqlc)  
Companion source: [Your Second Brain Is a Graveyard. Make It Agent Memory](https://www.decodingai.com/p/llm-wiki-agent-memory)  
Reference implementation: [ai-research-os-workshop](https://github.com/iusztinpaul/ai-research-os-workshop)

## The idea in one sentence

Keep the large personal knowledge archive cheap to capture and read-only; for each real piece of work, retrieve a small set of relevant sources into a project-scoped wiki, interrogate that wiki until the important gaps are resolved, and compile the result into a self-contained plan before asking an agent to write or build anything.

The system is not primarily a note-taking system. It is a pipeline that turns previously collected material into work.

## What Paul is actually proposing

### 1. Optimize capture for low friction, not perfect organization

Paul organizes his digital life loosely with PARA: Projects, Areas, Resources, and Archive. The resources layer receives notes, articles, videos, papers, code repositories, Readwise items, and trusted feeds. Saving something is already a weak but useful act of curation: it caught his attention.

The archive should require very little manual maintenance. Elaborate tagging, summarizing, and linking at capture time make the system expensive enough that it eventually stops being used.

> Design principle: capture now; organize and read deeply only when a real project creates demand.

### 2. Begin with the human's intent

For an article, Paul first creates a rough Markdown outline, often by dictation. It contains his intended argument, personal experience, questions, and approximate order. For software, the equivalent is a feature brief or spec.

This happens before automated research. The initial brain dump is the seed for retrieval and protects the work from becoming a generic summary of whatever the search system happens to find.

### 3. Search outward from the seed

A deep-research loop converts the seed into questions and search terms, then searches:

- the author's notes and manually saved resources;
- selected trusted feeds or authors;
- explicitly supplied “golden” links;
- the public web when the existing archive has gaps;
- relevant source-code repositories for coding work.

Paul describes retrieving roughly 20–30 relevant resources for an article. Candidate sources are reranked against the original intent using cheap representations such as metadata and summaries before expensive full-text reading.

The number 30 is a working heuristic, not a target. Topic coverage, source diversity, and marginal usefulness matter more than source count.

### 4. Build a small wiki for the project, not one wiki for everything

The full second brain remains an immutable source pool. The agent creates a separate mini-wiki for the current article, video, book, or feature.

That wiki stores:

- immutable copies or references to raw sources;
- one concise page per source;
- concepts and entities;
- comparisons and relationships;
- question-driven notes and emerging conclusions;
- an index that lets an agent decide what to read next;
- a log of ingestion, queries, and changes.

The wiki is a durable, inspectable context layer between raw sources and an agent harness such as Codex. It should be small enough that plain files and links remain practical.

### 5. Reveal context progressively

An agent should not receive the whole archive or even the whole project wiki.

It should traverse context in this order:

1. Read the project seed and index entries.
2. Open the most relevant source summaries or synthesis pages.
3. Follow links to concepts, comparisons, and question notes.
4. Read raw source text only when the claim cannot be resolved otherwise.

This is Paul's main context-budget technique: precompute useful intermediate representations once, then let later agents drill down only as far as a question requires.

### 6. Research is interactive and leaves durable traces

The first retrieval pass will expose missing knowledge, weak assumptions, and contradictions. The author queries the wiki, adds must-read sources, requests follow-up research, and fact-checks beliefs.

Useful answers become new notes, comparisons, or open questions in the project wiki. The research therefore compounds within the project instead of disappearing when a chat ends.

### 7. Distill the wiki into a self-contained guideline

Once the research is good enough, the agent compiles the relevant material into a detailed plan Paul calls a “guideline.” This is the handoff from research to production.

The guideline must contain the reasoning, evidence, structure, examples, and constraints needed for the output. Production should not have to rediscover the wiki. In Paul's framing, this is the last stage for which the wiki itself is required.

### 8. Critique the plan in two different ways

Paul separates:

- **Reflection:** objective or checkable questions. Are required sections present? Is every important claim supported? Were the structural rules followed? Are there contradictions?
- **Grilling:** subjective questions that require the human in the loop. Is the transformation compelling? Is the personal story in the right place? Is this really what the author means? What feels generic or unearned?

Reflection can be automated. Grilling is a conversation and may require several passes.

### 9. Separate reasoning from expression

For writing, the researched guideline contains the hard thinking. A separate style pass turns it into prose. Paul reports that lower-reasoning settings can produce cleaner prose because the model is less likely to rethink the argument, wander, or expose meta-reasoning while writing.

This separation also makes the style layer replaceable: it can use a different model, a writing profile learned from edited examples, or eventually a fine-tuned model. Human editing remains part of the process.

### 10. Adapt the last mile for code

The coding pipeline has the same backbone:

`research → project wiki → interrogate → detailed plan → execute`

There are important differences:

- The wiki contains external research: alternative implementations, algorithms, papers, and architecture notes from other repositories.
- The current repository remains the source of truth for its own behavior.
- Small ADRs and a glossary live beside the code and are read as part of the repository, not copied into an external wiki.
- A generated graph of the current codebase is usually a liability because it can drift out of sync.
- The implementation plan should settle interfaces, algorithms, decisions, and task boundaries before coding begins.

Paul's strongest claim is that execution is increasingly commoditized; the durable value is in research quality and plan quality.

## The deeper pattern

Paul's approach has three distinct memory temperatures:

| Layer | Purpose | Mutation policy | Lifetime |
|---|---|---|---|
| Resource archive | Broad personal or organizational source pool | Human-owned, agent read-only | Long-lived |
| Project wiki | Selected evidence and derived understanding | Agent-maintained with provenance | Life of project, optionally archived |
| Guideline/plan | Minimal complete context for production | Deliberately revised and approved | One deliverable or implementation |

This separation solves different problems:

- The archive optimizes for easy capture and future recall.
- The wiki optimizes for exploration, synthesis, and reuse.
- The guideline optimizes for focused execution.

Trying to make one artifact serve all three purposes creates either an unmaintainable knowledge graph or an enormous prompt.

## Recommended adaptation for this repository

### Product principle

Start as a Codex-native, plain-Markdown workflow rather than as a database, background service, or large CLI. The first version should prove that the process produces better work. Automation can be added only where repeated use reveals real friction.

The system should be harness-neutral at the artifact level. Codex skills may operate it, but every important state transition must be visible in ordinary files and reviewable with Git.

### One engine, two modes

Both modes share capture, research, wiki creation, querying, distillation, and linting.

#### Writing mode

Input:

- a brain dump or dictated outline;
- intended reader and desired change in the reader;
- personal experiences or opinions that must remain authoritative;
- optional must-use and must-not-use sources;
- a writing profile.

Output:

- a claim-and-evidence guideline;
- an approved narrative structure;
- a styled draft;
- a provenance report and unresolved fact list.

Writing-specific critique asks about voice, narrative movement, originality, reader value, unsupported confidence, and places where generated prose displaced the author's actual view.

#### Building mode

Input:

- a feature brief, bug report, or product decision;
- the current repository;
- local ADRs and glossary;
- optional comparison repositories and technical sources;
- explicit constraints and acceptance criteria.

Output:

- an evidence-grounded implementation plan;
- proposed ADR changes;
- tasks with validation criteria;
- implementation and verification results.

Building-specific critique asks about compatibility, failure modes, migration, security, observability, test strategy, and whether external patterns actually fit the local architecture.

### Proposed project workspace

Each piece of work gets an isolated directory:

```text
projects/<project-id>/
├── project.yaml             # mode, status, budgets, source locations
├── seed.md                  # the human's original intent
├── sources/
│   ├── raw/                 # immutable snapshots or manifests
│   └── index.yaml           # compact retrieval catalog
├── wiki/
│   ├── overview.md
│   ├── synthesis.md
│   ├── sources/             # one grounded page per source
│   ├── concepts/
│   ├── entities/
│   ├── comparisons/
│   ├── notes/               # answers created during interrogation
│   └── open-questions.md
├── guideline.md             # complete production handoff
├── critique.md              # reflection checks and human grilling
├── output/                  # draft or implementation artifacts
└── log.md                   # append-only operations and decisions
```

The exact schema should stay deliberately small. New page types earn their place only after at least two projects need them.

### Provenance contract

Every factual wiki claim should distinguish:

- source-backed fact;
- direct quotation;
- author's opinion or experience;
- agent inference;
- unresolved or conflicting claim.

Derived pages link to source pages, and source pages link to immutable raw material or a stable external URL. The final guideline retains claim-level references. A polished output may hide citations from readers, but the production artifact must remain auditable.

Without this contract, a living wiki can efficiently compound its own mistakes.

### Minimal skill surface

The first implementation needs four shared operations and two profiles:

1. **Research** — turn a seed into questions, retrieve and rerank sources, create or extend the project wiki.
2. **Query** — answer from the wiki through progressive disclosure and persist useful derivatives.
3. **Distill** — compile a self-contained guideline for the selected mode.
4. **Lint** — detect broken references, unsupported claims, contradictions, stale sources, duplicates, and orphan pages.
5. **Writing profile** — writing structure, critique criteria, and rendering rules.
6. **Building profile** — repository analysis, ADR handling, implementation-plan structure, and verification rules.

Rendering prose and executing code should remain explicit downstream actions. Research must never silently turn into publication or code changes.

### Suggested state machine

```text
SEED
  ↓
SCOPED
  ↓
RESEARCHING ↔ INTERROGATING
  ↓
DISTILLED
  ↓
CRITIQUED ↔ DISTILLED
  ↓
APPROVED
  ↓
RENDERED (writing) | IMPLEMENTED (building)
  ↓
VERIFIED
```

Transitions should be explicit because they have different permissions. Research may write only inside the project wiki. Rendering may write only to the output area. Building may modify a target repository only after the plan is approved.

## Where I would improve on Paul's description

### Preserve the seed as an immutable baseline

Keep the original brain dump unchanged and place later refinements elsewhere. This makes it possible to detect when research or model preferences have quietly replaced the author's intent.

### Use stopping rules, not fixed source counts

Stop research when:

- all important seed questions have evidence;
- another search round produces little new information;
- major source disagreements are represented;
- the remaining open questions are explicitly accepted.

This is more reliable than always collecting 30 sources.

### Make dissent a first-class artifact

The synthesis should include counterarguments, source conflicts, and rejected interpretations. A system optimized only for coherent synthesis will erase useful disagreement.

### Add freshness and confidence

Index entries should carry retrieval date, source date where known, authority/type, and confidence. Linting can then target claims whose evidence is old or weak instead of repeatedly reviewing everything.

### Evaluate outcomes, not wiki size

Useful measures include:

- percentage of guideline claims traceable to evidence;
- important sources reused from the archive;
- unresolved contradictions at approval time;
- human edits caused by factual versus stylistic errors;
- time from seed to approved guideline;
- retrieval cost per useful source;
- whether the output changed a reader's understanding or passed software acceptance tests.

Page count and graph density are not success metrics.

### Keep learning selective

After completion, return only durable lessons, approved decisions, and reusable sources to long-lived memory. Do not feed every generated note or draft back into the global archive. Otherwise low-quality derivatives gradually dominate the original evidence.

## What not to build yet

- A global LLM-maintained wiki over the entire archive.
- A vector database before project-scale file search becomes measurably inadequate.
- A generated knowledge graph of the current codebase.
- Automatic mutation of human-authored notes.
- Fully autonomous publication or implementation.
- Many specialized agents before the single-agent artifact contracts are stable.
- A style fine-tune before enough human-edited draft pairs exist.

## Proposed first experiment

Use one real, medium-sized article as the vertical slice.

1. Write the seed by hand.
2. Add 3–5 known-good sources and one local note collection.
3. Run one shallow research round.
4. Build a project wiki capped by stopping rules.
5. Ask five substantive questions and persist the useful answers.
6. Distill a claim-and-evidence guideline.
7. Run automated reflection and one human grilling session.
8. Render a draft in a separate low-reasoning style pass.
9. Compare it with a draft produced directly from the same seed and sources.
10. Record factual corrections, structural edits, voice edits, time, and token cost.

Only after this works should the same shared engine receive the building profile.

## Decisions to discuss before implementation

1. Where is the long-lived resource archive, and which parts may Codex read?
2. Is the first real output an article, a technical document, or a software feature?
3. Should project wikis remain in this repository, live beside each target project, or be created in a separate private data directory?
4. Which sources are available initially: local Markdown, Readwise, web URLs, YouTube, GitHub repositories, or something else?
5. Should the first version be a set of Codex skills only, or must it also expose a standalone CLI?
6. What constitutes human approval before prose rendering or code execution?
7. Which provenance details must survive into the public output?

## Bottom line

The valuable invention is not “use a wiki with an LLM.” It is the sequence and the boundaries:

`human intent → selective retrieval → scoped living context → grounded plan → critique → specialized execution`

The archive stays broad and inert. The project wiki becomes narrow and alive. The plan becomes smaller still and decisive. Writing and coding are two last-mile uses of the same research memory system.
