# MCQ 一致性测试 WebApp - UI 生成规范

**版本**: v1.2.0
**日期**: 2025-12-24
**目标 AI**: Gemini 3 Pro Preview
**生成目标**: 单页 WebApp (HTML + CSS + JS)
**样式风格**: iOS Human Interface Guidelines
**目标设备**: iPhone (iOS 原生尺寸适配)

---

## 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| v1.2.2 | 2025-12-24 | 新增 Boost Video Bottom Sheet (半屏弹窗+倒计时+播放控制)；补充完整数据映射总表 |
| v1.2.1 | 2025-12-24 | 新增报告等待页(PG-2.5)；重写 Mini Report 页(PG-3)：Check Tips 可折叠卡片 + Summary + Boost 推荐 |
| v1.2.0 | 2025-12-24 | 新增视频上传页、视频裁剪页(帧条组件)、AI等待页；iOS 尺寸适配 |
| v1.1.0 | 2025-12-24 | 移除代码块，改用 JSON 引用；简化测试者输入 |
| v1.0.0 | 2025-12-24 | 初始版本 |

---

## 角色设定

你是一个专业的前端工程师，擅长构建现代化的 iOS 风格 Web 应用。你需要根据以下规范，生成一个完整的、可运行的单页 WebApp。

---

## 组件层级树

```
MCQ-WebApp (iOS 适配)
├── PG-1: 测试准备页 (Prepare)
│   ├── Header: 标题区
│   ├── Card-Intro: 测试说明
│   ├── Input-Name: 名字输入框
│   └── Btn-Start: 开始按钮
├── PG-1a: 视频上传页 (Upload) [NEW]
│   ├── Header: 关闭按钮 + 步骤指示器 (1/4)
│   ├── Upload-Zone: 虚线上传区域
│   │   ├── Video-Icon: 视频占位符图标
│   │   └── Btn-Add: + 添加按钮
│   ├── Tip-Text: 提示文字
│   └── Btn-Next: 下一步按钮 (浮动, 禁用)
├── PG-1b: 视频裁剪页 (Trim) [NEW]
│   ├── Header: 关闭按钮 + 步骤指示器 (2/4)
│   ├── Video-Preview: 视频预览区
│   │   └── Btn-Refresh: 刷新/重选按钮
│   ├── Frame-Bar: 帧条组件
│   │   ├── Btn-Play: 播放按钮
│   │   ├── Thumbnails: 帧缩略图条
│   │   └── Selection-Box: 5秒选择框 (可拖动)
│   ├── Tip-Text: "Select 5 seconds to analyze"
│   └── Btn-Next: 下一步按钮 (浮动, 可用)
├── PG-1c: AI等待页 (Loading) [NEW]
│   ├── Animation: 沙漏动画/图片
│   └── Loading-Text: "Breaking down your motion..."
├── PG-2: MCQ 诊断页 (Diagnose)
│   ├── Header: 关闭按钮 + 标题 "Action Diagnosis"
│   ├── Video-User: 用户视频 (16:9, 220px)
│   ├── Video-Reference: 参考视频 (9:16, 280px)
│   │   ├── Toggle-Correct: ✓ 切换正确示范
│   │   └── Toggle-Error: ✕ 切换错误示范 (默认)
│   └── Card-Question: 问题卡片
│       ├── Question-Tag: 维度-原子标签
│       ├── Question-Text: "我有没有{description}?"
│       └── Answer-Buttons: "✓ 有" / "✕ 没有"
├── PG-2.5: 报告等待页 (Report Loading) [NEW]
│   ├── Animation: 沙漏动画
│   └── Loading-Text: "Generating your report..."
└── PG-3: Mini Report 页 (Report) [UPDATED]
    ├── Header: 标题 "Mini Report"
    ├── Video-Preview: 用户视频预览 (小尺寸)
    ├── Card-CheckTips: 检查提示 (可折叠)
    │   ├── Summary-Row: ✓ {count} / ✕ {count}
    │   └── Answer-List: 展开显示5题答案
    ├── Card-Summary: 总结洞察
    │   └── Insight-Text: summary.insight
    ├── Card-Boost: 推荐练习
    │   ├── Video-Thumbnail: 练习视频缩略图
    │   ├── Boost-Title: boost_name_cn
    │   ├── Boost-Description: description
    │   ├── Tags: difficulty + body_part
    │   └── Btn-Arrow: 展开箭头按钮 (→) [NEW]
    ├── Btn-Done: 完成按钮
    └── Sheet-BoostVideo: Boost 视频播放 Bottom Sheet [NEW]
        ├── Sheet-Header: ✕ 关闭按钮 + 标题 (boost_name_cn)
        ├── Video-Player: 全宽视频播放器
        └── Controls: 控制区
            ├── Btn-Reset: 重置按钮 (⟲)
            ├── Countdown: 倒计时显示 (00:28)
            └── Btn-Pause: 暂停/播放按钮 (⏸/▶)
```

---

## 用户-系统交互流程

