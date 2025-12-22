# Publish: 派生输出与发布规则

本文件描述 `vault/publish/` 的性质与构建规则。

## 核心原则

**publish/ 是派生输出（derivatives），不是事实源（source of truth）。**

```
vault/evidence/  ──┐
vault/cards/     ──┼──► vault/know/  ──► vault/publish/
vault/know/      ──┘         ↑                  ↑
                        事实源            派生输出（可重建）
```

- `publish/` 下的所有文件可随时删除并重建
- 不要手动编辑 `publish/` 下的内容
- 修改应在 `know/` 层完成，然后重新运行构建

## 构建命令

```bash
python vault/tools/build_publish.py
```

**输出**：
- 为每个符合条件的 Know 文档生成对应的 `PUBLISH-*.md`
- 打印处理摘要（processed / generated / skipped）

## Sensitivity 规则 v0

当前版本只导出 `sensitivity: public` 的 Know 文档。

| sensitivity | 行为 |
|-------------|------|
| `public` | 导出到 publish/ |
| `internal` | 跳过，打印提示 |
| `private` | 跳过，打印提示 |
| 未指定 | 跳过，打印提示 |

## 输出格式

每个生成的 `PUBLISH-*.md` 包含：

1. **标题**：原 Know 文档标题 + "(Publish)"
2. **Source**：原始文件名和 ID
3. **Takeaway**：提取的核心摘要段落
4. **Cards referenced**：引用的 Card ID 列表
5. **Footer**：生成时间戳

## 未来扩展

后续版本可增加：

- **Redaction（脱敏）**：自动移除 internal/private 内容中的敏感标记
- **Internal 导出**：带访问控制的内部分发格式
- **多格式输出**：HTML、PDF、Notion 导出
- **增量构建**：只重建变更的文档
