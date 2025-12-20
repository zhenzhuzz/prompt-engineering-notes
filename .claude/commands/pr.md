创建 Pull Request：

## 步骤

1. `git status` 确认当前分支状态
2. `git log main..HEAD --oneline` 查看所有待合并的 commits
3. `git diff main..HEAD --stat` 查看改动文件概览
4. 检查远程分支是否已推送，未推送则先 push
5. 使用 `gh pr create` 创建 PR

## PR 规范

- 标题和描述用**简体中文**
- 详细描述所有更改
- 用 **ASCII diagram** 描述架构变化、文件结构、数据流
- 用 **emoji** 增加可读性和趣味性

## PR Body 格式模板

```markdown
## 📋 变更摘要

[bullet points 列出主要更改]

## 🏗️ 架构/结构变化

[ASCII diagram 描述架构变化，如适用]

```
文件结构示意:
├── 新增文件...
├── 修改文件...
└── 删除文件...
```

## 📁 主要文件说明

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| xxx.md | 新增 | xxx |
| xxx.js | 修改 | xxx |

## ✅ 测试计划

- [ ] 测试项 1
- [ ] 测试项 2

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## gh pr create 命令格式

```bash
gh pr create --title "标题" --body "$(cat <<'EOF'
PR body 内容...
EOF
)"
```

## 注意事项

- 确保当前分支已推送到远程
- PR 标题简洁明了，body 详细描述
- 如有相关 issue，在描述中关联
