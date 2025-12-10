# State-of-the-Art Prompting for AI Agents

> **Source**: Y Combinator Video
> **Featured Company**: ParaHelp (AI Customer Support Startup)
> **Core Metric**: % of tickets resolved end-to-end

---

## The Essence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              AI AGENTS IN 2024 ≈ WEB DEV IN 1995                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   THE CORE INSIGHT:                                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                                                                     │   │
│   │     Evals are YOUR MOAT, not your prompts                           │   │
│   │     (Prompts can be copied, eval corpus cannot)                     │   │
│   │                                                                     │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   FIVE KEY TECHNIQUES:                                                      │
│                                                                             │
│   1. THREE-LAYER ARCH    System Prompt → Developer Prompt → User Prompt     │
│      ───────────────     Separates concerns; enables independent A/B tests  │
│                                                                             │
│   2. PROMPT FOLDING      Natural language → XML/structured format           │
│      ───────────────     89 tokens → 47 tokens; activates code-reasoning    │
│                                                                             │
│   3. META PROMPTING      Expensive model (Opus) refines prompts for         │
│      ───────────────     cheap model (Haiku) in production                  │
│                          $0.50 once vs $0.001 per request                   │
│                                                                             │
│   4. THINKING TRACES     Expose model's reasoning steps for debugging       │
│      ───────────────     Build REPL environment to see trace changes live   │
│                                                                             │
│   5. THE EVAL FLYWHEEL   Failures → Analysis → New Evals → Better Prompts   │
│      ───────────────     Each iteration compounds your competitive moat     │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   FORWARD DEPLOYED MINDSET (from Palantir):                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │  Don't build from tickets. Shadow real support agents.              │   │
│   │  Watch what they look up first, how they phrase difficult cases,    │   │
│   │  when they escalate vs. try harder.                                 │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   PRACTICAL RULE: If you're writing a new prompt per customer,              │
│                   you're doing it wrong. Build the abstraction.             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Executive Summary

This video reveals production-grade prompt engineering techniques from ParaHelp, a startup building AI customer support agents. The key insight: **most time spent on prompts isn't writing them—it's building evaluation systems and iterating on real-world failures.**

---

## 1. The Three-Layer Prompt Architecture

Modern AI agents use a layered prompt structure that separates concerns:

```
┌─────────────────────────────────────────────────────────┐
│  SYSTEM PROMPT (Platform Level)                         │
│  - Role definition                                      │
│  - Core constraints                                     │
│  - Output format specifications                         │
├─────────────────────────────────────────────────────────┤
│  DEVELOPER PROMPT (Application Level)                   │
│  - Task-specific instructions                           │
│  - Tool definitions & usage rules                       │
│  - Worked examples (few-shot learning)                  │
├─────────────────────────────────────────────────────────┤
│  USER PROMPT (Runtime Level)                            │
│  - User query/request                                   │
│  - Dynamic context & preferences                        │
└─────────────────────────────────────────────────────────┘
```

**Why this matters**: This separation allows you to:
- Update system prompts without touching business logic
- A/B test developer prompts independently
- Isolate failures to specific layers during debugging

---

## 2. The Flexibility vs. Standardization Trap

### The Problem
Every customer wants customization. If you say yes to everything, you become a consulting shop with N different prompts for N customers.

### The Solution: Parameterized Prompts

Instead of:
```
# Customer A prompt
"You are a friendly support agent for Customer A..."

# Customer B prompt
"You are a professional support agent for Customer B..."
```

Use:
```
# Single parameterized prompt
"You are a {{tone}} support agent for {{company_name}}.
Follow these policies: {{policy_document}}
Use these escalation rules: {{escalation_rules}}"
```

### Key Insight
> "The goal is automated tools managing optimized worked examples—not humans manually tweaking prompts per customer."

**Practical Rule**: If you're writing a new prompt for a new customer, you're doing it wrong. Build the abstraction instead.

---

## 3. Prompt Folding Technique

### Definition
Compressing verbose natural language instructions into structured, parseable formats that models handle better.

### Before (Verbose - 89 tokens)
```
When a user asks about refunds, you should first check when they made
the purchase. If they purchased within the last 30 days, you can approve
the refund automatically. If it's been more than 30 days, you need to
check if they have a valid reason like a defective product. If the
reason is valid, escalate to a human. Otherwise, deny the refund politely.
```

