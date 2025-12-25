# P0 执行记录：2025-12-25

## 基本信息

| 项目 | 内容 |
|------|------|
| 日期 | 2025年12月25日（周三） |
| P0 | MCQ Server 端管理后台 MVP |
| 完成状态 | ✅ 已完成 |
| 开始时间 | -- |
| 完成时间 | 2025-12-25 |

---

## P0 定义

| 项目 | 内容 |
|------|------|
| 任务 | MCQ Server 端管理后台 MVP |
| 背景 | User 端已完成，需要 Server 端配合完成完整通信流程 |

**核心目标**：
```
┌─────────────────────────────────────────────────────────────────┐
│  两个标签页能通信（MVP 的 MVP）                                   │
│  - User 上传视频 → Server 收到通知                               │
│  - Server 选 5 个 MCQ → 发送 → User 收到                         │
└─────────────────────────────────────────────────────────────────┘
```

**完成标准**：

| # | 标准 |
|---|------|
| 1 | 打开两个浏览器标签页（User 端 + Server 端） |
| 2 | User 端上传视频 → Server 端能看到通知 |
| 3 | Server 端选 5 个 MCQ → 点发送 → User 端能收到 |

**技术方案**：

| 项目 | 方案 |
|------|------|
| 通信 | localStorage + storage 事件（不用 WebSocket） |
| 文件结构 | webapp-v6-ios/server/admin.html |

---

## 时间线

| 时间 | 事件 | 状态 |
|------|------|------|
| -- | P0 确认，开始执行 | ✅ |
| -- | PROMPT 文档 v1.0 完成 | ✅ |
| -- | Gemini 生成 v1.0 | ✅ |
| -- | PROMPT v1.1 重构（3K桌面布局 + 完整交互流程） | ✅ |
| -- | Gemini 生成 v1.1 | ✅ |
| -- | PROMPT v1.2（格式优化 + 视频播放区域） | ✅ |
| -- | Gemini 生成 v1.2 | ✅ |
| -- | 反馈 5 点改进，启动 v1.3 | ✅ |
| -- | PROMPT v1.3（两阶段工作流 + 通知系统 + 音效） | ✅ |
| -- | Gemini 生成 v1.3 | ✅ |
| -- | v1.3 反馈 3 点问题（界面/文案/Mock） | ✅ |
| -- | PROMPT v1.4（界面合并 + Mock 机制） | ✅ |
| -- | Gemini 生成 v1.4 | ✅ |
| -- | v1.4 反馈（布局 + 业务逻辑重构） | ✅ |
| -- | PROMPT v1.5（两类独立事件 + 紧凑布局） | ✅ |
| -- | Gemini 生成 v1.5 | ✅ |
| -- | v1.5 反馈 6 点问题 | ✅ |
| -- | PROMPT v1.5.1（六项 UI/UX 优化） | ✅ |
| -- | Gemini 生成 v1.5.1 | ✅ |
| -- | 保存到本地 (webapp-v6-ios-server/) | ✅ |
| -- | Vite 多页面配置完成 | ✅ |
| -- | localStorage 通信模块实现 | ✅ |
| -- | MVP 通信机制验证通过 | ✅ |
| -- | 四项优化任务规划完成 | ✅ |
| -- | 优化任务 1: MCQ 视频路径修复 | 🔄 |
| -- | MCQ 视频黑屏问题定位（Vite publicDir） | ✅ |
| -- | Vite publicDir 配置修复 | ✅ |
| -- | Communication PROMPT v1.1 创建 | ✅ |
| -- | 视频扩展方案规划完成 | ✅ |
| -- | 优化任务 1: MCQ 视频路径修复 | ✅ 已完成 |
| -- | 优化任务 2: Boost 视频统一 | ✅ 已完成 |
| -- | 优化任务 3: Server 语音增强 | ✅ 已完成 |
| -- | 优化任务 4: User 音效动画 | ✅ 已完成 |
| -- | 验证完成标准（两种 Mock 流程） | ✅ 已完成 |

---

