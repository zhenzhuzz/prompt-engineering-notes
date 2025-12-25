# 知识资产库 (Knowledge Asset Vault)

> 可审计、证据驱动的知识管理系统。

**写作规范:** 参见 [STYLE.md](STYLE.md)

---

## 目录结构

```
vault/
├── evidence/     # Evidence（证据）：原始来源，追加式存储
├── cards/        # Card（卡片）：原子主张-证据资产
├── know/         # Know Doc（知识文档）：综合卡片，仅引用
├── schema/       # 预留给未来 schema 文件
├── ledger/       # Ledger（账本）：审计报告
├── publish/      # 发布输出，可重建
├── templates/    # 模板文件
└── tools/        # 验证脚本
```

## 核心文档

- [CONTRACT.md](CONTRACT.md) — 硬规则（主权、证据优先等）
- [SCHEMA.md](SCHEMA.md) — Card 和 Evidence 的字段定义
- [STYLE.md](STYLE.md) — 中英文混排规范

---

## 工作流程

```
Evidence → Cards → Know → Validate
  证据   →  卡片  → 知识文档 → 验证
```

### 1. 采集 Evidence（证据）

```bash
# 创建证据内容文件
vault/evidence/EVI-YYYYMMDD-XXXX.note.md   # 或 .pdf, .png 等

# 创建元数据文件
vault/evidence/EVI-YYYYMMDD-XXXX.yml
```

模板: `vault/templates/evidence.meta.template.yml`

**分型模板** (根据 `type` 选择):
- `evidence.tech_blog.meta.template.yml` — 技术博客
- `evidence.interview.meta.template.yml` — 访谈/播客
- `evidence.company_research.meta.template.yml` — 公司调研
- `evidence.debug_playbook.meta.template.yml` — 调试手册

### 2. 创建 Card（卡片）

```bash
vault/cards/CARD-YYYYMMDD-XXXX.md
```

模板: `vault/templates/card.template.md`

**分型模板** (根据 `type` 选择):
- `card.tech_blog.template.md` — 技术博客卡片
- `card.interview.template.md` — 访谈卡片
- `card.company_research.template.md` — 公司调研卡片
- `card.debug_playbook.template.md` — 调试手册卡片

每张 Card 必须：
- 包含完整的 YAML front matter
- 引用至少一条 Evidence（通过 `evidence_refs`）
- 包含 Claim、Evidence、Transferable Rule 三个部分

### 3. 撰写 Know Doc（知识文档）

```bash
vault/know/KNOW-YYYYMMDD-descriptor.md
```

模板: `vault/templates/know.template.md`

Know Doc 规则：
- 综合多张 Card 形成可读叙述
- **只引用已有 CARD IDs** — 不引入新主张
- 提供上下文和关联

### 4. 验证

```bash
python vault/tools/validate_vault.py
```

检查项：
- 所有 Card 具有必需的 YAML 字段
- `status` 和 `confidence` 枚举值有效
- 每张 Card 至少有一条 `evidence_ref`
- 所有 Evidence 元数据文件具有必需字段

---

## 快速命令

```bash
# 验证所有资产
python vault/tools/validate_vault.py

# 列出所有 Card
ls vault/cards/

# 列出所有 Evidence
ls vault/evidence/*.yml
```

---

## 新增资产指南

### 新增 Evidence
1. 复制 `vault/templates/evidence.meta.template.yml`
2. 重命名为 `vault/evidence/EVI-YYYYMMDD-XXXX.yml`
3. 填写元数据字段
4. 如有本地文件，使用相同的基础名（不同扩展名）

### 新增 Card
1. 复制 `vault/templates/card.template.md`
2. 重命名为 `vault/cards/CARD-YYYYMMDD-XXXX.md`
3. 填写 YAML front matter
4. 撰写 Claim、Evidence、Transferable Rule 三部分
5. 运行验证

### 新增 Know Doc
1. 复制 `vault/templates/know.template.md`
2. 重命名为 `vault/know/KNOW-YYYYMMDD-descriptor.md`
3. 只引用已有的 CARD IDs
4. 不引入新主张 — 仅综合已有内容
