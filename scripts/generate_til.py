#!/usr/bin/env python3

import os
import sys
import json
import re
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Dict, Optional
import subprocess

def get_openai_client():
    """Initialize OpenAI client with environment variables."""
    import openai
    
    api_key = os.environ.get('OPENAI_API_KEY')
    api_base = os.environ.get('OPENAI_API_BASE')
    
    if not api_key:
        print("Error: OPENAI_API_KEY environment variable not set")
        sys.exit(1)
    
    client = openai.OpenAI(api_key=api_key)
    if api_base:
        client.base_url = api_base
    
    return client

def parse_zsh_history(history_file: Path, target_date: datetime) -> List[str]:
    """Parse zsh history file and extract commands from target date."""
    commands = []
    target_date_str = target_date.strftime('%Y-%m-%d')
    
    try:
        with open(history_file, 'r', errors='ignore') as f:
            for line in f:
                # ZSH extended history format: ': timestamp:duration;command'
                if line.startswith(':'):
                    parts = line.split(';', 1)
                    if len(parts) == 2:
                        timestamp_part = parts[0].strip()
                        command = parts[1].strip()
                        
                        # Extract timestamp (format: ': 1234567890:0')
                        match = re.match(r': (\d+):\d+', timestamp_part)
                        if match:
                            timestamp = int(match.group(1))
                            cmd_date = datetime.fromtimestamp(timestamp)
                            
                            if cmd_date.date() == target_date.date():
                                # Clean up the command
                                if command and not command.startswith('#'):
                                    commands.append(command)
                else:
                    # Fallback for simple history format
                    if line.strip() and not line.startswith('#'):
                        commands.append(line.strip())
    
    except FileNotFoundError:
        print(f"History file not found: {history_file}")
        sys.exit(1)
    
    return commands

def get_published_commands(blog_path: Path) -> List[str]:
    """Extract previously published commands from TIL posts."""
    published_commands = []
    til_dir = blog_path / 'content' / 'til'
    
    if not til_dir.exists():
        return published_commands
    
    for post_file in til_dir.glob('*.md'):
        try:
            with open(post_file, 'r') as f:
                content = f.read()
                # Extract code blocks that might contain commands
                code_blocks = re.findall(r'```(?:bash|sh|shell)?\n(.*?)\n```', content, re.DOTALL)
                for block in code_blocks:
                    # Extract individual commands from code blocks
                    for line in block.split('\n'):
                        line = line.strip()
                        if line and not line.startswith('#'):
                            # Remove prompts like $ or >
                            line = re.sub(r'^[$>]\s*', '', line)
                            published_commands.append(line)
        except Exception as e:
            print(f"Warning: Could not read {post_file}: {e}")
    
    return published_commands

def analyze_commands(commands: List[str], published_commands: List[str]) -> Dict:
    """Use OpenAI to analyze commands and find interesting patterns."""
    client = get_openai_client()
    
    # Deduplicate and clean commands
    unique_commands = list(set(commands))
    
    # Filter out very common/simple commands
    filtered_commands = [
        cmd for cmd in unique_commands
        if not re.match(r'^(ls|cd|pwd|echo|cat|rm|mv|cp|exit|clear|history)(\s|$)', cmd)
        and len(cmd) > 5
    ]
    
    if not filtered_commands:
        return None
    
    # Create the prompt
    prompt = f"""Analyze these shell commands I ran today and identify the most interesting or educational one for a "Today I Learned" blog post.

Commands run today:
{chr(10).join(filtered_commands[:50])}  # Limit to 50 commands to avoid token limits

Previously published commands (avoid these):
{chr(10).join(published_commands[:30])}  # Show some recent published ones

Please identify ONE command or pattern that would make an interesting TIL post. Consider:
1. Complex command combinations or pipelines
2. Useful flags or options that aren't commonly known
3. Clever uses of standard tools
4. Problem-solving approaches
5. Performance or efficiency tricks

Return a JSON object with:
{{
  "command": "the exact command or command pattern",
  "title": "A catchy TIL title (without 'TIL' prefix)",
  "summary": "One sentence explaining what makes this interesting",
  "is_interesting": true/false,
  "reason": "Why this is worth sharing"
}}

If none of the commands are particularly interesting or educational, set is_interesting to false."""

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are a technical writer who identifies interesting command-line patterns and techniques."},
                {"role": "user", "content": prompt}
            ],
            response_format={"type": "json_object"},
            temperature=0.7
        )
        
        return json.loads(response.choices[0].message.content)
    
    except Exception as e:
        print(f"Error calling OpenAI API: {e}")
        return None