### After (Folded - 47 tokens)
```xml
<refund_policy>
  <rule condition="purchase_date <= 30_days">AUTO_APPROVE</rule>
  <rule condition="purchase_date > 30_days AND valid_reason">ESCALATE</rule>
  <rule condition="purchase_date > 30_days AND NOT valid_reason">DENY</rule>
</refund_policy>
```

### Why It Works
1. **Fewer tokens** = lower cost, faster inference
2. **Structured format** activates the model's code-reasoning capabilities from pretraining
3. **Parseable output** = easier to build evals and catch errors
4. **Explicit conditions** = fewer edge case failures

---

## 4. Meta Prompting: The Model Cascade

### The Core Idea
Use expensive, slow models to improve prompts for cheap, fast models.

```
┌──────────────────────────────────────────────────────────────────┐
│                    META PROMPTING WORKFLOW                       │
│                                                                  │
│   [Draft Prompt] ──▶ [GPT-4/Claude Opus] ──▶ [Refined Prompt]   │
│                            │                        │            │
│                     Analyzes for:              Used by:          │
│                     • Ambiguities              • GPT-3.5         │
│                     • Edge cases               • Claude Haiku    │
│                     • Missing rules            • Gemini Flash    │
│                                                                  │
│   Cost: $0.50 once          │           Cost: $0.001 per request │
│                             ▼                                    │
│                    [Production Traffic]                          │
└──────────────────────────────────────────────────────────────────┘
```

### Practical Implementation

**Step 1**: Write your initial prompt
**Step 2**: Send to a large model with this meta-prompt:

```
Analyze this prompt for an AI customer support agent. Identify:
1. Ambiguous instructions that could be interpreted multiple ways
2. Missing edge cases (what happens if X?)
3. Conflicting rules
4. Instructions that could be made more precise

Then rewrite the prompt to fix these issues.

PROMPT TO ANALYZE:
{{your_prompt}}
```

**Step 3**: Test refined prompt with smaller model
**Step 4**: Iterate based on eval results

---

## 5. Thinking Traces for Debugging

### What Are Thinking Traces?
Some models (Gemini Pro, Claude with extended thinking, o1) expose their intermediate reasoning steps. This is gold for prompt debugging.

### Debugging Workflow

```
INPUT: "I want a refund for my purchase from 45 days ago. The product was defective."

THINKING TRACE:
├── Step 1: Identified intent = refund_request
├── Step 2: Extracted purchase_date = 45 days ago (> 30 days)
├── Step 3: Extracted reason = "defective product"
├── Step 4: Checking policy... defective = valid_reason ✓
├── Step 5: Condition matched: "purchase_date > 30_days AND valid_reason"
└── Step 6: Action = ESCALATE

OUTPUT: "I understand your frustration. Let me connect you with a specialist..."
```

### What to Look For
| Trace Pattern | Problem | Fix |
|---------------|---------|-----|
| Wrong intent classification | Ambiguous intent keywords | Add explicit intent examples |
| Skipped condition check | Missing rule in policy | Add the missing rule |
| Wrong variable extraction | Unclear extraction format | Add extraction examples |
| Chose wrong action | Conflicting rules | Add rule priority ordering |

### Pro Tip
> Build a REPL-like environment where you can modify prompts and immediately see how thinking traces change. This is 10x faster than running full evals.

---

## 6. Evals: The Competitive Moat

### Why Evals Are "The Crown Jewel"

```
┌─────────────────────────────────────────────────────────────────┐
│                    THE EVAL FLYWHEEL                            │
│                                                                 │
│     Real User         Production        Failure                 │
│     Interactions  ──▶  Failures    ──▶  Analysis                │
│          ▲                                  │                   │
│          │                                  ▼                   │
│     Improved         Prompt              New Eval               │
│     Agent       ◀──  Refinement    ◀──   Cases                  │
│                                                                 │
│  Each iteration makes your eval suite MORE VALUABLE             │
│  Competitors can copy prompts, but not your eval corpus         │
└─────────────────────────────────────────────────────────────────┘
```

### Eval Structure

