# Claude API Web Fetch Tool: Full Content Retrieval for Web Pages and PDFs

> **Source**: Anthropic Platform Documentation
> **Status**: Beta (requires `web-fetch-2025-09-10` header)
> **Pricing**: No additional cost (only standard token costs)
> **Core Value**: Retrieve full web page/PDF content for deep analysis

---

## The Essence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     WEB FETCH = FULL DOCUMENT ACCESS                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐         ┌─────────────┐         ┌─────────────────────┐   │
│   │ Web Search  │         │  Web Fetch  │         │    Combined         │   │
│   │ (Snippets)  │    +    │  (Full Doc) │    =    │    Power Workflow   │   │
│   └─────────────┘         └─────────────┘         └─────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   CORE CONCEPTS:                                                            │
│                                                                             │
│   1. FULL CONTENT     Web Fetch retrieves entire documents (HTML/PDF)       │
│      ─────────────    while Web Search only returns excerpts                │
│                                                                             │
│   2. SECURITY MODEL   URLs must exist in conversation context               │
│      ─────────────    Claude cannot construct/generate URLs                 │
│                                                                             │
│   3. COST CONTROL     Use max_content_tokens to limit large docs            │
│      ─────────────    Average page ≈ 2,500 tokens; PDF ≈ 125,000           │
│                                                                             │
│   4. DOMAIN RULES     allowed_domains OR blocked_domains (not both)         │
│      ─────────────    Subdomains auto-included; beware Unicode attacks      │
│                                                                             │
│   5. CITATIONS        Enable with citations.enabled: true                   │
│      ─────────────    Links responses to specific source passages           │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   QUICK START:                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │  tools=[{"type": "web_fetch_20250910", "name": "web_fetch"}]        │   │
│   │  extra_headers={"anthropic-beta": "web-fetch-2025-09-10"}           │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Why This Matters

The Web Fetch tool fills a critical gap: **Web Search gives you snippets, Web Fetch gives you the full document**. This enables Claude to analyze complete articles, research papers, and documentation rather than working from summaries.

> Unlike web search where you get excerpts, web fetch retrieves the entire content for comprehensive analysis with optional citations.

**Key Insight**: Combine Web Search (find relevant sources) + Web Fetch (get full content) for the most powerful research workflow.

---

## How Web Fetch Works

```
┌─────────────────────────────────────────────────────────────────┐
│                    WEB FETCH WORKFLOW                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   User Message (contains URL)                                   │
│        │                                                        │
│        ▼                                                        │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   1. Claude decides to fetch based on prompt            │   │
│   └─────────────────────────────────────────────────────────┘   │
│        │                                                        │
│        ▼                                                        │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   2. API retrieves full text from URL                   │   │
│   │      • HTML → converted to text                         │   │
│   │      • PDF → automatic text extraction                  │   │
│   └─────────────────────────────────────────────────────────┘   │
│        │                                                        │
│        ▼                                                        │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   3. Claude analyzes content                            │   │
│   │      • Full document in context                         │   │
│   │      • Optional citations to specific passages          │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│   ⚠️ Limitation: Does NOT support JavaScript-rendered sites     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Supported Models

| Model | Model ID |
|-------|----------|
| Claude Opus 4.5 | `claude-opus-4-5-20251101` |
| Claude Opus 4.1 | `claude-opus-4-1-20250805` |
| Claude Opus 4 | `claude-opus-4-20250514` |
| Claude Sonnet 4.5 | `claude-sonnet-4-5-20250929` |
| Claude Sonnet 4 | `claude-sonnet-4-20250514` |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` |
| Claude Haiku 3.5 | `claude-3-5-haiku-latest` |

---

## Basic Usage

### Minimal Example (Python)

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": "Please analyze the content at https://example.com/article"
        }
    ],
    tools=[{
        "type": "web_fetch_20250910",
        "name": "web_fetch",
        "max_uses": 5
    }],
    extra_headers={
        "anthropic-beta": "web-fetch-2025-09-10"
    }
)
```

### Shell/cURL Example

```bash
curl https://api.anthropic.com/v1/messages \
    --header "x-api-key: $ANTHROPIC_API_KEY" \
    --header "anthropic-version: 2023-06-01" \
    --header "anthropic-beta: web-fetch-2025-09-10" \
    --header "content-type: application/json" \
    --data '{
        "model": "claude-sonnet-4-5",
        "max_tokens": 1024,
        "messages": [
            {
                "role": "user",
                "content": "Please analyze the content at https://example.com/article"
            }
        ],
        "tools": [{
            "type": "web_fetch_20250910",
            "name": "web_fetch",
            "max_uses": 5
        }]
    }'
