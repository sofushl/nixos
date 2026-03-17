# Check for uv on nixos
if ! command -v uv &> /dev/null; then
    echo "Error: 'uv' is not installed. Please install with 'nix-shell -p uv' or 'nix-env -iA nixpkgs.uv'."
    exit 1
fi

# Check if pyproject.toml exists
if [ ! -f "pyproject.toml" ]; then
    echo "Error: pyproject.toml not found in current directory ($(pwd))"
    exit 1
fi

# Enter nix-shell and run uv
nix-shell -p python314 uv --run "
  uv venv --python \$(which python)
  uv sync
"