## 版本迭代记录

### v1.0（初始版本）

**基础架构**：

| 项目 | 说明 |
|------|------|
| 目标设备 | 手机端（iPhone 16 Pro 尺寸） |
| 技术栈 | 单文件 HTML + 内联 CSS/JS |
| 数据 | 静态 JSON 内嵌 |

**初始布局**：
```
┌─────────────────────────────────┐
│         MCQ Admin               │
├─────────────────────────────────┤
│  ┌───────────────────────────┐  │
│  │      视频播放器            │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │      MCQ 列表              │  │
│  │      (垂直滚动)            │  │
│  └───────────────────────────┘  │
│  [发送 MCQ]                     │
└─────────────────────────────────┘
```

---

### v1.0 → v1.1

**核心变更**：

| 变更项 | v1.0 | v1.1 |
|--------|------|------|
| 目标设备 | 手机 | 3K 桌面 (3456×2234) |
| 布局方式 | 单列垂直 | 三列网格 |
| 交互流程 | 仅 MCQ 发送 | 完整 MCQ → Response → Report |
| 数据规模 | 少量测试数据 | 完整 46 Atom + 22 Boost |

**v1.1 三列布局**：
```
┌──────────────────────────────────────────────────────────────────┐
│                      MCQ Admin Console                           │
├─────────────────┬─────────────────────┬──────────────────────────┤
│  📋 左列 (280px) │  🎬 中列 (flex)      │  📝 右列 (360px)         │
│  ───────────────│  ─────────────────  │  ────────────────────── │
│  Session Queue  │  视频播放器          │  MCQ/Boost 选择区       │
│  - 待处理列表    │  ─────────────────  │  - 46 个 Atom Tab       │
│  - 已完成列表    │  用户回复详情        │  - 22 个 Boost Tab      │
│                 │                     │  - Summary 输入框       │
└─────────────────┴─────────────────────┴──────────────────────────┘
```

**内嵌数据结构**：

| 数据类型 | 数量 | 字段 |
|----------|------|------|
| Atom | 46 个 | id, name, description, category |
| Boost | 22 个 | id, name, description, target_atom |
| MCQ 模板 | 5 个/Atom | question, options, correct_answer |

---

### v1.1 → v1.2

**核心变更**：

| 变更项 | 说明 |
|--------|------|
| PROMPT 格式 | 代码块 → 表格 + Bullet Point 混合 |
| 视频播放 | 新增中列顶部视频区域 |
| 视频行为 | autoplay + loop + 点击暂停 |

**v1.2 视频区域规格**：

| 属性 | 值 |
|------|------|
| 位置 | 中列顶部 |
| 高度 | 40% 中列高度 |
| 播放模式 | autoplay, loop, muted |
| 交互 | 点击暂停/播放 |
| 适配 | object-fit: cover |

**v1.2 反馈 5 点改进**：

| # | 改进项 | 说明 |
|---|--------|------|
| 1 | 工作流不清晰 | 需要明确两阶段：MCQ 发送 → 等待回复 → Report 发送 |
| 2 | 按钮状态不明 | 按钮应显示当前阶段状态，而非始终"发送" |
| 3 | 缺少通知 | 收到新订单/回复时无提示，需要通知系统 |
| 4 | 无音效反馈 | 关键操作无声音反馈，体验不佳 |
| 5 | 超时处理 | 用户长时间不回复时，应有超时机制 |

---

### v1.2 → v1.3（已完成）

**v1.3 核心变更**：

| 变更项 | 说明 |
|--------|------|
| 工作流 | 两阶段：Phase 1 (MCQ) → 等待 → Phase 2 (Boost+Summary) |
| 布局 | 两列：左(视频+回复) / 右(共用工作区) |
| 通知 | 动态通知系统：右上角弹出，垂直堆叠 |
| 按钮 | 状态机：5 种状态 |
| 音效 | Web Audio API |
| 超时 | 60 秒无操作自动发送空 Response |

**按钮状态机**：