def generate_til_article(command_info: Dict) -> Optional[str]:
    """Generate a TIL article based on the selected command."""
    if not command_info or not command_info.get('is_interesting'):
        return None
    
    client = get_openai_client()
    
    prompt = f"""Write a concise "Today I Learned" blog post about this command/technique:

Command: {command_info['command']}
Title: {command_info['title']}
Summary: {command_info['summary']}

Guidelines:
- Keep it under 300 words
- Start with a brief introduction of the problem or use case
- Explain the command/technique clearly
- Include a practical example with the actual command
- Add a brief explanation of how it works
- End with when/why this is useful
- Use Markdown formatting
- Include appropriate code blocks with bash/shell syntax highlighting
- Don't include a title (it will be added separately)
- Make it informative but conversational
- Focus on the learning aspect

Write the article content only (no title, no "TIL" prefix)."""

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are a technical blogger writing concise, educational posts about command-line tools and techniques."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.8,
            max_tokens=500
        )
        
        return response.choices[0].message.content.strip()
    
    except Exception as e:
        print(f"Error generating article: {e}")
        return None

def create_til_post(title: str, content: str, blog_path: Path) -> Path:
    """Create a new TIL post file in the blog repository."""
    # Generate filename
    date_str = datetime.now().strftime('%Y-%m-%d')
    slug = re.sub(r'[^a-z0-9-]', '', title.lower().replace(' ', '-'))
    filename = f"{date_str}-{slug}.md"
    
    # Ensure TIL directory exists
    til_dir = blog_path / 'content' / 'til'
    til_dir.mkdir(parents=True, exist_ok=True)
    
    # Create the post file
    post_path = til_dir / filename
    
    # Format the post with front matter
    post_content = f"""---
title: "{title}"
date: {datetime.now().isoformat()}
draft: false
tags: ["cli", "terminal", "automation"]
---

{content}
"""
    
    with open(post_path, 'w') as f:
        f.write(post_content)
    
    return post_path

def main():
    # Configuration
    history_file = Path.home() / '.zsh_history'
    blog_path = Path.home() / 'src' / 'github.com' / 'leblancfg' / 'leblancfg.github.io'
    
    # Allow overriding the date (useful for testing)
    if len(sys.argv) > 1:
        target_date = datetime.strptime(sys.argv[1], '%Y-%m-%d')
    else:
        target_date = datetime.now()
    
    # Parse today's commands
    print(f"Analyzing commands from {target_date.strftime('%Y-%m-%d')}...")
    commands = parse_zsh_history(history_file, target_date)
    
    if not commands:
        print("No commands found for the target date")
        sys.exit(0)
    
    print(f"Found {len(commands)} commands")
    
    # Get previously published commands
    published_commands = get_published_commands(blog_path)
    print(f"Found {len(published_commands)} previously published commands")
    
    # Analyze commands
    print("Analyzing commands for interesting patterns...")
    command_info = analyze_commands(commands, published_commands)
    
    if not command_info or not command_info.get('is_interesting'):
        print("No interesting commands found today")
        sys.exit(0)
    
    print(f"Selected command: {command_info['command']}")
    print(f"Title: {command_info['title']}")
    
    # Generate article
    print("Generating TIL article...")
    article_content = generate_til_article(command_info)
    
    if not article_content:
        print("Failed to generate article")
        sys.exit(1)
    
    # Create the post file
    post_path = create_til_post(command_info['title'], article_content, blog_path)
    print(f"Created TIL post: {post_path}")
    
    # Output the path for the shell script to use
    print(f"POST_FILE={post_path}")

if __name__ == "__main__":
    main()