```python
# Example eval case structure
eval_case = {
    "id": "refund_045",
    "input": {
        "user_message": "I want my money back. Bought this 2 months ago and it never worked.",
        "context": {
            "purchase_date": "2024-01-15",
            "product": "Widget Pro",
            "previous_refunds": 0
        }
    },
    "expected": {
        "intent": "refund_request",
        "action": "escalate_to_human",
        "reason": "valid_reason_outside_window",
        "response_must_contain": ["understand", "specialist", "help"],
        "response_must_not_contain": ["sorry we can't", "policy doesn't allow"]
    },
    "tags": ["refund", "edge_case", "defective_product"]
}
```

### Eval Metrics That Matter

| Metric | Description | Target |
|--------|-------------|--------|
| **Resolution Rate** | % tickets fully resolved without human | 70-85% |
| **Escalation Accuracy** | % of escalations that were necessary | >90% |
| **Policy Compliance** | % responses following business rules | >99% |
| **Hallucination Rate** | % responses with fabricated info | <1% |
| **CSAT Impact** | Customer satisfaction delta vs human | ±5% |

---

## 7. The "Model RAM" Concept

### Definition
**Model RAM** = The number of conditional paths a model can reliably track in a single prompt.

### Why This Matters
Complex business logic has many branches:

```
Refund Request Flow:
├── Is purchase < 30 days?
│   ├── Yes → Auto approve
│   └── No → Check reason
│       ├── Defective? → Escalate
│       ├── Changed mind? → Deny
│       └── Subscription?
│           ├── Monthly? → Pro-rate
│           └── Annual? → Check country
│               ├── EU? → Full refund (law)
│               └── US? → Partial refund
```

**Smaller models** might handle 3-4 branches reliably.
**Larger models** (o1, o3) can handle 8-10+ branches.

### Practical Solutions When You Exceed Model RAM

1. **Decompose into sub-agents**: Split complex flows into specialized agents
2. **Use retrieval**: Instead of encoding all rules in prompt, retrieve relevant rules dynamically
3. **Multi-turn reasoning**: Force explicit reasoning steps before final action
4. **Prompt chaining**: First classify, then route to specialized prompt

---

## 8. The Forward Deployed Engineer Mindset

### Origin: Palantir's Secret Weapon

Palantir built a $50B+ company partly by embedding engineers directly with FBI agents, military analysts, and Fortune 500 executives.

### Traditional Sales vs. Forward Deployed

```
TRADITIONAL:
Sales Rep ──▶ Requirements Doc ──▶ Product Team ──▶ Engineering
    │              │                    │              │
    └──────────────┴────────────────────┴──────────────┘
                    Information Loss at Every Step

FORWARD DEPLOYED:
┌─────────────────────────────────────────────────────────┐
│   Engineer sits WITH user, observes workflow,           │
│   builds solution in real-time, iterates instantly      │
└─────────────────────────────────────────────────────────┘
         │
         ▼
    • Deep domain knowledge (not superficial requirements)
    • Immediate feedback loops
    • Solutions that actually fit the workflow
    • Trust that leads to enterprise deals
```

### Application to AI Agents

**Don't just build from support tickets. Shadow support agents.**

What you learn by sitting with support agents:
- Which tickets they dread (complexity indicators)
- What info they always look up first (retrieval priorities)
- How they phrase difficult responses (tone patterns)
- When they escalate vs. try harder (escalation thresholds)

> "The unique insights founders gain through this hands-on approach can form a sustainable competitive advantage."

---

## 9. AI Model Personalities: Rigidity vs. Flexibility

### The Discovery
Different models interpret the same rubric differently—like employees with different personalities.

### Example: Scoring a Startup

**Rubric**: "Score team quality 1-10. Consider: relevant experience, technical depth, previous exits."

**Rigid Model Response**:
```
Team Quality: 6/10
- Relevant experience: 2 years (below 5 year threshold) = 5 points
- Technical depth: PhD in ML = 8 points
- Previous exits: None = 4 points
Average: 5.7, rounded to 6
```

**Flexible Model Response**:
```
Team Quality: 8/10
While the team has only 2 years of direct experience, their PhD research
is directly applicable to this problem space. The lack of previous exits
is offset by their advisor's track record and the technical moat their
research provides. In this specific domain, academic credentials may be
more predictive than startup experience.
```

