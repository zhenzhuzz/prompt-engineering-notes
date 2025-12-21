# Claude Code MCP Bash Tools Architecture 快速概览

> **调研时间**: 2025-12-21
> **来源数量**: 15+ 个权威来源
> **一句话总结**: Claude Code 通过 MCP 协议构建了可扩展的 Bash 工具生态,相比 Codex CLI 的 Rust 原生性能和 Gemini CLI 的 Google 云集成,它是最灵活的开放式 AI 编程助手框架

---

## 这是什么?

Claude Code 是 Anthropic 推出的终端 AI 编程助手,通过 **Model Context Protocol (MCP)** 标准化协议连接外部工具、数据库和 API。它采用**双模架构**——既可以作为 MCP 服务器暴露自己的工具(Bash, Read, Write, Edit 等),也可以作为 MCP 客户端消费其他 MCP 服务器。这使得它能像乐高积木一样组合工具能力,形成强大的自动化工作流。

与竞品相比:OpenAI Codex CLI 用 Rust 实现追求原生性能,Gemini CLI 主打 Google Cloud 生态集成,而 Claude Code 则通过 MCP 开放标准构建了最具扩展性的工具生态系统。

---

## 核心特点

| 特点 | 说明 |
|------|------|
| **MCP 双模架构** | 同时充当服务器(暴露工具)和客户端(消费工具),支持 stdio/HTTP/SSE 三种传输协议 |
| **原生 Bash 集成** | 继承完整 Shell 环境,通过安全沙箱执行命令,支持 Hooks 事件驱动自动化 |
| **Subagents 并行架构** | 隔离上下文窗口的专用 AI 代理,可并行执行复杂任务,避免上下文污染 |
| **Skills 自动激活** | 基于任务描述自动加载相关技能,无需显式调用(vs Slash Commands) |
| **SWE-bench 72.7%** | 在实际软件工程测试中性能领先(Codex o3 69.1%, Gemini 2.5 Pro 63.8%) |

---

## 适用场景

- **复杂多文件重构**: 大型代码库迁移、依赖升级、架构调整——通过 Subagents 并行处理避免上下文爆炸
- **企业工具集成**: 连接 JIRA、GitHub、PostgreSQL、Sentry、Figma 等数十种服务,统一自动化工作流
- **定制开发环境**: 通过 MCP 服务器扩展,如一位开发者"一天内用 Claude Code 构建完整发票管理平台"
- **终端优先工作流**: 相比 IDE 插件,Claude Code 的终端 UX 设计更适合 DevOps、系统管理员、全栈工程师

---

## 快速上手

### 安装与配置

```bash
# 安装 Claude Code (需 Node.js 20+)
npm install -g claude-code

# 登录
claude login

# 添加 MCP 服务器 (HTTP 传输,推荐)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 添加本地 MCP 服务器 (Stdio 传输)
claude mcp add --transport stdio postgres \
  --env DATABASE_URL=postgresql://localhost/mydb \
  -- npx -y @modelcontextprotocol/server-postgres

# 列出已配置服务器
claude mcp list
```

### 基础使用

```bash
# 启动交互式会话
claude

# 在会话中使用 MCP 工具
> 分析 @github:issue://123 并提出修复方案
> 查询 @postgres:schema://users 并与文档对比

# 使用 MCP Prompt 作为 Slash 命令
> /mcp__github__list_prs
> /mcp__jira__create_issue "登录流程 Bug" high

# 检查 MCP 服务器状态
> /mcp
```

### 核心配置文件

| 文件路径 | 作用域 | 用途 |
|----------|--------|------|
| `~/.claude.json` | 用户级 | 跨项目个人 MCP 服务器配置 |
| `.mcp.json` | 项目级 | 团队共享,版本控制追踪 |
| `.claude/settings.json` | 项目级 | Hooks、Subagents、Skills 配置 |
| `.claude/skills/` | 项目/用户级 | 自定义技能库 |

---

## 与竞品/替代方案对比

| 维度 | Claude Code | OpenAI Codex CLI | Google Gemini CLI |
|------|-------------|------------------|-------------------|
| **核心技术栈** | TypeScript/Node.js + MCP 协议 | Rust (97.3%) 原生性能 | Python/TypeScript + Google Cloud |
| **SWE-bench 得分** | 72.7% | 69.1% (o3 模型) | 63.8% (Gemini 2.5 Pro) |
| **上下文窗口** | ~200K tokens | ~128K tokens | 1M tokens (最大) |
| **MCP 支持** | 原生双模架构 | 通过 `shell-tool-mcp` 支持 | 通过 `~/.gemini/settings.json` 配置 |
| **Bash 集成** | 继承完整 Shell 环境 + Hooks 自动化 | 执行策略 (execpolicy) 沙箱 | 内置 Shell 工具 + Headless 模式 |
| **架构特色** | Subagents 并行 + Skills 自动激活 | 非交互模式 `codex exec` | ReAct 循环 + Google Search 接地 |
| **开源程度** | 闭源(Anthropic 专有) | 开源(Apache 2.0) | 开源(Apache 2.0) |
| **定价** | 个人免费,团队付费 | ChatGPT Plus/Pro/Enterprise 包含 | 免费 60req/min, 付费 API 密钥 |
| **平台支持** | macOS, Linux, Windows 11 | macOS, Linux, Windows(WSL) | macOS, Linux, Windows + Cloud Shell |
| **实测速度** | 1h 17min (项目完成时间) | 未公开基准 | 2h 2min (同一项目) |

