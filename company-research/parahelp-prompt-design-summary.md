# Parahelp: Production Prompt Design for AI Customer Support

> **Source**: Parahelp Blog (Aug 27, 2025)
> **Authors**: Anker Ryhl & Mads Liechti (Co-founders)
> **Clients**: Perplexity, Framer, Replit, ElevenLabs
> **Core Metric**: % of tickets resolved end-to-end

---

## The Essence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│         PRODUCTION PROMPT ENGINEERING = EVALS > PROMPTS                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   TIME ALLOCATION (Counter-Intuitive Truth):                                │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │  Writing Prompts ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 20%    │   │
│   │  Building Evals  ██████████████████████████████████████████ 80%    │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   CORE TECHNIQUES:                                                          │
│                                                                             │
│   1. VARIABLE NAMING     <result> = runtime values (tool outputs)           │
│      ───────────────     {{policy}} = static values (config references)     │
│                          Enables multi-step planning without knowing outputs│
│                                                                             │
│   2. IF-BLOCK (NO ELSE)  Every branch needs explicit condition              │
│      ───────────────     ❌ <if condition="A">...<else>...</else>           │
│                          ✅ <if condition="A">...<if condition="NOT A">...  │
│                          Prevents unclear cases falling into catch-all      │
│                                                                             │
│   3. MANAGER PATTERN     Agent proposes → Manager verifies → Execute/Reject │
│      ───────────────     Catches policy violations before reaching users    │
│                          Enables cheaper agent + smarter manager combo      │
│                                                                             │
│   4. MODEL RAM           # of conditional paths model can reliably track    │
│      ───────────────     Haiku: 3-4 paths | Sonnet: 6-8 | Opus: 10-15+     │
│                          When exceeded: decompose, retrieve, chain          │
│                                                                             │
│   5. SOURCE ATTRIBUTION  "According to <helpcenter_result>..."              │
│      ───────────────     NEVER fabricate info not in sources                │
│                          Structurally prevents hallucination                │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   THE MOAT:  Eval Corpus > Prompts (competitors can copy prompts,           │
│              but not your categorized failures & edge cases)                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## The Uncomfortable Truth About Prompt Engineering

> "Most of the time spent optimizing prompts is actually NOT spent on writing the prompts."

**Time allocation breakdown**:
| Activity | Time % |
|----------|--------|
| Writing prompts | ~20% |
| Building evaluation systems | ~25% |
| Running evaluations | ~20% |
| Finding edge cases | ~15% |
| Real-world testing & iteration | ~20% |

**Key Insight**: If you're spending most of your time writing prompts, you're doing it wrong. The leverage is in evaluation systems.

---

## Real Production Prompts (Annotated)

### Prompt 1: The Planning Prompt

This is approximately 1/4 of Parahelp's actual planning prompt. Study the patterns.

```xml
## Plan elements
- A plan consists of steps.
- You can always include <if_block> tags to include different steps based on a condition.

### How to Plan
- When planning next steps, make sure it's only the goal of next steps,
  not the overall goal of the ticket or user.
- Make sure that the plan always follows the procedures and rules of
  the # Customer service agent Policy doc

### How to create a step
- A step will always include:
  - name of the action (tool call)
  - description of the action
  - arguments needed for the action
  - goal of the specific action

The step should be in the following format:
<step>
  <action_name></action_name>
  <description>{reason for taking the action, description of the action
    to take, which outputs from other tool calls that should be used
    (if relevant)}</description>
</step>

- The action_name should always be the name of a valid tool
- Make sure your description NEVER assumes any information, variables
  or tool call results even if you have a good idea of what the tool
  call returns from the SOP.
- Make sure your plan NEVER includes or guesses on information/instructions/rules
  for step descriptions that are not explicitly stated in the policy doc.
- Make sure you ALWAYS highlight in your description that <helpcenter_result>
  is the source of truth for the information you need.
```

