# MCQ 管理后台 (Admin Server) - UI 生成规范

**版本**: v1.0
**日期**: 2025-12-25
**目标 AI**: Gemini 3 Pro Preview
**生成目标**: 单页 WebApp (HTML + CSS + JS)
**样式风格**: iOS Human Interface Guidelines + 青墨绿色系
**设计继承**: 完全继承 User 端 v1.3 设计规范
**目标设备**: iPad / Desktop (管理后台场景)

---

## 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| v1.0 | 2025-12-25 | **初始版本**: Server 端管理后台 MVP；localStorage 双向通信；MCQ 选择发送功能 |

---

## 角色设定

你是一个专业的前端工程师，擅长构建现代化的 iOS 风格 Web 应用。你需要根据以下规范，生成一个完整的、可运行的单页 WebApp —— MCQ 管理后台。

这个管理后台与 User 端配合使用：
- **User 端**: 用户上传视频、回答 MCQ、查看报告
- **Server 端 (本文档)**: 管理员接收视频通知、选择 MCQ 问题、发送给 User 端

---

## 组件层级树

```
Admin-WebApp (管理后台)
├── PG-1: 主页面 (Admin Console)
│   ├── Header: 品牌区域
│   │   ├── Brand-Logo: "Admin" + "Console"
│   │   └── Connection-Status: 连接状态指示器
│   ├── Card-VideoNotification: 视频通知卡片 (毛玻璃)
│   │   ├── Card-Header: 标题 + 通知数量徽章
│   │   ├── Notification-List: 通知列表
│   │   │   └── Notification-Item: 单条通知
│   │   │       ├── Video-Thumbnail: 视频缩略图
│   │   │       ├── User-Name: 用户名
│   │   │       ├── Timestamp: 时间戳
│   │   │       └── Status-Badge: 状态标签
│   │   └── Empty-State: 空状态提示
│   ├── Card-MCQSelector: MCQ 选择卡片 (毛玻璃)
│   │   ├── Card-Header: 标题 + 已选计数器 (0/5)
│   │   ├── Dimension-Tabs: 维度分类标签页
│   │   │   └── Tab-Item: 单个维度标签
│   │   ├── MCQ-List: MCQ 列表
│   │   │   └── MCQ-Item: 单个 MCQ 项
│   │   │       ├── Checkbox: 选择框
│   │   │       ├── Atom-Name: 原子名称
│   │   │       └── Dimension-Tag: 维度标签
│   │   └── Selection-Summary: 已选摘要
│   ├── Btn-Send: 发送 MCQ 按钮 (Primary)
│   └── Card-Log: 通信日志卡片 (可折叠)
│       ├── Card-Header: 标题 + 展开/收起按钮
│       └── Log-List: 日志条目列表
└── Toast: 操作反馈提示
```

---

## 用户-系统交互流程

