---
id: CARD-YYYYMMDD-XXXX
type: debug_playbook
status: draft
created_at: YYYY-MM-DD
last_verified_at: YYYY-MM-DD
confidence: low
scope: "[简述本卡片解决的问题类型]"
tags:
  - debug
  - [技术栈/工具标签]
sensitivity: internal
evidence_refs:
  - EVI-YYYYMMDD-XXXX
sources: []
---

## Claim

[陈述问题的根因和解决方案。格式建议：「当 X 条件下出现 Y 症状时，根因是 Z，解决方法是 W」]

## Evidence

[总结调试过程中的关键发现。引用 evidence_refs 中的 ID（调试笔记），指明关键日志/错误信息位置。]

关键要素：
- 环境信息（OS、工具版本等）
- 复现步骤与预期/实际差异
- 日志/截图等产物定位

## Transferable Rule

[将调试经验泛化为可复用的诊断规则。考虑：]
- 触发条件（何时会遇到这个问题？）
- 诊断步骤（如何快速定位？）
- 预防措施（如何避免再次发生？）
