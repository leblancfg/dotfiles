#!/bin/bash

# TIL Generator Installation Script
# Sets up the daily TIL generator system

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=== TIL Generator Installation ==="
echo

# Check for required dependencies
echo "Checking dependencies..."

# Check for UV
if ! command -v uv &> /dev/null; then
    echo "❌ UV is required but not installed."
    echo "   Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi
echo "✅ UV found"

# Check for git
if ! command -v git &> /dev/null; then
    echo "❌ Git is required but not installed."
    exit 1
fi
echo "✅ Git found"

# Check for GitHub CLI (optional but recommended)
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found (PRs will be created automatically)"
else
    echo "⚠️  GitHub CLI not found (PRs will need to be created manually)"
    echo "   Install with: brew install gh"
fi

# Check for OpenAI API key
if [ -z "${OPENAI_API_KEY:-}" ]; then
    echo
    echo "⚠️  OPENAI_API_KEY environment variable not set"
    echo "   Please add to your shell config (~/.zshrc or ~/.bashrc):"
    echo "   export OPENAI_API_KEY='your-api-key-here'"
    echo
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ OpenAI API key found"
fi

# Check for blog repository
BLOG_REPO_PATH="${BLOG_REPO_PATH:-$HOME/src/github.com/leblancfg/leblancfg.github.io}"
if [ -d "$BLOG_REPO_PATH" ]; then
    echo "✅ Blog repository found at $BLOG_REPO_PATH"
else
    echo "❌ Blog repository not found at $BLOG_REPO_PATH"
    echo "   Please clone your blog repo or set BLOG_REPO_PATH environment variable"
    exit 1
fi

# Install Python dependencies using UV
echo
echo "Installing Python dependencies with UV..."
cd "$SCRIPT_DIR"

# Initialize UV project if needed
if [ ! -f "pyproject.toml" ]; then
    echo "Creating UV project configuration..."
    cat > pyproject.toml << 'EOF'
[project]
name = "til-generator"
version = "0.1.0"
description = "Daily TIL article generator from shell history"
requires-python = ">=3.8"
dependencies = [
    "openai>=1.0.0",
]

[tool.setuptools]
py-modules = ["generate_til"]

[tool.uv]
dev-dependencies = []
EOF
fi

# Install dependencies with UV
uv sync

echo "✅ Python dependencies installed with UV"

# Make scripts executable
chmod +x "$SCRIPT_DIR/generate_til.py"
chmod +x "$SCRIPT_DIR/daily_til_generator.sh"
echo "✅ Scripts made executable"

# Set up cron job
echo
echo "Setting up cron job..."

# Create cron entry (runs at 11:30 PM daily)
# Note: The script will source ~/.env automatically
CRON_CMD="30 23 * * * $SCRIPT_DIR/daily_til_generator.sh >> $HOME/.til_generator.log 2>&1"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "daily_til_generator.sh"; then
    echo "⚠️  Cron job already exists. Skipping..."
else
    # Add cron job
    (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
    echo "✅ Cron job added (runs daily at 11:30 PM)"
fi

echo
echo "=== Installation Complete ==="
echo
echo "The TIL generator has been set up to run daily at 11:30 PM."
echo "It will analyze your shell history and create a PR with an interesting TIL article."
echo
echo "You can also run it manually:"
echo "  $SCRIPT_DIR/daily_til_generator.sh"
echo
echo "Or test with a specific date:"
echo "  cd $SCRIPT_DIR && uv run python generate_til.py 2025-01-13"
echo
echo "Logs are saved to: ~/.til_generator.log"
echo
echo "To view/edit the cron job:"
echo "  crontab -e"
echo
echo "To uninstall:"
echo "  crontab -l | grep -v daily_til_generator.sh | crontab -"