```
┌─────────────────────────────────────────────────────────────────────────┐
│  管理员                            系统                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [打开 admin.html] ────────────────► 初始化页面                          │
│                                      监听 localStorage 变化             │
│                                      显示连接状态: 🟢 Ready              │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  等待 User 端消息                                                │    │
│  │                                                                 │    │
│  │  [User 上传视频] ──────────────► 收到 VIDEO_UPLOADED 消息        │    │
│  │                                  │                              │    │
│  │                                  ▼                              │    │
│  │                               显示通知卡片                       │    │
│  │                               - 用户名: {raterName}             │    │
│  │                               - 时间: {timestamp}               │    │
│  │                               - 状态: 待处理                     │    │
│  │                               播放通知音效                       │    │
│  │                               触觉反馈                           │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  [点击维度标签] ──────────────────► 筛选显示该维度的 MCQ                  │
│                                                                         │
│  [勾选 MCQ 问题] ─────────────────► 更新已选计数器 (n/5)                  │
│                                    │                                   │
│                                    ├─ n < 5: 计数器显示 n/5            │
│                                    ├─ n = 5: 计数器变绿, 按钮可用        │
│                                    └─ n > 5: 阻止选择, 显示提示          │
│                                                                         │
│  [点击发送 MCQ] ──────────────────► 验证已选 5 个问题                     │
│                                    │                                   │
│                                    ├─ 验证通过:                         │
│                                    │  - 发送 MCQ_SELECTED 消息          │
│                                    │  - 显示成功 Toast                  │
│                                    │  - 更新通知状态: 已发送             │
│                                    │  - 记录到通信日志                   │
│                                    │                                   │
│                                    └─ 验证失败:                         │
│                                       - 显示错误提示                     │
│                                       - 按钮抖动动画                     │
│                                                                         │
│  [展开/收起日志] ─────────────────► 切换日志卡片展开状态                   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 任务描述

构建一个 **MCQ 管理后台 WebApp**，用于管理网球正手动作诊断的 MCQ 问题分发。

**核心流程**: 接收视频通知 → 选择 MCQ 问题 (5个) → 发送给 User 端

**使用场景**:
- 管理员在浏览器中打开 admin.html
- User 端用户上传视频后，管理员收到通知
- 管理员根据视频内容选择 5 个相关的 MCQ 问题
- 点击发送，User 端收到问题并开始答题

**与 User 端的关系**:
- User 端和 Server 端在同一浏览器的不同标签页中运行
- 通过 localStorage + storage 事件实现跨标签页通信

---

## 技术约束

### 必须使用
- 单个 HTML 文件 (内联 CSS + JS)
- 原生 JavaScript (ES6+)
- CSS 变量定义主题色
- Flexbox / Grid 布局
- localStorage API (跨标签页通信)
- storage 事件监听

### 禁止使用
- 任何外部框架 (React, Vue, Angular)
- 任何 UI 库 (Bootstrap, Tailwind)
- 任何外部 CDN 依赖
- WebSocket / Server-Sent Events (本 MVP 使用 localStorage)

---

## 设计规范 (继承自 User 端 v1.3)

### 主题模式

**强制浅色模式**，确保所有用户看到一致的视觉效果。

| 元素 | 属性 | 值 | 用途 |
|------|------|-----|------|
| `<meta>` | name | `color-scheme` | 声明主题模式 |
| | content | `light` | 强制浅色模式 |
| `:root` | color-scheme | `light only` | 根元素强制浅色 |

---

### 青墨绿配色系统

使用低饱和度、柔和高级的青墨绿色系，与 User 端保持一致。

**设计令牌表 (Design Tokens)**:

| 令牌名 | 值 | 用途 |
|--------|-----|------|
| `--color-primary` | `#3A5F5A` | 主色 - 青墨绿 |
| `--color-primary-light` | `#4D7570` | 主色浅 - hover 状态 |
| `--color-primary-dark` | `#2D4A46` | 主色深 - active 状态 |
| `--color-success` | `#5A8F7A` | 成功色 - 薄荷灰绿 |
| `--color-success-light` | `#7AAF9A` | 成功色浅 |
| `--color-success-dark` | `#4A7A68` | 成功色深 |
| `--color-warning` | `#C4A86C` | 警告色 - 琥珀金 |
| `--color-warning-light` | `#D9C4A0` | 警告色浅 |
| `--color-warning-dark` | `#B89660` | 警告色深 |
| `--color-danger` | `#B87070` | 危险色 - 豆沙红 |
| `--color-danger-light` | `#D49090` | 危险色浅 |
| `--color-danger-dark` | `#A85858` | 危险色深 |
| `--color-bg-base` | `#EBE7E3` | 页面背景基色 |
| `--color-bg-gradient-end` | `#DDD9D5` | 渐变结束色 |
| `--color-surface` | `rgba(255,255,255,0.6)` | 毛玻璃卡片背景 |
| `--color-surface-solid` | `#FFFFFF` | 纯白卡片背景 |
| `--color-text-primary` | `#2C2C2E` | 主文字 - 深灰 |
| `--color-text-secondary` | `#6E6E73` | 次要文字 |
| `--color-text-tertiary` | `#8E8E93` | 辅助文字 |
| `--color-border` | `rgba(0,0,0,0.08)` | 边框色 |
| `--color-divider` | `rgba(0,0,0,0.05)` | 分隔线色 |

---

### Mesh Gradient 弥散渐变背景

页面背景使用多层 `radial-gradient` 叠加，模拟弥散光斑效果。

**Body 背景配置**:

| 属性 | 值 | 说明 |
|------|-----|------|
| min-height | `100vh` | 视口高度 |
| background-attachment | `fixed` | 滚动时背景固定 |

**Mesh Gradient 光斑参数**:

