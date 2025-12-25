# Playbook: Deep Report 工作流

> 从 Evidence 直接产出深度分析报告，后续可提取为原子 CARD。

## 适用场景

```
┌─────────────────────────────────────────────────────────────┐
│  深度报告 (kind: deep) 适用于：                               │
│  - 技术深度分析需要完整叙事结构                                │
│  - 访谈需要保留上下文和信号分析                                │
│  - 公司研究需要多维度综合评估                                  │
│  - 故障复盘需要完整时间线和根因分析                            │
│                                                             │
│  已验证主张组合 (kind: assembled) 适用于：                    │
│  - 从多张 CARD 提炼综合洞见                                   │
│  - 不引入新主张，仅组合已验证内容                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 工作流对比

### 标准流程 (assembled)

```
Evidence → CARD → CARD → CARD → Know (assembled)
   ↓         ↓       ↓       ↓        ↓
 采集      原子    原子    原子    综合组装
          主张    主张    主张    (只引用)
```

### 报告流程 (deep)

```
Evidence → Know (deep) → [可选] CARD 提取
   ↓           ↓              ↓
 采集      深度分析       后续提取
          完整报告       原子主张
```

---

## 选择指南

| 场景 | 推荐 kind | 说明 |
|------|-----------|------|
| 阅读技术博客后快速记录 1-2 个点 | assembled | 先写 CARD，必要时汇总 |
| 技术博客深度分析+对比+决策框架 | **deep** | 直接写 Know，后续提取 CARD |
| 面试一个候选人后的结构化评估 | assembled | 评估点可原子化为 CARD |
| 与专家深度访谈 2 小时的洞见提炼 | **deep** | 需要完整上下文和信号分析 |
| 公司简单调研（基础信息收集） | assembled | 事实点可原子化 |
| 公司深度研究（战略评估+启示） | **deep** | 需要多维度综合分析 |
| 线上小问题快速修复 | assembled | 1 个 fix CARD 即可 |
| 重大故障复盘（P0/P1） | **deep** | 需要完整时间线和根因分析 |

---

## Deep Report 流程详解

### Step 1: 选择模板

根据 type 选择对应的 deep 模板：

| type | 模板文件 |
|------|---------|
| tech_blog | `templates/know.tech_blog.deep.template.md` |
| interview | `templates/know.interview.deep.template.md` |
| company_research | `templates/know.company_research.deep.template.md` |
| debug_playbook | `templates/know.debug_playbook.deep.template.md` |

### Step 2: 填写 front matter

```yaml
---
id: KNOW-YYYYMMDD-descriptor
kind: deep                    # 必须标记为 deep
type: tech_blog               # 选择对应类型
title: "标题"
created_at: YYYY-MM-DD
last_updated_at: YYYY-MM-DD
sensitivity: public           # 或 internal/private
source_refs:                  # 引用 Evidence（非 CARD）
  - EVI-YYYYMMDD-XXXX
tags:
  - tag1
---
```

### Step 3: 完成核心章节

每种 type 有特定的核心章节：

**tech_blog:**
- 技术深度分析
- 对比评估
- 决策框架

**interview:**
- 核心主题分析（带原始引用）
- 信号与噪音分离
- 交叉验证

**company_research:**
- 产品与技术分析
- 市场与竞争分析
- 战略洞察

**debug_playbook:**
- Incident Narrative（事件叙事）
- A/B Isolation（隔离定位）
- Root Cause Analysis（根因分析）
- Postmortem（事后复盘）

### Step 4: 填写 Transferable Rules

从分析中提炼可迁移规则：

```markdown
## Transferable Rules

1. **[规则名称]**: [可迁移的通用原则]
2. **[规则名称]**: [可迁移的通用原则]
```

### Step 5: [可选] 提取 CARD

如果报告中有值得单独追踪的原子主张，后续可提取为 CARD：

```
Know (deep)
    │
    ├── 洞见 A → CARD-YYYYMMDD-XXXX
    ├── 洞见 B → CARD-YYYYMMDD-YYYY
    └── 洞见 C (保留在 Know 中，暂不提取)
