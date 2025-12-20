创建新分支：

## 步骤

1. `git status` 确认当前分支和工作区状态
2. `git branch -a` 查看现有分支
3. 根据用户描述，**提供 3 个分支命名建议**
4. **⚠️ 等待用户确认后再继续**
5. 创建并切换到新分支
6. (可选) 如果有未提交的更改，执行 git add → commit → push

## 分支命名格式

```
type/description-YYYY-MM-DD
```

### Type 类型

| Type | 说明 | 示例 |
|------|------|------|
| feature | 新功能 | feature/boost-recommendation-2025-12-19 |
| fix | Bug 修复 | fix/mcq-video-loading-2025-12-19 |
| refactor | 重构 | refactor/api-structure-2025-12-19 |
| docs | 文档 | docs/mcq-guide-2025-12-19 |
| chore | 杂项 | chore/cleanup-unused-files-2025-12-19 |

## 输出格式

当用户请求创建分支时，按以下格式输出：

```
## 🌿 分支命名建议

根据您的描述，建议以下分支名：

1. `feature/xxx-YYYY-MM-DD` - 说明
2. `feature/yyy-YYYY-MM-DD` - 说明
3. `feature/zzz-YYYY-MM-DD` - 说明

请选择一个，或告诉我您想要的名称。
```

## 注意事项

- **必须等用户确认分支名后再创建**
- 分支名使用小写字母和连字符
- 日期格式: YYYY-MM-DD
- 如果用户没有说明分支用途，先询问
