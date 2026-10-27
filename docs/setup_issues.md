
## Common setup problems

### `uv: command not found`

Install uv using its official installation guide and restart the terminal so the updated `PATH` is loaded. Or use the [venv and pip method](#alternative-setup-venv-and-pip-no-uv) instead.

### `make: command not found`

- **macOS:** install Apple command-line tools or GNU Make.
- **Windows:** use WSL 2 (recommended) or install GNU Make and use Git Bash.
- Confirm `make --version` works in the same terminal where you run project commands.
- With the venv method you can skip Make and run `ruff`, `ty`, and `pytest` directly.

### `uv run` cannot find Ruff, pytest, or ty

Check that the tool is declared in the project dependencies. If needed:

```bash
uv add --dev ruff pytest ty
uv lock
```

Then synchronize:

```bash
uv sync --all-extras
```

Commit the updated `pyproject.toml` and `uv.lock`.

### `ruff`, `pytest`, or `ty` not found (venv method)

The virtual environment is probably not activated, or the tools were not installed.

```bash
source .venv/bin/activate         # macOS / Linux / WSL
source .venv/Scripts/activate     # Git Bash
.venv\Scripts\Activate.ps1        # PowerShell
pip install ruff pytest ty
```

Your prompt should show `(.venv)` when the environment is active.

### PowerShell: "running scripts is disabled on this system"

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

Then run `.venv\Scripts\Activate.ps1` again.

### `py` is not recognized (Windows)

Reinstall Python from <https://www.python.org/downloads/> with the **py launcher** option enabled, or use `python -m venv .venv` if `python` is on your `PATH`. Check the version with `python --version`; it should be 3.12.x.

### `ERROR: unknown option --group` or `No such option: --group`

Your pip is older than 25.1. Upgrade it:

```bash
python -m pip install --upgrade pip
```

Or install the dev tools directly with `pip install ruff pytest ty`.

### `ModuleNotFoundError: No module named 'finsight'`

The project is not installed into the active environment. From the repository root, run `pip install -e .` (venv method) or `uv sync` (uv method).

### Git hook does not run

Check the configured hooks directory:

```bash
git config --get core.hooksPath
```

It should report `.githooks`. Reinstall the hook:

```bash
make hooks-install
```

Check that both scripts exist and that the hook is executable in macOS/WSL or callable from Git Bash on Windows.

### Formatting check fails

Run:

```bash
make format
make lint-fix
make check
```

Review the changes before staging them.

### PostgreSQL container does not start

Check Docker Desktop is running and inspect:

```bash
docker compose ps
docker compose logs postgres
```

Make sure port `5432` is not already in use and that the local `.env` file has a `POSTGRES_PASSWORD` value.

### Tests fail only on one operating system

Check file paths, line endings, case-sensitive filenames, locale assumptions, time zones, and dependency versions. Prefer `pathlib` for filesystem paths and keep CI checks platform-independent where possible.
