---
name: kagi-search
description: Use Kagi Search API to find information on the web.
---

# Kagi Search

Use when the user asks you to research something, look something up, or search the web.
Triggers on: search, research, look up, find out, what is, how to.

## Prerequisites

The `KAGI_API_KEY` environment variable must be set. The user has this configured
in their shell environment.

## Usage

Kagi exposes two useful API endpoints:

### 1. FastGPT (quick answers)

Best for direct questions where you want a synthesized answer with references.

```bash
curl -s "https://kagi.com/api/v0/fastgpt" \
  -H "Authorization: Bot $KAGI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "<your question here>"}' | python3 -m json.tool
```

Response shape: `{ data: { output: string, references: [...] } }`

### 2. Web Search (full results)

Best for broader research where you want to browse multiple results.

```bash
curl -s "https://kagi.com/api/v0/search?q=<url-encoded-query>" \
  -H "Authorization: Bot $KAGI_API_KEY" | python3 -m json.tool
```

Response shape: `{ data: [ { t: "title", url: "...", snippet: "..." }, ... ] }`

## Notes

- Always URL-encode query parameters for the search endpoint.
- The FastGPT endpoint is preferred for factual questions; web search is better
  for exploring a topic or finding specific documentation pages.
- If you get `Unauthorized` errors, the API key may have expired. Fall back to
  fetching documentation directly from known sources (e.g., GitHub raw URLs).
