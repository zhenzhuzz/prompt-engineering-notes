# P0: MCQ Server 端管理后台 MVP - 2025-12-25

**一句话**: 双标签页 localStorage 通信 | **状态**: ✅ 已完成 | **进度**: 7/7

---

## 核心状态

**关键发现**:
✅ v1.0→v1.5.1 共 6 次迭代完成
✅ Vite 多页面 + localStorage 通信已验证
✅ MCQ 视频黑屏问题已修复（publicDir）
⚠️ 视频资源仅 5/46 个 Atom 有映射
○ 剩余 3 项优化任务待执行

**关键数字**:
- **6** 次版本迭代 (v1.0 → v1.5.1)
- **46** 个 Atom + **22** 个 Boost 内嵌
- **5** 种消息类型 (MCQ_REQUEST → MINI_REPORT)
- **2** 分钟完整闭环（预估）

**技术栈**: Vite + React 18 + TypeScript + localStorage (零后端)

---

## 当前 Phase

```
┌──────────────────────────────────────────────────────────────┐
│  Phase 3: 优化任务                                            │
│  ✅ 任务1(视频路径)  ○ 任务2(Boost)  ○ 任务3(语音)  ○ 任务4(动画) │
└──────────────────────────────────────────────────────────────┘
```

**下一步**: 执行任务 2 → 任务 3 → 任务 4 → Mock 验证 → 完成

---

## 完成标准

| # | 标准 | 状态 |
|---|------|------|
| 1 | 打开两个浏览器标签页（User + Server） | ✅ |
| 2 | User 上传视频 → Server 收到通知 | ✅ |
| 3 | Server 选 5 MCQ → 发送 → User 收到 | ✅ |
| 4 | 两种 Mock 流程验证通过 | ✅ |

---

## 版本演进

| 版本 | 核心变更 | 布局 |
|------|----------|------|
| v1.0 | 初始版本 | 手机单列 |
| v1.0→1.1 | 手机→3K桌面, +46 Atom | 单列→三列 |
| v1.1→1.2 | +视频区域 | 中列顶部 40% |
| v1.2→1.3 | +两阶段工作流, +通知, +音效 | 两列 |
| v1.3→1.4 | +Session Queue, +Mock | 左 Queue / 右 工作区 |
| v1.4→1.5 | 业务重构: Session→独立事件 | Event Queue |
| v1.5→1.5.1 | 6 项 UI/UX 优化 | 紧凑网格 |

**v1.5 布局**:
```
┌────────────────────┬────────────────────────────────────────────────┐
│  📋 Event Queue    │  🎬 视频区域                          [Send ➤] │
│  ────────────────  │  ─────────────────────────────────────────────│
│  ┌──────────────┐  │  🎯 工作区 (根据事件类型显示)                   │
│  │ 📹 MCQ 请求  │◄─┤  Type A: MCQ 紧凑网格                         │
│  │    12:30     │  │  Type B: Response + Boost + Summary          │
│  └──────────────┘  │                                              │
│  [+ Mock MCQ]      │                                              │
│  [+ Mock Boost]    │                                              │
└────────────────────┴────────────────────────────────────────────────┘
```

**业务逻辑重构** (v1.4→v1.5):
- ❌ 之前: Session = 用户生命周期
- ✅ 现在: 两类独立事件，无"用户"概念

| 事件类型 | 输入 | 操作 | 输出 |
|----------|------|------|------|
| Type A: MCQ | 视频 | 选 5 MCQ | MCQ Batch |
| Type B: Boost | 视频+Response | 选 Boost+写 Summary | Mini Report |

---

