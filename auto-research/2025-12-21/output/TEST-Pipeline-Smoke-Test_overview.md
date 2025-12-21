# Claude Code Headless Mode 快速概览

> **调研时间**: 2025-12-21
> **来源数量**: 3 个核心文档
> **一句话总结**: Claude Code 的 headless mode 通过 `-p` 参数实现非交互式自动化调用，可无缝集成到 CI/CD、脚本、监控等工作流中，让 AI 编程助手成为可编程的自动化工具。

---

## 这是什么?

Claude Code headless mode 是 Claude Code CLI 的非交互式运行模式。传统 Claude Code 需要在终端中手动输入指令，而 headless mode 通过命令行参数接收任务，自动执行并返回结果，不需要人工干预。就像把一个交互式的专家助手变成了可以批量调用的 API 服务。

这种模式特别适合自动化场景：CI/CD 流水线、定时任务、批量处理、日志分析等。你可以像调用 `grep` 或 `jq` 一样调用 Claude Code，让它成为脚本工具链的一环。

---

## 核心特点

| 特点 | 说明 |
|------|------|
| **非交互式执行** | 通过 `-p` 参数传入 prompt，无需人工输入 |
| **结构化输出** | 支持 `text`、`json`、`stream-json` 三种格式 |
| **工具权限预授权** | 用 `--allowedTools` 自动批准工具调用，避免交互式确认 |
| **会话管理** | 支持 `--continue` 和 `--resume` 延续上下文 |
| **管道友好** | 可与 Unix 管道、`jq`、`gh` 等工具无缝组合 |

---

## 适用场景

- **CI/CD 自动化**: 在 GitHub Actions / GitLab CI 中自动代码审查、测试修复、生成 commit message
- **定时监控任务**: 分析日志文件、监控系统状态、识别异常流量
- **批量迁移/重构**: 生成任务清单后批量调用 Claude 处理每个文件（Fan-out 模式）
- **GitOps 工作流**: 自动创建规范化的 commit、PR、代码审查报告
- **数据管道**: 作为 ETL 流程的一环，进行数据质量检查、文档生成

---

## 快速上手

### 基础用法

```bash
# 最简单的非交互式调用
claude -p "What does the auth module do?"

# 输出为 JSON 格式
claude -p "Summarize this project" --output-format json

# 实时流式 JSON（适合长任务）
claude -p "Analyze all test files" --output-format stream-json
```

### 自动批准工具权限

```bash
# 允许 Claude 自动运行测试并修复代码
claude -p "Run the test suite and fix any failures" \
  --allowedTools "Bash,Read,Edit"

# 只允许特定 git 命令（精细化控制）
claude -p "Review staged changes and create commit" \
  --allowedTools "Bash(git diff:*),Bash(git status:*),Bash(git commit:*)"
```

### 管道集成

```bash
# 分析 PR diff 并输出安全建议
gh pr diff 123 | claude -p \
  --append-system-prompt "You are a security engineer. Review for vulnerabilities." \
  --output-format json

# 提取 JSON 结果中的字段
result=$(claude -p "Analyze logs" --output-format json | jq -r '.result')
```

### 会话延续

```bash
# 第一次调用
claude -p "Review this codebase for performance issues"

# 继续上一次对话
claude -p "Now focus on the database queries" --continue

# 恢复特定会话
session_id=$(claude -p "Start review" --output-format json | jq -r '.session_id')
claude -p "Continue that review" --resume "$session_id"
```

---

## 与竞品/替代方案对比

| 方面 | Claude Code Headless | GitHub Copilot CLI | ChatGPT API |
|------|---------------------|-------------------|-------------|
| **工具调用能力** | 原生支持 Read/Edit/Bash 等代码工具 | 主要是对话式建议 | 需要自己实现工具层 |
| **上下文管理** | 自动管理代码库上下文 | 依赖 IDE 插件 | 需要手动传入上下文 |
| **输出格式** | text/json/stream-json | 纯文本 | JSON API 响应 |
| **本地集成** | CLI 直接操作文件系统 | 通过 IDE 间接操作 | 纯在线 API |
| **成本模式** | 按月订阅 + token 消耗 | 按月订阅 | 纯按 token 计费 |

---

## 值得关注的点

1. **Fan-out 模式**: 先让 Claude 生成任务列表，再用脚本循环调用处理每个任务。这是大规模迁移/重构的最佳实践。
   ```bash
   for task in $(cat tasks.txt); do
     claude -p "Migrate $task" --allowedTools "Read,Edit" --output-format json
   done
   ```

2. **工具权限精细控制**: 可以限制到具体命令级别，如 `Bash(git diff:*)` 只允许 `git diff` 相关命令，避免误操作。

3. **会话不持久化限制**: "Headless mode does not persist between sessions" —— 每次调用都是独立的，除非显式使用 `--resume`。这意味着不适合需要长期记忆的场景。

4. **成本监控**: 使用 JSON 输出可以提取 token 消耗数据，便于批量任务的成本追踪。

5. **调试模式**: 开发时用 `--verbose` 查看详细日志，生产环境去掉以减少噪音。

---

## 典型工作流示例

### GitHub Actions 代码审查

```yaml
name: AI Code Review
on: pull_request
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Claude Code Review
        run: |
          gh pr diff ${{ github.event.pull_request.number }} | \
          claude -p "Review this PR for bugs and best practices" \
            --output-format json \
            --allowedTools "Read,Grep" > review.json
      - name: Post Comment
        run: gh pr comment ${{ github.event.pull_request.number }} --body "$(jq -r '.result' review.json)"
```

### 日志异常检测 Cron Job

```bash
#!/bin/bash
# 每小时检查 nginx 日志异常
claude -p "Analyze last 1000 lines of /var/log/nginx/access.log for unusual patterns" \
  --allowedTools "Bash(tail:*),Read" \
  --output-format json | \
  jq -r '.result' | \
  mail -s "Nginx Traffic Alert" admin@example.com
```

---

## 延伸阅读

- [Headless mode - Claude Code Docs](https://code.claude.com/docs/en/headless) — 官方文档，最权威的参数说明
- [Claude Code Headless · Adriano Melo](https://adrianomelo.com/posts/claude-code-headless.html) — 8 个实战场景详解
- [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices) — Anthropic 官方最佳实践指南
- [Building Agents with Claude Code's SDK](https://blog.promptlayer.com/building-agents-with-claude-codes-sdk/) — 进阶：用 Python/TypeScript SDK 构建复杂 agent
- [ClaudeCode Tutorial Center - Headless Mode](https://www.claudecode101.com/en/tutorial/advanced/headless-mode) — 中文教程和案例

---

## Sources

- [Headless mode - Claude Code Docs](https://code.claude.com/docs/en/headless)
- [Claude Code: Best Practices and Pro Tips](https://htdocs.dev/posts/claude-code-best-practices-and-pro-tips/)
- [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Claude Code Headless · Adriano Melo](https://adrianomelo.com/posts/claude-code-headless.html)
- [ClaudeCode Tutorial Center - Complete Claude Code AI Programming Assistant Guide](https://www.claudecode101.com/en/tutorial/advanced/headless-mode)