| 状态 | 显示 | 触发条件 |
|------|------|----------|
| idle | 等待订单 | 初始状态 |
| phase1 | 发送 MCQ | 收到新订单 |
| waiting | 等待回复... | MCQ 已发送 |
| phase2 | 发送报告 | 收到 Response |
| complete | ✅ 已完成 | 报告已发送 |

**通知系统**：

| 属性 | 值 |
|------|------|
| 位置 | 右上角 fixed |
| 动画 | slideIn 从右侧滑入 |
| 堆叠 | 垂直向下，最新在上 |
| 自动消失 | 5 秒后 fadeOut |
| 类型 | info(蓝) / success(绿) / warning(橙) |

**v1.3 反馈 3 点问题**：

| # | 问题 | 说明 |
|---|------|------|
| 1 | 界面拥挤 | 左列视频+回复挤在一起，需要分离 |
| 2 | 文案不清 | "订单"术语不准确，应改为"Session" |
| 3 | 无 Mock 功能 | 无法模拟测试，需要添加 Mock 按钮 |

---

### v1.3 → v1.4（已完成）

**v1.4 核心变更**：

| 变更项 | v1.3 | v1.4 |
|--------|------|------|
| 左列内容 | 视频+回复 | Session Queue (280px) |
| 右列内容 | 共用工作区 | 视频+工作区 |
| 任务管理 | 单任务 | 多任务队列 |
| Mock 功能 | 无 | [+ Mock Session] 按钮 |
| 术语 | "订单" | "Session" |

**v1.4 布局**：
```
┌─────────────────────────────────────────────────────────────────┐
│  MCQ Admin Console                                 🟢 Connected │
├────────────────────┬────────────────────────────────────────────┤
│  📋 Session Queue  │  🎬 视频区域                               │
│  (280px fixed)     │  ──────────────────────────────────────── │
│  ────────────────  │  🎯 工作区                                 │
│  ┌──────────────┐  │                                           │
│  │ Session #1   │  │  Phase 1: MCQ 选择                        │
│  │ 🔄 进行中    │  │  ┌─────┐┌─────┐┌─────┐                    │
│  └──────────────┘  │  │ MCQ1││ MCQ2││ MCQ3│...                 │
│  ┌──────────────┐  │  └─────┘└─────┘└─────┘                    │
│  │ Session #2   │  │                                           │
│  │ ⏳ 等待中    │  │  Phase 2: Boost + Summary                 │
│  └──────────────┘  │  [Boost 网格] + [Summary 输入]            │
│                    │                                           │
│  [+ Mock Session]  │                        [发送]              │
└────────────────────┴────────────────────────────────────────────┘
```

**Session Queue 功能**：

| 功能 | 说明 |
|------|------|
| 多任务并行 | 同时显示多个 Session |
| 状态标识 | 🔄 进行中 / ⏳ 等待中 / ✅ 已完成 |
| 点击切换 | 点击 Session 切换到对应视频和工作区 |
| 嵌套事件 | 每个 Session 内含 MCQ→Response→Report 事件流 |

**Mock 机制**：

| 功能 | 说明 |
|------|------|
| 按钮 | [+ Mock Session] |
| 作用 | 创建模拟 Session 用于测试 |
| 数据 | 随机选择视频 + 预设 Response |

### v1.4 → v1.5（进行中）

**v1.4 问题反馈**：

| # | 问题 | 说明 |
|---|------|------|
| 1 | 卡片太大 | MCQ/Boost 卡片宽度减小，紧凑排列，一行多个 |
| 2 | Boost 内容不全 | 需显示 name + description + target_atom |
| 3 | 按钮浪费空间 | 发送按钮不要占一整行，放角落 |

**业务逻辑重构（重大变更）**：
- ❌ 之前：一个 Session = 一个用户的完整生命周期
- ✅ 现在：两类独立事件，无"用户"概念

**v1.5 两类独立事件**：

