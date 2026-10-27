
.DEFAULT_GOAL := help

# Project configuration
UV      := uv
PYTHON  := 3.12

.PHONY: help install sync lock \
        lint lint-fix format format-check \
        typecheck test test-cov check clean

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  %-16s %s\n", $$1, $$2}'

install: ## Create the environment and install all dependencies
	$(UV) python install $(PYTHON)
	$(UV) sync --all-extras

sync: ## Synchronize the environment with the lockfile
	$(UV) sync --all-extras

lock: ## Update the dependency lockfile
	$(UV) lock

lint: ## Check Python code for linting issues
	$(UV) run ruff check .

lint-fix: ## Automatically fix supported linting issues
	$(UV) run ruff check . --fix

format: ## Format Python files
	$(UV) run ruff format .

format-check: ## Check formatting without changing files
	$(UV) run ruff format --check .

typecheck: ## Run the ty static type checker
	$(UV) run ty check

test: ## Run unit tests
	$(UV) run pytest -v

test-cov: ## Run tests with coverage reporting
	$(UV) run pytest --cov --cov-report=term-missing

check: lint format-check typecheck test ## Run all code quality checks

clean: ## Remove generated Python caches and test artifacts
	rm -rf .pytest_cache .ruff_cache .mypy_cache .coverage htmlcov
	find . -type d -name __pycache__ -prune -exec rm -rf {} +
