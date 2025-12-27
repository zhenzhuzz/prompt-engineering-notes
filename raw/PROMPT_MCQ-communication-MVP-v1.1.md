# MCQ 双端通信 MVP - 实现规范

**版本**: v1.1
**日期**: 2025-12-25
**目标**: User ↔ Server localStorage 通信验证
**前置依赖**: webapp-v6-ios-server (User 端 + Server 端已完成)

---

## 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| v1.1 | 2025-12-25 | 修复 Vite publicDir 配置；新增视频映射表；更新端口和音效 |
| v1.0 | 2025-12-25 | 初始版本 |

---

## TL;DR 核心方案

```
┌──────────────────────────────────────────────────────────────────┐
│  核心思路: localStorage 做跨标签页消息总线                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  User 标签页                        Server 标签页                 │
│  ───────────                        ────────────                 │
│  localStorage.setItem() ──────────► storage 事件监听             │
│  storage 事件监听 ◄──────────────── localStorage.setItem()       │
│                                                                  │
│  发消息 = 写 localStorage                                        │
│  收消息 = 监听 storage 事件 (自动在其他标签页触发)                  │
│                                                                  │
│  同源限制 → 两个标签页必须在同一个 origin (域名+端口)               │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 通信流程图

```
User 端                                Server 端
────────                               ─────────
   │                                      │
   │ [上传视频 → 裁剪 → AI等待页]           │
   │                                      │
   │ ═══ MCQ_REQUEST ════════════════════►│ (Base64 视频)
   │                                      │ 自动创建 MCQ 卡片
   │                                      │ 管理员选 5 个 MCQ
   │                                      │ 点击 [Send MCQ Batch]
   │◄═══ MCQ_SELECTED ═════════════════════│
   │                                      │
   │ [显示 5 道题，用户回答]                 │
   │                                      │
   │ ═══ REPORT_REQUEST ═════════════════►│ (视频 + 5个回答)
   │                                      │ 自动创建 Boost 卡片
   │                                      │ 管理员选 Boost + 写 Summary
   │                                      │ 点击 [Send Mini Report]
   │◄═══ REPORT_GENERATED ═════════════════│
   │                                      │
   │ [显示 Mini Report]                    │
   ▼                                      ▼
