# Prompt Engineering Notes 项目配置

## 项目概述

知识提取与 Prompt Engineering 最佳实践文档库

- KNOW 知识提取文档
- Claude Code 使用指南
- Prompt 最佳实践总结

## 文档类型

| 类型 | 模板 | 说明 |
|------|------|------|
| KNOW | `_templates/KNOW_知识提取文档编写指南.md` | 知识提取文档 |
| 最佳实践 | 无固定模板 | Prompt 技巧总结 |

## 写作规范

遵循 KNOW 指南 (`_templates/KNOW_知识提取文档编写指南.md`)：

### 必须包含

1. **开头** (二选一):
   - Golden Rule — 适用于决策指南、流程规范
   - One Paragraph Takeaway — 适用于技术总结、研究报告

2. **The Essence** — ASCII 核心精华图

3. **结构要素**:
   - 文档头部元信息 (Source, URL, Author, Core Theme)
   - Executive Summary
   - 主题章节 (定义 + 案例 + 图表)
   - Transferable Rules (可迁移规则)
   - Key Takeaways (按角色分类)
   - Sources / References

### 中英文混排规范

- 中文为主，保留核心英文术语
- 英文术语首次出现时加中文注释
- 技术名词保持原文：Sub-Agent, Context Window, Prompt 等

## Git 工作流

使用用户级 Slash Commands（所有项目通用）:

| 命令 | 用途 |
|------|------|
| `/commit` | 标准化提交：emoji + 中文 + ASCII 图 |
| `/pr` | 创建 Pull Request |
| `/branch` | 交互式分支创建（先建议，后确认）|

### Commit Message 规范

- 标题和描述用**简体中文**
- 用 emoji 前缀标识类型：🚀 feat / 🐛 fix / 📚 docs / 🔧 chore / ♻️ refactor
- 详细描述变更内容，用 ASCII diagram 说明结构
- 末尾添加 Claude Code 签名

### 分支命名规范

- 格式: `type/description-YYYY-MM-DD`
- 示例: `docs/know-guide-update-2025-12-20`
- 类型: feature / fix / refactor / docs / chore

## 效率优先原则

在讨论方案或执行任务前，主动考虑：

1. **批量操作** - 能否用模板、脚本代替逐个操作？
2. **并行执行** - 多个独立任务是否可以并行？
3. **避免重复** - 是否有现成工具/模板可以复用？

## 确认清单工作流

执行破坏性变更前，需先列出完整影响范围，用户确认后再执行。