```
┌─────────────────────────────────────────────────────────────────────────┐
│  用户                              系统                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [输入名字] ────────────────────► 验证非空                               │
│                                    │                                    │
│  [点击开始] ────────────────────► 进入 PG-1a                            │
│                                    │                                    │
│  ┌─────────────────────────────────┴─────────────────────────────────┐  │
│  │  PG-1a: 视频上传                                                   │  │
│  │  [选择视频文件] ──────────────► 加载视频, 启用下一步按钮             │  │
│  │  [点击下一步] ────────────────► 进入 PG-1b                          │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                    │                                    │
│  ┌─────────────────────────────────┴─────────────────────────────────┐  │
│  │  PG-1b: 视频裁剪                                                   │  │
│  │  [拖动选择框] ────────────────► 更新 trimRange (5秒)                │  │
│  │  [点击播放] ──────────────────► 预览选中片段                        │  │
│  │  [点击下一步] ────────────────► 记录 startTime, 进入 PG-1c          │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                    │                                    │
│  ┌─────────────────────────────────┴─────────────────────────────────┐  │
│  │  PG-1c: AI等待 (模拟 2-3 秒)                                        │  │
│  │  系统自动 ────────────────────► 进入 PG-2                           │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                    │                                    │
│                       ┌────────────┴────────────┐                       │
│                       │      MCQ 循环 (5次)      │                       │
│  [观看视频]           │  显示问题 + 视频          │                       │
│  [选择答案] ──────────┼─► 记录 answer             │                       │
│                       │   index < 5? ──┬── Y ────┘                       │
│                       │                N                                │
│                       └────────────────┼────────────────────────────────│
│                                        ▼                                │
│                                 记录 endTime                            │
│                                 进入 PG-2.5                             │
│                                        │                                │
│  ┌─────────────────────────────────────┴─────────────────────────────┐  │
│  │  PG-2.5: 报告等待 (模拟 2-3 秒)                                    │  │
│  │  "Generating your report..."                                      │  │
│  │  系统自动 ────────────────────► 进入 PG-3                          │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                        │                                │
│  [展开/收起 Check Tips] ────────► 显示/隐藏答案列表                      │
│  [点击 Done] ───────────────────► 清空状态, 回到 PG-1a (重新上传)        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 任务描述

构建一个 **MCQ 一致性测试 WebApp**，用于网球正手动作诊断。

**核心流程**: 测试准备 → 视频上传 → 视频裁剪(5秒) → AI分析等待 → MCQ 诊断 (5题) → Mini Report → 导出 JSON

**用户场景**:
- 用户上传自己的网球正手视频
- 选择要分析的 5 秒片段
- 回答 5 道 MCQ 诊断题目
- 导出评分结果 (JSON)

---

## 技术约束

### 必须使用
- 单个 HTML 文件 (内联 CSS + JS)
- 原生 JavaScript (ES6+)
- CSS 变量定义主题色
- Flexbox / Grid 布局
- Canvas API (用于帧缩略图提取)
- File API (用于视频文件选择)

### 禁止使用
- 任何外部框架 (React, Vue, Angular)
- 任何 UI 库 (Bootstrap, Tailwind)
- 任何外部 CDN 依赖
- localStorage (本次不需要持久化)

### iOS 样式规范
- 字体: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`
- 主色: `#007AFF` (iOS 蓝)
- 成功色: `#34C759` (iOS 绿)
- 警告色: `#FF9500` (iOS 橙)
- 危险色: `#FF3B30` (iOS 红)
- 背景色: `#F2F2F7` (iOS 浅灰)
- 卡片背景: `#FFFFFF`
- 圆角: `12px` (卡片), `8px` (按钮), `22px` (浮动按钮)
- 阴影: `0 2px 8px rgba(0,0,0,0.1)`

### iOS 尺寸适配规范 [NEW]

**参考机型**: iPhone 16 Pro

| 参数 | 值 |
|------|-----|
| 物理分辨率 | 1206 x 2622 px |
| 逻辑分辨率 | 402 x 874 pt |
| 缩放比例 | @3x |
| Safe Area Top | ~59 pt |
| Safe Area Bottom | ~34 pt |
| 屏幕比例 | 约 19.5:9 |

```css
:root {
    /* Safe Area 适配 (iPhone 16 Pro) */
    --safe-area-top: env(safe-area-inset-top, 59px);
    --safe-area-bottom: env(safe-area-inset-bottom, 34px);

    /* iPhone 16 Pro 基准尺寸 */
    --container-max-width: 402px;

    /* 视频区域尺寸 */
    --video-user-height: 220px;       /* 用户视频高度 */
    --video-reference-height: 280px;  /* 参考视频高度 */
}

/* 容器样式 */
.container {
    max-width: var(--container-max-width);
    margin: 0 auto;
    min-height: 100vh;
    min-height: 100dvh;  /* Dynamic viewport height */
    padding-top: var(--safe-area-top);
    padding-bottom: var(--safe-area-bottom);
}

/* 浮动按钮 */
.btn-floating {
    position: fixed;
    bottom: calc(20px + var(--safe-area-bottom));
    right: 20px;
    width: 56px;
    height: 56px;
    border-radius: 28px;
}

/* Viewport Meta */
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, viewport-fit=cover">
```

---

## 页面规范

### Page 1: 测试准备页 (PG-1)

**功能**: 输入测试者名字，准备开始测试

**布局**:
```
┌─────────────────────────────────────────┐
│  Header                                 │
│  ┌───────────────────────────────────┐  │
│  │  🎾 MCQ 一致性测试                 │  │
│  │  网球正手动作诊断系统               │  │
│  └───────────────────────────────────┘  │
├─────────────────────────────────────────┤
│  Card-Intro                             │
│  ┌───────────────────────────────────┐  │
│  │  📋 测试说明                       │  │
│  │  1. 上传你的正手击球视频            │  │
│  │  2. 选择 5 秒片段进行分析           │  │
│  │  3. 回答 5 道诊断问题               │  │
│  │  4. 完成后导出你的评分结果          │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Input-Name                             │
│  ┌───────────────────────────────────┐  │
│  │  👤 请输入你的名字                  │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │ [请输入名字...]               │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Btn-Start                              │
│  ┌───────────────────────────────────┐  │
│  │       [ ▶️ 开始测试 ]              │  │
│  │       (禁用状态，直到输入名字)      │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

**交互行为**:
1. 输入名字 → 实时验证非空
2. 名字非空后 → "开始测试" 按钮变为可用 (从灰色变蓝色)
3. 点击"开始测试" → 跳转到 PG-1a (视频上传页)

---

### Page 1a: 视频上传页 (PG-1a) [NEW]

**功能**: 上传用户的网球正手视频

**布局**:
```
┌─────────────────────────────────────────┐
│  Header                                 │
│  ┌───────────────────────────────────┐  │
│  │  ✕                    [🎥]• • •   │  │
│  │  (关闭按钮)           (步骤1/4)    │  │
│  └───────────────────────────────────┘  │
├─────────────────────────────────────────┤
│                                         │
│  Title                                  │
│  ┌───────────────────────────────────┐  │
│  │  Upload your video                 │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Upload-Zone (虚线边框)                  │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│  │                                   │  │
│  │      ┌─────────────────┐          │  │
│  │      │   [🎬 视频图标]  │          │  │
│  │      │    ▶ 播放符号    │          │  │
│  │      └─────────────────┘          │  │
│  │              [+]                  │  │
│  │         (绿色添加按钮)             │  │
│  │                                   │  │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                         │
│  Tip-Card                               │
│  ┌───────────────────────────────────┐  │
│  │  💡 Upload the technique clip     │  │
│  │     you want to troubleshoot      │  │
│  │     (about 5 seconds)             │  │
│  └───────────────────────────────────┘  │
│                                         │
│                              [→]        │
│                         (浮动按钮,灰色)  │
└─────────────────────────────────────────┘
```

**交互行为**:
1. 点击上传区域或 "+" 按钮 → 打开文件选择器 (accept="video/*")
2. 选择视频后 → 验证视频时长 >= 5 秒
3. 视频有效 → 下一步按钮变为绿色可用
4. 点击 "✕" → 返回 PG-1
5. 点击下一步 → 进入 PG-1b

**技术实现**:
```javascript
// 文件选择
<input type="file" accept="video/*" id="video-input" hidden>