| 光斑 | 位置 | 形状 | 颜色 (RGBA) | 透明度 | 渐变范围 |
|------|------|------|-------------|--------|----------|
| 光斑 1 | 左上 (15%, 20%) | 椭圆 80%×60% | `58, 95, 90` (青墨绿) | 25% | 0% → 55% |
| 光斑 2 | 右下 (85%, 75%) | 椭圆 70%×80% | `90, 143, 122` (薄荷灰绿) | 20% | 0% → 50% |
| 光斑 3 | 中右 (60%, 45%) | 椭圆 50%×50% | `77, 117, 112` (浅墨绿) | 15% | 0% → 45% |
| 基底 | 全屏 | 线性渐变 180° | `--color-bg-base` → `--color-bg-gradient-end` | 100% | 0% → 100% |

---

### 毛玻璃卡片效果

所有卡片使用 `backdrop-filter` 实现毛玻璃效果。

**毛玻璃组件样式表**:

| 组件 | 背景透明度 | 模糊度 | 边框 | 圆角 |
|------|-----------|--------|------|------|
| `.card` | 60% 白 | 20px | 1px 50%白 | 16px |
| `.btn-glass` | 40% 白 | 12px | 1px 30%白 | 12px |
| `.input-glass` | 50% 白 | 8px | 1px 40%白 | 8px |

**卡片阴影效果**:
- 外阴影: `0 4px 24px rgba(0,0,0,0.06)` - 柔和投影
- 内阴影: `inset 0 1px 0 rgba(255,255,255,0.8)` - 顶部高光

**Safari 兼容**: 需同时设置 `backdrop-filter` 和 `-webkit-backdrop-filter`

---

### 交互动效规范

#### 1. 按钮按压效果 (Apple 风格缩放)

