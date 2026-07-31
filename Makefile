.PHONY: check test validate

check: test validate

test:
	python3 -m unittest discover -s tests -v

validate:
	uv run --with pyyaml "$${CODEX_HOME:-$$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" skills/memory-wiki