// 视频时长验证
video.onloadedmetadata = () => {
    if (video.duration >= 5) {
        enableNextButton();
    }
};
```

---

### Page 1b: 视频裁剪页 (PG-1b) [NEW]

**功能**: 选择视频中的 5 秒片段进行分析

**布局**:
```
┌─────────────────────────────────────────┐
│  Header                                 │
│  ┌───────────────────────────────────┐  │
│  │  ✕                    [🎥]•[•]• • │  │
│  │  (关闭按钮)           (步骤2/4)    │  │
│  └───────────────────────────────────┘  │
├─────────────────────────────────────────┤
│                                         │
│  Title                                  │
│  ┌───────────────────────────────────┐  │
│  │  Upload your video                 │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Video-Preview                          │
│  ┌───────────────────────────────────┐  │
│  │                           [🔄]    │  │
│  │                      (刷新按钮)    │  │
│  │                                   │  │
│  │      [视频预览画面]                │  │
│  │      (显示当前选中帧)              │  │
│  │                                   │  │
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Frame-Bar (帧条组件)                    │
│  ┌───────────────────────────────────┐  │
│  │ [▶] │ [帧1][帧2][帧3][帧4][帧5]   │  │
│  │     │ ┌────────────────┐          │  │
│  │     │ │  [黄色选择框]   │          │  │
│  │     │ │   (5秒范围)     │          │  │
│  │     │ └────────────────┘          │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Tip-Text                               │
│  ┌───────────────────────────────────┐  │
│  │  Select 5 seconds to analyze      │  │
│  └───────────────────────────────────┘  │
│                                         │
│                              [→]        │
│                         (浮动按钮,绿色)  │
└─────────────────────────────────────────┘
```

**交互行为**:
1. 加载视频后 → 自动提取 5 个帧缩略图显示在帧条中
2. 黄色选择框默认选中前 5 秒
3. 左右拖动选择框 → 更新选中范围
4. 点击播放按钮 → 播放选中的 5 秒片段
5. 点击刷新按钮 → 返回 PG-1a 重新选择视频
6. 点击 "✕" → 返回 PG-1
7. 点击下一步 → 记录 startTime，进入 PG-1c

**帧条组件技术实现**:
```javascript
class FrameBar {
    constructor(video, container) {
        this.video = video;
        this.container = container;
        this.frameCount = 5;
        this.selectionStart = 0;
        this.selectionDuration = 5; // 秒
    }

    // 提取帧缩略图
    async extractFrames() {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        const frames = [];
        const interval = this.video.duration / this.frameCount;

        for (let i = 0; i < this.frameCount; i++) {
            this.video.currentTime = i * interval;
            await new Promise(resolve => {
                this.video.onseeked = () => {
                    ctx.drawImage(this.video, 0, 0, canvas.width, canvas.height);
                    frames.push(canvas.toDataURL('image/jpeg', 0.5));
                    resolve();
                };
            });
        }
        return frames;
    }

    // 初始化拖动
    initDragSelection() {
        // 触摸/鼠标拖动事件处理
        // 限制选择框在有效范围内
        // 更新 selectionStart
    }

    // 获取选择范围
    getSelectedRange() {
        return {
            start: this.selectionStart,
            end: this.selectionStart + this.selectionDuration
        };
    }
}
```

**选择框样式**:
```css
.selection-box {
    position: absolute;
    height: 100%;
    background: rgba(255, 200, 0, 0.3);
    border: 3px solid #FFC800;
    border-radius: 8px;
    cursor: grab;
}

.selection-box:active {
    cursor: grabbing;
}
```

---

### Page 1c: AI等待页 (PG-1c) [NEW]

**功能**: 显示 AI 分析等待动画

**布局**:
```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│                                         │
│                                         │
│           ┌─────────────┐               │
│           │             │               │
│           │  [沙漏动画]  │               │
│           │             │               │
│           └─────────────┘               │
│                                         │
│      Breaking down your motion...       │
│                                         │
│                                         │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

**交互行为**:
1. 进入页面 → 显示加载动画
2. 模拟等待 2-3 秒 → 自动跳转到 PG-2

**动画实现**:
```css
/* 简单的沙漏动画 (使用 CSS 动画) */
.hourglass {
    width: 120px;
    height: 120px;
    animation: rotate 2s ease-in-out infinite;
}

@keyframes rotate {
    0%, 100% { transform: rotate(0deg); }
    50% { transform: rotate(180deg); }
}

/* 或使用 SVG/图片 */
.loading-image {
    width: 150px;
    height: 150px;
    /* 使用内联 SVG 或 base64 图片 */
}
```

**技术实现**:
```javascript
// 进入等待页
function showLoadingPage() {
    showPage('loading');

    // 模拟 AI 分析时间
    setTimeout(() => {
        showPage('mcq');
        renderQuestion();
    }, 2500); // 2.5 秒
}
```

---

### Page 2: MCQ 诊断页 (PG-2) [UPDATED]

**功能**: 逐题回答 5 道 MCQ 诊断题

**布局** (垂直单列，iOS 移动端风格):