| 元素 | 状态 | 属性 | 值 | 缓动曲线 |
|------|------|------|-----|----------|
| `.btn` | 默认 | transition | transform 0.15s | `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| `.btn` | :active | transform | `scale(0.96)` | - |
| `.card-pressable` | :active | transform | `scale(0.98)` | - |

#### 2. 弹性动画 (Bounce Effect)

**缓动函数令牌**:

| 令牌名 | 值 | 效果 |
|--------|-----|------|
| `--ease-bounce` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | 弹性回弹 |
| `--ease-smooth` | `cubic-bezier(0.4, 0, 0.2, 1)` | 平滑过渡 |

**bounceIn 动画关键帧**:

| 时间点 | opacity | transform |
|--------|---------|-----------|
| 0% | 0 | `scale(0.9)` |
| 60% | - | `scale(1.02)` |
| 100% | 1 | `scale(1)` |

#### 3. 通知进入动画

**slideIn 关键帧** (通知卡片从右侧滑入):

| 时间点 | transform | opacity |
|--------|-----------|---------|
| 0% | `translateX(100%)` | 0 |
| 100% | `translateX(0)` | 1 |

**使用**: `.animate-slide-in` 类，时长 0.4s

#### 4. 触觉反馈

| 样式 | 震动模式 | 适用场景 |
|------|----------|----------|
| `light` | 10ms | 普通选择 |
| `medium` | 20ms | MCQ 选中/取消 |
| `success` | [10, 50, 20]ms | 发送成功 |
| `error` | [50, 30, 50, 30, 50]ms | 发送失败 |
| `notification` | [20, 100, 20]ms | 收到新通知 |

---

### 图标与视觉设计规范

#### 图标系统

**图标尺寸规范**:

| 场景 | 尺寸 | 示例 |
|------|------|------|
| 导航图标 | 24x24 px | ✕ 关闭、← 返回 |
| 状态图标 | 20x20 px | 🟢 连接、🔔 通知 |
| 标签图标 | 14x14 px | 维度图标 |
| 装饰图标 | 40x40 px | 空状态图标 |

#### 按钮设计规范

| 按钮类型 | 背景 | 文字色 | 边框 | 圆角 | 特殊效果 |
|----------|------|--------|------|------|----------|
| Primary | 主色 | 白色 | 无 | 12px | 阴影 `0 2px 8px` |
| Secondary | 透明 | 主色 | 2px 主色 | 12px | - |
| Ghost | 30%白 | 主文字色 | 1px 40%白 | 12px | 毛玻璃 |
| Disabled | 20%黑 | 50%黑 | 无 | 12px | 无阴影 |

#### 徽章 (Badge) 设计

| 类型 | 背景 | 文字 | 尺寸 | 用途 |
|------|------|------|------|------|
| 通知计数 | `--color-danger` | 白色 | min-width 20px, height 20px | 未读通知数 |
| 已选计数 | `--color-primary` | 白色 | 自适应 | 已选 MCQ 数 |
| 状态标签 | 各状态色 | 白色 | padding 4px 8px | 处理状态 |

---

### 间距系统

**8px 基准网格**:

| 令牌名 | 值 | 用途 |
|--------|-----|------|
| `--spacing-xs` | 4px | 图标内边距 |
| `--spacing-sm` | 8px | 元素间隙 |
| `--spacing-md` | 16px | 卡片内边距 |
| `--spacing-lg` | 24px | 区块间距 |
| `--spacing-xl` | 32px | 页面边距 |

---

### 排版系统

| 类名 | 字号 | 字重 | 行高 | 用途 |
|------|------|------|------|------|
| `.text-h1` | 32px | 700 | 1.3 | 页面标题 |
| `.text-h2` | 22px | 600 | 1.4 | 区块标题 |
| `.text-h3` | 18px | 600 | 1.4 | 卡片标题 |
| `.text-body` | 16px | 400 | 1.6 | 正文内容 |
| `.text-caption` | 14px | 400 | 1.5 | 辅助说明 |
| `.text-label` | 12px | 500 | 1.4 | 标签/徽章 |

---

## 通信协议规范

### localStorage Keys

| Key | 方向 | 说明 |
|-----|------|------|
| `mcq_user_to_server` | User → Server | User 端发送的消息 |
| `mcq_server_to_user` | Server → User | Server 端发送的消息 |

### 消息类型枚举

| 类型 | 方向 | 触发时机 | 说明 |
|------|------|----------|------|
| `VIDEO_UPLOADED` | User → Server | User 上传视频后 | 通知 Server 有新视频 |
| `MCQ_SELECTED` | Server → User | Server 选择并发送 MCQ | 包含 5 个 MCQ 问题 |
| `MCQ_COMPLETED` | User → Server | User 完成答题 | 包含答题结果 |
| `HEARTBEAT` | 双向 | 定时 (可选) | 保活检测 |

### 消息格式 (JSON Schema)

#### 通用消息结构

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `type` | string | ✅ | 消息类型 |
| `timestamp` | number | ✅ | Unix 时间戳 (ms) |
| `payload` | object | ✅ | 消息数据 |

#### VIDEO_UPLOADED 消息

```
{
  type: "VIDEO_UPLOADED",
  timestamp: 1735084800000,
  payload: {
    raterName: "Kim",
    videoFileName: "forehand_001.mp4",
    videoDuration: 15.5,
    trimRange: { start: 2, end: 7 }
  }
}
```

**payload 字段说明**:

| 字段 | 类型 | 说明 |
|------|------|------|
| `raterName` | string | 用户名 |
| `videoFileName` | string | 视频文件名 |
| `videoDuration` | number | 视频总时长 (秒) |
| `trimRange` | object | 选中的 5 秒范围 {start, end} |

#### MCQ_SELECTED 消息

```
{
  type: "MCQ_SELECTED",
  timestamp: 1735084900000,
  payload: {
    questions: [
      {
        question_id: "Q1",
        atom_id: "DM3-IS08-AT45",
        atom_name_cn: "被挤着打",
        dimension_cn: "击球空间",
        description: "击球被挤住",
        error_videos: ["Q1_error.mp4"],
        correct_videos: ["Q1_correct.mp4"]
      },
      // ... 共 5 个问题
    ]
  }
}
```

**payload.questions[] 字段说明**:

| 字段 | 类型 | 说明 |
|------|------|------|
| `question_id` | string | 问题 ID (Q1-Q5) |
| `atom_id` | string | 错误原子 ID |
| `atom_name_cn` | string | 原子中文名 |
| `dimension_cn` | string | 维度中文名 |
| `description` | string | 错误描述 |
| `error_videos` | string[] | 错误示范视频路径 |
| `correct_videos` | string[] | 正确示范视频路径 |

### 通信实现

#### 发送消息函数

```javascript
function sendMessage(key, type, payload) {
  const message = {
    type: type,
    timestamp: Date.now(),
    payload: payload
  };
  localStorage.setItem(key, JSON.stringify(message));
}
```

#### 监听消息

```javascript
window.addEventListener('storage', (event) => {
  if (event.key === 'mcq_user_to_server') {
    const message = JSON.parse(event.newValue);
    handleUserMessage(message);
  }
});
```

**注意**: `storage` 事件只在**其他标签页**修改 localStorage 时触发，不会在当前页触发。

---

## 页面规范

### Page 1: 管理后台主页 (Admin Console)

**功能**: 接收视频通知、选择 MCQ 问题、发送给 User 端

**布局** (桌面端):

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ Mesh Gradient 背景 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                              Admin                                      │
│                             Console                       🟢 Ready      │
│                                                                         │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────┐  │
│  │  🔔 视频通知              [1]   │  │  📋 选择 MCQ          3/5   │  │
│  │  ───────────────────────────── │  │  ─────────────────────────  │  │
│  │                                 │  │                             │  │
│  │  ┌───────────────────────────┐ │  │  [全部] [准备] [引拍] [击球] │  │
│  │  │ 📹 │ Kim          12:30   │ │  │                             │  │
│  │  │    │ 正手视频    待处理   │ │  │  ☑ 击球空间 - 被挤着打      │  │
│  │  └───────────────────────────┘ │  │  ☑ 发力本能 - 靠手腕翻      │  │
│  │                                 │  │  ☑ 重心平衡 - 重心不往前    │  │
│  │  (空状态: 等待 User 端上传...)  │  │  ☐ 转体控制 - 左手先收      │  │
│  │                                 │  │  ☐ 动力源头 - 只拉手引拍    │  │
│  │                                 │  │  ...                        │  │
│  │                                 │  │                             │  │
│  └─────────────────────────────────┘  └─────────────────────────────┘  │
│                                                                         │
│                    ┌───────────────────────────────┐                    │
│                    │         发送 MCQ →            │                    │
│                    └───────────────────────────────┘                    │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  📜 通信日志                                              [v]   │   │
│  │  ─────────────────────────────────────────────────────────────  │   │
│  │  12:30:15  ← 收到 VIDEO_UPLOADED: Kim                          │   │
│  │  12:31:22  → 发送 MCQ_SELECTED: 5 questions                    │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

### 组件详细规范

#### Header (品牌区域)

**布局**:
```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│                              Admin                                      │
│                             Console                       🟢 Ready      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**字体规范**:

