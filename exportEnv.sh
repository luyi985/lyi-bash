
# Load secrets from .env (gitignored) if it exists
if [ -f "$script_dir/.env" ]; then
    set -a
    source "$script_dir/.env"
    set +a
fi