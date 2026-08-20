#!/bin/bash
# install_sqlite.sh — Install/upgrade SQLite on Ubuntu or macOS

set -e

# ---------- helpers ----------
info()  { printf "\r[ \033[00;34m..\033[0m ] %s\n" "$1"; }
ok()    { printf "\r[ \033[00;32mOK\033[0m ] %s\n" "$1"; }
fail()  { printf "\r[ \033[0;31mFAIL\033[0m ] %s\n" "$1"; exit 1; }

# ---------- OS detection ----------
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="ubuntu"
else
    fail "Unsupported OS: $OSTYPE (only macOS and Ubuntu are supported)"
fi

info "Detected OS: $OS"

# ---------- install ----------
if [[ "$OS" == "macos" ]]; then
    # macOS — use Homebrew
    if ! command -v brew &> /dev/null; then
        fail "Homebrew is not installed. Install it first: https://brew.sh"
    fi

    info "Updating Homebrew formulae..."
    brew update

    if brew list sqlite &> /dev/null; then
        info "Upgrading SQLite..."
        brew upgrade sqlite
    else
        info "Installing SQLite..."
        brew install sqlite
    fi

    # Link keg-only sqlite to override system version (optional)
    info "Linking SQLite (keg-only) for PATH priority..."
    brew link --force sqlite 2>/dev/null || true

elif [[ "$OS" == "ubuntu" ]]; then
    # Ubuntu / Linux — use apt
    info "Updating apt package index..."
    sudo apt-get update -qq

    info "Installing SQLite..."
    sudo apt-get install -y -qq sqlite3 libsqlite3-dev
fi

# ---------- verify ----------
if command -v sqlite3 &> /dev/null; then
    ok "SQLite installed successfully: $(sqlite3 --version)"
else
    fail "SQLite installation failed — sqlite3 not found in PATH"
fi