| 事件类型 | 输入 | 操作 | 输出 |
|----------|------|------|------|
| Type A: MCQ 请求 | 视频 | 选择 5 个 MCQ | 发送 MCQ Batch |
| Type B: Report 请求 | 视频 + Response JSON | 选择 Boost + 写 Summary | 发送 Mini Report |

**v1.5 布局方案**：
```
┌────────────────────┬────────────────────────────────────────────────┐
│  📋 Event Queue    │  🎬 视频区域                          [Send ➤] │
│  ────────────────  │  ─────────────────────────────────────────────│
│  ┌──────────────┐  │  🎯 工作区 (根据事件类型显示)                   │
│  │ 📹 MCQ 请求  │◄─┤                                              │
│  │    12:30     │  │  Type A: MCQ 紧凑网格                         │
│  └──────────────┘  │  ┌────┐┌────┐┌────┐┌────┐┌────┐...           │
│  ┌──────────────┐  │  └────┘└────┘└────┘└────┘└────┘              │
│  │ 📝 Report    │  │                                              │
│  │    12:25     │  │  Type B: Response + Boost网格 + Summary      │
│  └──────────────┘  │                                              │
│  [+ Mock MCQ]      │                                              │
│  [+ Mock Report]   │                                              │
└────────────────────┴────────────────────────────────────────────────┘
```

### v1.5 → v1.5.1（已完成）

**v1.5 反馈 6 点问题**：

| # | 问题 | 说明 |
|---|------|------|
| 1 | Summary 空间不足 | 输入框太小，需要更大编辑区域 |
| 2 | 完成勾重叠 | ✅ 符号与其他元素位置重叠 |
| 3 | 术语不一致 | Report Request 应改为 Boost |
| 4 | Mock 数据固定 | 每次 Mock 数据相同，应随机化 |
| 5 | 视觉弱化 | 未选中状态与选中状态对比不够明显 |
| 6 | 视频裁切问题 | 视频被裁切，应使用 object-fit: contain |

**v1.5.1 六项 UI/UX 优化**：

| # | 优化项 | 说明 |
|---|--------|------|
| 1 | Boost 两步流程 | Selection → Summary（有返回/下一步按钮） |
| 2 | Request 卡片简化 | MCQ Request → MCQ, Report Request → Boost |
| 3 | 完成状态布局 | ✅ 位置明确 + 绿色变色 |
| 4 | Mock 按钮重命名 | Mock Report → Mock Boost + 数据随机化 |
| 5 | 视觉增强 | 选中状态、自定义复选框、动效 |
| 6 | 视频适配 | 顶部栏 44px, 视频区 40%, object-fit: contain |

**额外补充**：
- 切换 Request 时视频同步切换（每个 Request 有独立视频）
- 视频自动播放（autoplay + loop + muted）

---

## MVP 通信实现

### 技术架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    Vite 多页面应用配置                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   http://localhost:3000/user/                                   │
│   ├── index.html (User 端入口)                                  │
│   └── React App (MCQ 自测界面)                                  │
│                                                                 │
│   http://localhost:3000/server/                                 │
│   ├── index.html (Server 端入口)                                │
│   └── React App (管理后台界面)                                  │
│                                                                 │
│   shared/communication.ts (共享通信模块)                         │
│   └── localStorage + storage 事件跨标签页通信                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 通信协议

**消息类型定义**：

| 消息类型 | 字段 | 类型 | 说明 |
|----------|------|------|------|
| MCQRequest | type | 'mcq_request' | 消息标识 |
| | videoUrl | string | 视频地址 |
| | timestamp | number | 时间戳 |
| MCQBatch | type | 'mcq_batch' | 消息标识 |
| | questions | MCQQuestion[] | 5 个 MCQ |
| | timestamp | number | 时间戳 |
| MCQResponse | type | 'mcq_response' | 消息标识 |
| | answers | UserAnswer[] | 用户回答 |
| | timestamp | number | 时间戳 |
| ReportRequest | type | 'report_request' | 消息标识 |
| | videoUrl | string | 视频地址 |
| | response | MCQResponse | 用户回答数据 |
| | timestamp | number | 时间戳 |
| MiniReport | type | 'mini_report' | 消息标识 |
| | boost | Boost | 推荐的 Boost |
| | summary | string | 教练总结 |
| | timestamp | number | 时间戳 |

