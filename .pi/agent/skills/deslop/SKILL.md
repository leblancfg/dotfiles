---
name: deslop
description: Rewrite AI-generated text to remove slop -- the telltale patterns and structural tics that make LLM output feel generic. Use when asked to "deslop", "remove AI slop", "make this sound human", "fix AI writing", "deslopify", "clean up AI text", or when reviewing any generated prose for authenticity.
user-invocable: true
argument-hint: "<file path or text>"
context: fork
---

# Deslop: Remove AI Writing Slop

Rewrite AI-generated text to strip the patterns that signal "a machine wrote this."


## Process
### 0. Check if the user needs a checkpoint

If working in a codebase, ask if the user wants to commit their current changes before deslopifying.
This is a destructive process, and it's good practice to have a checkpoint to roll back to if
needed. It's also a good way to visualize the changes performed.

### 1. Load the tropes catalog

Read `references/tropes.md` before every rewrite. This is the canonical list of patterns to flag.

### 2. Flag slop in the input

Walk through the text and flag every match against the tropes catalog. For each match, record:

- Location: line number or quote
- Trope: which pattern from the catalog
- Severity: `hard` (unambiguous AI tell) or `soft` (fine once, sloppy if repeated)
- Fix: a concrete replacement or deletion

#### Severity rules

- A single em dash or one tricolon is `soft`. Three or more in the same piece is `hard`.
- Any pattern from the "Word Choice" category (delve, tapestry, landscape, serves as) is always
  `hard`. These words are never natural at the frequency AI uses them.
- "Formatting" patterns (bold-first bullets, unicode arrows) are always `hard`.
- Everything else: `hard` if it appears 2+ times, `soft` if once.

### 3. Rewrite

Apply all fixes. Follow these constraints:

- Preserve all ideas. Every fact, argument, and point from the source must survive.
- Don't over-correct into blandness. The goal is human-sounding prose. Keep varied sentence lengths
  and let informality in where it fits.
- Don't introduce new slop. After rewriting, re-check the output against the tropes catalog. If new
  patterns crept in, fix them.
- Prefer simple verbs. "Use" over "utilize", "help" over "facilitate", "improve" over "enhance",
  "show" over "demonstrate".
- Vary structure. If three consecutive sentences follow the same syntactic pattern, restructure at
  least one.

#### Example

Before:

> "Here's the thing — the ecosystem doesn't just serve as a framework. It fundamentally reshapes how
> we think about robust, streamlined workflows, decisions, and interactions."

After:

> "The ecosystem changes how we think about workflows, decisions, and interactions."
