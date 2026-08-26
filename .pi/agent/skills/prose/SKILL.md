---
name: prose
description: >
  Always use this skill whenever an agent writes prose intended to be read by humans, especially
  responses longer than two sentences. Trigger for explanations, summaries, recommendations,
  reports, Slack messages, documentation, PR descriptions, READMEs, and other natural-language
  writing where clarity, readability, tone, and structure matter. Do not trigger for code,
  structured data, terse labels, or very short responses of one or two sentences.
user-invocable: false
---

There are a couple facets that are really important to nail when writing prose meant to be consumed
by humans And I have a very strict and stringent bar on the quality, readability, clarity, and
overall organicness of prose that it's written by agents.

Whenever writing prose meant to be consumed by humans, it's often worth having a two-pass approach:

1. start by writing the first draft in a temp file or the like.
   - if you have access to a memory tool, search for relevant context on the expected form, e.g.
     - a PR description template and guidelines
     - rules learned from sharing posts on Slack
     - etc.
   - Guidelines:
     - optimize for clarity and unambiguity
     - prefer a lexical density under 50%
     - avoid jargon at all costs; that is, terms specific only to the codebase, problem, or current
       agent session
     - use ASD-STE100 Simplified Technical English
     - when writing docs, use Google developer docs style guidelines
   - use the `leblancfg` skill: write in the author's voice and cognitive lens
2. make sure to run these skills after you've done the first draft:
   - deslop: remove tells and writing tics that basically all LLM models exhibit, make the writing
     sound more organic

Then use that as the final output.