#### What Makes This Prompt Special

**1. Variable Naming Convention**
```
<>  = Tool call results (runtime values)
{{}} = Policy references (static values)

Example in use:
"reply to the user with instructions from <helpcenter_result>"
"ask for {{troubleshooting_info_name_from_policy_2}}"
```

**Why it works**: The model can plan multi-step workflows without knowing actual tool outputs. It treats `<helpcenter_result>` as a variable that will be populated later.

**2. Anti-Hallucination Guardrails**
```
❌ BAD: "Tell the user how to fix the error"
✅ GOOD: "Reply with instructions from <helpcenter_result>"

❌ BAD: "The refund policy says..."
✅ GOOD: "According to {{refund_policy}} in the policy doc..."
```

**Why it works**: Forces the model to cite sources, making hallucinations structurally impossible.

**3. The IF-Block Pattern (No ELSE Allowed)**

```xml
<!-- PARAHELP'S APPROACH: Explicit conditions for every path -->
<if_block condition='<helpcenter_result> found'>
    <step>
        <action_name>reply</action_name>
        <description>Reply with instructions from <helpcenter_result></description>
    </step>
</if_block>
<if_block condition='no <helpcenter_result> found'>
    <step>
        <action_name>search_helpcenter</action_name>
        <description>Search for general troubleshooting</description>
    </step>
    <if_block condition='<helpcenter_result> found'>
        <step>
            <action_name>reply</action_name>
            <description>Reply with general troubleshooting from <helpcenter_result></description>
        </step>
    </if_block>
    <if_block condition='no <helpcenter_result> found'>
        <step>
            <action_name>reply</action_name>
            <description>Ask for {{troubleshooting_info_name_from_policy_2}}
              since we already have {{troubleshooting_info_name_from_policy_1}}</description>
        </step>
    </if_block>
</if_block>
```

**Why no ELSE?**
- Forces explicit condition definition for every branch
- Prevents "catch-all" behavior where unclear cases get dumped
- Makes eval parsing trivial (every path has a named condition)
- Eval showed measurable performance improvement

---

### Prompt 2: The Manager Prompt

This prompt creates a "supervisor" that reviews every tool call before execution.

```markdown
# Your instructions as manager

- You are a manager of a customer service agent.
- You have a very important job: making sure the customer service agent
  working for you does their job REALLY well.

- Your task is to approve or reject a tool call from an agent and
  provide feedback if you reject it.

- You will return either:
  <manager_verify>accept</manager_verify>
  OR
  <manager_verify>reject</manager_verify>
  <feedback_comment>{{ feedback_comment }}</feedback_comment>

## Your Verification Process:
1) Analyze all <context_customer_service_agent> and <latest_internal_messages>
   to understand the ticket context and your own internal thinking/results.

2) Check the tool call against:
   - <customer_service_policy>
   - <checklist_for_tool_call>

3) If passes checklist AND policy → <manager_verify>accept</manager_verify>

4) If fails checklist OR policy → <manager_verify>reject</manager_verify>
   <feedback_comment>{{ feedback_comment }}</feedback_comment>

5) ALWAYS ensure the tool call helps the user AND follows policy.

## How to structure feedback:
- Provide feedback on the specific tool call if wrong
- OR provide feedback if the general process is wrong
  (e.g., "you have not called {{tool_name}} yet to get required information")

<customer_service_policy>
{wiki_system_prompt}
</customer_service_policy>

<context_customer_service_agent>
{agent_system_prompt}
{initial_user_prompt}
</context_customer_service_agent>

<available_tools>
{json.dumps(tools, indent=2)}
</available_tools>

<latest_internal_messages>
{format_messages_with_actions(messages)}
</latest_internal_messages>

<checklist_for_tool_call>
{verify_tool_check_prompt}
</checklist_for_tool_call>
```

#### Architectural Insight: The Manager Pattern

