现在让我整理这些信息，为您生成快速概览报告：

```markdown
# MCP Best Practices 快速概览

> **调研时间**: 2025-12-21  
> **来源数量**: 5 个  
> **一句话总结**: MCP 是 AI 与外部工具的标准化通信协议，让 Claude Code 像接入 ROS Topic/Service 一样连接数据库、API、文件系统等资源

---

## 这是什么？

**Model Context Protocol (MCP)** 是 Anthropic 于 2024 年 11 月推出的开源标准，用于规范 AI 系统（如 LLM）与外部工具、数据源、系统的双向连接。它类比于 ROS 中的 Topic/Service 机制——通过标准化协议实现模块间解耦通信，让 Claude Code 可以调用 GitHub API、查询数据库、操作文件系统等，无需为每个工具写专门的集成代码。

---

## 核心特点

| 特点 | 说明 |
|------|------|
| **三种传输模式** | HTTP（远程服务）、SSE（已弃用）、Stdio（本地进程） |
| **三级配置作用域** | Local（个人实验）、Project（团队共享）、User（跨项目工具） |
| **开箱即用生态** | GitHub、Sentry、PostgreSQL、Puppeteer 等预构建服务器 |
| **双向身份认证** | 支持 OAuth 2.0、Bearer Token、环境变量注入 |
| **输出流控制** | 默认 25,000 tokens 上限，10,000 tokens 警告阈值 |

---

## 适用场景

- **代码审查自动化**: 连接 GitHub MCP 服务器，让 Claude 直接读取 PR、评论、自动生成审查意见
- **数据库查询**: 通过 PostgreSQL/MySQL MCP 服务器，用自然语言查询业务数据（"本月总收入是多少？"）
- **错误监控**: 集成 Sentry MCP，实时分析错误日志并建议修复方案
- **浏览器自动化**: 使用 Puppeteer MCP 进行截图、UI 测试、表单填充
- **企业内部工具**: 封装私有 API 为 MCP 服务器，实现安全的内部数据访问

---

## 快速上手

### 1. 添加 MCP 服务器（三种方式）

```bash
# HTTP 模式（推荐用于远程服务）
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Stdio 模式（本地进程）
claude mcp add --transport stdio postgres --env DB_URL=postgresql://localhost:5432/mydb \
  -- npx -y @bytebase/dbhub --dsn "postgresql://user:pass@localhost:5432/db"

# 项目级配置（团队共享）
claude mcp add --transport http sentry --scope project https://mcp.sentry.dev/mcp
```

### 2. 配置文件直接编辑（推荐）

创建 `.mcp.json` 于项目根目录：

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_PATHS": "/home/user/projects"
      }
    }
  }
}
```

### 3. 管理命令

```bash
claude mcp list              # 列出所有服务器
claude mcp get github        # 查看单个服务器配置
claude mcp remove github     # 移除服务器
claude --mcp-debug           # 调试模式启动
```

### 4. 在 Claude Code 中使用

```bash
> /mcp                       # 查看所有可用 MCP 工具
> @github:issue://123        # 引用 GitHub Issue 作为上下文
> "分析最近 24 小时的错误日志"   # 自动调用 Sentry MCP
```

---

## 与竞品/替代方案对比

| 方面 | MCP | LangChain Tools | OpenAI Function Calling |
|------|-----|-----------------|-------------------------|
| **协议标准化** | ✅ 开放标准，跨平台 | ❌ 框架锁定 | ❌ OpenAI 专属 |
| **双向通信** | ✅ 服务器可主动推送 | ❌ 单向调用 | ❌ 单向调用 |
| **环境变量注入** | ✅ 原生支持 `${VAR}` | ⚠️ 需手动处理 | ❌ 不支持 |
| **企业级管控** | ✅ 白名单/黑名单策略 | ⚠️ 需自定义 | ❌ 无内置机制 |
| **本地/远程混合** | ✅ HTTP+Stdio 双模式 | ⚠️ 主要本地 | ❌ 仅 API 调用 |
| **生态成熟度** | ⚠️ 新兴（2024年11月） | ✅ 成熟丰富 | ✅ OpenAI 生态 |

---

## 值得关注的点

1. **团队协作优化**: 将 `.mcp.json` 纳入版本控制，新成员克隆仓库即可获得完整工具链，无需逐个配置（类似 `package.json` 的依赖管理思想）

2. **安全边界清晰**: 
   - 支持企业级 `managed-mcp.json`（系统管理员控制）和策略白名单（限制员工安装范围）
   - ⚠️ **警告**: 第三方 MCP 服务器存在 Prompt Injection 风险，务必审查来源

3. **输出流量控制**: 
   - 默认单次 MCP 输出不超过 25,000 tokens（约 10 万字），防止爆内存
   - 可通过 `MAX_MCP_OUTPUT_TOKENS` 环境变量调整

4. **调试工具**: 
   - `--mcp-debug` 标志可查看服务器启动日志、请求/响应详情
   - 日志位于 `~/.claude/logs/mcp-server-<name>.log`

5. **潜在问题**:
   - Windows 系统需用 `cmd /c npx ...` 包装命令
   - `--` 双破折号是必须的，用于分隔 Claude CLI 参数和 MCP 服务器命令
   - OAuth 2.0 服务器需在 Claude Code 内通过 `/mcp` 触发浏览器认证流程

---

## 延伸阅读

- [Connect Claude Code to tools via MCP - 官方文档](https://code.claude.com/docs/en/mcp)
- [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Add MCP Servers to Claude Code - MCPcat 配置指南](https://mcpcat.io/guides/adding-an-mcp-server-to-claude-code/)
- [ClaudeLog - MCP 配置最佳实践](https://claudelog.com/configuration/)
- [Model Context Protocol - Wikipedia](https://en.wikipedia.org/wiki/Model_Context_Protocol)

---

## 实战示例：三步集成 GitHub + Sentry

```bash
# 1. 添加服务器
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp --scope project

# 2. 在 Claude Code 中认证
> /mcp  
# 选择 github，浏览器授权
# 选择 sentry，浏览器授权

# 3. 自然语言调用
> "审查 PR #456 并检查是否引入 Sentry 中记录的崩溃问题"
```

Claude 会自动：
- 从 GitHub 获取 PR diff
- 从 Sentry 查询近期错误日志
- 交叉分析并生成报告

---

**类比总结**: 如果说传统 LLM 集成像手工焊接传感器到单片机，那 MCP 就是 ROS 的即插即用 Topic——标准化接口让你专注业务逻辑，而非底层通信协议。
