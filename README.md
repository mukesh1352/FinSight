# FinSight

**A Data-Quality-Aware Financial Data Engineering and Machine Learning Platform**

FinSight is an end-to-end learning and portfolio project that turns transaction-level data into trustworthy analytical datasets. It identifies data-quality issues, preserves traceability, calculates financial metrics, evaluates transaction-category prediction models, and measures how data defects affect downstream results.

The project is built incrementally. Start with Python, CSV files, tests, and local developer tooling. Add PostgreSQL, SQL/dbt, machine learning, an API, a dashboard, Docker-based services, orchestration, and scalability experiments only when the earlier stages work.

> **Project status:** This README describes the intended project and development plan. Treat features as planned until they are implemented and tested. Do not report experimental results that have not actually been measured.

## Table of contents

- [Problem statement](#problem-statement)
- [Goals and scope](#goals-and-scope)
- [How FinSight works](#how-finsight-works)
- [Technology stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Choose a setup method](#choose-a-setup-method)
- [Setup on macOS (uv)](#setup-on-macos-uv)
- [Setup on Windows (uv)](#setup-on-windows-uv)
- [Alternative setup: venv and pip (no uv)](#alternative-setup-venv-and-pip-no-uv)
- [Run the project checks](#run-the-project-checks)
- [Native Git pre-commit hook](#native-git-pre-commit-hook)
- [GitHub Actions CI](#github-actions-ci)
- [Docker and PostgreSQL](#docker-and-postgresql)
- [Definition of done](#definition-of-done)

## Problem statement

Financial analytics systems depend on accurate, consistent, and reliable transaction data. Real-world transaction files can contain duplicate records, missing values, invalid amounts or dates, inconsistent merchant descriptions, and incorrect category labels. If these defects pass through a data pipeline undetected, they can distort financial reports, reduce the reliability of machine-learning predictions, and lead to misleading business insights.

Simply cleaning records is not enough. Cleaning decisions should be explainable, traceable, and evaluated so that downstream effects can be measured.

FinSight aims to build a reproducible, testable financial data engineering and data science platform that ingests public or synthetic transaction data, preserves original records, validates and standardizes fields, flags possible duplicates, stores trusted data, builds analytical models, evaluates category-classification models, and measures how controlled data defects affect financial metrics and model performance.

The system should help answer questions such as:

- How much can duplicate transactions change reported totals?
- Which validation rules detect injected defects most reliably?
- How do missing or inconsistent descriptions affect transaction categorization?
- Do data cleaning and quality controls improve selected financial metrics or model performance?
- Does Random Forest outperform a Logistic Regression baseline on the selected dataset?
- Does a small neural network provide a measurable benefit over traditional models?
- Can an import be rerun without accidentally duplicating records?
- Can a reported metric be traced back to its source batch and transformation logic?

The project prioritizes correctness, explainability, repeatability, and measurable evidence over using as many technologies as possible.

## Goals and scope

### Goals

- Build a repeatable CSV-to-analytics pipeline.
- Preserve source data and record import-batch metadata.
- Define data contracts and testable data-quality rules.
- Separate raw, validated, and curated transaction data.
- Store curated data and pipeline metadata in PostgreSQL.
- Build modular SQL transformations and analytical models with dbt Core.
- Calculate financial aggregates and reconciliation checks.
- Train and compare a baseline, Logistic Regression, Random Forest, and optionally a small PyTorch neural network.
- Introduce controlled defects into dataset copies and measure their effects.
- Expose real pipeline outputs through FastAPI and a Next.js dashboard.
- Add automated tests, Git hooks, CI, Docker, and eventually orchestration.
- Keep the core learning workflow free and runnable locally.

### Non-goals for the first version

- Connecting to real bank accounts or payment providers.
- Processing sensitive customer financial information.
- Building a production banking or financial-advice system.
- Claiming model predictions are safe for real financial decisions.
- Paying for cloud infrastructure or APIs.
- Starting with distributed systems before a local pipeline works.

## How FinSight works

The planned high-level flow is:

```text
Public / Synthetic Transaction Dataset
                  |
                  v
         CSV Ingestion (Python)
                  |
                  v
       Raw Records + Import Batch
                  |
                  v
       Validation and Standardization
                  |
          +-------+--------+
          |                |
          v                v
  Data Quality Findings  Curated Transactions
          |                |
          +-------+--------+
                  |
                  v
             PostgreSQL
                  |
                  v
          SQL Models / dbt Core
                  |
          +-------+--------+
          |                |
          v                v
 Financial Analytics   ML Experiments
                           |
                           v
              Baseline / Logistic Regression /
                Random Forest / PyTorch
          +----------------+----------------+
                           |
                           v
                    FastAPI Backend
                           |
                           v
                 Next.js Dashboard
```

Supporting tools: pytest, Ruff, ty, Git hooks, GitHub Actions, Docker Compose, and later Apache Airflow and PySpark.

### Processing layers

1. **Raw layer:** Preserves the source values and ingestion metadata.
2. **Validation layer:** Records errors, warnings, affected rows, and decisions.
3. **Curated layer:** Contains standardized records suitable for analysis.
4. **Analytics layer:** Contains tested SQL/dbt models and financial metrics.
5. **ML layer:** Contains features, predictions, model versions, and evaluation results.
6. **Serving layer:** Exposes selected outputs through an API and dashboard.

A failed validation should not silently disappear. Record the reason, affected row, severity, and action. Some records should be flagged or quarantined for review rather than automatically corrected or deleted.

## Technology stack

| Technology | Purpose | When to introduce it |
|---|---|---|
| Python | Ingestion, validation, transformations, experiments | First |
| uv (or venv + pip) | Python version and dependency management | First |
| Pandas and NumPy | CSV processing and numerical operations | First |
| Ruff | Python linting and formatting | First |
| ty | Static type checking | Early |
| pytest | Unit and integration tests | First |
| Git and GitHub | Version control and collaboration | First |
| Native Git hook | Run local checks before a commit | Early |
| GitHub Actions | Repeat checks on pushes and pull requests | Once tests exist |
| PostgreSQL | Persistent raw and curated data | After CSV pipeline works |
| SQL | Reconciliation and analytical queries | With PostgreSQL |
| dbt Core | Modular SQL models, tests, and documentation | After SQL basics |
| scikit-learn | Baseline and traditional classifiers | After clean data exists |
| PyTorch | Small neural-network experiment | Optional later phase |
| FastAPI and Pydantic | API and request/response validation | After pipeline outputs work |
| Next.js, TypeScript, Tailwind CSS | Dashboard | After API exists |
| Docker and Docker Compose | Repeatable services and local database | Introduce gradually |
| Apache Airflow | Workflow orchestration and retries | After tasks work independently |
| PySpark and Parquet | Scale and storage-format benchmarks | Optional advanced phase |

Do not install or run every service at once. A small, tested working system is more valuable than an unfinished stack.

## Prerequisites

Install the following tools:

- **Git**: version control.
- **Python 3.12**: the project's configured Python version.
- **uv** *(recommended)*: Python package and environment manager. Not needed if you use the `venv` + `pip` method.
- **GNU Make** *(optional with the venv method)*: runs the project's Makefile commands.
- **Docker Desktop**: needed later for PostgreSQL or other containerized services.
- **A code editor**: VS Code is a reasonable choice.

You do not need Docker to run the initial Python checks. Install it when you reach the database phase.

### Check whether tools are installed

Run these commands in your terminal.

```bash
git --version
python --version
uv --version
make --version
```

On some Windows installations, use `py --version` instead of `python --version`. The project's `uv` commands will manage the project environment after setup.

## Choose a setup method

| Method | Best for | Uses `uv.lock` | Works with `make check` as-is |
|---|---|---|---|
| **uv** (recommended) | Reproducible installs identical to CI | Yes | Yes |
| **venv + pip** | You do not want to install uv, or you want the standard-library workflow | No | No, run tools directly (see [below](#running-the-checks-without-uv)) |

Pick one method and stick with it for a given clone of the repository.

## Setup on macOS (uv)

These instructions work for Intel and Apple Silicon Macs. To use `venv` and `pip` instead, jump to [Alternative setup: venv and pip](#alternative-setup-venv-and-pip-no-uv).

### 1. Install or verify Git

Check:

```bash
git --version
```

If Git is missing, install Apple command-line developer tools:

```bash
xcode-select --install
```

Follow the installation prompts, then check `git --version` again.

### 2. Install uv

If Homebrew is installed:

```bash
brew install uv
```

Alternatively, use the installation instructions on the official uv website: <https://docs.astral.sh/uv/getting-started/installation/>.

Close and reopen the terminal if the `uv` command is not found. Verify:

```bash
uv --version
```

### 3. Clone the repository

Replace the URL with the actual URL of your GitHub repository:

```bash
mkdir -p ~/Documents/Projects
cd ~/Documents/Projects
git clone <YOUR_REPOSITORY_URL>
cd FinSight
```

If you already cloned the repository, just navigate into it:

```bash
cd ~/Documents/Projects/FinSight
```

### 4. Install the project environment

From the directory containing `pyproject.toml`, run:

```bash
make install
```

The Makefile target should install Python 3.12 through uv and synchronize the project dependencies. It assumes the Makefile, `pyproject.toml`, and dependency declarations are present.

If `make` is not installed, use the Apple command-line tools from step 1 or install GNU Make through your preferred package manager.

### 5. Check the environment

```bash
uv run python --version
uv run ruff --version
uv run pytest --version
```

If the `ty` checker is configured in the Makefile, verify it too:

```bash
uv run ty --version
```

If a tool is missing from the project dependencies, add it as a development dependency and commit the resulting `pyproject.toml` and `uv.lock` changes. For example:

```bash
uv add --dev ruff pytest ty
```

### 6. Run the checks

```bash
make check
```

This runs the configured lint, formatting, type-checking, and test commands. Fix any errors before moving on.

## Setup on Windows (uv)

There are two practical options. For the smoothest compatibility with this project's Makefile and Bash hook scripts, use **WSL 2**. A native Windows setup is also possible if you install a compatible Bash environment and GNU Make. To use `venv` and `pip` instead of uv on Windows, jump to [Alternative setup: venv and pip](#alternative-setup-venv-and-pip-no-uv).

### Option A: Windows with WSL 2 (recommended)

WSL runs a Linux development environment on Windows and is a convenient choice for projects using Makefiles and shell scripts.

#### 1. Install WSL

Open PowerShell as Administrator:

```powershell
wsl --install
```

Restart Windows if prompted. Open the installed Linux distribution (usually Ubuntu) and create the Linux username and password when requested.

For troubleshooting and other installation options, use Microsoft's official guide: <https://learn.microsoft.com/windows/wsl/install>.

#### 2. Install Git and build tools in Ubuntu

Open the Ubuntu terminal:

```bash
sudo apt update
sudo apt install -y git curl build-essential
```

Verify:

```bash
git --version
make --version
```

#### 3. Install uv in Ubuntu

Use the official uv installation instructions: <https://docs.astral.sh/uv/getting-started/installation/>.

For example, the official installer can be run from the Ubuntu terminal using:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Restart the terminal or load the shell environment as instructed by the installer, then verify:

```bash
uv --version
```

#### 4. Clone the repository inside WSL

Keep the working repository in the Linux filesystem for better performance:

```bash
mkdir -p ~/projects
cd ~/projects
git clone <YOUR_REPOSITORY_URL>
cd FinSight
```

If the repository already exists, navigate to its directory instead.

#### 5. Install dependencies and run checks

```bash
make install
make check
```

Use this same Ubuntu/WSL terminal for Git commands so that Git uses the Linux environment and its hook configuration consistently.

### Option B: Native Windows

This option keeps the repository on Windows. Because the native hook uses Bash and the Makefile uses GNU Make, you need compatible versions of both.

#### 1. Install Git for Windows

Download and install Git for Windows: <https://git-scm.com/download/win>.

Git Bash provides the Bash shell required by the hook script. During installation, use the standard option that makes Git available from your terminal.

Open Git Bash and verify:

```bash
git --version
```

#### 2. Install Python and uv

Install Python 3.12 if needed, or let uv install it for the project.

Install uv using the official instructions: <https://docs.astral.sh/uv/getting-started/installation/>.

If you use PowerShell, a package-manager installation may be available:

```powershell
winget install --id astral-sh.uv -e
```

Open a new terminal and verify:

```powershell
uv --version
```

If you use Git Bash, verify `uv --version` there as well. The executable must be on that shell's `PATH`.

#### 3. Install GNU Make

Git for Windows does not guarantee that GNU Make is installed. Install a compatible GNU Make distribution and ensure `make` is on the `PATH` used by your terminal.

For example, if you use Chocolatey and its package is available in your environment:

```powershell
choco install make
```

Follow the package's instructions, open a new terminal, and verify:

```bash
make --version
```

If your chosen Make installation is not visible from Git Bash, configure the appropriate `PATH` or use WSL 2 instead.

#### 4. Clone the repository

Open Git Bash:

```bash
mkdir -p ~/Documents/Projects
cd ~/Documents/Projects
git clone <YOUR_REPOSITORY_URL>
cd FinSight
```

#### 5. Install dependencies and run checks

```bash
make install
make check
```

Use Git Bash for commits so the Bash pre-commit hook can run. If this setup becomes troublesome, WSL 2 is the simpler and more consistent option.

## Alternative setup: venv and pip (no uv)

Use this method if you do not want to install uv. You need **Python 3.12** and **pip** installed. This uses only Python's built-in `venv` module.

> **Trade-offs:** pip ignores `uv.lock`, so dependency versions may drift from what uv and CI install. The Makefile targets call `uv run ...`, so with this method you run the tools directly (see [Running the checks without uv](#running-the-checks-without-uv)).

### Check Python first

```bash
# macOS / Linux / WSL
python3.12 --version
```

```powershell
# Windows
py -3.12 --version
```

If Python 3.12 is missing, install it from <https://www.python.org/downloads/> (on Windows, tick **Add python.exe to PATH** and keep the **py launcher** option enabled), or on macOS use `brew install python@3.12`.

### macOS, Linux, and WSL

```bash
cd FinSight

# 1. Create the virtual environment
python3.12 -m venv .venv

# 2. Activate it
source .venv/bin/activate

# 3. Upgrade pip
python -m pip install --upgrade pip

# 4. Install the project and development tools
pip install -e .
pip install --group dev        # needs pip 25.1+; see the note below

# 5. Verify
python --version
ruff --version
pytest --version
```

### Windows: PowerShell

```powershell
cd FinSight

# 1. Create the virtual environment (the py launcher selects Python 3.12)
py -3.12 -m venv .venv

# 2. Activate it
.venv\Scripts\Activate.ps1

# 3. Upgrade pip
python -m pip install --upgrade pip

# 4. Install the project and development tools
pip install -e .
pip install --group dev

# 5. Verify
python --version
ruff --version
pytest --version
```

If PowerShell blocks activation with a "running scripts is disabled" error, run this once, then activate again:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Windows: Command Prompt (cmd)

```bat
cd FinSight
py -3.12 -m venv .venv
.venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -e .
pip install --group dev
```

### Windows: Git Bash

```bash
cd FinSight
py -3.12 -m venv .venv
source .venv/Scripts/activate
python -m pip install --upgrade pip
pip install -e .
pip install --group dev
```

Git Bash uses `Scripts/`, not `bin/`.

### If `pip install --group dev` does not work

The `--group` flag requires **pip 25.1 or newer** and dev tools declared under `[dependency-groups]` in `pyproject.toml` (which `uv add --dev` creates). If it fails, use one of these instead:

```bash
# Option 1: install the tools directly
pip install ruff pytest ty

# Option 2: if pyproject.toml declares [project.optional-dependencies] dev = [...]
pip install -e ".[dev]"

# Option 3: if the repository contains a requirements.txt
pip install -r requirements.txt
```

To generate a `requirements.txt` from the uv lockfile for pip users (requires uv on the maintainer's machine only):

```bash
uv export --no-hashes --all-groups -o requirements.txt
```

### Running the checks without uv

With the virtual environment **activated**, run the tools directly:

```bash
ruff check .
ruff format --check .
ty check
pytest
```

To auto-fix lint and formatting issues:

```bash
ruff check . --fix
ruff format .
```

To run tests with coverage (requires `pytest-cov`):

```bash
pytest --cov=src/finsight
```

### Make the Makefile work with both methods (optional)

If you want `make check` to work without uv, define a command prefix that defaults to `uv run` and can be overridden:

```makefile
# Use "make check RUN=" to run tools from an activated venv instead of uv
RUN ?= uv run

lint:
	$(RUN) ruff check .

format-check:
	$(RUN) ruff format --check .

typecheck:
	$(RUN) ty check

test:
	$(RUN) pytest

check: lint format-check typecheck test
```

Then, with the venv activated:

```bash
make check RUN=
```

### Deactivate or recreate the environment

```bash
deactivate                          # leave the virtual environment
```

Delete the environment to start fresh:

```bash
rm -rf .venv                        # macOS / Linux / WSL / Git Bash
```

```bat
rmdir /s /q .venv
```

```powershell
Remove-Item -Recurse -Force .venv   # PowerShell
```

Always activate `.venv` before running project commands, and make sure `.venv/` is listed in `.gitignore`.

## Run the project checks

FinSight uses a Makefile to provide consistent commands.

| Command | Purpose |
|---|---|
| `make help` | List available commands |
| `make install` | Install Python 3.12 and synchronize dependencies |
| `make sync` | Synchronize dependencies from the lockfile |
| `make lock` | Update the lockfile |
| `make lint` | Check Python lint issues |
| `make lint-fix` | Automatically fix supported lint issues |
| `make format` | Format Python files |
| `make format-check` | Verify formatting without changing files |
| `make typecheck` | Run the ty static type checker |
| `make test` | Run pytest |
| `make test-cov` | Run tests with coverage |
| `make check` | Run linting, formatting validation, type checking, and tests |
| `make hooks-install` | Configure the native Git pre-commit hook |
| `make pre-commit` | Run the pre-commit validation script manually |
| `make clean` | Remove generated caches and test artifacts |

Run `make help` to inspect the targets defined in the current Makefile. Commands may need adjustment if your local Makefile differs from the documented version.

If you are not using uv, see [Running the checks without uv](#running-the-checks-without-uv).

## Native Git pre-commit hook

FinSight uses a small shell script and Git's built-in hook system. This avoids adding a separate hook-management dependency.

### 1. Validation script

Create `scripts/pre-commit-checks.sh`:

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

echo "Running FinSight quality checks..."
make check

echo "All checks passed. Commit permitted."
```

This script reuses the Makefile rather than duplicating lint, formatting, type-checking, and test commands.

> **venv users:** activate `.venv` before committing and use the `RUN ?= uv run` Makefile variant shown above, then change the `make check` line to `make check RUN=`. Otherwise the hook will look for uv.

### 2. Git hook

Create `.githooks/pre-commit`:

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
exec "$ROOT_DIR/scripts/pre-commit-checks.sh"
```

Git runs this hook before completing a commit. A non-zero exit status blocks the commit.

### 3. Enable the hook

On macOS or Linux/WSL:

```bash
chmod +x scripts/pre-commit-checks.sh
chmod +x .githooks/pre-commit
make hooks-install
```

The `hooks-install` target sets:

```bash
git config core.hooksPath .githooks
```

On native Windows, run the executable-bit and setup commands from Git Bash, not PowerShell. Git for Windows can execute Bash hook scripts when they are configured correctly.

### 4. Test it

Run the checks manually:

```bash
make pre-commit
```

Then stage your changes and commit:

```bash
git add .
git commit -m "chore: configure quality gates"
```

If any check fails, fix the problem and commit again.

> **Important:** Local Git hooks can be bypassed, for example with `git commit --no-verify`, and they only run on machines where they are installed. GitHub Actions must run the checks independently.

## GitHub Actions CI

GitHub Actions runs the checks on a clean GitHub-hosted runner when code is pushed or a pull request is opened. It protects the project even if a contributor has not installed the local hook.

Create `.github/workflows/ci.yml`:

```yaml
name: FinSight CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  quality:
    name: Code Quality and Tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v6
        with:
          enable-cache: true

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --locked --all-extras

      - name: Run all quality checks
        run: make check
```

This workflow assumes that:

- `uv.lock` is committed and up to date.
- `pyproject.toml` declares the required runtime and development dependencies.
- The Makefile and all test configuration files are committed.
- The tests do not require unavailable external services.

CI uses uv even if you develop locally with `venv` and `pip`. That keeps CI results tied to the lockfile.

Keep GitHub Actions versions up to date. For stricter supply-chain security, pin third-party actions to verified full commit SHAs.

For stronger enforcement, configure a GitHub branch protection rule or repository ruleset that requires the CI status check to pass before merging into `main`.

## Docker and PostgreSQL

Docker is introduced gradually. First make the Python CSV pipeline work. Then run PostgreSQL in Docker Compose, connect the Python code to it, and add application containers when those services exist.

### 1. Install Docker Desktop

Download Docker Desktop for your operating system:

- macOS: <https://docs.docker.com/desktop/setup/install/mac-install/>
- Windows: <https://docs.docker.com/desktop/setup/install/windows-install/>

On Windows, follow the WSL 2 requirements if you use the WSL backend. Start Docker Desktop and verify:

```bash
docker --version
docker compose version
```

### 2. Add a PostgreSQL Compose service

When you reach the database phase, create `docker-compose.yml`:

```yaml
services:
  postgres:
    image: postgres:16
    container_name: finsight-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: finsight
      POSTGRES_USER: finsight
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:?Set POSTGRES_PASSWORD in your local .env file}
    ports:
      - "5432:5432"
    volumes:
      - finsight_pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U finsight -d finsight"]
      interval: 5s
      timeout: 5s
      retries: 10

volumes:
  finsight_pgdata:
```

Create a local `.env` file at the repository root:

```dotenv
POSTGRES_PASSWORD=replace_with_a_local_development_password
```

Use a development-only password for this local environment. Make sure `.env` is listed in `.gitignore` and never commit it.

### 3. Start and inspect PostgreSQL

```bash
docker compose up -d postgres
docker compose ps
docker compose logs -f postgres
```

Stop the service without deleting its data:

```bash
docker compose stop postgres
```

Or remove the container while preserving the named volume:

```bash
docker compose down
```

> **Warning:** `docker compose down -v` deletes the named database volume and its local contents. Use it only when you intentionally want to reset the database.

When Python runs directly on your computer, the database host is normally `localhost` and the published port is `5432`. When Python runs in another Compose service, use the service name `postgres` as the hostname.

## Definition of done

The core project is complete when:

- A documented public or synthetic dataset can be loaded.
- Ingestion records batch metadata and preserves source records.
- Selected data-quality issues are detected and explained.
- Potential duplicates are flagged under a documented policy.
- Curated transactions are stored in PostgreSQL.
- SQL/dbt models produce documented financial metrics.
- Automated tests cover important validation and transformation logic.
- Repeated imports follow the documented idempotency policy.
- At least one baseline and a traditional model are evaluated reproducibly.
- Controlled data-quality experiments compare analytical and predictive results.
- FastAPI serves actual pipeline results.
- The dashboard displays actual backend data.
- Docker Compose can start the core local services.
- Local checks and GitHub Actions CI work.
- Setup, test, run, and reset instructions are documented.
- Reported results are measured, not invented.
- The project can be demonstrated without paid APIs or cloud services.

Airflow orchestration and PySpark benchmarks are advanced goals; they should not prevent a reliable core release.

## Future improvements

Possible extensions include:

- Confidence-based review for uncertain predictions.
- Incremental ingestion and safe reprocessing.
- Better schema evolution and data contracts.
- More complete lineage visualization.
- Structured experiment tracking and model versioning.
- More reconciliation checks and failure-recovery tests.
- Additional processing and memory benchmarks.

Only add an extension when it answers a clear engineering or analytical question.

## Final project principle

Build a reliable pipeline first, measure the effects of data quality next, compare models with controlled experiments, and then make the results accessible through an API and dashboard.

FinSight should demonstrate not only the ability to use Data Engineering and Data Science tools, but also the ability to explain why each tool is needed, test system behavior, measure outcomes honestly, and reproduce the results on another machine.