### 文件结构

```
webapp-v6-ios-server/
├── vite.config.ts          # 多页面配置
├── shared/
│   └── communication.ts    # 跨标签页通信模块
├── user/
│   ├── index.html
│   ├── index.tsx
│   ├── App.tsx
│   └── services/
│       └── audioService.ts
└── server/
    ├── index.html
    ├── index.tsx
    ├── App.tsx
    ├── constants.ts        # ATOM_VIDEOS 映射表
    └── services/
        └── audioService.ts
```

---

## 四项优化任务

### 任务 1：MCQ 视频路径修复（致命 Bug）✅ 已完成

#### 问题 1：视频路径为空

**问题**：MCQ 发送时 `error_videos` 和 `correct_videos` 为空数组

**解决方案**：新增 `ATOM_VIDEOS` 常量映射表

**ATOM_VIDEOS 结构**（server/constants.ts）：

| atom_id | error | correct |
|---------|-------|---------|
| DM3-IS08-AT45 | /videos/Q1_6102_15-22_打球被挤到_error.mp4 | /videos/0094_挥拍转体_德约科维奇正手网球_correct.mp4 |
| DM3-IS08-AT46 | /videos/Q2_error_example.mp4 | /videos/Q2_correct_example.mp4 |
| ... | （其他 46 个 Atom 的视频映射） | |

**修改位置**：

| 文件 | 修改内容 |
|------|----------|
| server/constants.ts | 新增 ATOM_VIDEOS 常量 |
| server/App.tsx | handleSendMCQ() 函数填充视频路径 |

**handleSendMCQ() 逻辑**：

| 步骤 | 操作 |
|------|------|
| 1 | 遍历 selectedMCQs |
| 2 | 从 ATOM_VIDEOS[mcq.atom_id] 获取 error/correct 路径 |
| 3 | 填充 error_videos 和 correct_videos 字段 |
| 4 | 调用 sendMessage({ type: 'mcq_batch', questions: mcqBatch }) |

---

#### 问题 2：Vite publicDir 配置错误（视频仍黑屏）

**问题定位**：

| 项目 | 说明 |
|------|------|
| 症状 | User 端 MCQ 页面视频黑屏（路径正确但 404） |
| 根本原因 | Vite publicDir 配置错误 |
| 默认 publicDir | webapp-v6-ios-server/public/（不存在） |
| 实际视频位置 | webapp-v6-ios-server/user/public/videos/ |

**数据流追踪**：
```
Server handleSendMCQ()
    ↓ 发送 { error_videos: ['/videos/Q1_...mp4'] }
User listenForMessages()
    ↓ 接收并存入 serverQuestions state
McqPage 组件
    ↓ <video src="/videos/Q1_...mp4" />
Vite 静态文件服务
    ↓ 查找 {root}/public/videos/Q1_...mp4
❌ 404 Not Found (root 下无 public 目录)
    ↓
视频黑屏
```

**修复方案**（vite.config.ts）：

| 配置项 | 修改前 | 修改后 |
|--------|--------|--------|
| publicDir | (默认 public/) | path.resolve(__dirname, 'user/public') |

**修复状态**：

| 状态 | 说明 |
|------|------|
| ✅ 配置已修复 | vite.config.ts 添加 publicDir |
| ✅ 黑屏问题解决 | 视频可正常播放 |
| ⚠️ 视频数量有限 | 仅 5 个 Atom 有映射，其余复用默认 |

---

#### 视频扩展方案（待执行）

**当前状态**：

| 类别 | 已配置 | 待配置 |
|------|--------|--------|
| Atom 错误示范 | 5 个 (AT45, AT46, AT20, AT29, AT23) | 13+ 个 |
| 正确示范 | 2 个 (0093, 0094) | 可复用 |
| Boost 视频 | 1 个 | 可按需扩展 |