### When to Use Each

| Model Type | Best For | Avoid For |
|------------|----------|-----------|
| **Rigid** | Compliance checks, policy enforcement, consistent scoring | Creative tasks, nuanced judgment |
| **Flexible** | Complex evaluation, edge cases, situations requiring reasoning | Tasks requiring exact reproducibility |

### Key Insight
> "Managing AI is like managing people. You need to understand individual strengths, communicate clearly, and continuously improve."

---

## 10. Concrete Prompt Patterns

### Pattern 1: Explicit Non-Assumption

```xml
<instruction>
NEVER assume information not explicitly provided. If you need:
- Purchase date: ASK the user
- Product details: SEARCH the database
- Policy exceptions: ESCALATE to human

Even if you're 90% confident, verify before acting.
</instruction>
```

### Pattern 2: Variable Chaining

```xml
<plan>
  <step>Search helpcenter for {{user_issue}}</step>
  <step>
    IF <helpcenter_result> found:
      Reply using <helpcenter_result>
    ELSE:
      Search for general troubleshooting
  </step>
</plan>
```

The `<helpcenter_result>` acts as a variable name, allowing the model to plan across multiple tool calls without knowing actual outputs.

### Pattern 3: Explicit IF Without ELSE

```xml
<!-- DON'T DO THIS -->
<if condition="purchase < 30 days">APPROVE</if>
<else>DENY</else>

<!-- DO THIS INSTEAD -->
<if condition="purchase < 30 days">APPROVE</if>
<if condition="purchase >= 30 days AND valid_reason">ESCALATE</if>
<if condition="purchase >= 30 days AND NOT valid_reason">DENY</if>
```

**Why**: Forcing explicit conditions for every path prevents the model from dumping unclear cases into a catch-all "else".

### Pattern 4: Source Attribution

```xml
<instruction>
When providing troubleshooting steps:
1. ALWAYS cite the source: "According to <helpcenter_result>..."
2. NEVER make up steps not in the source
3. If source is insufficient, say "I couldn't find specific steps for this. Let me connect you with a specialist."
</instruction>
```

---

## 11. The 1995 Analogy

### Historical Parallel

| 1995 (Early Web) | 2024 (Early AI Agents) |
|------------------|------------------------|
| HTML was new, best practices unknown | Prompt engineering is new, best practices emerging |
| Every website was hand-coded | Every AI agent is hand-prompted |
| Frameworks didn't exist yet | Agent frameworks are primitive |
| Huge opportunity for those who learned early | Huge opportunity for those learning now |

### Implication
The people who deeply understand prompt engineering today will be the "senior engineers" of the AI agent era. This knowledge compounds.

---

## Key Takeaways

### For Individual Engineers
1. **Build evals first**, prompts second
2. **Use structured formats** (XML/JSON) to activate code-reasoning
3. **Shadow real users** before writing prompts
4. **Track "Model RAM"** when designing complex flows

### For Teams
1. **Parameterize prompts** to avoid consulting-model trap
2. **Build meta-prompting pipelines** for continuous improvement
3. **Invest in thinking trace debugging** infrastructure
4. **Treat eval corpus as core IP**

### For Founders
1. **Forward deployed mindset** creates defensible insights
2. **Evals are your moat**, not your prompts
3. **Current AI ≈ 1995 coding**—massive opportunity for those who go deep

---

## Quick Reference: Timestamps

| Time | Topic |
|------|-------|
| 00:00 | AI Prompt Engineering: Secrets of Top Startups |
| 01:41 | Crafting Detailed Prompts for AI Agent Coordination |
| 04:13 | Flexibility vs. Standardization in AI Agents |
| 06:58 | Advanced Prompt Engineering Techniques |
| 09:54 | Meta Prompting: Big Models Improving Small Models |
| 12:43 | Thinking Traces for Prompt Debugging |
| 14:18 | Evals as the Crown Jewel |
| 17:41 | Palantir's Forward Deployed Engineer Model |
| 19:30 | Bridging Tech and Domain Expertise |
| 22:56 | AI in Enterprise Sales |
| 26:27 | LLMs for Investment Scoring |
| 27:51 | AI Model Personalities |
