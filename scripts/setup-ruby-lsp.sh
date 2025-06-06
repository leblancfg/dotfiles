#!/bin/bash

# Exit on error
set -e

# Source chruby
if [[ -f /opt/dev/sh/chruby/chruby.sh ]]; then
  source /opt/dev/sh/chruby/chruby.sh
else
  echo "Error: chruby not found"
  exit 1
fi

# Use Ruby 3.3.6
chruby 3.3.6 || {
  echo "Error: Ruby 3.3.6 not available"
  exit 1
}

# Check Ruby version
ruby -v
echo "Using Ruby from: $(which ruby)"

# Install required gems
echo "Installing Ruby LSP tools..."
gem install ruby-lsp solargraph standard

# Verify installation
echo "Installation complete. Checking installations:"
echo "ruby-lsp: $(which ruby-lsp || echo 'Not found')"
echo "solargraph: $(which solargraph || echo 'Not found')"
echo "standardrb: $(which standardrb || echo 'Not found')"

echo ""
echo "Done! Now you can use Ruby LSP tools in Neovim."