```
┌─────────────────────────────────────────┐
│  Header                                 │
│  ┌───────────────────────────────────┐  │
│  │  ✕           Action Diagnosis     │  │
│  │ (关闭)            (标题)           │  │
│  └───────────────────────────────────┘  │
├─────────────────────────────────────────┤
│                                         │
│  Video-User (用户上传的视频)             │
│  ┌───────────────────────────────────┐  │
│  │                                   │  │
│  │      [用户正手视频 - 宽屏16:9]     │  │
│  │      (选中的5秒片段循环播放)        │  │
│  │                                   │  │
│  └───────────────────────────────────┘  │
│  height: 220px, border-radius: 12px     │
│                                         │
│  Video-Reference (参考视频)              │
│  ┌───────────────────────────────────┐  │
│  │                       [✓]  [✕]    │  │
│  │                     (切换按钮)     │  │
│  │                                   │  │
│  │   [正确示范 / 错误示范视频]        │  │
│  │   (默认显示错误示范)               │  │
│  │                                   │  │
│  │  ▬▬▬▬▬●▬▬▬▬▬▬▬▬  00:02 / 00:20   │  │
│  │      (进度条)        (时间)        │  │
│  └───────────────────────────────────┘  │
│  height: 280px, border-radius: 12px     │
│                                         │
│  Card-Question (问题卡片)                │
│  ┌───────────────────────────────────┐  │
│  │ ┌─────────────────────────┐       │  │
│  │ │ {dimension_cn}-{atom_cn}│       │  │
│  │ └─────────────────────────┘       │  │
│  │  (绿色标签, 如 "发力本能-靠手腕翻")  │  │
│  │                                   │  │
│  │  我有没有{description}?            │  │
│  │  (如 "我有没有击球时用手腕翻拍面?") │  │
│  │                                   │  │
│  │  ┌─────────────┐ ┌─────────────┐  │  │
│  │  │   ✓  有     │ │   ✕  没有   │  │  │
│  │  │  (绿边框)   │ │  (红边框)   │  │  │
│  │  └─────────────┘ └─────────────┘  │  │
│  └───────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

**组件详细规范**:

#### Header
- 左侧: 关闭按钮 (✕)，点击返回上一页或关闭诊断
- 中间: 标题 "Action Diagnosis"
- 无进度条（简洁设计）

#### Video-User (用户视频)
- 高度: 220px
- 比例: 16:9 宽屏
- 圆角: 12px
- 循环播放选中的 5 秒片段

#### Video-Reference (参考视频)
- 高度: 280px
- 比例: 竖屏（约 9:16）
- 圆角: 12px
- 右上角切换按钮:
  - ✓ 按钮: 显示正确示范 (白色背景, 灰色边框)
  - ✕ 按钮: 显示错误示范 (红色背景, 红色✕)
  - **默认选中**: ✕ 错误示范
- 底部播放控制:
  - 进度条 (白色轨道，灰色进度)
  - 时间显示 (00:00 / 00:00)

#### Card-Question (问题卡片)
- 背景: 白色
- 圆角: 12px
- 阴影: 0 2px 8px rgba(0,0,0,0.1)
- 内边距: 16px

**问题标签样式**:
```css
.question-tag {
    display: inline-block;
    background: #1B5E20;  /* 深绿色 */
    color: white;
    padding: 6px 12px;
    border-radius: 16px;
    font-size: 14px;
    font-weight: 500;
}
```

**问题文字样式**:
```css
.question-text {
    font-size: 17px;
    font-weight: 400;
    color: #000;
    margin: 16px 0;
}
```

**答案按钮样式**:
```css
.answer-btn {
    flex: 1;
    padding: 12px 24px;
    border-radius: 20px;
    font-size: 16px;
    font-weight: 500;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.answer-btn-yes {
    background: transparent;
    border: 2px solid #34C759;  /* iOS 绿 */
    color: #34C759;
}

.answer-btn-no {
    background: transparent;
    border: 2px solid #FF3B30;  /* iOS 红 */
    color: #FF3B30;
}
```

**交互行为**:
1. 点击 ✓ 按钮 → 切换显示正确示范视频
2. 点击 ✕ 按钮 → 切换显示错误示范视频 (默认)
3. 点击 "✓ 有" → 记录 `has_error: true`，0.5秒后自动跳转下一题
4. 点击 "✕ 没有" → 记录 `has_error: false`，0.5秒后自动跳转下一题
5. 点击 Header ✕ → 返回上一页或退出诊断
6. 完成第 5 题后 → 自动跳转到 PG-2.5 (报告等待页)

**数据映射**:

| 字段 | 来源 | 示例 |
|------|------|------|
| 问题标签 | `{dimension_cn}-{atom_name_cn}` | 发力本能-靠手腕翻 |
| 问题文字 | `我有没有{description}?` | 我有没有击球时用手腕翻拍面? |
| 正确视频 | `correct_videos[0]` | 德约科维奇正手网球_correct.mp4 |
| 错误视频 | `error_videos[0]` | 翻腕_翻拍面_error.mp4 |

---

### Page 2.5: 报告等待页 (PG-2.5) [NEW]

**功能**: 显示报告生成等待动画

**布局**:
```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│                                         │
│                                         │
│           ┌─────────────┐               │
│           │             │               │
│           │  [沙漏动画]  │               │
│           │             │               │
│           └─────────────┘               │
│                                         │
│      Generating your report...          │
│                                         │
│                                         │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

**交互行为**:
1. 进入页面 → 显示加载动画
2. 模拟等待 2-3 秒 → 自动跳转到 PG-3

**技术实现**:
```javascript
// 进入报告等待页
function showReportLoadingPage() {
    showPage('report-loading');

    // 模拟报告生成时间
    setTimeout(() => {
        showPage('report');
        renderMiniReport();
    }, 2500); // 2.5 秒
}
```

**样式规范**:
```css
.report-loading-container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background: #F2F2F7;
}

.loading-text {
    font-size: 18px;
    color: #666;
    margin-top: 24px;
}
```

---

### Page 3: Mini Report 页 (PG-3) [UPDATED]

**功能**: 显示诊断结果，包含 Check Tips、Summary 洞察、推荐 Boost 练习

**布局**:
```
┌─────────────────────────────────────────┐
│  Header                                 │
│  ┌───────────────────────────────────┐  │
│  │         Mini Report               │  │
│  │          (居中标题)               │  │
│  └───────────────────────────────────┘  │
├─────────────────────────────────────────┤
│                                         │
│  Video-Preview (用户视频预览)            │
│  ┌───────────────────────────────────┐  │
│  │                                   │  │
│  │      [用户正手视频 - 小尺寸]       │  │
│  │      (选中的5秒片段静态预览)       │  │
│  │                                   │  │
│  └───────────────────────────────────┘  │
│  height: 160px, border-radius: 12px     │
│                                         │
│  Card-CheckTips (可折叠卡片)             │
│  ┌───────────────────────────────────┐  │
│  │  Check tips                  [v]  │  │
│  │  (标题)               (展开箭头)   │  │
│  │                                   │  │
│  │  ✓ {correct_count}  ✕ {error_count}│ │
│  │  (绿色图标+数字)   (红色图标+数字) │  │
│  │                                   │  │
│  │  [展开后显示5题答案列表]           │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │ ✓ 被挤着打                  │  │  │
│  │  │ ✓ 靠手腕翻                  │  │  │
│  │  │ ✓ 重心不往前                │  │  │
│  │  │ ✓ 左手先收                  │  │  │
│  │  │ ✕ 只拉手引拍                │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Card-Summary (总结卡片)                 │
│  ┌───────────────────────────────────┐  │
│  │  Summary                          │  │
│  │  (标题)                           │  │
│  │                                   │  │
│  │  {summary.insight}                │  │
│  │  (洞察文字, 多行显示)              │  │
│  │                                   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Card-Boost (推荐练习卡片)               │
│  ┌───────────────────────────────────┐  │
│  │  ┌───────────┐                    │  │
│  │  │           │  {boost_name_cn}   │  │
│  │  │  [视频    │  (练习名称, 粗体)   │  │
│  │  │  缩略图]  │                    │  │
│  │  │           │  {description}     │  │
│  │  │   ▶       │  (练习描述)         │  │
│  │  └───────────┘                    │  │
│  │                                   │  │
│  │  ┌─────────┐  ┌─────────────┐    │  │
│  │  │ {难度}   │  │ {body_part} │    │  │
│  │  │(灰背景) │  │  (灰背景)    │    │  │
│  │  └─────────┘  └─────────────┘    │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Btn-Done (完成按钮)                     │
│  ┌───────────────────────────────────┐  │
│  │           [ Done ]                │  │
│  │       (绿色圆角按钮, 全宽)         │  │
│  └───────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

**组件详细规范**:

#### Header
- 居中标题: "Mini Report"
- 无关闭按钮 (用户必须点击 Done 完成)

#### Video-Preview (用户视频预览)
- 高度: 160px
- 比例: 16:9
- 圆角: 12px
- 显示选中的5秒片段第一帧 (静态图片)

#### Card-CheckTips (检查提示卡片)
- 白色背景，圆角 12px，阴影
- 默认**收起状态**，只显示标题行和统计数字
- 点击展开/收起答案列表

**收起状态布局**:
```
┌─────────────────────────────────────┐
│  Check tips                    [v]  │
│  ✓ 4        ✕ 1                     │
└─────────────────────────────────────┘
```

**展开状态布局**:
```
┌─────────────────────────────────────┐
│  Check tips                    [^]  │
│  ✓ 4        ✕ 1                     │
│  ─────────────────────────────────  │
│  ✓ 被挤着打                         │
│  ✓ 靠手腕翻                         │
│  ✓ 重心不往前                       │
│  ✓ 左手先收                         │
│  ✕ 只拉手引拍                       │
└─────────────────────────────────────┘
```

**答案列表项样式**:
- ✓ (绿色 #34C759) + atom_name_cn → has_error: true (有这个问题)
- ✕ (红色 #FF3B30) + atom_name_cn → has_error: false (没有这个问题)

#### Card-Summary (总结卡片)
- 白色背景，圆角 12px，阴影
- 标题: "Summary"
- 内容: 从 `summary.insight` 读取
- 字体大小: 15px，行高 1.6

#### Card-Boost (推荐练习卡片)
- 白色背景，圆角 12px，阴影
- 左侧: 视频缩略图 (80x100px)，带播放按钮图标
- 右侧上方: `boost_name_cn` (粗体)
- 右侧下方: `description` (灰色小字)
- 底部: 两个标签
  - `difficulty` 标签 (灰色背景)
  - `body_part` 标签 (灰色背景)

**标签样式**:
```css
.boost-tag {
    display: inline-block;
    background: #E5E5EA;
    color: #666;
    padding: 4px 12px;
    border-radius: 12px;
    font-size: 12px;
    margin-right: 8px;
}
```

#### Btn-Done (完成按钮)
- 全宽按钮
- 背景色: #34C759 (iOS 绿)
- 文字: "Done" (白色)
- 圆角: 22px
- 高度: 50px

**交互行为**:
1. 点击 Check Tips 卡片 → 展开/收起答案列表
2. 点击 Boost 卡片的箭头按钮 (→) → 打开 Boost Video Bottom Sheet [UPDATED]
3. 点击 "Done" → 清空状态，回到 PG-1a (重新上传新视频)

---

### Sheet: Boost Video 播放弹窗 (Sheet-BoostVideo) [NEW]

**功能**: 半屏弹窗显示 Boost 练习视频，带倒计时和播放控制

**触发方式**: 点击 Card-Boost 卡片的箭头按钮 (→)

**布局** (Bottom Sheet 样式):

```
┌─────────────────────────────────────────┐
│                                         │
│        [页面背景变暗 50%]                │
│                                         │
├─────────────────────────────────────────┤
│  ╭─────────────────────────────────────╮│
│  │  Sheet-Header                       ││
│  │  ┌───────────────────────────────┐  ││
│  │  │  ✕           球起架拍          │  ││
│  │  │ (关闭)    (boost_name_cn)     │  ││
│  │  └───────────────────────────────┘  ││
│  ├─────────────────────────────────────┤│
│  │                                     ││
│  │  Video-Player (全宽视频播放器)       ││
│  │  ┌───────────────────────────────┐  ││
│  │  │                               │  ││
│  │  │                               │  ││
│  │  │      [Boost 练习视频]          │  ││
│  │  │      (自动播放)                │  ││
│  │  │                               │  ││
│  │  │                               │  ││
│  │  └───────────────────────────────┘  ││
│  │                                     ││
│  │  Controls (控制区)                   ││
│  │  ┌───────────────────────────────┐  ││
│  │  │                               │  ││
│  │  │   [⟲]      00:28      [⏸]    │  ││
│  │  │  (重置)   (倒计时)   (暂停)   │  ││
│  │  │                               │  ││
│  │  └───────────────────────────────┘  ││
│  ╰─────────────────────────────────────╯│
└─────────────────────────────────────────┘
```

**组件详细规范**:

#### Sheet 容器
- 高度: 约 50% 屏幕高度 (半屏)
- 背景: 白色
- 圆角: 顶部 16px (iOS Bottom Sheet 风格)
- 阴影: 0 -4px 16px rgba(0,0,0,0.15)
- 动画: 从底部滑入 (0.3s ease-out)

#### Sheet-Header
- 高度: 56px
- 左侧: 关闭按钮 (✕)，24x24px
- 中间: 标题 (boost_name_cn)，如 "球起架拍"
- 底部: 1px 分隔线 (#E5E5EA)

#### Video-Player
- 宽度: 100%
- 高度: 自适应 (保持视频比例)
- 圆角: 0 (方形边缘)
- 背景: #000 (黑色)
- 自动播放: 是

#### Controls (控制区)
- 高度: 80px
- 背景: #F2F2F7 (iOS 浅灰)
- 布局: 三个元素水平居中分布

**控制按钮样式**:
```css
/* 重置按钮 */
.btn-reset {
    width: 44px;
    height: 44px;
    border-radius: 22px;
    background: #E5E5EA;
    border: none;
    font-size: 20px;
    color: #666;
}

/* 倒计时显示 */
.countdown {
    font-size: 32px;
    font-weight: 600;
    font-family: -apple-system, monospace;
    color: #000;
}

/* 暂停/播放按钮 */
.btn-pause {
    width: 56px;
    height: 56px;
    border-radius: 28px;
    background: #34C759;  /* iOS 绿 */
    border: none;
    font-size: 24px;
    color: white;
}
```

**交互行为**:
1. 点击箭头按钮 → 打开 Bottom Sheet，开始播放视频
2. 视频开始 → 倒计时从视频总时长开始倒数 (如 00:28)
3. 点击暂停按钮 (⏸) → 暂停视频和倒计时，按钮变为播放 (▶)
4. 点击播放按钮 (▶) → 继续播放，按钮变回暂停 (⏸)
5. 点击重置按钮 (⟲) → 视频跳回开头，倒计时重置
6. 倒计时归零 → 视频播放完毕，可重新播放
7. 点击关闭按钮 (✕) → 关闭 Bottom Sheet，停止播放
8. 点击背景遮罩 → 关闭 Bottom Sheet

**数据映射**:

| UI 元素 | 数据来源 | 字段路径 |
|---------|----------|----------|
| 标题 | recommended_boost.boost_name_cn | `usr001_mini_report.json` |
| 视频 | recommended_boost.video | `usr001_mini_report.json` |
| 倒计时初始值 | 视频时长 (video.duration) | 运行时获取 |

**技术实现**:
```javascript
// Bottom Sheet 状态
let boostVideoSheetOpen = false;

// 打开 Bottom Sheet
function openBoostVideoSheet() {
    boostVideoSheetOpen = true;
    const sheet = document.getElementById('boost-video-sheet');
    const overlay = document.getElementById('sheet-overlay');

    overlay.style.display = 'block';
    sheet.classList.add('open');

    // 开始播放视频
    const video = sheet.querySelector('video');
    video.currentTime = 0;
    video.play();
    startCountdown(video.duration);
}

// 关闭 Bottom Sheet
function closeBoostVideoSheet() {
    boostVideoSheetOpen = false;
    const sheet = document.getElementById('boost-video-sheet');
    const overlay = document.getElementById('sheet-overlay');

    sheet.classList.remove('open');
    overlay.style.display = 'none';

    // 停止播放
    const video = sheet.querySelector('video');
    video.pause();
}

// 倒计时
let countdownInterval;
function startCountdown(totalSeconds) {
    let remaining = Math.ceil(totalSeconds);
    updateCountdownDisplay(remaining);

    countdownInterval = setInterval(() => {
        remaining--;
        updateCountdownDisplay(remaining);
        if (remaining <= 0) {
            clearInterval(countdownInterval);
        }
    }, 1000);
}

function updateCountdownDisplay(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    document.getElementById('countdown').textContent =
        `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}
```

**CSS 动画**:
```css
/* 背景遮罩 */
.sheet-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 100;
    display: none;
}

/* Bottom Sheet 容器 */
.bottom-sheet {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    background: white;
    border-radius: 16px 16px 0 0;
    z-index: 101;
    transform: translateY(100%);
    transition: transform 0.3s ease-out;
}

.bottom-sheet.open {
    transform: translateY(0);
}
```

---

## 数据结构

### 数据文件引用

| 文件 | 用途 | 说明 |
|------|------|------|
| `usr001_mcq_questions.json` | 测试题目 | 5 道固定题目，含 atom_id、维度、视频路径 |
| `usr001_mcq_response.json` | 响应格式 | 用户回答结构 (question_id, atom_id, has_error) |
| `usr001_mini_report.json` | 报告示例 | 完整报告结构参考 |

### 题目数据字段说明

从 `usr001_mcq_questions.json` 读取，每题包含:
- `question_id`: 题目编号 (Q1-Q5)
- `atom_id`: 错误原子 ID (如 DM3-IS08-AT45)
- `atom_name_cn`: 中文名称 (如 "被挤着打")
- `dimension_cn`: 所属维度 (如 "击球空间")
- `description`: 错误描述
- `error_videos`: 错误示范视频路径
- `correct_videos`: 正确示范视频路径

**UI 显示映射** [UPDATED]:

| UI 元素 | 数据来源 | 格式 |
|---------|----------|------|
| 问题标签 | `dimension_cn` + `atom_name_cn` | `{dimension_cn}-{atom_name_cn}` |
| 问题文字 | `description` | `我有没有{description}?` |

**5道题目示例**:

| Q | 标签 | 问题 |
|---|------|------|
| Q1 | 击球空间-被挤着打 | 我有没有击球被挤住? |
| Q2 | 发力本能-靠手腕翻 | 我有没有击球时用手腕翻拍面? |
| Q3 | 重心平衡-重心不往前 | 我有没有击球后重心不往前? |
| Q4 | 转体控制-左手先收 | 我有没有挥拍前左手先收回? |
| Q5 | 动力源头-只拉手引拍 | 我有没有引拍只用手往后拉拍? |

### Mini Report 数据字段说明 [NEW]

从 `usr001_mini_report.json` 读取，结构如下：

```json
{
  "atoms": [
    {
      "atom_id": "DM3-IS08-AT45",
      "atom_name_cn": "被挤着打",
      "has_error": true
    }
    // ... 共 5 项
  ],
  "summary": {
    "insight": "Kim展现了优异的协调性..."
  },
  "recommended_boost": {
    "boost_id": "BOOST-23",
    "boost_name_cn": "肘肋空间感训练",
    "description": "通过在腋下创造虚拟空间...",
    "difficulty": "入门",
    "body_part": "手臂与躯干",
    "video": "BO_6102_30-01_09_被挤到解决办法...mp4"
  }
}
```

**PG-3 数据映射**:

| UI 组件 | 数据来源 | 说明 |
|---------|----------|------|
| Check Tips 统计 | `atoms[].has_error` | 统计 ✓ 和 ✕ 的数量 |
| Check Tips 列表 | `atoms[].atom_name_cn` + `has_error` | 5 项答案列表 |
| Summary 文字 | `summary.insight` | 洞察总结 |
| Boost 标题 | `recommended_boost.boost_name_cn` | 练习名称 |
| Boost 描述 | `recommended_boost.description` | 练习描述 |
| Boost 标签 | `difficulty` + `body_part` | 两个灰色标签 |
| Boost 视频 | `recommended_boost.video` | 视频占位符 |

**统计计算**:
```javascript
// 计算 ✓ 和 ✕ 数量
const errorCount = atoms.filter(a => a.has_error).length;   // ✓ 有问题
const correctCount = atoms.filter(a => !a.has_error).length; // ✕ 没问题
```

---

### 完整数据映射总表 [NEW]

以下表格汇总了所有页面组件的数据来源和字段映射：

#### 数据文件总览

| 文件 | 路径 | 用途 |
|------|------|------|
| MCQ 题目数据 | `_spec/_kim_usr001/usr001_mcq_questions.json` | 5 道 MCQ 题目、视频路径 |
| Mini Report 数据 | `_spec/_kim_usr001/usr001_mini_report.json` | 诊断结果、洞察、推荐练习 |
| 用户视频 | 运行时上传 | 用户正手视频文件 |

#### PG-1 测试准备页 - 数据映射

| UI 组件 | 数据来源 | 字段/说明 |
|---------|----------|----------|
| 测试者名字 | 用户输入 | 保存到 `state.raterName` |

#### PG-1a/1b 视频上传/裁剪页 - 数据映射

| UI 组件 | 数据来源 | 字段/说明 |
|---------|----------|----------|
| 用户视频 | File API | 保存到 `state.videoFile`, `state.videoUrl` |
| 帧缩略图 | Canvas API | 从视频提取，保存到 `state.frameThumbnails` |
| 选中范围 | 用户拖动 | 保存到 `state.trimRange` {start, end} |

#### PG-2 MCQ 诊断页 - 数据映射

| UI 组件 | 数据来源 | 字段路径 | 示例值 |
|---------|----------|----------|--------|
| Header 标题 | 硬编码 | - | "Action Diagnosis" |
| 用户视频 | 运行时 | `state.videoUrl` | blob:xxx |
| 参考视频-正确 | JSON | `questions[i].correct_videos[0]` | "德约科维奇正手_correct.mp4" |
| 参考视频-错误 | JSON | `questions[i].error_videos[0]` | "翻腕_翻拍面_error.mp4" |
| 问题标签 | JSON | `questions[i].dimension_cn` + `questions[i].atom_name_cn` | "发力本能-靠手腕翻" |
| 问题文字 | JSON | `questions[i].description` | "我有没有击球时用手腕翻拍面?" |
| 当前问题索引 | 运行时 | `state.currentQuestionIndex` | 0-4 |

**PG-2 题目数据来源**: `usr001_mcq_questions.json`

```json
{
  "questions": [
    {
      "question_id": "Q1",
      "atom_id": "DM3-IS08-AT45",
      "atom_name_cn": "被挤着打",
      "dimension_cn": "击球空间",
      "description": "击球被挤住",
      "error_videos": ["被挤到_球太靠近身体_error.mp4"],
      "correct_videos": ["德约科维奇正手网球_correct.mp4"]
    }
    // ... Q2-Q5
  ]
}
```

#### PG-3 Mini Report 页 - 数据映射

| UI 组件 | 数据来源 | 字段路径 | 示例值 |
|---------|----------|----------|--------|
| Header 标题 | 硬编码 | - | "Mini Report" |
| 用户视频预览 | 运行时 | `state.videoUrl` | blob:xxx |
| Check Tips ✓数量 | 运行时计算 | `atoms.filter(a => a.has_error).length` | 4 |
| Check Tips ✕数量 | 运行时计算 | `atoms.filter(a => !a.has_error).length` | 1 |
| Check Tips 列表 | JSON + 运行时 | `atoms[].atom_name_cn` + `atoms[].has_error` | "✓ 被挤着打" |
| Summary 文字 | JSON | `summary.insight` | "Kim展现了优异的协调性..." |
| Boost 标题 | JSON | `recommended_boost.boost_name_cn` | "肘肋空间感训练" |
| Boost 描述 | JSON | `recommended_boost.description` | "通过在腋下创造虚拟空间..." |
| Boost 难度标签 | JSON | `recommended_boost.difficulty` | "入门" |
| Boost 部位标签 | JSON | `recommended_boost.body_part` | "手臂与躯干" |
| Boost 视频路径 | JSON | `recommended_boost.video` | "BO_6102_30-01_09_...mp4" |

**PG-3 报告数据来源**: `usr001_mini_report.json`

```json
{
  "atoms": [
    {"atom_id": "DM3-IS08-AT45", "atom_name_cn": "被挤着打", "has_error": true},
    {"atom_id": "DM4-IS10-AT46", "atom_name_cn": "靠手腕翻", "has_error": true},
    {"atom_id": "DM2-IS05-AT21", "atom_name_cn": "重心不往前", "has_error": true},
    {"atom_id": "DM2-IS07-AT29", "atom_name_cn": "左手先收", "has_error": true},
    {"atom_id": "DM2-IS06-AT23", "atom_name_cn": "只拉手引拍", "has_error": true}
  ],
  "summary": {
    "insight": "Kim展现了优异的协调性，但目前正处于'羽球思维'误区..."
  },
  "recommended_boost": {
    "boost_id": "BOOST-23",
    "boost_name_cn": "肘肋空间感训练",
    "description": "通过在腋下创造虚拟空间，改掉"霸王龙手臂"，释放挥拍半径。",
    "instruction": "1. 腋下夹个大西瓜，挥拍千万别挤它...",
    "goal": "建立健康的击球空间，告别动作蜷缩。",
    "body_part": "手臂与躯干",
    "difficulty": "入门",
    "target_atom": "DM3-IS08-AT45",
    "video": "BO_6102_30-01_09_被挤到解决办法_球起架拍球落找球_boost.mp4"
  }
}
```

#### Sheet-BoostVideo - 数据映射

| UI 组件 | 数据来源 | 字段路径 | 示例值 |
|---------|----------|----------|--------|
| Sheet 标题 | JSON | `recommended_boost.boost_name_cn` | "球起架拍" |
| 视频文件 | JSON | `recommended_boost.video` | "BO_6102_...mp4" |
| 倒计时初始值 | 运行时 | `video.duration` | 28 (秒) |

---

### 导出 JSON 格式说明

导出文件应包含:
- `rater.name`: 测试者名字
- `rater.timestamp`: 完成时间 (ISO 格式)
- `meta.duration_sec`: 用时 (秒)
- `meta.video_trim`: 选中的视频范围 `{start, end}`
- `summary.findings_count`: 发现问题数
- `responses[]`: 回答数组，每项含 question_id, atom_id, has_error

---

## 状态管理

应用需要维护以下状态:

| 状态 | 类型 | 说明 |
|------|------|------|
| currentPage | string | 当前页面: 'prepare' / 'upload' / 'trim' / 'loading' / 'mcq' / 'report-loading' / 'report' |
| raterName | string | 测试者名字 |
| videoFile | File | 用户上传的视频文件 [NEW] |
| videoUrl | string | 视频 ObjectURL [NEW] |
| trimRange | object | 选中范围 {start, end} [NEW] |
| frameThumbnails | array | 帧缩略图 base64 数组 [NEW] |
| currentQuestionIndex | number | 当前问题索引 (0-4) |
| answers | array | 回答数组 [{question_id, atom_id, has_error}] |
| startTime | timestamp | 开始时间 (MCQ 开始时记录) |
| endTime | timestamp | 结束时间 |
| checkTipsExpanded | boolean | Check Tips 卡片展开状态 (默认 false) [NEW] |
| miniReport | object | Mini Report 数据 {atoms, summary, recommended_boost} [NEW] |
| boostVideoSheetOpen | boolean | Boost Video Bottom Sheet 展开状态 (默认 false) [NEW] |
| boostVideoPlaying | boolean | Boost 视频播放状态 [NEW] |
| boostCountdown | number | Boost 视频倒计时剩余秒数 [NEW] |

---

## 验收标准

### 功能验收
- [ ] PG-1: 可以输入测试者名字
- [ ] PG-1: 输入名字后"开始测试"按钮变为可用
- [ ] PG-1a: 可以上传视频文件 [NEW]
- [ ] PG-1a: 视频时长验证 (>= 5秒) [NEW]
- [ ] PG-1a: 上传后下一步按钮变为可用 [NEW]
- [ ] PG-1b: 显示视频预览 [NEW]
- [ ] PG-1b: 显示帧缩略图条 [NEW]
- [ ] PG-1b: 可以拖动选择 5 秒范围 [NEW]
- [ ] PG-1b: 可以播放预览选中片段 [NEW]
- [ ] PG-1c: 显示加载动画 [NEW]
- [ ] PG-1c: 自动跳转到 MCQ 页 [NEW]
- [ ] PG-2: 显示用户视频 (16:9, 220px) [UPDATED]
- [ ] PG-2: 显示参考视频 (9:16, 280px) 带 ✓/✕ 切换按钮 [UPDATED]
- [ ] PG-2: 默认显示错误示范视频 [UPDATED]
- [ ] PG-2: 显示问题标签 ({dimension_cn}-{atom_name_cn}) [UPDATED]
- [ ] PG-2: 显示问题文字 (我有没有{description}?) [UPDATED]
- [ ] PG-2: 点击"✓ 有"或"✕ 没有"后自动跳转下一题
- [ ] PG-2.5: 显示 "Generating your report..." 等待页 [NEW]
- [ ] PG-2.5: 自动跳转到 Mini Report 页 [NEW]
- [ ] PG-3: 显示用户视频预览 (小尺寸) [UPDATED]
- [ ] PG-3: 显示 Check Tips 卡片 (✓ count / ✕ count) [UPDATED]
- [ ] PG-3: Check Tips 可展开/收起显示5题答案 [UPDATED]
- [ ] PG-3: 显示 Summary 洞察文字 [UPDATED]
- [ ] PG-3: 显示 Boost 推荐练习卡片 [UPDATED]
- [ ] PG-3: Boost 卡片有箭头按钮 (→) [NEW]
- [ ] PG-3: 点击箭头打开 Boost Video Bottom Sheet [NEW]
- [ ] PG-3: 点击 Done 按钮回到 PG-1a [UPDATED]

### Bottom Sheet 验收 [NEW]
- [ ] Sheet: 从底部滑入动画 (0.3s)
- [ ] Sheet: 背景遮罩变暗 50%
- [ ] Sheet: 顶部圆角 16px
- [ ] Sheet: 显示 Boost 标题 (boost_name_cn)
- [ ] Sheet: 视频自动播放
- [ ] Sheet: 显示倒计时 (从视频总时长开始倒数)
- [ ] Sheet: 暂停/播放按钮可切换
- [ ] Sheet: 重置按钮可重新播放
- [ ] Sheet: 点击 ✕ 关闭弹窗
- [ ] Sheet: 点击背景遮罩关闭弹窗

### 样式验收
- [ ] 整体风格符合 iOS Human Interface Guidelines
- [ ] 使用 iOS 系统颜色 (#007AFF, #34C759, #FF3B30)
- [ ] 卡片有圆角 (12px) 和阴影
- [ ] 按钮有圆角 (8px/22px) 和适当的 padding
- [ ] 响应式布局 (桌面端左右分栏，移动端上下排列)
- [ ] 适配 iPhone 安全区域 (Safe Area) [NEW]
- [ ] 浮动按钮位于右下角 [NEW]

### 代码验收
- [ ] 单个 HTML 文件，可直接在浏览器打开
- [ ] 无外部依赖
- [ ] 代码结构清晰，有注释
- [ ] 使用 Canvas API 提取视频帧 [NEW]
- [ ] 使用 File API 处理视频上传 [NEW]

---

## 附录：状态流转图

```
┌───────────────────────────────────────────────────────────────────────┐
│                                                                       │
│  ┌─────────────┐                                                      │
│  │   PG-1      │                                                      │
│  │   测试准备   │                                                      │
│  └──────┬──────┘                                                      │
│         │ 输入名字 + 点击开始                                          │
│         ▼                                                             │
│  ┌─────────────┐                                                      │
│  │   PG-1a     │ ◄─────────────┬───────────────────────────────┐      │
│  │  视频上传   │               │ 点击刷新                       │      │
│  └──────┬──────┘               │                               │      │
│         │ 上传视频 + 下一步     │                               │      │
│         ▼                      │                               │      │
│  ┌─────────────┐               │                               │      │
│  │   PG-1b     │ ──────────────┘                               │      │
│  │  视频裁剪   │                                               │      │
│  └──────┬──────┘                                               │      │
│         │ 选择5秒 + 下一步                                      │      │
│         ▼                                                      │      │
│  ┌─────────────┐                                               │      │
│  │   PG-1c     │                                               │      │
│  │  AI等待    │                                               │      │
│  └──────┬──────┘                                               │      │
│         │ 自动 (2-3秒)                                          │      │
│         ▼                                                      │      │
│  ┌─────────────┐                                               │      │
│  │   PG-2      │ ◄─────────────┐                               │      │
│  │   MCQ 诊断  │               │ 选择答案                       │      │
│  └──────┬──────┘               │ (循环5次)                      │      │
│         │ 第5题完成             │                               │      │
│         ├──────────────────────┘                               │      │
│         ▼                                                      │      │
│  ┌─────────────┐                                               │      │
│  │   PG-2.5    │ [NEW]                                         │      │
│  │  报告等待   │                                               │      │
│  └──────┬──────┘                                               │      │
│         │ 自动 (2-3秒)                                          │      │
│         ▼                                                      │      │
│  ┌─────────────┐                                               │      │
│  │   PG-3      │ [UPDATED]                                     │      │
│  │ Mini Report │                                               │      │
│  └──────┬──────┘                                               │      │
│         │                                                      │      │
│         ├── 展开/收起 Check Tips → 切换 checkTipsExpanded      │      │
│         └── 点击 Done → 清空状态, 回到 PG-1a ──────────────────┘      │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 生成指令

请根据以上规范，生成一个完整的、可运行的单页 WebApp。

**输出要求**：
1. 单个 HTML 文件
2. CSS 使用 `<style>` 标签内联
3. JavaScript 使用 `<script>` 标签内联
4. 代码有清晰的注释
5. 可以直接在浏览器中打开运行

**特别注意**：
1. 参考视频使用占位符 (灰色方块 + 文字说明)，用户视频使用实际上传的文件
2. 导出 JSON 使用 Blob + URL.createObjectURL 实现下载
3. 移动端适配使用媒体查询，左右分栏变为上下排列
4. 帧条组件使用 Canvas API 提取视频帧缩略图 [NEW]
5. 视频裁剪使用拖动手势选择 5 秒范围 [NEW]
6. 适配 iOS Safe Area [NEW]