### 类比解释

用机器人控制架构打比方:

- **Claude Code**: 像 **ROS (Robot Operating System)** 开放生态——通过标准化接口(MCP)连接各种传感器(工具),Subagents 就像多个并行控制器协同工作
- **Codex CLI**: 像 **ABB 机器人专用控制器**——高性能 Rust 内核,执行策略(execpolicy)精确控制,但需要 ChatGPT 订阅才能访问
- **Gemini CLI**: 像 **新能源汽车的混合动力系统**——结合传统引擎(本地 Shell 工具)和电池(Google Cloud 服务),1M 上下文像超大油箱

---

## 值得关注的点

1. **MCP 生态爆发 (2025)**: OpenAI 在 3 月将 MCP 集成到 ChatGPT,Google 在 4 月确认 Gemini 支持,Block、Apollo、Zed、Replit、Sourcegraph 全部跟进——MCP 正在成为 AI 工具集成的事实标准

2. **双模架构的威力**: Claude Code 可以同时作为服务器和客户端,意味着你可以在 Cursor IDE 中通过 MCP 调用 Claude Code 的工具,同时 Claude Code 又在后台连接 GitHub 和 PostgreSQL——这种可组合性是竞品不具备的

3. **Subagents 解决上下文污染**: 传统 AI 编程助手在长会话中会"遗忘"或混淆信息,Claude Code 通过隔离上下文的 Subagents 并行处理,每个专用代理维护独立状态——类比就像多核 CPU 各管各的任务

4. **Skills 的"零触发"设计**: 不同于 Slash Commands 需要显式调用,Skills 根据任务描述自动激活——你说"优化数据库查询",相关的 SQL 性能分析 Skill 会自动加载,无需记忆命令

5. **潜在问题/限制**:
   - **上下文窗口压力**: 虽然 Subagents 缓解了问题,但实测显示复杂任务仍会遇到上下文瓶颈(相比 Gemini 的 1M tokens)
   - **Windows 支持曲折**: MCP 服务器模式在 Windows 上需要 WSL,不如原生支持顺滑
   - **MCP 服务器质量参差**: Anthropic 警告"未验证所有第三方 MCP 服务器的安全性",存在 Prompt 注入风险
   - **代码格式不一致**: 某些基准测试中 Claude Code 的输出格式化不如 Cursor 等竞品

---

## 延伸阅读