**扩展步骤**：

| 步骤 | 操作 |
|------|------|
| 1 | 准备视频文件（命名：`{来源ID}_{描述}_error.mp4`） |
| 2 | 放入 `user/public/videos/` |
| 3 | 更新 `server/constants.ts` 映射表 |
| 4 | 重启开发服务器 |

---

#### Communication PROMPT 文档更新

| 版本 | 状态 | 新增内容 |
|------|------|----------|
| v1.0 | ✅ 已完成 | 基础通信协议 |
| v1.1 | ✅ 已创建 | publicDir 配置 + ATOM_VIDEOS 映射表 |

### 任务 2：Boost 视频统一

**问题**：Boost 需要显示视频但没有对应视频资源

**解决方案**：使用统一的 Demo 视频

**handleSendReport() 修改**（server/App.tsx）：

| 字段 | 值 |
|------|------|
| type | 'mini_report' |
| boost.video | /videos/boost_demo.mp4（统一 Demo 视频） |
| summary | summaryText |

### 任务 3：Server 端语音增强

**目标**：新请求到达时播放语音提示"您有新的订单，请及时查收"

**技术方案**：Web Speech API

**AudioService 新增方法**（server/services/audioService.ts）：

| 方法 | 参数 | 功能 |
|------|------|------|
| speak(text) | text: string | 语音合成，lang='zh-CN', rate=1.1, volume=0.8 |
| playNewRequest() | - | 双音提示 (800Hz→1000Hz) + 语音"您有新的订单，请及时查收" |
| playComplete() | - | 三音上升 (800Hz→1000Hz→1200Hz) |
| playTone(freq, type, duration, volume) | 频率/波形/时长/音量 | 基础音调生成（Web Audio API） |

**App.tsx 调用替换**：

| 原调用 | 新调用 |
|--------|--------|
| audioService.playDing() | audioService.playNewRequest() |
| audioService.playSuccess() | audioService.playComplete() |

### 任务 4：User 端音效动画

**目标**：为 User 端添加完整的音效和动画反馈系统

**4 种音效类型**：

| 音效 | 触发时机 | 参数 |
|------|----------|------|
| `playTap()` | 点击按钮、选择选项 | 短促 tick |
| `playSuccess()` | 答对、完成、提交成功 | 上升和弦 |
| `playError()` | 答错、验证失败 | 下降音 |
| `playNotification()` | 收到 MCQ/Report | 双音提示 |

**6 种动画效果**：

| 动画 | 触发时机 | 效果 |
|------|----------|------|
| `fadeIn` | 页面切换 | 淡入 0.3s |
| `slideUp` | 卡片出现 | 向上滑入 |
| `pulse` | 选中状态 | 脉冲缩放 |
| `shake` | 错误提示 | 左右抖动 |
| `bounce` | 成功确认 | 弹跳效果 |
| `ripple` | 按钮点击 | 水波纹扩散 |

**触发点详细列表**：

| 页面 | 触发事件 | 音效 |
|------|----------|------|
| 首页 | 开始按钮点击 | playTap() |
| 视频上传页 | 选择文件 | playTap() |
| | 上传成功 | playSuccess() |
| MCQ 答题页 | 选择选项 | playTap() |
| | 收到题目 | playNotification() |
| | 答对 | playSuccess() |
| | 答错 | playError() |
| 等待页 | 收到 Report | playNotification() |
| 报告页 | 查看完成 | playSuccess() |

**文件修改**：

| 文件 | 修改内容 |
|------|----------|
| user/services/audioService.ts | 新建（从 Server 端复制并修改） |
| user/App.tsx | 添加音效调用点 |
| user/styles.css | 添加动画 keyframes |

---

## 执行记录

### PROMPT 文档

- 文件：`raw/PROMPT_MCQ-admin-server-v1.0.md` → `v1.5.1`
- 当前版本：v1.5.1
- 状态：✅ Gemini 生成完成

### 生成进度

