# 网球正手动作评分标准 (Band 1-9)

**版本**: v2.0.0
**语言**: 中文
**创建日期**: 2025-12-09
**设计原则**: 类似 IELTS 的 Band 档位制，任何评分者都能给出一致结果

---

## 目录

- [1. 评分体系概述](#1-评分体系概述)
- [2. 四个评分维度](#2-四个评分维度)
- [3. Band 1-9 总体描述](#3-band-1-9-总体描述)
- [4. 各维度详细评分标准](#4-各维度详细评分标准)
- [5. 评分流程](#5-评分流程)
- [6. 输出格式](#6-输出格式)

---

## 1. 评分体系概述

### 1.1 核心理念

本评分体系采用 **IELTS 式 Band 档位制**，核心目的是：

1. **发现问题** — 定位球员在哪个维度存在 Core Issue
2. **一致性** — 任何评分者（人类或 AI）都能给出相近的结果
3. **可执行** — 每个评分项都有明确的视觉锚点，无需主观判断

### 1.2 评分公式

```
整体 Band = round(四个维度 Band 的平均值)

例如：
- 动力链 Band 5
- 击球点 Band 4
- 身体协调 Band 6
- 稳定性 Band 5

整体 Band = round((5+4+6+5)/4) = round(5.0) = Band 5
```

### 1.3 Core Issue 定义

**Core Issue** = 某个维度内评分最低的子项（score ≤ 4）

- 每个维度最多报告 1 个 Core Issue
- 如果该维度所有子项 score > 4，则该维度无 Core Issue
- `primaryCoreIssues` 列出所有维度中最严重的问题（用于后续 AI 修复）

---

## 2. 四个评分维度

| 维度 | 英文 | 权重 | 评估内容 |
|------|------|------|----------|
| 动力链 | Power Chain (PC) | 25% | 大臂驱动、肩膀转动、髋部转动、重心转移 |
| 击球点 | Contact Point (CP) | 25% | 击球位置、手臂伸展、击球时机 |
| 身体协调 | Body Coordination (BC) | 25% | 引拍、随挥、动作流畅性 |
| 稳定性 | Stability (ST) | 25% | 动作一致性、拍面控制、握拍稳定 |

---

## 3. Band 1-9 总体描述

| Band | 等级名称 | 总体描述 |
|------|----------|----------|
| **9** | Expert (专家级) | 所有维度接近完美，职业级水平。动力链完全传递，击球点精准，动作经济流畅，高度一致。 |
| **8** | Advanced (高级) | 所有维度熟练，极少失误。动力链传递良好，击球点稳定，动作流畅协调，一致性高。 |
| **7** | Proficient (熟练) | 动作清晰规范，偶有小问题。动力链基本完整，击球点合理，整体协调，稳定性好。 |
| **6** | Competent (胜任) | 基本结构完整，但有明显局限。动力链有但不充分，击球点有时偏移，动作基本协调。 |
| **5** | Modest (中等) | 有框架但不稳定，多处需改进。动力链部分传递，击球点不稳定，动作有明显断点。 |
| **4** | Limited (有限) | 多个维度有问题，仅基础可用。动力链传递差，击球点经常偏移，动作不协调。 |
| **3** | Very Limited (非常有限) | 严重问题，仅有少量正确元素。动力链几乎不存在，击球点随机，动作僵硬。 |
| **2** | Intermittent (间歇) | 几乎无法识别正确动作。偶尔有正确元素，但无法持续。 |
| **1** | Non-user (无效) | 无有效挥拍动作。无法识别任何正确的网球技术元素。 |

---

## 4. 各维度详细评分标准

### 4.1 动力链 (Power Chain)

**定义**: 从下肢到躯干到手臂的力量传递链条

#### 子项定义

| 子项 | 英文 | 视觉锚点 |
|------|------|----------|
| 大臂驱动 | upperArmDrive | 击球时肘关节与躯干的距离 |
| 肩膀转动 | shoulderRotation | 引拍到击球过程中肩膀的转动角度 |
| 髋部转动 | hipRotation | 髋部从侧向前的转动程度 |
| 重心转移 | weightTransfer | 身体重心从后脚到前脚的转移 |

#### Band 描述

| Band | upperArmDrive | shoulderRotation | hipRotation | weightTransfer |
|------|---------------|------------------|-------------|----------------|
| **9** | 肘距躯干 > 20cm，大臂充分甩动 | 肩膀转动 > 90度，完全转正 | 髋部完全转正，有爆发力 | 重心完全转移到前脚，有蹬地 |
| **8** | 肘距躯干 15-20cm，大臂参与明显 | 肩膀转动 70-90度 | 髋部转动明显 | 重心转移充分 |
| **7** | 肘距躯干 10-15cm，大臂有参与 | 肩膀转动 45-70度 | 髋部有转动 | 重心有转移 |
| **6** | 肘距躯干 8-10cm，大臂参与有限 | 肩膀转动 30-45度 | 髋部轻微转动 | 重心轻微转移 |
| **5** | 肘距躯干 5-8cm，主要靠小臂 | 肩膀转动 20-30度 | 髋部几乎不动 | 重心基本不动 |
| **4** | 肘距躯干 < 5cm，肘部夹紧 | 肩膀转动 < 20度 | 髋部不动 | 重心在后脚 |
| **3** | 肘部贴身，无大臂参与 | 肩膀几乎不转 | 髋部固定 | 重心固定 |
| **2** | 手臂僵硬如棍 | 无转动 | 无转动 | 无转移 |
| **1** | 无法识别大臂动作 | 无法识别 | 无法识别 | 无法识别 |

#### 维度 Band 计算

```
动力链 Band = round((upperArmDrive + shoulderRotation + hipRotation + weightTransfer) / 4)
```

---

### 4.2 击球点 (Contact Point)

**定义**: 球拍与球接触时的位置、时机和手臂状态

#### 子项定义

| 子项 | 英文 | 视觉锚点 |
|------|------|----------|
| 击球位置 | contactPosition | 击球瞬间球拍相对于身体中线的位置 |
| 手臂伸展 | armExtension | 击球时手臂的伸展程度（肘角） |
| 击球时机 | timing | 球被击中时相对于最佳击球点的时机 |

#### Band 描述

| Band | contactPosition | armExtension | timing |
|------|-----------------|--------------|--------|
| **9** | 击球点在身前舒适区，距身体约一臂远 | 肘角 > 160度，手臂充分伸展 | 球在最佳上升期被击中 |
| **8** | 击球点在身前，位置稳定 | 肘角 150-160度 | 球在上升期被击中 |
| **7** | 击球点基本在身前 | 肘角 140-150度 | 球在最高点附近被击中 |
| **6** | 击球点略偏，有时不在身前 | 肘角 130-140度 | 击球时机有时偏早或偏晚 |
| **5** | 击球点经常偏移 | 肘角 120-130度，手臂弯曲 | 击球时机不稳定 |
| **4** | 击球点在身侧或身后 | 肘角 < 120度，手臂明显弯曲 | 经常打晚球 |
| **3** | 击球点随机 | 肘角 < 100度，顶肘 | 击球时机混乱 |
| **2** | 无法判断击球点 | 手臂完全弯曲 | 无法判断时机 |
| **1** | 无有效击球 | 无法识别 | 无法识别 |

#### 维度 Band 计算

```
击球点 Band = round((contactPosition + armExtension + timing) / 3)
```

---

### 4.3 身体协调 (Body Coordination)

**定义**: 引拍、击球、随挥的连贯性和流畅度

#### 子项定义

| 子项 | 英文 | 视觉锚点 |
|------|------|----------|
| 引拍完整 | backswing | 向后引拍动作的幅度和完整性 |
| 随挥完整 | followThrough | 击球后收拍动作的幅度和方向 |
| 动作流畅 | fluidity | 整个动作的连贯性，是否有卡顿 |

#### Band 描述

| Band | backswing | followThrough | fluidity |
|------|-----------|---------------|----------|
| **9** | 引拍充分，拍头指向后方，侧身完整 | 随挥完整，收拍到对侧肩膀上方 | 动作如行云流水，无任何断点 |
| **8** | 引拍充分，侧身明显 | 随挥完整，收拍流畅 | 动作流畅，节奏好 |
| **7** | 引拍到位，有侧身 | 随挥基本完整 | 动作连贯 |
| **6** | 引拍基本到位 | 随挥较短，但有向前收拍 | 动作基本连贯，有轻微断点 |
| **5** | 引拍不充分 | 随挥不完整，收拍早 | 动作有明显断点 |
| **4** | 引拍很短 | 几乎无随挥 | 动作不连贯 |
| **3** | 几乎无引拍 | 无随挥 | 动作僵硬，多处断点 |
| **2** | 无法识别引拍 | 无法识别随挥 | 动作支离破碎 |
| **1** | 无引拍动作 | 无收拍动作 | 无法识别动作 |

#### 维度 Band 计算

```
身体协调 Band = round((backswing + followThrough + fluidity) / 3)
```

---

### 4.4 稳定性 (Stability)

**定义**: 动作的一致性和控制能力

#### 子项定义

| 子项 | 英文 | 视觉锚点 |
|------|------|----------|
| 动作一致性 | consistency | 多次挥拍动作轨迹的相似程度 |
| 拍面控制 | racketFaceControl | 击球时拍面角度的稳定性 |
| 握拍稳定 | gripStability | 击球前后握拍手型的一致性 |

#### Band 描述

| Band | consistency | racketFaceControl | gripStability |
|------|-------------|-------------------|---------------|
| **9** | 每次挥拍几乎完全一致 | 拍面角度精确控制 | 握拍完全稳定 |
| **8** | 挥拍高度一致 | 拍面角度稳定 | 握拍稳定 |
| **7** | 挥拍基本一致，偶有变化 | 拍面基本稳定 | 握拍基本稳定 |
| **6** | 挥拍有一定一致性 | 拍面有时翻转 | 握拍偶尔变化 |
| **5** | 挥拍一致性有限 | 拍面经常翻转 | 握拍有变化 |
| **4** | 挥拍每次都不同 | 拍面不稳定 | 握拍不稳定 |
| **3** | 无一致性可言 | 拍面混乱 | 握拍每次不同 |
| **2** | 无法判断一致性 | 无法控制拍面 | 无法判断 |
| **1** | 无有效挥拍 | 无法识别 | 无法识别 |

#### 维度 Band 计算

```
稳定性 Band = round((consistency + racketFaceControl + gripStability) / 3)
```

---

## 5. 评分流程

### 5.1 评分步骤

```
步骤 1: 观看视频，识别击球动作
    → 确认视频中有可识别的网球正手挥拍动作
    → 如果无法识别 → 整体 Band = 1

步骤 2: 逐维度评分
    → 对每个维度的每个子项打分 (Band 1-9)
    → 计算每个维度的 Band（子项平均值四舍五入）
    → 识别每个维度的 Core Issue（score ≤ 4 的子项）

步骤 3: 计算整体 Band
    → 整体 Band = round(四个维度 Band 的平均值)

步骤 4: 汇总 Core Issues
    → 列出所有 Core Issues
    → 按严重程度排序（score 越低越严重）
    → 确定 improvementPriority（最需要改进的子项）
```

### 5.2 评分注意事项

1. **必须按视觉锚点评分** — 不要凭整体印象，要逐项检查
2. **分数必须有依据** — 每个分数都要有对应的 observation
3. **Core Issue 阈值为 4** — score ≤ 4 的子项才算 Core Issue
4. **维度 Band 取平均值** — 不是取最低值
5. **整体 Band 取四维度平均** — 四舍五入

---

## 6. 输出格式

### 6.1 JSON 输出结构

```json
{
  "dimensions": {
    "powerChain": {
      "band": 5,
      "subItems": {
        "upperArmDrive": { "score": 4, "observation": "肘关节与躯干距离约5cm，肘部夹紧" },
        "shoulderRotation": { "score": 6, "observation": "肩膀转动约40度" },
        "hipRotation": { "score": 5, "observation": "髋部有轻微转动" },
        "weightTransfer": { "score": 5, "observation": "重心基本不动" }
      },
      "coreIssue": "upperArmDrive"
    },
    "contactPoint": {
      "band": 4,
      "subItems": {
        "contactPosition": { "score": 3, "observation": "击球点在身侧" },
        "armExtension": { "score": 4, "observation": "肘角约110度" },
        "timing": { "score": 5, "observation": "击球时机基本合理" }
      },
      "coreIssue": "contactPosition"
    },
    "bodyCoordination": {
      "band": 6,
      "subItems": {
        "backswing": { "score": 7, "observation": "引拍完整" },
        "followThrough": { "score": 5, "observation": "随挥较短" },
        "fluidity": { "score": 6, "observation": "动作基本连贯" }
      },
      "coreIssue": null
    },
    "stability": {
      "band": 5,
      "subItems": {
        "consistency": { "score": 5, "observation": "动作有一定一致性" },
        "racketFaceControl": { "score": 4, "observation": "拍面偶尔翻转" },
        "gripStability": { "score": 6, "observation": "握拍基本稳定" }
      },
      "coreIssue": "racketFaceControl"
    }
  },
  "overallBand": 5,
  "weakestDimension": "contactPoint",
  "primaryCoreIssues": [
    { "dimension": "contactPoint", "subItem": "contactPosition", "score": 3, "description": "击球点在身侧" },
    { "dimension": "powerChain", "subItem": "upperArmDrive", "score": 4, "description": "肘部夹紧" },
    { "dimension": "stability", "subItem": "racketFaceControl", "score": 4, "description": "拍面翻转" }
  ],
  "improvementPriority": "contactPoint.contactPosition"
}
```

### 6.2 字段说明

| 字段 | 说明 |
|------|------|
| `dimensions` | 四个维度的详细评分 |
| `band` | 该维度的 Band 分数 (1-9) |
| `subItems` | 子项详细评分 |
| `score` | 子项分数 (1-9) |
| `observation` | 该分数的视觉依据 |
| `coreIssue` | 该维度的核心问题（score ≤ 4 的子项），无则为 null |
| `overallBand` | 整体 Band（四维度平均值四舍五入） |
| `weakestDimension` | 最弱的维度 |
| `primaryCoreIssues` | 所有 Core Issues 列表，按严重程度排序 |
| `improvementPriority` | 最需要改进的子项（格式: dimension.subItem） |

---

## 附录：快速参考表

### 维度 → 子项 对照表

| 维度 | 子项 (英文) | 子项 (中文) |
|------|-------------|-------------|
| powerChain | upperArmDrive | 大臂驱动 |
| powerChain | shoulderRotation | 肩膀转动 |
| powerChain | hipRotation | 髋部转动 |
| powerChain | weightTransfer | 重心转移 |
| contactPoint | contactPosition | 击球位置 |
| contactPoint | armExtension | 手臂伸展 |
| contactPoint | timing | 击球时机 |
| bodyCoordination | backswing | 引拍完整 |
| bodyCoordination | followThrough | 随挥完整 |
| bodyCoordination | fluidity | 动作流畅 |
| stability | consistency | 动作一致性 |
| stability | racketFaceControl | 拍面控制 |
| stability | gripStability | 握拍稳定 |

### Band 关键词速查

| Band | 关键词 |
|------|--------|
| 9 | 完美、职业级、精准 |
| 8 | 熟练、极少失误、充分 |
| 7 | 清晰、规范、偶有小问题 |
| 6 | 基本、有限、明显局限 |
| 5 | 不稳定、需改进、有断点 |
| 4 | 问题多、仅基础可用 |
| 3 | 严重问题、仅少量正确 |
| 2 | 几乎无法识别 |
| 1 | 无效、无法识别 |

---

**文档维护**: Yoach 产品团队
**最后更新**: 2025-12-09
