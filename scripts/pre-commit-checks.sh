echo "========================="
if ! command -v uv>/dev/null 2&1; then
    echo "ERROR: uv is not installed in the system or not in the PATH"
    exit 1
fi

echo ""
echo "[1/3] Checking the python linting..."
uv run ruff check .

echo ""
echo "[2/3] Checking the code formatting..."
uv run ruff format --check .

echo ""
echo "[3/3] Running the tests..."
uv run pytest -q

echo ""
echo "ALL THE TESTS HAVE BEEN PERFORMED PERFORMED."