| 元素 | 字体 | 大小 | 字重 | 颜色 |
|------|------|------|------|------|
| "Admin" | SF Pro Display | 40px | 300 (Light) | `--color-text-primary` |
| "Console" | SF Pro Display | 40px | 700 (Bold) | `--color-primary` |

**连接状态指示器**:

| 状态 | 图标 | 文字 | 颜色 |
|------|------|------|------|
| 就绪 | 🟢 | Ready | `--color-success` |
| 等待 | 🟡 | Waiting | `--color-warning` |
| 断开 | 🔴 | Disconnected | `--color-danger` |

---

#### Card-VideoNotification (视频通知卡片)

**功能**: 显示 User 端上传的视频通知

**卡片样式**:
| 属性 | 值 |
|------|-----|
| 背景 | 毛玻璃 (60% 白, blur 20px) |
| 圆角 | 16px |
| 阴影 | `0 4px 24px rgba(0,0,0,0.06)` |
| 内边距 | 20px |
| 最小高度 | 200px |

**卡片头部**:
- 左侧: 🔔 图标 + "视频通知" 标题
- 右侧: 红色通知数量徽章 (有未处理通知时显示)

**Notification-Item (单条通知)**:

```
┌───────────────────────────────────────┐
│  ┌─────┐                              │
│  │ 📹  │  Kim              12:30:15   │
│  │     │  正手视频 (5s)     待处理    │
│  └─────┘                              │
└───────────────────────────────────────┘
```

| 元素 | 样式 |
|------|------|
| 缩略图区域 | 48x48px, 圆角 8px, 背景 `--color-primary` 20% |
| 用户名 | 16px, 600 字重, 主文字色 |
| 时间戳 | 14px, 400 字重, 次要文字色 |
| 视频信息 | 14px, 400 字重, 辅助文字色 |
| 状态标签 | 12px, 圆角 4px, 背景色随状态变化 |

**状态标签颜色**:

| 状态 | 背景 | 文字 |
|------|------|------|
| 待处理 | `--color-warning` 20% | `--color-warning-dark` |
| 已发送 | `--color-success` 20% | `--color-success-dark` |

**空状态**:
```
┌───────────────────────────────────────┐
│                                       │
│              📭                       │
│                                       │
│       等待 User 端上传视频...         │
│                                       │
│    请在另一个标签页打开 User 端        │
│                                       │
└───────────────────────────────────────┘
```

---

#### Card-MCQSelector (MCQ 选择卡片)

**功能**: 显示所有 MCQ 问题，允许选择 5 个

**卡片头部**:
- 左侧: 📋 图标 + "选择 MCQ" 标题
- 右侧: 已选计数器徽章 "n/5"

**计数器样式**:

| 状态 | 背景 | 文字 |
|------|------|------|
| n < 5 | `--color-text-tertiary` 20% | `--color-text-secondary` |
| n = 5 | `--color-success` | 白色 |
| n > 5 | `--color-danger` | 白色 |

**Dimension-Tabs (维度标签页)**:

```
[全部] [准备姿势] [引拍转体] [击球空间] [发力本能] [随挥收拍]
```

| 元素 | 默认状态 | 选中状态 |
|------|----------|----------|
| 背景 | 透明 | `--color-primary` 15% |
| 文字 | `--color-text-secondary` | `--color-primary` |
| 边框 | 无 | 无 |
| 圆角 | 8px | 8px |
| 内边距 | 8px 16px | 8px 16px |

**MCQ-Item (单个 MCQ 项)**:

```
┌───────────────────────────────────────┐
│  ☑  击球空间 - 被挤着打               │
│      击球时身体离球太近被挤住          │
└───────────────────────────────────────┘
```

| 元素 | 样式 |
|------|------|
| Checkbox | 20x20px, 圆角 4px, 边框 2px |
| Checkbox (选中) | 背景 `--color-primary`, 白色对勾 |
| 维度名 | 14px, `--color-primary`, 600 字重 |
| 原子名 | 16px, 主文字色, 400 字重 |
| 描述 | 14px, 辅助文字色, 400 字重 |

**选中效果**:
- 整行背景: `--color-primary` 5%
- 左侧边框: 3px solid `--color-primary`

**禁用效果** (已选满 5 个时，其他未选项):
- 透明度: 50%
- 鼠标: not-allowed

---

#### Btn-Send (发送按钮)

**样式**:

| 属性 | 值 |
|------|-----|
| 宽度 | 280px |
| 高度 | 56px |
| 背景 | `--color-primary` |
| 文字 | 白色, 18px, 600 字重 |
| 圆角 | 16px |
| 阴影 | `0 4px 16px rgba(58, 95, 90, 0.3)` |

**状态**:

| 状态 | 背景 | 效果 |
|------|------|------|
| 禁用 (n ≠ 5) | `--color-text-tertiary` 30% | 无阴影, cursor: not-allowed |
| 可用 (n = 5) | `--color-primary` | 有阴影 |
| Hover | `--color-primary-light` | - |
| Active | `--color-primary-dark` | scale(0.96) |

**按钮文字**:
- 禁用时: "选择 5 个问题"
- 可用时: "发送 MCQ →"

---

#### Card-Log (通信日志卡片)

**功能**: 显示收发消息的日志，便于调试

**默认状态**: 收起 (只显示标题)

**卡片头部**:
- 左侧: 📜 图标 + "通信日志" 标题
- 右侧: 展开/收起箭头 (▼ / ▲)

**Log-Item (单条日志)**:

```
12:30:15  ← 收到 VIDEO_UPLOADED: Kim
12:31:22  → 发送 MCQ_SELECTED: 5 questions
```

| 元素 | 样式 |
|------|------|
| 时间戳 | 12px, 等宽字体, 辅助文字色 |
| 方向箭头 | ← (收到) / → (发送), 主色 |
| 消息类型 | 14px, 主文字色, 600 字重 |
| 摘要 | 14px, 次要文字色 |

---

#### Toast (操作反馈)

**功能**: 显示操作结果的轻量提示

**样式**:

| 属性 | 值 |
|------|-----|
| 位置 | 屏幕顶部居中, 距顶 80px |
| 背景 | 毛玻璃 (80% 黑, blur 10px) |
| 文字 | 白色, 16px |
| 圆角 | 12px |
| 内边距 | 12px 24px |

**类型**:

| 类型 | 图标 | 持续时间 |
|------|------|----------|
| 成功 | ✓ | 2 秒 |
| 错误 | ✕ | 3 秒 |
| 信息 | ℹ | 2 秒 |

**动画**:
- 进入: 从上方淡入滑下
- 退出: 向上滑出淡出

---

## 数据结构

### MCQ 问题数据

Server 端需要内嵌完整的 MCQ 问题数据，以便管理员选择。

**数据来源**: 与 User 端共享同一份数据

**MCQ_ALL_QUESTIONS 数组结构**:

| 字段 | 类型 | 说明 |
|------|------|------|
| `question_id` | string | 唯一标识 (如 "Q1", "Q2"...) |
| `atom_id` | string | 错误原子 ID (如 "DM3-IS08-AT45") |
| `atom_name_cn` | string | 原子中文名 (如 "被挤着打") |
| `dimension_id` | string | 维度 ID (如 "DM3") |
| `dimension_cn` | string | 维度中文名 (如 "击球空间") |
| `description` | string | 错误描述 |
| `error_videos` | string[] | 错误示范视频路径 |
| `correct_videos` | string[] | 正确示范视频路径 |

**示例数据** (内嵌在 HTML 中):

```javascript
const MCQ_ALL_QUESTIONS = [
  {
    question_id: "Q1",
    atom_id: "DM3-IS08-AT45",
    atom_name_cn: "被挤着打",
    dimension_id: "DM3",
    dimension_cn: "击球空间",
    description: "击球被挤住",
    error_videos: ["Q1_6102_15-22_打球被挤到_error.mp4"],
    correct_videos: ["0094_挥拍转体_德约科维奇正手网球_correct.mp4"]
  },
  {
    question_id: "Q2",
    atom_id: "DM4-IS10-AT46",
    atom_name_cn: "靠手腕翻",
    dimension_id: "DM4",
    dimension_cn: "发力本能",
    description: "击球时用手腕翻拍面",
    error_videos: ["Q2_6101_07-28_翻腕_翻拍面_error.mp4"],
    correct_videos: ["0094_挥拍转体_德约科维奇正手网球_correct.mp4"]
  },
  {
    question_id: "Q3",
    atom_id: "DM2-IS05-AT21",
    atom_name_cn: "重心不往前",
    dimension_id: "DM2",
    dimension_cn: "重心平衡",
    description: "击球后重心不往前",
    error_videos: ["Q3_2202_21-27_髋部原地转动踩烟头_error.mp4"],
    correct_videos: ["0094_挥拍转体_德约科维奇正手网球_correct.mp4"]
  },
  {
    question_id: "Q4",
    atom_id: "DM2-IS07-AT29",
    atom_name_cn: "左手先收",
    dimension_id: "DM2",
    dimension_cn: "转体控制",
    description: "挥拍前左手先收回",
    error_videos: ["Q4_2402_01-06_左臂先打开_error.mp4"],
    correct_videos: ["0093_收拍_德约科维奇正手网球_correct.mp4"]
  },
  {
    question_id: "Q5",
    atom_id: "DM2-IS06-AT23",
    atom_name_cn: "只拉手引拍",
    dimension_id: "DM2",
    dimension_cn: "动力源头",
    description: "引拍只用手往后拉拍",
    error_videos: ["Q5_2301_23-32_不转腰髋引拍_error.mp4"],
    correct_videos: ["0094_挥拍转体_德约科维奇正手网球_correct.mp4"]
  }
];
```

**维度列表**:

| dimension_id | dimension_cn | 描述 |
|--------------|--------------|------|
| DM1 | 准备姿势 | 分腿步、握拍等 |
| DM2 | 引拍转体 | 重心、转体、引拍 |
| DM3 | 击球空间 | 击球点位置 |
| DM4 | 发力本能 | 发力方式 |
| DM5 | 随挥收拍 | 收拍动作 |

---

## 状态管理

| 状态 | 类型 | 说明 |
|------|------|------|
| `notifications` | array | 收到的视频通知列表 |
| `selectedQuestions` | array | 已选中的 MCQ 问题 ID 列表 |
| `activeTab` | string | 当前激活的维度标签 ("all" / "DM1" / ...) |
| `logExpanded` | boolean | 通信日志卡片是否展开 |
| `logs` | array | 通信日志列表 [{time, direction, type, summary}] |
| `connectionStatus` | string | 连接状态 ("ready" / "waiting" / "disconnected") |