```

---

## 通信协议

### localStorage Keys

| Key | 方向 | 说明 |
|-----|------|------|
| `mcq_user_to_server` | User → Server | 客户端发送的消息 |
| `mcq_server_to_user` | Server → User | 服务端发送的消息 |

### 消息类型定义

| 类型 | 方向 | 触发时机 | payload |
|------|------|----------|---------|
| `MCQ_REQUEST` | U→S | User 进入 AI 等待页 | videoDataUrl, videoDuration |
| `MCQ_SELECTED` | S→U | Server 选完 MCQ 点发送 | questions[] (5个) |
| `REPORT_REQUEST` | U→S | User 答完 5 题 | videoDataUrl, responses[] |
| `REPORT_GENERATED` | S→U | Server 生成报告点发送 | atoms[], summary, boost |

---

## 消息格式详细定义

### MCQ_REQUEST (User → Server)

| 字段路径 | 类型 | 说明 |
|----------|------|------|
| `type` | string | `"MCQ_REQUEST"` |
| `timestamp` | number | Unix 时间戳 |
| `payload.videoDataUrl` | string | Base64 编码的视频 |
| `payload.videoDuration` | number | 视频时长 (秒) |

### MCQ_SELECTED (Server → User) [v1.1 更新]

| 字段路径 | 类型 | 说明 |
|----------|------|------|
| `type` | string | `"MCQ_SELECTED"` |
| `timestamp` | number | Unix 时间戳 |
| `payload.questions` | array | 5 个问题对象 |
| `payload.questions[].question_id` | string | Q1-Q5 |
| `payload.questions[].atom_id` | string | 如 `"AT45"` |
| `payload.questions[].atom_name_cn` | string | 如 `"被挤着打"` |
| `payload.questions[].dimension_cn` | string | 如 `"击球点"` |
| `payload.questions[].description` | string | 错误描述 |
| `payload.questions[].error_videos` | string[] | 错误示范视频路径 |
| `payload.questions[].correct_videos` | string[] | 正确示范视频路径 |

### REPORT_REQUEST (User → Server)

| 字段路径 | 类型 | 说明 |
|----------|------|------|
| `type` | string | `"REPORT_REQUEST"` |
| `timestamp` | number | Unix 时间戳 |
| `payload.videoDataUrl` | string | Base64 编码的视频 |
| `payload.videoDuration` | number | 视频时长 (秒) |
| `payload.responses` | array | 5 个回答对象 |
| `payload.responses[].question_id` | string | Q1-Q5 |
| `payload.responses[].atom_id` | string | Atom ID |
| `payload.responses[].atom_name_cn` | string | Atom 中文名 |
| `payload.responses[].has_error` | boolean | 用户是否有此错误 |

### REPORT_GENERATED (Server → User) [v1.1 更新]

| 字段路径 | 类型 | 说明 |
|----------|------|------|
| `type` | string | `"REPORT_GENERATED"` |
| `timestamp` | number | Unix 时间戳 |
| `payload.atoms` | array | 5 个诊断结果 |
| `payload.summary.insight` | string | AI 生成的洞察 |
| `payload.recommended_boost.boost_id` | string | Boost ID |
| `payload.recommended_boost.boost_name_cn` | string | Boost 中文名 |
| `payload.recommended_boost.description` | string | Boost 描述 |
| `payload.recommended_boost.target_atom` | string | 目标 Atom |
| `payload.recommended_boost.video` | string | Boost 视频路径 [v1.1 新增] |

---

## Vite 配置 [v1.1 更新]

### 多页应用 + 静态资源配置

```typescript
// webapp-v6-ios-server/vite.config.ts
import path from 'path';
import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, '.', '');

  return {
    root: __dirname,
    publicDir: path.resolve(__dirname, 'user/public'),  // [v1.1] 修复视频路径
    server: {
      port: 3000,
      host: '0.0.0.0',
      fs: {
        allow: ['..'],
      },
    },
    plugins: [react()],
    build: {
      rollupOptions: {
        input: {
          user: path.resolve(__dirname, 'user/index.html'),
          admin: path.resolve(__dirname, 'server/index.html'),
        },
      },
    },
    define: {
      'process.env.GEMINI_API_KEY': JSON.stringify(env.GEMINI_API_KEY),
    },
    resolve: {
      alias: {
        '@shared': path.resolve(__dirname, 'shared'),
      },
    },
  };
});
```

### 关键配置说明

| 配置项 | 值 | 说明 |
|--------|-----|------|
| `root` | `__dirname` | 项目根目录 |
| `publicDir` | `user/public` | [v1.1] 静态资源目录，解决视频 404 问题 |
| `server.port` | 3000 | 开发服务器端口 |

### 访问地址

| 端 | URL |
|----|-----|
| User | http://localhost:3000/user/ |
| Server | http://localhost:3000/server/ |

---

## 视频资源配置 [v1.1 新增]

### 目录结构

```
webapp-v6-ios-server/
├── user/
│   └── public/
│       └── videos/
│           ├── Q1_6102_15-22_打球被挤到_error.mp4
│           ├── Q2_6101_07-28_翻腕_翻拍面_error.mp4
│           ├── Q3_2202_21-27_髋部原地转动踩烟头_error.mp4
│           ├── Q4_2402_01-06_左臂先打开_error.mp4
│           ├── Q5_2301_23-32_不转腰髋引拍_error.mp4
│           ├── 0093_收拍_德约科维奇正手网球_correct.mp4
│           ├── 0094_挥拍转体_德约科维奇正手网球_correct.mp4
│           └── BO_6102_30-01_09_被挤到解决办法_球起架拍球落找球_boost.mp4
├── server/
│   └── constants.ts  (ATOM_VIDEOS 映射表)
└── vite.config.ts    (publicDir 配置)
```

### Server 端视频映射表

```typescript
// server/constants.ts

// Atom 视频映射表 - 用于 MCQ_SELECTED 消息
export const ATOM_VIDEOS: Record<string, { error: string[], correct: string[] }> = {
  'AT45': {
    error: ['/videos/Q1_6102_15-22_打球被挤到_error.mp4'],
    correct: ['/videos/0094_挥拍转体_德约科维奇正手网球_correct.mp4']
  },
  'AT46': {
    error: ['/videos/Q2_6101_07-28_翻腕_翻拍面_error.mp4'],
    correct: ['/videos/0094_挥拍转体_德约科维奇正手网球_correct.mp4']
  },
  'AT20': {
    error: ['/videos/Q3_2202_21-27_髋部原地转动踩烟头_error.mp4'],
    correct: ['/videos/0094_挥拍转体_德约科维奇正手网球_correct.mp4']
  },
  'AT29': {
    error: ['/videos/Q4_2402_01-06_左臂先打开_error.mp4'],
    correct: ['/videos/0093_收拍_德约科维奇正手网球_correct.mp4']
  },
  'AT23': {
    error: ['/videos/Q5_2301_23-32_不转腰髋引拍_error.mp4'],
    correct: ['/videos/0094_挥拍转体_德约科维奇正手网球_correct.mp4']
  }
};