```

---

## 验证规则

| 检查项 | kind: deep | kind: assembled |
|--------|------------|-----------------|
| 必须引用 CARD | ❌ 不要求 | ✓ 要求 |
| 可引用 Evidence | ✓ 通过 source_refs | ❌ 不推荐 |
| 可引入新主张 | ✓ 可以 | ❌ 禁止 |

---

## 命名规范

```
KNOW-YYYYMMDD-descriptor.md

示例:
- KNOW-20251222-redis-vs-memcached-deep-dive.md  (tech_blog, deep)
- KNOW-20251222-cto-interview-insights.md         (interview, deep)
- KNOW-20251222-competitor-x-analysis.md          (company_research, deep)
- KNOW-20251222-api-outage-postmortem.md          (debug_playbook, deep)
```

---

## Background 自动加载

Deep report 生成时应自动读取 `vault/CONFIG.yml` 中的 `background_file` 配置。

```yaml
# vault/CONFIG.yml
background_file: "vault/context/BACKGROUND.md"
background_mode: "always"
```

**加载规则:**
- `always`: 每次生成 deep report 都加载
- `on_request`: 仅在用户明确要求时加载
- `never`: 不自动加载

---

## 解释标准: 双车道模式 (Hard Requirement)

所有 deep report 必须遵循「双车道解释模式」:

```
┌─────────────────────────────────────────────────────────────────┐
│  Lane 1: 机理优先 (Mechanism-first)                             │
│  ─────────────────────────────────────────                      │
│  先讲底层原理、数学模型、因果链条                                  │
│                                                                 │
│  Lane 2: 类比其次 (Analogy-second)                              │
│  ─────────────────────────────────────────                      │
│  用类比帮助理解，但必须标注类比失效条件                            │
│                                                                 │
│  ⚠️ 类比使用规范:                                               │
│  • 类比后必须说明「类比失效边界」                                  │
│  • 不能用类比替代机理解释                                         │
│  • 先机理，后类比（不可反过来）                                    │
└─────────────────────────────────────────────────────────────────┘
```

**示例:**

❌ 错误: "Redis 就像一个超快的便利店..."（只有类比，无机理）

✅ 正确: "Redis 使用单线程事件循环 + 内存数据结构实现 O(1) 读写。类比：像便利店收银台（单队列单服务员），但失效边界：Redis 用 I/O 多路复用并发处理网络请求，而非真的只服务一个客户。"

---

## 安全警告

```
⚠️  WARNING: 敏感信息保护
─────────────────────────────────────────────────────────────────
生成 deep report 时，禁止从任何来源背景文件复制以下内容到 vault 输出:

• 姓名、电话、邮箱、地址
• 推荐人/证书/身份证号
• 学历/工作经历的可识别细节
• 任何 PII (Personally Identifiable Information)

Background 文件应仅包含技术基线、协作规范、工具链偏好。
如发现 vault 输出包含 PII，应立即删除并重新生成。
─────────────────────────────────────────────────────────────────
```

---

## FAQ

### Q: Deep 报告完成后必须提取 CARD 吗？

A: 不必须。Deep 报告是完整的知识资产，可以独立存在。只有当某个洞见需要：
- 独立追踪和验证
- 在其他 Know 中复用
- 设定 review 周期

才需要提取为 CARD。

### Q: 一个 Evidence 可以同时产出 assembled Know 和 deep Know 吗？

A: 可以，但不推荐。通常：
- 如果需要深度分析 → 写 deep Know
- 如果只需要记录几个点 → 写 CARD，再组合为 assembled Know

### Q: Validator 会检查 deep Know 的 CARD 引用吗？

A: 不会。Validator 只对 `kind: assembled`（或未指定 kind）的 Know 检查 CARD 引用。
`kind: deep` 的 Know 检查的是 `source_refs`（Evidence 引用）。

---

*本文档定义 Deep Report 工作流，与 assembled Know 工作流互补。*