```
┌─────────────────────────────────────────────────────────────────┐
│                    MANAGER PATTERN ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   User Query                                                    │
│       │                                                         │
│       ▼                                                         │
│   ┌───────────────┐                                             │
│   │  Agent        │ ──▶ Proposed Tool Call                      │
│   │  (Worker)     │                                             │
│   └───────────────┘            │                                │
│                                ▼                                │
│                    ┌───────────────────────┐                    │
│                    │      Manager          │                    │
│                    │  (Verifier/Critic)    │                    │
│                    └───────────────────────┘                    │
│                           │         │                           │
│                    ┌──────┘         └──────┐                    │
│                    ▼                       ▼                    │
│              [ACCEPT]                 [REJECT]                  │
│                 │                         │                     │
│                 ▼                         ▼                     │
│           Execute Tool            Return Feedback               │
│                                   to Agent for Retry            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Why This Works**:
1. **Catches policy violations** before they reach users
2. **Provides training signal** - rejected calls with feedback improve the agent
3. **Enables cheaper agent models** - manager can be smarter model checking dumber agent
4. **Audit trail** - every decision has explicit reasoning

---

## The "Model RAM" Concept

### Definition
**Model RAM** = The number of conditional execution paths a model can reliably track and execute correctly.

### Why This Changes Everything

```
Simple Flow (2 paths - Any model handles this):
├── User wants refund
│   ├── Within 30 days → Approve
│   └── After 30 days → Deny

Complex Flow (8+ paths - Exceeds small model RAM):
├── User wants refund
│   ├── Within 30 days
│   │   ├── Full refund requested → Approve
│   │   └── Partial refund requested → Calculate & Approve
│   └── After 30 days
│       ├── Defective product
│       │   ├── EU customer → Full refund (legal requirement)
│       │   └── US customer → Escalate to human
│       ├── Subscription
│       │   ├── Monthly → Pro-rate remaining days
│       │   └── Annual → Check cancellation policy
│       └── Changed mind
│           ├── First-time buyer → Offer store credit
│           └── Repeat buyer → Deny politely
```

### Practical Model RAM Limits (Approximate)

| Model | Reliable Path Count | Use Case |
|-------|---------------------|----------|
| GPT-3.5 / Claude Haiku | 3-4 paths | Simple routing, FAQ |
| GPT-4 / Claude Sonnet | 6-8 paths | Standard support flows |
| o1 / o3 / Claude Opus | 10-15+ paths | Complex policy enforcement |

### Solutions When You Exceed Model RAM

**1. Decompose into Sub-Agents**
```
Main Agent → Classifies intent
    ├── Refund Agent → Handles all refund logic
    ├── Billing Agent → Handles all billing logic
    └── Technical Agent → Handles all tech support
```

**2. Dynamic Rule Retrieval**
```python
# Instead of encoding all rules in prompt:
rules = retrieve_relevant_rules(user_query, top_k=3)
prompt = f"Apply these specific rules: {rules}"
```

**3. Multi-Turn Reasoning**
```xml
<instruction>
Before taking action, explicitly state:
1. What condition applies to this case
2. What rule you're following
3. What action you'll take and why

Then execute.
</instruction>
```

---

## XML: Why It Outperforms Natural Language

### The Hypothesis
XML/structured formats activate code-reasoning pathways from pretraining, not just language pathways.

### Evidence from Parahelp

**Natural Language Version**:
```
When the user asks about a refund, first search the help center.
If you find relevant information, reply with those instructions.
If not, search again with broader terms. If still nothing,
ask the user for more details.
```

**XML Version**:
```xml
<workflow trigger="refund_request">
  <step name="search_specific">
    <action>search_helpcenter</action>
    <query>{{user_issue}}</query>
  </step>
  <branch condition="<search_result> found">
    <action>reply</action>
    <content>Instructions from <search_result></content>
  </branch>
  <branch condition="<search_result> not found">
    <step name="search_general">
      <action>search_helpcenter</action>
      <query>general troubleshooting</query>
    </step>
    <branch condition="<search_result> found">
      <action>reply</action>
      <content>General instructions from <search_result></content>
    </branch>
    <branch condition="<search_result> not found">
      <action>reply</action>
      <content>Request {{additional_info}} from user</content>
    </branch>
  </branch>