---

## 验收标准

### 功能验收

- [ ] 页面加载后显示 "Ready" 连接状态
- [ ] 监听 localStorage 的 `mcq_user_to_server` key
- [ ] 收到 `VIDEO_UPLOADED` 消息后:
  - [ ] 显示通知卡片
  - [ ] 播放通知音效 (可选)
  - [ ] 触发触觉反馈
  - [ ] 更新通知数量徽章
- [ ] 维度标签页可切换筛选 MCQ
- [ ] 点击 MCQ 项可选中/取消
- [ ] 已选计数器实时更新 (n/5)
- [ ] 选满 5 个后:
  - [ ] 计数器变绿
  - [ ] 发送按钮变为可用
  - [ ] 其他未选项变为禁用状态
- [ ] 点击发送按钮:
  - [ ] 发送 `MCQ_SELECTED` 消息到 `mcq_server_to_user`
  - [ ] 显示成功 Toast
  - [ ] 更新通知状态为 "已发送"
  - [ ] 记录到通信日志
- [ ] 通信日志可展开/收起

### 视觉验收

- [ ] 强制浅色模式
- [ ] 青墨绿配色系统
- [ ] Mesh Gradient 弥散渐变背景
- [ ] 毛玻璃卡片效果
- [ ] 卡片圆角 16px + 柔和阴影
- [ ] 按钮圆角 12px/16px
- [ ] 排版层次清晰

### 交互验收

- [ ] 按钮按压缩放 scale(0.96)
- [ ] 弹性缓动动画
- [ ] 通知滑入动画
- [ ] Toast 淡入淡出动画
- [ ] 触觉反馈 (支持的设备)

### 通信验收

- [ ] 打开两个标签页 (User + Server)
- [ ] User 上传视频 → Server 收到通知
- [ ] Server 选择 5 个 MCQ → 点击发送 → User 收到问题

### 代码验收

- [ ] 单个 HTML 文件，可直接打开
- [ ] 无外部依赖
- [ ] 代码结构清晰，有注释
- [ ] 使用 localStorage + storage 事件通信

---

## 附录：与 User 端的配合流程

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  [浏览器标签页 1: User 端]           [浏览器标签页 2: Server 端]          │
│                                                                         │
│  ┌─────────────────────┐             ┌─────────────────────┐            │
│  │                     │             │                     │            │
│  │  1. 输入名字        │             │  等待通知...         │            │
│  │     ↓               │             │                     │            │
│  │  2. 上传视频        │             │                     │            │
│  │     ↓               │             │                     │            │
│  │  3. 裁剪 5 秒       │             │                     │            │
│  │     ↓               │             │                     │            │
│  │  4. 发送通知 ───────┼─────────────┼──► 收到通知         │            │
│  │     ↓               │             │     ↓               │            │
│  │  5. 等待 MCQ...     │             │  5. 选择 5 个 MCQ    │            │
│  │                     │             │     ↓               │            │
│  │  6. 收到 MCQ ◄──────┼─────────────┼─── 发送 MCQ         │            │
│  │     ↓               │             │     ↓               │            │
│  │  7. 回答问题        │             │  显示 "已发送"       │            │
│  │     ↓               │             │                     │            │
│  │  8. 查看报告        │             │                     │            │
│  │                     │             │                     │            │
│  └─────────────────────┘             └─────────────────────┘            │
│                                                                         │
│  localStorage: mcq_user_to_server ─────►                                │
│                                                                         │
│              ◄───────── localStorage: mcq_server_to_user                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
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
1. **强制浅色模式** - 使用 `color-scheme: light only`
2. **青墨绿配色** - 与 User 端保持一致
3. **Mesh Gradient 背景** - 多层 radial-gradient 叠加
4. **毛玻璃效果** - 使用 backdrop-filter: blur()
5. **Apple 风格动效** - 按压缩放 + 弹性缓动
6. **localStorage 通信** - 使用 storage 事件监听
7. **内嵌 MCQ 数据** - 5 个示例问题

**测试方法**：
1. 在浏览器中打开 admin.html (Server 端)
2. 在另一个标签页打开 User 端
3. User 端上传视频 → Server 端应显示通知
4. Server 端选择 5 个 MCQ → 点击发送 → User 端应收到问题
