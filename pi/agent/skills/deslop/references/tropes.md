# AI Writing Tropes Catalog

Canonical list of AI writing patterns to flag during deslop scans. Organized by category. Each trope
includes examples of what to catch.

Source: adapted from [tropes.fyi](https://tropes.fyi) / deslopify.

---


## Word Choice
### Magic Adverbs

Adverbs used to inject false significance: "quietly", "deeply", "fundamentally", "remarkably",
"arguably".

- "quietly orchestrating workflows"
- "a deeply flawed approach"
- "fundamentally reshaping the industry"

### "Delve" and Friends

Uncommon words that became AI tells through overuse: "delve", "utilize", "leverage" (as verb),
"robust", "streamline", "harness", "foster", "bolster", "spearhead", "underpin", "pivotal",
"multifaceted".

- "Let's delve into the details"
- "We need to leverage these robust frameworks"

### Ornate Nouns

Grandiose nouns where simpler words work: "tapestry", "landscape", "paradigm", "synergy",
"ecosystem", "framework", "cornerstone", "bedrock".

- "The rich tapestry of human experience"
- "Navigating the complex landscape of modern AI"

### "Serves As" Dodge

Pompous copula replacements: "serves as", "stands as", "marks", "represents" where "is" works fine.

- "The building serves as a reminder"
- "The station marks a pivotal moment"

---


## Sentence Structure
### Negative Parallelism

"It's not X — it's Y" pattern. The single most common AI writing tell. One per piece is borderline
acceptable; more than one is slop.

- "It's not bold. It's backwards."
- "Half the bugs you chase aren't in your code. They're in your head."

### Dramatic Countdown

"Not X. Not Y. Just Z." — building false tension by negating before revealing.

- "Not a bug. Not a feature. A fundamental design flaw."

### Self-Answered Questions

"The X? A Y." — posing a rhetorical question nobody asked, then immediately answering it.

- "The result? Devastating."
- "The worst part? Nobody saw it coming."

### Anaphora Abuse

Repeating the same sentence opening 3+ times in succession.

- "They could expose... They could offer... They could provide..."

### Tricolon Abuse

Overuse of three-part lists, especially multiple tricolons back-to-back. One is rhetoric; three in a
row is a pattern failure.

- "workflows, decisions, and interactions"

### Filler Transitions

"It's worth noting", "It bears mentioning", "Importantly", "Interestingly", "Notably" — transitions
that connect nothing.

### Superficial -ing Analysis

Tacking "-ing" phrases onto sentences for shallow analysis: "highlighting its importance",
"reflecting broader trends", "underscoring its role".

### False Ranges

"From X to Y" where X and Y aren't on any real scale.

- "From innovation to cultural transformation"

### Gerund Fragment Litany

Streams of verbless gerund fragments after a claim: "Fixing small bugs. Writing straightforward
features. Implementing well-defined tickets."

---


## Paragraph Structure
### Short Punchy Fragments

Excessive use of very short sentences or fragments as standalone paragraphs for manufactured
emphasis. One-word paragraphs. Two-word paragraphs. Like this.

### Listicle in a Trench Coat

Numbered points disguised as prose: "The first wall is... The second wall is... The third wall
is..."

---


## Tone
### False Suspense

"Here's the kicker", "Here's the thing", "Here's where it gets interesting", "Here's what most
people miss" — promising a revelation before delivering an unremarkable point.

### Patronizing Analogy

"Think of it as...", "It's like a..." — defaulting to teacher mode. Often produces analogies less
clear than the original concept.

### "Imagine a World Where..."

Futurist invitations to sell a premise: "Imagine a world where every tool you use..."

### False Vulnerability

Performative self-awareness: "And yes, I'm openly..." — polished, risk-free "honesty".

### "The Truth Is Simple"

Asserting clarity instead of demonstrating it: "The reality is simpler", "History is unambiguous on
this point."

### Stakes Inflation

Everything becomes world-historically significant: "will fundamentally reshape how we think about
everything", "will define the next era of computing."

### Pedagogical Voice

"Let's break this down", "Let's unpack this", "Let's explore" — hand-holding an expert audience.

### Vague Attributions

"Experts argue", "Industry reports suggest", "Observers have cited" — unnamed authorities instead of
specific sources.

### Invented Concept Labels

Compound labels that sound analytical without being established: "the supervision paradox", "the
acceleration trap", "workload creep."

---


## Formatting
### Em-Dash Addiction

20+ em dashes in a piece where a human would use 2–3. Watch for em dashes used for dramatic pauses,
parenthetical asides, and pivot points all in the same text.

### Bold-First Bullets

Every bullet point starts with a bolded keyword. Almost nobody formats lists this way by hand.

- "**Security**: Environment-based configuration with..."
- "**Performance**: Lazy loading of expensive resources..."

### Unicode Decoration

Unicode arrows (→), smart quotes, and special characters that can't be easily typed. Real writers
produce straight quotes and `->` or `=>`.

---


## Composition
### Fractal Summaries

"What I'm going to tell you; what I'm telling you; what I just told you" — at every level. Intro
summarizes, section summarizes, conclusion re-summarizes.

### Dead Metaphor Beating

Latching onto one metaphor and repeating it 5–10 times across the piece. Humans use a metaphor and
move on.

### Historical Analogy Stacking

Rapid-fire historical company references: "Apple didn't build Uber. Facebook didn't build Spotify.
Stripe didn't build Shopify."

### One-Point Dilution

A single argument restated 10 different ways across thousands of words. An 800-word point padded to
4000 words of circular repetition.

### Signposted Conclusion

"In conclusion", "To sum up", "In summary" — announcing the structural move instead of just making
it.

### "Despite Its Challenges..."

The rigid formula: acknowledge problems, immediately dismiss them. "Despite these challenges, the
initiative continues to thrive."

---


## Quick-Reference: Word Swaps

| AI Default      | Human Alternative  |
| --------------- | ------------------ |
| utilize         | use                |
| leverage (verb) | use, apply         |
| facilitate      | help, enable       |
| implement       | build, do, set up  |
| demonstrate     | show               |
| enhance         | improve            |
| robust          | strong, solid      |
| streamline      | simplify           |
| foster          | encourage, support |
| bolster         | strengthen         |
| spearhead       | lead               |
| multifaceted    | complex            |
| pivotal         | key, important     |
| underpin        | support            |
| ecosystem       | system, community  |
| paradigm        | model, approach    |

---

_Any pattern used once might be fine, the problem is density. This can happen both for multiple tropes together, or one trope repeated. When writing, the goal is to sound like a specific person, not a language model._