```

---

## Tool Configuration Options

### Full Configuration Schema

```json
{
  "type": "web_fetch_20250910",
  "name": "web_fetch",

  "max_uses": 10,                    // Limit fetches per request

  "allowed_domains": ["example.com"], // Whitelist (OR blocked_domains)
  "blocked_domains": ["private.com"], // Blacklist (OR allowed_domains)

  "citations": {
    "enabled": true                   // Enable passage citations
  },

  "max_content_tokens": 100000        // Limit content size
}
```

### Configuration Options Explained

| Parameter | Purpose | Default | Notes |
|-----------|---------|---------|-------|
| `max_uses` | Limit fetch count | No limit | Prevents runaway fetching |
| `allowed_domains` | Whitelist domains | None | Cannot use with `blocked_domains` |
| `blocked_domains` | Blacklist domains | None | Cannot use with `allowed_domains` |
| `citations.enabled` | Enable citations | false | Unlike web search (always on) |
| `max_content_tokens` | Limit content size | None | Approximate limit |

### Domain Filtering Rules

```
✅ Correct domain format:
   • example.com (NOT https://example.com)
   • docs.example.com
   • example.com/blog (subpaths supported)

✅ Subdomains auto-included:
   • example.com covers docs.example.com

❌ Cannot combine:
   • allowed_domains AND blocked_domains in same request
```

---

## Token Usage Estimates

| Content Type | Size | Approximate Tokens |
|--------------|------|-------------------|
| Average web page | 10KB | ~2,500 tokens |
| Large documentation | 100KB | ~25,000 tokens |
| Research paper PDF | 500KB | ~125,000 tokens |

**Cost Control**: Use `max_content_tokens` to prevent large documents from consuming excessive tokens.

---

## The Power Combo: Search + Fetch

### Combined Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                 SEARCH + FETCH WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Step 1: Web Search                                            │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   "Find articles about quantum computing"               │   │
│   │   → Returns list of URLs with snippets                  │   │
│   └─────────────────────────────────────────────────────────┘   │
│        │                                                        │
│        ▼                                                        │
│   Step 2: Claude Selects Best Results                           │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   Evaluates relevance, recency, source quality          │   │
│   └─────────────────────────────────────────────────────────┘   │
│        │                                                        │
│        ▼                                                        │
│   Step 3: Web Fetch                                             │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   Retrieves full content from selected URLs             │   │
│   └─────────────────────────────────────────────────────────┘   │
│        │                                                        │
│        ▼                                                        │
│   Step 4: Deep Analysis with Citations                          │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   Comprehensive response citing specific passages       │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Python Implementation

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=4096,
    messages=[
        {
            "role": "user",
            "content": "Find recent articles about quantum computing and analyze the most relevant one in detail"
        }
    ],
    tools=[
        {
            "type": "web_search_20250305",
            "name": "web_search",
            "max_uses": 3
        },
        {
            "type": "web_fetch_20250910",
            "name": "web_fetch",
            "max_uses": 5,
            "citations": {"enabled": True}
        }
    ],
    extra_headers={
        "anthropic-beta": "web-fetch-2025-09-10"
    }
)
```

---

## Security Considerations

### URL Validation Rule

> **Critical**: Claude can ONLY fetch URLs that appear in conversation context.

```
✅ URLs Claude CAN fetch:
   • URLs in user messages
   • URLs in tool results
   • URLs from previous web search/fetch results

❌ URLs Claude CANNOT fetch:
   • Dynamically constructed URLs
   • URLs Claude "generates"
   • URLs from code execution tools
```

### Data Exfiltration Risk

**Warning**: If Claude processes untrusted input alongside sensitive data, there's risk of data exfiltration.

**Mitigation Strategies**:

| Risk Level | Mitigation |
|------------|------------|
| High security | Disable web fetch entirely |
| Medium security | Use `allowed_domains` whitelist |
| Standard | Use `max_uses` to limit requests |

### Unicode Homograph Attack Warning

```
⚠️ Beware of lookalike domains:
   • аmazon.com (Cyrillic 'а') ≠ amazon.com (Latin 'a')
   • These bypass domain filters!

Recommendation:
   • Use ASCII-only domain names
   • Test filters with Unicode variations
   • Audit domain configurations regularly
```

---

## Response Structure

### Successful Fetch Response

```json
{
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "I'll fetch the content from the article to analyze it."
    },
    {
      "type": "server_tool_use",
      "id": "srvtoolu_01234567890abcdef",
      "name": "web_fetch",
      "input": {
        "url": "https://example.com/article"
      }
    },
    {
      "type": "web_fetch_tool_result",
      "tool_use_id": "srvtoolu_01234567890abcdef",
      "content": {
        "type": "web_fetch_result",
        "url": "https://example.com/article",
        "content": {
          "type": "document",
          "source": {
            "type": "text",
            "media_type": "text/plain",
            "data": "Full text content of the article..."
          },
          "title": "Article Title",
          "citations": {"enabled": true}
        },
        "retrieved_at": "2025-08-25T10:30:00Z"
      }
    },
    {
      "text": "Based on the article, ",
      "type": "text"
    },
    {
      "text": "the main argument is...",
      "type": "text",
      "citations": [
        {
          "type": "char_location",
          "document_index": 0,
          "document_title": "Article Title",
          "start_char_index": 1234,
          "end_char_index": 1456,
          "cited_text": "Original passage from article..."
        }
      ]
    }
  ],
  "usage": {
    "input_tokens": 25039,
    "output_tokens": 931,
    "server_tool_use": {
      "web_fetch_requests": 1
    }
  }
}
```

### Error Codes

| Error Code | Meaning |
|------------|---------|
| `invalid_input` | Invalid URL format |
| `url_too_long` | URL > 250 characters |
| `url_not_allowed` | Blocked by domain rules |
| `url_not_accessible` | HTTP error fetching |
| `too_many_requests` | Rate limit hit |
| `unsupported_content_type` | Not text or PDF |
| `max_uses_exceeded` | Exceeded `max_uses` limit |
| `unavailable` | Internal error |

---

## Real-World Limitations (Not in Official Docs)

### The 50%+ Failure Rate Problem

**Reality Check**: Many major websites block automated fetching requests. In practice, expect **40-60% of fetch attempts to fail** on popular sites.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    COMMON FETCH FAILURE SCENARIOS                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   SITE BLOCKS (403 Forbidden):                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   • Google Scholar, Google Docs                                     │   │
│   │   • Medium.com articles                                             │   │
│   │   • LinkedIn pages                                                  │   │
│   │   • Many corporate blogs (Palantir, etc.)                           │   │
│   │   • Paywalled content (WSJ, NYT, etc.)                              │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   JS-RENDERED SITES (Empty/Partial Content):                                │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   • Single Page Applications (React, Vue, Angular)                  │   │
│   │   • Framer-built websites                                           │   │
│   │   • Sites with heavy client-side rendering                          │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   BOT DETECTION:                                                            │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │   • Cloudflare-protected sites                                      │   │
│   │   • Sites with aggressive rate limiting                             │   │
│   │   • CAPTCHA-gated content                                           │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Sites That Typically Work Well

| Category | Examples | Success Rate |
|----------|----------|--------------|
| Official documentation | docs.anthropic.com, docs.python.org | High |
| Open-source repos | github.com (raw files), gitlab.com | High |
| Academic preprints | arxiv.org | Medium-High |
| News sites (some) | techcrunch.com, theverge.com | Medium |
| Personal blogs | Most static sites | High |
| Wikipedia | en.wikipedia.org | High |

### Sites That Commonly Fail

| Category | Examples | Failure Reason |
|----------|----------|----------------|
| Search engines | Google Scholar, Bing | Bot blocking |
| Social platforms | LinkedIn, Twitter/X, Facebook | Auth required |
| Publishing platforms | Medium, Substack (some) | Bot blocking |
| Enterprise sites | Many corporate blogs | Cloudflare/WAF |
| Paywalled content | NYT, WSJ, Bloomberg | Subscription required |
| Modern web apps | Framer, Webflow (some) | JS-rendered |

### Practical Workarounds

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    WORKAROUND STRATEGIES                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   WHEN FETCH FAILS:                                                         │
│                                                                             │
│   1. USE WEB SEARCH FIRST                                                   │
│      ─────────────────────                                                  │
│      WebSearch returns snippets that may contain the info you need          │
│      without requiring full page access                                     │
│                                                                             │
│   2. ASK USER TO PASTE CONTENT                                              │
│      ─────────────────────────                                              │
│      "I couldn't access that URL. Could you paste the relevant content?"    │
│      Works 100% of the time for any site                                    │
│                                                                             │
│   3. TRY ALTERNATIVE SOURCES                                                │
│      ─────────────────────────                                              │
│      • docs.* subdomains (often less protected)                             │
│      • Archive.org cached versions                                          │
│      • GitHub mirrors of documentation                                      │
│                                                                             │
│   4. USE SEARCH TO FIND SIMILAR CONTENT                                     │
│      ─────────────────────────────────                                      │
│      Search for the topic rather than fetching specific blocked URLs        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### What the Documentation Doesn't Tell You

| Gap in Docs | Reality |
|-------------|---------|
| No mention of 403 handling | Common failure mode, no retry logic |
| No list of blocked sites | Many major sites block by default |
| No fallback strategies | Must implement your own workarounds |
| "url_not_accessible" is vague | Covers everything from 403 to timeouts |
| No user-agent info | Can't customize to avoid blocks |
| No robots.txt guidance | Unclear if respected |

---

## Advanced Features

### Prompt Caching

```python
# First request - fetch content
response1 = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Analyze: https://arxiv.org/abs/2024.12345"}
    ],
    tools=[{"type": "web_fetch_20250910", "name": "web_fetch"}],
    extra_headers={"anthropic-beta": "web-fetch-2025-09-10"}
)

# Add to conversation
messages.append({"role": "assistant", "content": response1.content})

# Second request - cache breakpoint
messages.append({
    "role": "user",
    "content": "What methodology does the paper use?",
    "cache_control": {"type": "ephemeral"}  # Enable caching
})

response2 = client.messages.create(...)
# Fetched content is cached, not re-fetched
print(f"Cache read tokens: {response2.usage.get('cache_read_input_tokens', 0)}")
```

### Streaming

Web fetch events stream with a pause during content retrieval:

```
event: server_tool_use (web_fetch starts)
event: input_json_delta (URL streamed)
[PAUSE - fetch executing]
event: web_fetch_tool_result (content streams)
event: text (Claude's analysis)
```

### Batch Processing

Web fetch works with Messages Batches API - same pricing as regular requests.

---

## Key Takeaways

### For API Users
1. **Enable with beta header**: `anthropic-beta: web-fetch-2025-09-10`
2. **Combine with web search** for the most powerful research workflow
3. **Use `max_content_tokens`** to control costs on large documents
4. **Enable citations** for traceable, verifiable responses

### For Security-Conscious Applications
1. **Use `allowed_domains`** to whitelist trusted sources
2. **URLs must exist in context** - Claude can't construct URLs
3. **Watch for Unicode homograph attacks** in domain filters
4. **Consider disabling** if handling sensitive data with untrusted input

### For Cost Optimization
1. **No additional cost** beyond token usage
2. **Average web page ≈ 2,500 tokens**
3. **Research PDF ≈ 125,000 tokens** - use limits!
4. **Prompt caching** avoids re-fetching in multi-turn conversations

---

## Quick Reference

### Minimum Viable Request

```python
tools=[{
    "type": "web_fetch_20250910",
    "name": "web_fetch"
}],
extra_headers={"anthropic-beta": "web-fetch-2025-09-10"}
```

### Production-Ready Request

```python
tools=[{
    "type": "web_fetch_20250910",
    "name": "web_fetch",
    "max_uses": 5,
    "allowed_domains": ["docs.anthropic.com", "arxiv.org"],
    "citations": {"enabled": True},
    "max_content_tokens": 50000
}],
extra_headers={"anthropic-beta": "web-fetch-2025-09-10"}
```

---

## Sources

- [Anthropic Web Fetch Tool Documentation](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-fetch-tool)