// 默认视频路径 (当 Atom 没有配置视频时使用)
export const DEFAULT_VIDEOS = {
  error: ['/videos/Q1_6102_15-22_打球被挤到_error.mp4'],
  correct: ['/videos/0094_挥拍转体_德约科维奇正手网球_correct.mp4']
};
```

### handleSendMCQ 中的视频路径填充

```typescript
// server/App.tsx
const handleSendMCQ = () => {
  const questions = DIMENSIONS.map((dm, idx) => {
    const atomId = selectedAtoms[dm.id];
    const atom = ATOMS.find(a => a.id === atomId);
    return {
      question_id: `Q${idx + 1}`,
      atom_id: atomId,
      atom_name_cn: atom?.name || '',
      dimension_cn: dm.name,
      description: atom?.description || '',
      // [v1.1] 从 ATOM_VIDEOS 查询，或使用默认值
      error_videos: ATOM_VIDEOS[atomId]?.error || DEFAULT_VIDEOS.error,
      correct_videos: ATOM_VIDEOS[atomId]?.correct || DEFAULT_VIDEOS.correct
    };
  });

  sendMessage(STORAGE_KEYS.SERVER_TO_USER, MessageType.MCQ_SELECTED, { questions });
};
```

### 视频扩展方案

当需要为更多 Atom 配置专属视频时：

1. **添加视频文件**: 将新视频放入 `user/public/videos/`
2. **更新映射表**: 在 `server/constants.ts` 的 `ATOM_VIDEOS` 中添加新条目
3. **命名规范**:
   - 错误示范: `{来源ID}_{描述}_error.mp4`
   - 正确示范: `{来源ID}_{描述}_correct.mp4`
   - Boost: `BO_{来源ID}_{描述}_boost.mp4`

---

## 音效系统 [v1.1 更新]

Server 端使用 Web Audio API + Web Speech API 提供音效反馈：

| 触发场景 | 方法 | 说明 |
|----------|------|------|
| 新 Request 到达 | `audioService.playNewRequest()` | 双音叮咚 + 语音"您有新的订单" |
| Request 完成 | `audioService.playComplete()` | 三音上升 |

```typescript
// 监听消息时播放音效
if (msg.type === MessageType.MCQ_REQUEST) {
  setRequests(prev => [newReq, ...prev]);
  audioService.playNewRequest();  // [v1.1] 替换 playDing()
}
```

---

## 测试验证清单

| 步骤 | User 端操作 | Server 端操作 | 验证点 |
|------|-------------|---------------|--------|
| 1 | 打开 http://localhost:3000/user/ | 打开 http://localhost:3000/server/ | 两个标签页 |
| 2 | 输入名字 → Start | - | 进入上传页 |
| 3 | 上传视频 → 裁剪 → 下一步 | - | 进入 AI 等待页 |
| 4 | - | 看到新 MCQ 卡片 + 语音提示 | MCQ_REQUEST 接收成功 |
| 5 | - | 选 5 个 MCQ → 点发送 | - |
| 6 | 看到 5 道题 + 视频播放 | - | MCQ_SELECTED 接收成功 + 视频正常 |
| 7 | 回答 5 题 → 完成 | - | 进入报告等待页 |
| 8 | - | 看到新 Boost 卡片 + 语音提示 | REPORT_REQUEST 接收成功 |
| 9 | - | 选 Boost → 写 Summary → 发送 | - |
| 10 | 看到 Mini Report + Boost 视频 | - | REPORT_GENERATED 接收成功 |

---

## 已知限制

### 视频覆盖范围

当前只有 5 个 Atom 配置了专属视频：

| Atom ID | 名称 | 视频状态 |
|---------|------|----------|
| AT45 | 被挤着打 | 专属错误/正确示范 |
| AT46 | 靠手腕翻 | 专属错误/正确示范 |
| AT20 | 转髋滞后 | 专属错误/正确示范 |
| AT29 | 左手先收 | 专属错误/正确示范 |
| AT23 | 只拉手引拍 | 专属错误/正确示范 |
| 其他 | - | 使用默认视频 |

### 扩展视频的操作步骤

1. 准备新的错误示范和正确示范视频
2. 按命名规范放入 `user/public/videos/`
3. 在 `server/constants.ts` 的 `ATOM_VIDEOS` 中添加映射
4. 重启开发服务器验证

---

## 迁移路径 (同端口 → 双端口 → 远程)

| 阶段 | 通信方式 | 限制 | 改动量 |
|------|----------|------|--------|
| MVP | localStorage | 同源 | 基础实现 |
| 双端口 | BroadcastChannel | 同源 | 换通信模块 (~20行) |
| 远程部署 | WebSocket | 无限制 | 换通信模块 (~50行) |

**关键设计**: 通信逻辑封装在 `sendMessage()` / `listenForMessages()` 中，业务代码只调用这两个函数，不关心底层实现。迁移时只需替换通信模块，业务代码零修改。

---

## 文件修改清单 [v1.1 更新]

| 文件 | 操作 | 说明 |
|------|------|------|
| `vite.config.ts` | 修改 | 添加 publicDir 配置 |
| `shared/communication.ts` | 无变化 | 通信模块 |
| `server/constants.ts` | 修改 | 添加 ATOM_VIDEOS 映射表 |
| `server/App.tsx` | 修改 | handleSendMCQ 填充视频路径 |
| `server/services/audioService.ts` | 修改 | 新增 playNewRequest/playComplete |
| `user/public/videos/` | 新增文件 | 放置视频资源 |

---

## 待办：视频资源扩展

### 当前覆盖状态

| Atom ID | 名称 | 维度 | 视频状态 |
|---------|------|------|----------|
| AT45 | 被挤着打 | DM3 击球点 | ✅ 专属视频 |
| AT46 | 靠手腕翻 | DM4 动力链 | ✅ 专属视频 |
| AT20 | 转髋滞后 | DM2 转体引拍 | ✅ 专属视频 |
| AT29 | 左手先收 | DM2 转体引拍 | ✅ 专属视频 |
| AT23 | 只拉手引拍 | DM2 转体引拍 | ✅ 专属视频 |
| AT01 | 重心落脚后跟 | DM1 准备姿势 | ⏳ 使用默认 |
| AT02 | 往上跳(马里奥跳) | DM1 准备姿势 | ⏳ 使用默认 |
| AT03 | 提前侧身 | DM1 准备姿势 | ⏳ 使用默认 |
| AT04 | 分腿过大 | DM1 准备姿势 | ⏳ 使用默认 |
| AT05 | 僵尸跳 | DM1 准备姿势 | ⏳ 使用默认 |
| AT08 | 重心后仰 | DM1 准备姿势 | ⏳ 使用默认 |
| AT14 | 虎口位置错误 | DM1 准备姿势 | ⏳ 使用默认 |
| AT16 | 转肩抬右肩 | DM2 转体引拍 | ⏳ 使用默认 |
| AT17 | 转肩不充分 | DM2 转体引拍 | ⏳ 使用默认 |
| AT26 | 左手没伸出 | DM2 转体引拍 | ⏳ 使用默认 |
| AT32 | 击球点过高 | DM3 击球点 | ⏳ 使用默认 |
| AT33 | 击球点过低 | DM3 击球点 | ⏳ 使用默认 |
| AT37 | 大力蹬转 | DM4 动力链 | ⏳ 使用默认 |
| AT38 | 蹬转无力 | DM4 动力链 | ⏳ 使用默认 |
| AT41 | 收不住拍 | DM5 随挥恢复 | ⏳ 使用默认 |
| AT42 | 横向甩臂 | DM5 随挥恢复 | ⏳ 使用默认 |

### 扩展操作步骤

1. **准备视频**: 按命名规范 `{来源ID}_{描述}_error.mp4` / `_correct.mp4`
2. **放入目录**: `webapp-v6-ios-server/user/public/videos/`
3. **更新映射**: 在 `server/constants.ts` 的 `ATOM_VIDEOS` 添加新条目
4. **验证**: 重启 dev server，选择对应 Atom 测试视频显示