- [x] Gemini 生成 v1.0
- [x] Gemini 生成 v1.1
- [x] Gemini 生成 v1.2
- [x] Gemini 生成 v1.3
- [x] Gemini 生成 v1.4
- [x] Gemini 生成 v1.5
- [x] Gemini 生成 v1.5.1（六项 UI/UX 优化）
- [x] 保存到本地 webapp-v6-ios-server/
- [x] Vite 多页面配置
- [x] localStorage 通信模块
- [x] MVP 通信机制验证
- [x] 优化任务 1：MCQ 视频路径修复（含 Vite publicDir 配置）
- [x] Communication PROMPT v1.1 创建
- [x] 优化任务 2：Boost 视频统一
- [x] 优化任务 3：Server 语音增强
- [x] 优化任务 4：User 音效动画
- [x] 用 Mock 验证两种流程（MCQ + Boost）
- [x] 验证完成标准
- [ ] 视频资源扩展（13+ Atom 映射）— P2

### 视觉/交互评价

**已确认优秀的方面**：
- 青墨绿配色系统
- 毛玻璃卡片效果
- 圆角设计
- Atom/Boost 名称和描述样式
- Tab 样式设计

---

## 偏离轨道记录

（暂无重大偏离）

---

## 后续任务（P1/P2，不是今天）

- [ ] P1：检查内容模板（AI分析报告、教练回复、自测结果、训练任务库）
- [ ] P1：用 Gemini 3 Pro 检查文件逻辑是否通畅

---

## 相关文件

### PROMPT 文档

**Server 端 Admin PROMPT**：
- 初始版本：`raw/PROMPT_MCQ-admin-server-v1.0.md`
- 当前版本：`raw/PROMPT_MCQ-admin-server-v1.5.1.md`

**Communication MVP PROMPT**：
- v1.0：`_spec/_kim_usr001/PROMPT_MCQ-communication-MVP-v1.0.md`
- v1.1：`_spec/_kim_usr001/PROMPT_MCQ-communication-MVP-v1.1.md`（新增 publicDir + ATOM_VIDEOS）

### 原始 User 端（昨日 P0）
- 位置：`webapp-v6-ios/index.html`
- 状态：✅ 已完成

### 新项目结构
```
webapp-v6-ios-server/
├── vite.config.ts
├── package.json
├── shared/
│   └── communication.ts
├── user/
│   ├── index.html
│   ├── index.tsx
│   ├── App.tsx
│   └── services/audioService.ts
└── server/
    ├── index.html
    ├── index.tsx
    ├── App.tsx
    ├── constants.ts
    └── services/audioService.ts
```

### 开发服务器
- User 端：`http://localhost:3000/user/`
- Server 端：`http://localhost:3000/server/`

---

## 待办备注（明日处理）

### 1. 视频扩展方案

**待添加到 PROMPT 文档**：`_spec/_kim_usr001/PROMPT_MCQ-communication-MVP-v1.1.md`

| 类别 | 已配置 | 待配置 |
|------|--------|--------|
| Atom 错误示范 | 5 个 (AT45, AT46, AT20, AT29, AT23) | 13+ 个 |
| 正确示范 | 2 个 (0093, 0094) | 可复用 |
| Boost 视频 | 1 个 (boost_demo.mp4) | 可按需扩展 |

**扩展步骤**：
1. 准备视频文件（命名：`{来源ID}_{描述}_error.mp4`）
2. 放入 `user/public/videos/`
3. 更新 `server/constants.ts` 映射表
4. 重启开发服务器

### 2. UI 修复备注

**问题**：User 端 mini report 的 Boost 卡片缺少标题

| 当前 | 期望 |
|------|------|
| 直接显示 Boost 内容 | 增加 "Boost" 小标题 |

**格式要求**：与 Check Tips、Summary 标题样式保持一致

---

## 完成状态

| 项目 | 状态 |
|------|------|
| P0 主目标 | ✅ 完成 |
| 四项优化任务 | ✅ 全部完成 |
| Mock 验证 | ✅ 通过 |
| 完成标准 | ✅ 达成 |
