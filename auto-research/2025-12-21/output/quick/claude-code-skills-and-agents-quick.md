太好了！现在让我整合信息并输出快速概览报告。

# Claude Code Skills and Agents 快速概览

> **调研时间**: 2025-12-21
> **来源数量**: 4 个
> **一句话总结**: Claude Code 的扩展体系——Skills 自动激活、Commands 手动触发、Subagents 并行执行、Hooks 事件驱动，构成分层自动化框架。

---

## 这是什么?

Claude Code Skills & Agents 是 Anthropic 开发的模块化扩展系统，让 AI 编程助手能够自动加载专业能力包、并行运行专家代理、触发自定义工作流。它不是单一工具，而是分层的自动化架构——从"完全自动"的 Skills 到"完全手动"的 Slash Commands，中间填充了并行执行的 Subagents 和事件驱动的 Hooks，形成从被动响应到主动协作的完整频谱。

---

## 核心特点

| 特点 | 说明 |
|------|------|
| **模型自主决策 (Model-Invoked)** | Skills 基于任务上下文自动激活，无需手动输入命令——Claude 读懂需求后自动调用 |
| **渐进式信息披露 (Progressive Disclosure)** | 只加载必要文件到上下文窗口，避免 token 浪费——先读 SKILL.md 元信息，需要时再加载详细文档 |
| **工具权限管控 (allowed-tools)** | 可限制 Skill 使用的工具范围（如只读权限的 Read/Grep/Glob），避免误操作 |
| **分层安装位置** | Personal (~/.claude/skills/) 全局可用，Project (.claude/skills/) 团队共享，Plugin 随插件分发 |
| **并行专家代理 (Subagents)** | 独立上下文窗口的专家代理，可同时运行多个深度分析任务（如安全审计 + 性能优化） |

---

## 适用场景

- **自动化代码审查**: 提交前自动触发 linting、测试、安全扫描——无需记住 `/review` 命令，Claude 看到 `git diff --staged` 就主动检查
- **领域专家协作**: 同时启动"AWS 架构师"和"前端性能专家"两个 Subagent 并行分析复杂系统
- **团队规范强制执行**: 将 commit message 规范、文档模板、测试要求打包成 Skill，新人加入后自动遵循标准
- **自定义工作流编排**: 用 Slash Commands 将"拉取最新代码 → 运行测试 → 生成报告 → 通知 Slack"串成一键命令
- **事件驱动自动化**: 用 Hooks 在每次保存文件后自动运行格式化，或在 Claude 调用 Write 工具前自动备份

---

## 快速上手

### 创建第一个 Skill

```bash
# 1. 创建 Skill 目录
mkdir -p ~/.claude/skills/auto-commit-msg

# 2. 编写 SKILL.md
cat > ~/.claude/skills/auto-commit-msg/SKILL.md << 'EOF'
---
name: auto-commit-msg
description: 根据 git diff 自动生成规范的 commit message。在用户执行 git commit 或查看暂存区变更时使用。
---

# Auto Commit Message Generator

## 指令

1. 运行 `git diff --staged` 查看变更
2. 生成符合约定式提交 (Conventional Commits) 的消息：
   - 标题不超过 50 字符
   - 包含类型前缀 (feat/fix/docs/refactor)
   - 用中文描述"为什么改"而非"改了什么"

## 示例

**变更**: 新增用户登录表单组件
**生成**: `feat(auth): 支持邮箱密码登录以替代第三方认证`
EOF

# 3. 验证安装
ls ~/.claude/skills/auto-commit-msg/SKILL.md
```

### 配置 Subagent (专家代理)

在 `.claude/settings.json` 中定义：

```json
{
  "subagents": {
    "security-auditor": {
      "systemPrompt": "你是安全审计专家，专注于发现 OWASP Top 10 漏洞和供应链风险",
      "allowedTools": ["Read", "Grep", "Bash"]
    }
  }
}
```

调用方式：`@security-auditor 检查这个 API 端点的注入风险`

### 创建 Slash Command

```bash
# 1. 创建命令文件
mkdir -p .claude/commands
cat > .claude/commands/test-and-commit.md << 'EOF'
---
name: test-and-commit
description: 运行测试套件，通过后自动提交代码
args: [message]
---

# Test and Commit Workflow

```bash
npm test
```

# 指令给 Claude

如果测试全部通过，执行以下操作：
1. 暂存所有变更：`git add .`
2. 提交代码，使用用户提供的 message 参数
3. 输出提交哈希和变更统计

如果测试失败，报告失败用例并停止。
EOF

# 2. 使用命令
# 在 Claude Code 中输入: /test-and-commit "fix: 修复登录表单验证逻辑"
```