## 通信架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    Vite 多页面应用                               │
├─────────────────────────────────────────────────────────────────┤
│  http://localhost:3000/user/     http://localhost:3000/server/  │
│  ┌─────────────┐                 ┌─────────────┐                │
│  │  User 端    │ ◄─────────────► │  Server 端  │                │
│  │  MCQ 自测   │   localStorage  │  管理后台   │                │
│  └─────────────┘   + storage 事件 └─────────────┘                │
└─────────────────────────────────────────────────────────────────┘
```

**消息协议**:

| 消息 | 方向 | Payload |
|------|------|---------|
| MCQ_REQUEST | U→S | videoUrl, timestamp |
| MCQ_BATCH | S→U | questions[5], timestamp |
| MCQ_RESPONSE | U→S | answers[], timestamp |
| REPORT_REQUEST | U→S | videoUrl, response, timestamp |
| MINI_REPORT | S→U | boost, summary, timestamp |

---

## 问题追踪

### 问题 1: MCQ 视频黑屏 ✅

**触发**: User 端收到 MCQ 后播放视频
**症状**: 视频区域黑屏，控制台 404
**定位**: Vite publicDir 配置错误
**修复**: vite.config.ts 添加 `publicDir: 'user/public'`
**状态**: ✅ 已修复

```
Server handleSendMCQ()
    ↓ 发送 { error_videos: ['/videos/Q1_...mp4'] }
User McqPage
    ↓ <video src="/videos/Q1_...mp4" />
Vite 静态文件
    ↓ 查找 {root}/public/... → ❌ 404
修复后
    ↓ 查找 user/public/... → ✅ 200
```

---

## 优化任务

| # | 任务 | 状态 | 说明 |
|---|------|------|------|
| 1 | MCQ 视频路径 | ✅ | ATOM_VIDEOS 映射 + publicDir |
| 2 | Boost 视频统一 | ✅ | 使用 /videos/boost_demo.mp4 |
| 3 | Server 语音 | ✅ | Web Speech API "您有新订单" |
| 4 | User 音效动画 | ✅ | 4 音效 + 6 动画 |

**任务 3 详情**:

| 方法 | 功能 |
|------|------|
| speak(text) | 语音合成 zh-CN |
| playNewRequest() | 双音 + 语音提示 |
| playComplete() | 三音上升 |

**任务 4 详情**:

| 音效 | 触发 |
|------|------|
| playTap() | 点击按钮 |
| playSuccess() | 答对/完成 |
| playError() | 答错 |
| playNotification() | 收到消息 |

---

## 里程碑

**进度**: P0 确认 → v1.0 → v1.1 → v1.2 → v1.3 → v1.4 → v1.5 → v1.5.1 → 通信实现 → 🔄 优化任务 → ○ 验证

---

## 相关文件

**PROMPT 文档**:
- `raw/PROMPT_MCQ-admin-server-v1.5.1.md`
- `_spec/_kim_usr001/PROMPT_MCQ-communication-MVP-v1.1.md`

**代码**:
```
webapp-v6-ios-server/
├── vite.config.ts        # publicDir: user/public
├── shared/communication.ts
├── user/                 # localhost:3000/user/
└── server/               # localhost:3000/server/
```

**服务**:
- User: http://localhost:3000/user/
- Server: http://localhost:3000/server/

---

## 版本反馈记录

### v1.2 反馈 (5 点)
✅ 工作流不清晰 → v1.3 两阶段
✅ 按钮状态不明 → v1.3 状态机
✅ 缺少通知 → v1.3 通知系统
✅ 无音效 → v1.3 Web Audio
✅ 超时处理 → v1.3 60秒自动发送

### v1.3 反馈 (3 点)
✅ 界面拥挤 → v1.4 Session Queue 分离
✅ 文案不清 → v1.4 "订单"→"Session"
✅ 无 Mock → v1.4 Mock 按钮

### v1.4 反馈 (3 点 + 业务重构)
✅ 卡片太大 → v1.5 紧凑网格
✅ Boost 内容不全 → v1.5 显示 target_atom
✅ 按钮浪费空间 → v1.5 右上角
✅ 业务重构 → v1.5 两类独立事件

### v1.5 反馈 (6 点)
✅ Summary 空间不足 → v1.5.1 两步流程
✅ 完成勾重叠 → v1.5.1 布局调整
✅ 术语不一致 → v1.5.1 Report→Boost
✅ Mock 数据固定 → v1.5.1 随机化
✅ 视觉弱化 → v1.5.1 选中增强
✅ 视频裁切 → v1.5.1 object-fit: contain

---

## 偏离轨道记录

（暂无重大偏离）

---

## 后续任务 (P1/P2)

- P1: 检查内容模板（AI报告、教练回复、自测结果）
- P1: Gemini 3 Pro 检查逻辑
- P2: 视频资源扩展 (5→46 Atom)