### 官方文档
- [Claude Code MCP 集成指南](https://code.claude.com/docs/en/mcp)
- [OpenAI Codex CLI 官方文档](https://developers.openai.com/codex/cli/)
- [Google Gemini CLI 开发文档](https://developers.google.com/gemini-code-assist/docs/gemini-cli)

### 深度分析
- [Understanding Claude Code's Full Stack: MCP, Skills, Subagents, and Hooks Explained](https://alexop.dev/posts/understanding-claude-code-full-stack/)
- [Claude Code as an MCP Server: Setup and Real-World Usage](https://www.ksred.com/claude-code-as-an-mcp-server-an-interesting-capability-worth-understanding/)
- [Testing AI coding agents (2025): Cursor vs. Claude, OpenAI, and Gemini - Render Blog](https://render.com/blog/ai-coding-agents-benchmark)

### 对比评测
- [Claude Code CLI vs Codex CLI vs Gemini CLI: Best AI CLI Tool 2025](https://www.codeant.ai/blogs/claude-code-cli-vs-codex-cli-vs-gemini-cli-best-ai-cli-tool-for-developers-in-2025)
- [Agentic CLI Tools Compared: Claude Code vs Cline vs Aider](https://research.aimultiple.com/agentic-cli/)
- [Codex CLI vs Gemini CLI vs Claude Code: Which is the Best?](https://www.analyticsvidhya.com/blog/2025/08/codex-cli-vs-gemini-cli-vs-claude-code/)

### MCP 生态
- [Model Context Protocol 官方规范](https://github.com/modelcontextprotocol)
- [Claude Code MCP Server on GitHub](https://github.com/auchenberg/claude-code-mcp)

---

## 技术细节补充

### MCP 三种传输协议对比

```bash
# 1. HTTP (推荐,企业级)
claude mcp add --transport http notion https://mcp.notion.com/mcp \
  --header "Authorization: Bearer token"
# 优点: 标准化、支持认证、可远程部署
# 缺点: 需要网络连接

# 2. Stdio (本地,轻量)
claude mcp add --transport stdio airtable \
  --env AIRTABLE_API_KEY=xxx \
  -- npx -y airtable-mcp-server
# 优点: 无网络依赖、启动快
# 缺点: 每个连接独立进程、无状态共享

# 3. SSE (已弃用)
claude mcp add --transport sse legacy-service https://old.api.com/mcp
# 状态: 官方不再推荐使用
```

### Hooks 事件驱动自动化示例

```json
// .claude/settings.json
{
  "hooks": {
    "PostToolUse": {
      "Edit": {
        "command": "oxlint ${filePath}",
        "description": "自动格式化编辑后的 JS/TS 文件"
      }
    },
    "PreToolUse": {
      "Bash": {
        "prompt": "该命令是否安全? ${command}",
        "mode": "llm-evaluation"
      }
    }
  }
}
```

### Subagents 配置模式

```json
{
  "subagents": {
    "security-auditor": {
      "systemPrompt": "你是安全专家,专注于代码审计和漏洞检测",
      "allowedTools": ["Read", "Grep", "Bash(grep:*, find:*)"],
      "model": "opus"  // 用最强模型处理安全任务
    },
    "test-runner": {
      "systemPrompt": "你负责运行测试并分析失败原因",
      "allowedTools": ["Bash(npm:*, pytest:*)", "Read"],
      "model": "haiku"  // 用快速模型处理重复任务
    }
  }
}
```

### 企业级 MCP 管理

```json
// /Library/Application Support/ClaudeCode/managed-mcp.json (macOS)
{
  "mcpServers": {
    "company-github": {
      "type": "http",
      "url": "https://github.company.com/mcp"
    }
  },
  "allowedMcpServers": [
    { "serverUrl": "https://*.company.com/*" },
    { "serverCommand": ["npx", "-y", "@company/internal-mcp"] }
  ],
  "deniedMcpServers": [
    { "serverUrl": "https://*.external-untrusted.com/*" }
  ]
}
```

---

## 实际案例: 从零到生产的工作流

```bash
# 1. 配置项目 MCP 服务器 (团队共享)
cd ~/my-project
claude mcp add --scope project --transport http github https://api.github.com/mcp
claude mcp add --scope project --transport stdio postgres \
  --env DATABASE_URL=$DATABASE_URL -- npx -y @mcp/server-postgres

# 2. 启动 Claude Code
claude

# 3. 在交互式会话中执行复杂任务
> 分析 @github:issue://456 中报告的性能问题
> 查询 @postgres:table://analytics 最近 7 天的慢查询日志
> 生成优化方案并创建 PR

# 4. 使用 Subagent 并行处理
> /subagent security-auditor "审计 auth.ts 中的 JWT 实现"
> /subagent test-runner "运行集成测试并分析失败"

# 5. 通过 Hooks 自动化
# (每次 Edit 后自动运行 ESLint + Prettier)

# 6. 创建自定义 Skill
cat > .claude/skills/db-optimizer/SKILL.md << 'EOF'
---
name: db-optimizer
description: 分析并优化 PostgreSQL 查询性能
---

1. 连接 @postgres 查看 EXPLAIN ANALYZE 结果
2. 识别缺失索引、N+1 查询、表扫描
3. 生成优化建议和迁移脚本
4. 运行测试验证性能提升
EOF

# 下次说"优化数据库"时自动激活此 Skill
```

---

## 总结: 为什么选择 Claude Code?

**选择 Claude Code 如果你**:
- 需要深度集成企业工具生态(JIRA、Slack、内部 API)
- 处理复杂多文件重构,需要 Subagents 并行能力
- 重视终端 UX 和可编程性(Hooks、Skills)
- 认可 MCP 开放标准的长期价值

**选择 Codex CLI 如果你**:
- 已有 ChatGPT Plus/Pro 订阅,无需额外成本
- 追求原生性能和快速响应(Rust 实现)
- 需要严格的执行策略沙箱控制
- 偏好 OpenAI 的 o3 推理模型

**选择 Gemini CLI 如果你**:
- 需要超大上下文窗口(1M tokens)处理巨型代码库
- 深度使用 Google Cloud 服务
- 偏好完全开源方案(Apache 2.0)
- 需要 Google Search 接地能力

---

> **下一步**:
> 1. 尝试安装 Claude Code: `npm install -g claude-code`
> 2. 浏览 [MCP Server Registry](https://github.com/modelcontextprotocol/servers) 寻找你需要的集成
> 3. 阅读 [Claude Code Full Stack 解析](https://alexop.dev/posts/understanding-claude-code-full-stack/) 深入理解架构

**调研完成时间**: 2025-12-21 | **字数**: ~2500 字 | **预计阅读时间**: 8-10 分钟