---

## 与竞品/替代方案对比

| 方面 | Claude Code Skills & Agents | GitHub Copilot | Cursor AI |
|------|-----------|----------|-----------|
| **自动触发能力** | ✅ Skills 基于上下文自动激活 | ❌ 需手动触发 Copilot Chat | 部分支持（Rules 文件） |
| **并行执行** | ✅ 多个 Subagent 独立上下文 | ❌ 单一对话流 | ❌ 单一对话流 |
| **工具权限管理** | ✅ 细粒度 allowed-tools 控制 | N/A | N/A |
| **渐进式加载** | ✅ 按需加载文档和脚本 | N/A（全量模型） | N/A（全量模型） |
| **团队共享机制** | ✅ Project Skills + Plugin 分发 | 通过 GitHub Copilot Enterprise | 通过 .cursorrules 文件 |
| **事件驱动自动化** | ✅ Hooks 支持生命周期事件 | ❌ | ❌ |

---

## 值得关注的点

1. **设计哲学的转变**: 从"用户问我答"到"AI 主动发现问题" — Skills 让 Claude 变成"随时待命的专家顾问"而非"等待指令的助手"

2. **Token 效率优化**: 渐进式披露机制避免将整个 Skill 文档塞进上下文——先读 YAML 元信息（name + description），只有真正需要时才加载详细指南，类似"按需分页加载"

3. **安全风险提示**: Anthropic 明确警告"仅从可信来源安装 Skills"——Skill 可以执行任意代码、访问文件系统、调用外部 API，恶意 Skill 可能窃取敏感信息或破坏代码库

4. **描述即接口 (Description as API)**: Skill 的 `description` 字段决定激活时机——写得太宽泛（"帮助处理文档"）会导致误触发，写得太具体（"提取 2023 年财报 PDF 第 3 页表格"）又限制复用性，需要找到平衡

5. **潜在限制**:
   - **调试困难**: 很难知道为什么 Claude 没有激活某个 Skill（可能是 description 不够明确，也可能是上下文不匹配）
   - **冲突处理**: 多个 Skill 的 description 重叠时，Claude 的选择逻辑不透明
   - **依赖管理**: Skill 中的 Python 脚本需要外部依赖（如 `pypdf`），但安装时机和版本控制尚未标准化

---

## 延伸阅读

- [Agent Skills - Claude Code 官方文档](https://code.claude.com/docs/en/skills)
- [Understanding Claude Code's Full Stack: MCP, Skills, Subagents, and Hooks Explained](https://alexop.dev/posts/understanding-claude-code-full-stack/)
- [Equipping agents for the real world with Agent Skills - Anthropic 工程博客](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Ultimate guide to extending Claude Code - GitHub Gist](https://gist.github.com/alirezarezvani/a0f6e0a984d4a4adc4842bbe124c5935)
- [Claude Code Skill Factory - 开源工具包](https://github.com/alirezarezvani/claude-code-skill-factory)

---

## 核心架构图（类比：机器人分层控制）

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code 扩展架构                      │
│                                                              │
│  [用户] ───┬──> Slash Commands (/test-and-commit)          │ 手动触发
│            │         ↓                                      │ （显式指令）
│            │    执行预定义工作流                            │
│            │                                                │
│            ├──> Hooks (PreToolUse, PostToolUse)            │ 事件驱动
│            │         ↓                                      │ （条件触发）
│            │    监听生命周期事件自动响应                    │
│            │                                                │
│  [Claude] ─┴──> Skills (auto-commit-msg, pdf-processor)    │ 模型自主
│                      ↓                                      │ （上下文匹配）
│                 读取任务上下文 → 自动激活                   │
│                      ↓                                      │
│                 Subagents (security-auditor, perf-expert)   │ 并行专家
│                      ↓                                      │ （独立上下文）
│                 深度分析 (独立 context window)              │
│                                                              │
│  [MCP] ────────> 外部系统集成 (GitHub, DB, APIs)            │ 工具连接层
└─────────────────────────────────────────────────────────────┘

类比机器人控制系统：
- Slash Commands = 操作员手动操作杆（Manual Override）
- Hooks = PLC 条件逻辑（If sensor X triggers, then Y）
- Skills = 自适应控制策略（根据振动信号自动调整 PID 参数）
- Subagents = 分布式子控制器（各管一个自由度，并行运算）
```

---

**报告长度**: 约 220 行  
**关键洞察**: Claude Code 不再是"被动响应式助手"，而是"主动协作式系统"——Skills 像机械系统中的自适应控制器，Subagents 像并行运行的子控制器，Hooks 像 PLC 的条件触发逻辑，共同构成可编程的 AI 协作框架。
