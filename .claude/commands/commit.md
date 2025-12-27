执行 Git 提交流程：

## 核心步骤（严格执行）

1. `git status` 查看所有更改
2. `git add` 相关文件（只 stage 与本次提交相关的文件）
3. `git diff --cached --stat` 确认待提交内容
4. 生成 commit message → 写入 `.git/COMMIT_EDITMSG`
5. 输出摘要：**标题 + 行数 + staged 文件列表**
6. 用户确认后执行 `git commit -F .git/COMMIT_EDITMSG`

## 禁止事项

- ❌ 不要执行 `git log` 查看历史（除非用户要求）
- ❌ 不要执行详细的 `git diff`（除非用户要求）
- ❌ 不要修改 .gitignore 或做其他"顺便清理"
- ❌ 不要在 commit 流程中做与提交无关的操作

## Commit Message 分级（根据改动规模选择）

### Level 1: 小改动（1-5 文件，单一功能）

```
[emoji] [类型](scope): 一句话标题

• 改动点 1
• 改动点 2
• 改动点 3

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

**示例**:
```
🐛 fix(api): 修复 CORS 跨域问题

• server.js: 添加 Vercel 域名到白名单
• communication.ts: 支持 VITE_BACKEND_URL 环境变量

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

### Level 2: 中等改动（6-15 文件，多个相关功能）

```
[emoji] [类型](scope): 一句话标题

**变更摘要**:
• 分类 1: 描述
• 分类 2: 描述

**文件清单**:
path/to/file1.js  # 简短说明
path/to/file2.ts  # 简短说明

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

### Level 3: 大改动（15+ 文件 或 重大重构/新功能）

使用完整模板：业务价值 + 变更摘要 + ASCII diagram + 文件清单

```
[emoji] [类型](scope): 一句话标题

═══════════════════════════════════════════════════════════════════
🎯 业务价值
═══════════════════════════════════════════════════════════════════

> **一句话**: [用非技术语言说明这个提交的价值]

• 解决问题: [之前的痛点]
• 实现功能: [对用户/产品的改善]
• 采用方案: [简述方法]

═══════════════════════════════════════════════════════════════════
📋 变更摘要
═══════════════════════════════════════════════════════════════════

[按类型分组描述所有更改]

═══════════════════════════════════════════════════════════════════
🏗️ 结构变化
═══════════════════════════════════════════════════════════════════

[ASCII diagram 描述文件结构、组件关系、数据流、重构前后对比等]

═══════════════════════════════════════════════════════════════════
📁 文件清单
═══════════════════════════════════════════════════════════════════

[列出主要更改的文件及其用途]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

## Emoji 类型前缀

| Emoji | 类型 | 说明 |
|-------|------|------|
| 🚀 | feat | 新功能 |
| 🐛 | fix | Bug 修复 |
| 📚 | docs | 文档更新 |
| 🔧 | chore | 杂项/配置 |
| ♻️ | refactor | 重构 |
| 🎨 | style | 样式/格式 |
| ✅ | test | 测试 |
| 📦 | build | 构建/打包 |

## 注意事项

- 如果 push 失败 (HTTP 408)，先诊断是否有大文件，不要盲目重试
- 参考 `_knowledge/KNOW_git-large-file-push-trap-与正确工作流.md`
- **业务价值部分用老板能听懂的语言**，避免技术术语

## 技术说明：为什么使用临时文件？

使用 `git commit -F .git/COMMIT_EDITMSG` 而非 heredoc 的原因：
- ✅ 支持任意特殊字符（单引号、反引号、美元符等）
- ✅ 不需要转义
- ✅ git 自动管理文件生命周期