</workflow>
```

### Why XML Wins

| Aspect | Natural Language | XML |
|--------|------------------|-----|
| **Parsing** | Ambiguous | Deterministic |
| **Eval automation** | Requires NLU | Simple XPath/regex |
| **Condition coverage** | Easy to miss branches | All branches visible |
| **Model compliance** | Variable | Higher consistency |
| **Token efficiency** | ~30% more verbose | Compact |

---

## Transferable Prompt Design Rules

### Rule 1: Specify Thinking Order
```xml
<instruction>
To handle this request, follow these steps IN ORDER:
1) First, identify the user's primary intent
2) Then, check which policy applies
3) Next, verify you have all required information
4) Finally, take the appropriate action
</instruction>
```

**Why**: Models are autoregressive. Specifying order ensures correct dependency chain.

### Rule 2: Use Emphasis Words Strategically
```
Weak: "Make sure to check the policy"
Strong: "You MUST check the policy before responding"
Strongest: "IMPORTANT: ALWAYS verify against policy. NEVER skip this step."
```

**Emphasis hierarchy**: IMPORTANT > ALWAYS/NEVER > MUST > should > can

### Rule 3: Role Assignment
```
❌ Generic: "You are an AI assistant"
✅ Specific: "You are a manager reviewing your team's work"
✅ Better: "You are a senior support agent with 10 years experience
           who takes pride in accurate, helpful responses"
```

**Why**: Roles activate relevant behavioral patterns from training data.

### Rule 4: Source Attribution Requirements
```xml
<rule name="no_hallucination">
When providing information:
- ALWAYS cite your source: "According to <helpcenter_result>..."
- If source doesn't contain the answer: "I couldn't find specific
  information about this. Let me connect you with a specialist."
- NEVER fabricate information not in your sources
</rule>
```

### Rule 5: Explicit Failure Modes
```xml
<error_handling>
  <case name="search_returns_empty">
    Do NOT make up an answer. Instead, ask user for more context.
  </case>
  <case name="ambiguous_user_intent">
    Do NOT guess. Ask a clarifying question.
  </case>
  <case name="policy_conflict">
    Do NOT decide yourself. Escalate to human with summary.
  </case>
</error_handling>
```

---

## The Model Progression: o1/o3 Unlock

### What Changed with Reasoning Models

Parahelp found that **o1-med** (now using **o3-med**) was the first model to pass their planning prompt evaluations.

**Why o1/o3 succeeded where others failed**:

1. **Extended thinking** allows complex condition tracking
2. **Self-correction** catches logical errors before output
3. **Higher "Model RAM"** handles more conditional paths
4. **Better at "I don't know"** - less confident hallucination

### When to Use Reasoning Models

| Task Type | Standard Model | Reasoning Model |
|-----------|----------------|-----------------|
| Simple classification | ✅ | Overkill |
| FAQ responses | ✅ | Overkill |
| Multi-step planning | ❌ Fails | ✅ Required |
| Complex policy application | ❌ Fails | ✅ Required |
| Edge case handling | ⚠️ Inconsistent | ✅ Reliable |

---

## The Eval Imperative

### What Parahelp Evaluates

```python
eval_dimensions = {
    "policy_compliance": {
        "description": "Does response follow all applicable policies?",
        "weight": 0.30,
        "examples": ["refund_policy", "escalation_rules", "tone_guidelines"]
    },
    "information_accuracy": {
        "description": "Is all provided information factually correct?",
        "weight": 0.25,
        "anti_patterns": ["hallucinated_features", "wrong_prices", "fake_policies"]
    },
    "completeness": {
        "description": "Does response fully address user's question?",
        "weight": 0.20,
        "check": "all_user_questions_answered"
    },
    "appropriate_action": {
        "description": "Did agent take the right action for this case?",
        "weight": 0.15,
        "actions": ["resolved", "escalated", "asked_clarification"]
    },
    "tone_and_empathy": {
        "description": "Is tone appropriate for the situation?",
        "weight": 0.10,
        "contexts": ["frustrated_user", "simple_question", "complex_issue"]
    }
}
```

### Building Your Eval Corpus

**Step 1**: Collect real failures
```python
# Log every case where human had to take over
failure_log = {
    "ticket_id": "12345",
    "user_query": "...",
    "agent_response": "...",
    "failure_reason": "hallucinated_a_feature",
    "correct_response": "...",
}
```

**Step 2**: Categorize by failure type
```
Failure Categories:
├── Hallucinations (35%)
│   ├── Made up product features
│   ├── Incorrect policy quotes
│   └── Fabricated troubleshooting steps
├── Policy Violations (25%)
│   ├── Approved refund outside window
│   ├── Skipped required verification
│   └── Wrong escalation path
├── Incomplete Responses (20%)
│   └── Answered first question, ignored second
└── Tone Issues (20%)
    ├── Too casual for serious issue
    └── Too formal for simple question
