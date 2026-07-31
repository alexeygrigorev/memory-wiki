# Memory Wiki

Memory Wiki turns a human brain dump into a small, project-scoped research wiki and then into an approved writing guideline or software implementation plan.

It implements the workflow:

```text
human intent → selective research → scoped wiki → grounded plan → critique → writing or implementation
```

The broad resource archive stays human-owned and read-only. Agents write only to the current project wiki until the user approves the final guideline.

See [APPROACH.md](APPROACH.md) for the reasoning and its relationship to Paul Iusztin's research workflow.

## Current capabilities

- One Codex skill with writing and building profiles.
- Plain Markdown and constrained YAML artifacts with no database.
- Safe, non-overwriting project initialization.
- An immutable seed protected by SHA-256 after scoping.
- Progressive-disclosure research and query instructions.
- Claim-level provenance markers.
- Objective reflection and human approval gates.
- Guarded workflow state transitions.
- Structural, provenance, link, source-index, and seed-integrity linting.
- Standard-library Python scripts with automated tests.

Research retrieval itself is agent-driven so it can use whatever source connectors and web tools are available in the active harness. The durable artifact format does not depend on Codex.

## Install for Codex

Clone the repository and link its canonical skill directory into your Codex skills directory:

```bash
git clone git@github.com:alexeygrigorev/memory-wiki.git
cd memory-wiki
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
test ! -e "${CODEX_HOME:-$HOME/.codex}/skills/memory-wiki"
ln -s "$PWD/skills/memory-wiki" "${CODEX_HOME:-$HOME/.codex}/skills/memory-wiki"
```

Start a new Codex session after installation. Invoke it explicitly with `$memory-wiki`, or ask Codex to research a substantial article or software change using a project-scoped wiki.

## Initialize a project

Run scripts from the skill directory:

```bash
cd skills/memory-wiki

python3 scripts/init_project.py ../../../projects/my-article \
  --mode writing \
  --title "My article"
```

For an existing brain dump, initialize and freeze it in one operation:

```bash
python3 scripts/init_project.py ../../../projects/my-article \
  --mode writing \
  --title "My article" \
  --seed-file /absolute/path/to/brain-dump.md \
  --source-root /absolute/path/to/notes
```

For building work:

```bash
python3 scripts/init_project.py ../../../projects/my-feature \
  --mode building \
  --title "Add project search" \
  --target-repo /absolute/path/to/repository
```

When initialization creates a template, complete `seed.md` and freeze it before research:

```bash
python3 scripts/freeze_seed.py ../../../projects/my-article
```

## Operate the workflow

Ask Codex:

```text
Use $memory-wiki to research this project. Search my configured sources first,
build only the project-scoped wiki, and show me unresolved questions before distilling.
```

The skill reads the compact source index first, then summaries and derivative pages, and raw sources only when required. Factual bullets use explicit provenance markers:

```text
- [FACT source-id] A source-backed paraphrase.
- [QUOTE source-id] A short direct quotation.
- [HUMAN] The user's view or experience.
- [INFERENCE source-a,source-b] A synthesis not directly stated by a source.
- [OPEN] An unresolved claim or disagreement.
```

Advance workflow states through the guarded script:

```bash
python3 scripts/advance_project.py ../../../projects/my-article researching \
  --reason "seed frozen; beginning source retrieval"

python3 scripts/advance_project.py ../../../projects/my-article distilled \
  --reason "stopping rules satisfied and guideline compiled"
```

After reflection and human grilling, explicit approval is required:

```bash
python3 scripts/advance_project.py ../../../projects/my-article critiqued \
  --reason "reflection and human grilling completed"

python3 scripts/advance_project.py ../../../projects/my-article approved \
  --approve \
  --reason "user approved guideline"
```

Writing projects may then become `rendered`; building projects may become `implemented`. Either may finally become `verified`.

## Validate

Lint one project:

```bash
python3 skills/memory-wiki/scripts/lint_project.py /path/to/project
```

Run the repository checks:

```bash
make check
```

The test suite uses only Python's standard library. Skill metadata validation runs through an isolated `uv` environment with PyYAML.

## Development rule

Each coherent milestone is committed and pushed separately so design changes, mistakes, and corrections remain visible in the public history.
