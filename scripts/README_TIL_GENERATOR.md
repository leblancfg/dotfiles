# Daily TIL Generator

Automated system that analyzes your shell history daily and creates "Today I Learned" blog posts via pull requests.

## Features

- Analyzes shell commands from the current day
- Uses OpenAI to identify interesting/educational commands
- Avoids republishing previously covered topics
- Generates concise TIL articles (< 1 page)
- Creates PRs automatically for review

## Setup

### Prerequisites

1. **Python 3.8+** with OpenAI library:
   ```bash
   pip install openai
   ```

2. **GitHub CLI** (for automatic PR creation):
   ```bash
   brew install gh
   gh auth login
   ```

3. **Environment Variables** (add to ~/.env or ~/.zshrc):
   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   export OPENAI_API_BASE="https://api.openai.com/v1"  # Optional
   export BLOG_REPO_PATH="$HOME/code/blog"  # Path to your blog repo
   ```

4. **Blog Repository Structure**:
   - Your blog should have a `content/til/` directory for TIL posts
   - Posts should use Markdown with front matter
   - **Important**: Feature branches are created from `dev`, not `main`
   - PRs will target the `dev` branch for review

### Installation as Cron Job

1. **Test the script manually first**:
   ```bash
   cd ~/dotfiles/scripts
   ./daily_til_generator.sh
   ```

2. **Add to crontab** (runs daily at 11 PM):
   ```bash
   crontab -e
   ```
   
   Add this line:
   ```cron
   0 23 * * * source $HOME/.env && $HOME/dotfiles/scripts/daily_til_generator.sh >> $HOME/.til_generator.log 2>&1
   ```

   Alternative times:
   - `0 9 * * *` - 9 AM daily
   - `30 17 * * *` - 5:30 PM daily
   - `0 22 * * 1-5` - 10 PM weekdays only

3. **Verify cron is running**:
   ```bash
   crontab -l  # List current cron jobs
   tail -f ~/.til_generator.log  # Monitor the log file
   ```

## How It Works

1. **History Analysis**: Reads ~/.zsh_history for commands from today
2. **AI Selection**: OpenAI identifies the most interesting/educational command
3. **Article Generation**: Creates a concise TIL post
4. **Git Workflow**:
   - Switches to `dev` branch (base for feature branches)
   - Creates a feature branch from `dev`
   - Commits the new article
   - Pushes to remote
   - Opens a PR to merge into `dev` (not `main`)

## Manual Usage

Run for a specific date:
```bash
python3 generate_til.py 2024-01-15  # Analyze commands from Jan 15, 2024
```

## Troubleshooting

- **No commands found**: Check `HISTSIZE` and `SAVEHIST` in ~/.zshrc
- **OpenAI errors**: Verify API key and network connectivity
- **PR creation fails**: Ensure `gh` is authenticated
- **Blog repo issues**: Check `BLOG_REPO_PATH` is correct

## Log Files

- Main log: `~/.til_generator.log`
- Cron errors: Check system mail or `/var/mail/$USER`

## Customization

Edit `generate_til.py` to:
- Change AI model (default: gpt-4o-mini)
- Adjust article length
- Modify filtering criteria
- Change blog post format