```

**Step 3**: Convert to eval cases
```python
eval_case = {
    "id": "hallucination_001",
    "input": failure_log["user_query"],
    "context": failure_log["context"],
    "expected_behavior": "cite_helpcenter_only",
    "anti_pattern": failure_log["agent_response"],
    "correct_pattern": failure_log["correct_response"],
}
```

---

## Topics Parahelp Wants to Share Next

The founders mentioned these topics for future posts:

1. **Token-first vs. Workflow-first Architecture**
   - Token-first: Optimize for minimal tokens per resolution
   - Workflow-first: Optimize for predictable execution paths

2. **Memory Systems for Agents**
   - How to give agents persistent context across tickets
   - When to remember vs. forget

3. **Why Great Retrieval is Underrated**
   - RAG quality determines agent ceiling
   - "Garbage in, garbage out" at scale

---

## Key Takeaways

### For Prompt Engineers
1. **Invest 80% in evals**, 20% in prompt writing
2. **Use XML** for complex conditional logic
3. **Ban ELSE blocks** - force explicit conditions
4. **Variable naming** (`<result>`, `{{policy}}`) enables multi-step planning
5. **Anti-hallucination = source attribution requirements**

### For AI Agent Architects
1. **Manager pattern** catches errors before users see them
2. **Model RAM** is a real constraint - design around it
3. **o1/o3 models** unlock complex planning that wasn't possible before
4. **Decompose** when flows exceed model capacity

### For Technical Leaders
1. **Eval corpus = competitive moat** (prompts can be copied, evals can't)
2. **Time allocation**: Most value is in eval systems, not prompt writing
3. **Reasoning models** are worth the cost for complex policy enforcement

---

## 术语表 (Glossary)

| English | 中文 | Definition |
|---------|------|------------|
| Model RAM | 模型内存 | Number of conditional paths a model can reliably track |
| Planning Prompt | 规划提示词 | Prompt that generates multi-step execution plans |
| Manager Prompt | 管理者提示词 | Prompt that verifies/approves agent actions |
| Variable Chaining | 变量链接 | Using placeholder names for future tool outputs |
| IF-Block (no ELSE) | 无ELSE的IF块 | Explicit condition for every branch, no catch-all |
| Source Attribution | 来源归属 | Requiring citations to prevent hallucination |
| Token-first | Token优先 | Architecture optimizing for minimal token usage |
| Workflow-first | 工作流优先 | Architecture optimizing for predictable paths |
| Eval Corpus | 评估语料库 | Collection of test cases for prompt evaluation |
