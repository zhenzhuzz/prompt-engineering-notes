# 网球正手视频标注系统调研报告

> 调研日期：2024-12-14
> 目标：为网球正手动作评分 WebApp 的视频阶段标注功能提供技术方案和最佳实践参考

---

## 目录

1. [体育领域动作阶段划分标准](#1-体育领域动作阶段划分标准)
2. [专业运动分析软件参考](#2-专业运动分析软件参考)
3. [视频标注 UI/UX 最佳实践](#3-视频标注-uiux-最佳实践)
4. [开源视频标注工具](#4-开源视频标注工具)
5. [HTML5 视频技术实现](#5-html5-视频技术实现)
6. [视频指纹与识别](#6-视频指纹与识别)
7. [AI 辅助方案（未来参考）](#7-ai-辅助方案未来参考)
8. [推荐方案与实施建议](#8-推荐方案与实施建议)

---

## 1. 体育领域动作阶段划分标准

### 1.1 学术界公认的网球正手三阶段划分

根据运动生物力学研究，网球正手击球被学术界标准化为 **三个阶段、四个关键时刻**：

| 阶段 | 英文名称 | 描述 | 关键动作 |
|------|----------|------|----------|
| **Phase 1** | Back-swing / Lead-in | 引拍准备阶段 | 肩膀转离球网，球拍向后移动，上肢肌群开始参与 |
| **Phase 2** | Forward Acceleration Swing | 向前加速挥拍阶段 | 球拍开始向前移动直到击球瞬间，上下肢形成动力链 |
| **Phase 3** | Post-swing / Follow-through | 随挥收拍阶段 | 从击球瞬间到挥拍结束，上肢-球拍复合体减速 |

**四个关键时刻**：
1. 准备姿势开始
2. 引拍结束 / 向前挥拍开始 (对应你的 **t1**)
3. 击球瞬间 (对应你的 **t2**)
4. 随挥结束

> **来源**: [PMC - Biomechanical Analysis of Touch Ball Movements in Tennis Forehand Strokes](https://pmc.ncbi.nlm.nih.gov/articles/PMC9225835/)

### 1.2 动力链（Kinetic Chain）原理

学术研究强调正手击球的关键生物力学特点：

- **力量来源**: 击球力量来自下肢，通过髋部和肩部旋转传递到手臂
- **协调难点**: 下肢主要在矢状面推蹬，而躯干和上肢在水平面旋转
- **肩内旋的重要性**: 肩关节内旋是正手和发球的核心动作

> **来源**: [PMC - Biomechanics and Tennis](https://pmc.ncbi.nlm.nih.gov/articles/PMC2577481/)

### 1.3 高尔夫挥杆的类似阶段划分

高尔夫挥杆分析软件（如 GolfFix AI）将挥杆分为 **4 个部分**计算节奏：

| 阶段 | 名称 |
|------|------|
| 1 | Swing Tempo (整体节奏) |
| 2 | Backswing (上杆) |
| 3 | Top Pause (顶点停顿) |
| 4 | Downswing (下杆) |

这与网球的阶段划分理念一致，都是基于**物理运动轨迹的转折点**。

> **来源**: [GolfFix AI App](https://apps.apple.com/us/app/golffix-ai-golf-swing-analyzer/id1586120680)

---

## 2. 专业运动分析软件参考

### 2.1 主流平台对比

| 软件 | 定位 | 核心特点 | 阶段分割方式 |
|------|------|----------|--------------|
| **Dartfish** | 专业生物力学分析 | 轨迹追踪、3D测量、多相机同步 | 用静态关键帧+语音注释标记阶段 |
| **Hudl** | 团队运动战术分析 | 美国高中/大学团队标准、视频分享 | 视频剪辑+标签分类 |
| **OnForm** | 个人技术分析 | 慢动作回放、并排对比、语音反馈 | 手动标记+AI辅助 |
| **SwingVision** | 网球AI分析 | 自动记分、球速检测、高亮生成 | AI自动分割每一拍 |
| **Kinovea** | 免费开源 | 逐帧分析、角度测量、轨迹追踪 | 手动逐帧标记 |

### 2.2 Dartfish 的阶段标记方法

Dartfish Express 的独特方式：
- 拍摄**关键位置的静态照片**（如转体、顶点、击球）
- 在静态图上进行**语音注释**
- 创建一系列关键帧作为评论点

> **来源**: [Tennis Techie - Video Analysis Apps](https://www.tennistechie.com/blog/2018/6/22/di8w77d2myqrom8bwtyklg3s7xffhf-lpa9z)

### 2.3 SwingVision 的自动化方法

SwingVision（网球/匹克球AI分析应用）的特点：
- **自动检测挥拍动作**并记录
- **自动剪辑**去除死球时间
- 按**拍数(shot-by-shot)** 或 **分数(point-by-point)** 回顾视频
- 检测球速、落点深度、精度和回合长度

> **来源**: [SwingVision Official](https://swing.vision/)

### 2.4 Kinovea（免费开源）

**核心功能**：
- 逐帧播放和慢动作
- 基于 FFMpeg，支持几乎所有视频格式
- 时间显示：帧号、毫秒、标准时间码
- 标注工具：标签、箭头、曲线、自由绘制
- **双视频同步对比**
- 轨迹追踪（右键点击对象即可追踪）

> **来源**: [Kinovea Features](https://www.kinovea.org/features.html) | [GitHub](https://github.com/Kinovea/Kinovea)

---

## 3. 视频标注 UI/UX 最佳实践

### 3.1 时间线标记设计原则

#### 章节/锚点导航
- 在长视频中显示**章节标记**帮助用户跳转
- 类似网页锚点链接，允许用户直接访问特定时间点
- 在进度条上用**小点**表示章节位置

> **来源**: [NN/g - Videos as Instructional Content](https://www.nngroup.com/articles/instructional-video-guidelines/)

#### 标记交互设计
**Annotated Player**（React 视频播放器）的实现：
- 时间线上配置**可点击的标记点**
- 鼠标悬停显示：标题、描述、缩略图预览
- 点击标记时**平滑过渡**到目标位置
- 可自定义缩略图（不必使用视频帧）

> **来源**: [GitHub - annotated-player](https://github.com/TheCodeTherapy/annotated-player)

### 3.2 标注工具 UX 原则

| 原则 | 说明 |
|------|------|
| **最小化点击次数** | 减少完成标注所需的操作步骤 |
| **实时反馈** | 标注后立即显示结果 |
| **支持撤销/重做** | 允许用户修正错误 |
| **减少认知负荷** | 清晰的图标、标签和工作流 |
| **色盲友好设计** | 不仅依赖颜色，结合图标形状区分 |
| **键盘快捷键** | 提高效率（如空格暂停、←→逐帧） |

> **来源**: [Labellerr - Best Data Labeling UI](https://www.labellerr.com/blog/best-data-labeling-user-interface-tools-features-and-best-practices/)

### 3.3 视觉区分设计

研究表明，**图标+颜色组合**的标记方式效果最好：
- 仅用颜色区分风险高（色盲用户问题）
- 仅用形状可能不够显眼
- **组合使用**图标形状和颜色能最大化识别效率

> **来源**: [NN/g - Visual Indicators](https://www.nngroup.com/articles/visual-indicators-differentiators/)

### 3.4 移动端适配建议

基于 React Native Video 和相关组件库的经验：
- 使用**自定义控件**替代系统默认控件
- `seek()` 方法用于跳转到指定时间
- 考虑使用**滑块组件**（scrubber）处理精确定位
- 注意 `currentTime` 更新频率可能不够快的问题

> **来源**: [react-native-video npm](https://www.npmjs.com/package/react-native-video)

---

## 4. 开源视频标注工具

### 4.1 JavaScript/HTML5 视频标注库

| 库名 | 特点 | 适用场景 |
|------|------|----------|
| **Video.js** | 最流行的开源播放器，400k+网站使用 | 基础播放器框架 |
| **videojs-annotation-comments** | Video.js 插件，支持时间点/范围评论 | 协作标注 |
| **OpenVideoAnnotation** | 结合 annotator.js 的视频标注 | 学术研究 |
| **OAC Video Annotator** | 符合 Open Annotation 标准 | 标准化数据交换 |
| **Annotator.js** | 通用标注框架，可扩展 | 自定义标注系统 |

> **来源**:
> - [Video.js GitHub](https://github.com/videojs/video.js)
> - [videojs-annotation-comments](https://github.com/contently/videojs-annotation-comments)
> - [Annotator.js](http://annotatorjs.org/)

### 4.2 videojs-annotation-comments 功能

- 支持**时间点标记**和**时间范围标记**
- 评论/回复功能
- 使用 Handlebars 模板渲染
- 预编译模板节省约 100kb

```javascript
// 示例配置
videojs('my-video', {
  plugins: {
    annotationComments: {
      // 标记配置
    }
  }
});
```

### 4.3 CVAT（专业标注工具）

CVAT（Computer Vision Annotation Tool）的 UX 优化：
- **关键帧间边界框插值**（自动补全中间帧）
- 自动标注功能
- 关键操作快捷键

> **来源**: [ResearchGate - Tool for annotating video](https://www.researchgate.net/post/Tool-for-annotating-and-evaluating-video-object-detection-or-tracking)

---

## 5. HTML5 视频技术实现

### 5.1 currentTime 精度问题

#### 基本特性
- `currentTime` 是**双精度浮点数**，单位为秒
- 设置该值会触发视频 seek

#### 精度限制
```
⚠️ 重要警告：
- 出于安全考虑（防止时序攻击和指纹识别），浏览器可能降低精度
- Firefox 可能将精度降低到 2ms
- currentTime 是时间值，不是帧号
- 内部舍入可能导致跳转到前一帧末尾而非目标帧开头
- HTML5 video 不保证逐帧精确 seek
```

> **来源**: [MDN - currentTime](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/currentTime) | [W3C - Frame accurate seeking issue](https://github.com/w3c/media-and-entertainment/issues/4)

#### 解决方案：requestVideoFrameCallback

```javascript
// 使用 mediaTime 获取精确的帧时间戳
video.requestVideoFrameCallback((now, metadata) => {
  // metadata.mediaTime 是精确的 PTS（演示时间戳）
  // 比 video.currentTime 更准确
  console.log('Precise time:', metadata.mediaTime);
});
```

> **来源**: [web.dev - requestVideoFrameCallback](https://web.dev/requestvideoframecallback-rvfc/)

#### VideoFrame 库（帧号支持）

如果需要帧号和 SMPTE 时间码支持，可使用 **VideoFrame** 库：

```javascript
// 根据已知帧率计算帧号
const frameNumber = Math.floor(video.currentTime * fps);
```

> **来源**: [VideoFrame Docs](https://allensarkisyan.github.io/VideoFrameDocs/)

### 5.2 视频片段循环播放

#### 方法1：timeupdate 事件监听

```javascript
const video = document.getElementById('video');
let loopStart = 5.0;  // t1
let loopEnd = 8.5;    // t2

video.addEventListener('timeupdate', function() {
  if (video.currentTime >= loopEnd) {
    video.currentTime = loopStart;
    video.play();
  }
});
```

#### 方法2：完整实现（带UI控制）

```javascript
const video = document.getElementById('video');

function setupLoop(startTime, endTime) {
  video.addEventListener('timeupdate', function checkLoop() {
    if (video.currentTime < startTime || video.currentTime >= endTime) {
      video.currentTime = startTime;
    }
  });
}

// 使用
setupLoop(t1, t2);
```

#### 方法3：Media Fragment URI

```html
<!-- 直接在 URL 中指定播放范围 -->
<video src="video.mp4#t=5,10"></video>
```

```javascript
// 动态设置
video.src = 'video.mp4#t=' + startTime + ',' + endTime;
```

#### 方法4：Video.js AB Loop 插件

```javascript
// 使用 videojs-abloop 插件
videojs('video', {
  plugins: {
    abLoopPlugin: {
      start: 5,      // 开始时间
      end: 8.5,      // 结束时间
      enabled: true
    }
  }
});
```

> **来源**: [GitHub - videojs-abloop](https://github.com/phhu/videojs-abloop) | [Stack Overflow](https://stackoverflow.com/questions/21251979/play-full-html5-video-and-then-loop-a-section-of-it)

#### 注意事项

```
⚠️ 循环播放的已知问题：
- 某些视频可能无法瞬时切换 currentTime
- 循环之间可能有延迟
- 使用两个视频元素交替播放可能更可靠
- 原生 loop 属性没有延迟问题
```

### 5.3 localStorage 存储方案

#### 推荐的数据结构

```javascript
// 视频标注数据结构
const videoAnnotation = {
  // 视频标识
  videoId: "hash_or_filename",
  fileName: "forehand_practice.mp4",
  fileSize: 15728640,  // bytes
  duration: 12.5,      // seconds

  // 标注时间点
  annotations: {
    t1: 2.35,          // 分腿垫步结束（可为 null）
    t2: 3.82,          // 击球瞬间
    hasPhase1: true    // 是否有准备阶段
  },

  // 元数据
  createdAt: "2024-12-14T10:30:00Z",
  updatedAt: "2024-12-14T10:35:00Z",
  version: 1
};

// 存储
localStorage.setItem(
  `tennis_annotation_${videoAnnotation.videoId}`,
  JSON.stringify(videoAnnotation)
);

// 读取
const saved = JSON.parse(
  localStorage.getItem(`tennis_annotation_${videoId}`)
);
```

#### 视频识别的 Key 生成

```javascript
// 简单方案：文件名 + 文件大小
function generateVideoKey(file) {
  return `${file.name}_${file.size}`;
}

// 更可靠方案：包含修改时间
function generateVideoKeyV2(file) {
  return `${file.name}_${file.size}_${file.lastModified}`;
}
```

#### 存储限制

```
localStorage 限制：
- 大多数浏览器允许 5MB+ 存储空间
- Key 和 Value 必须是字符串
- 使用 JSON.stringify/parse 处理对象
- 数据在页面刷新和浏览器重启后保留
```

> **来源**: [javascript.info - localStorage](https://javascript.info/localstorage)

---

## 6. 视频指纹与识别

### 6.1 感知哈希（Perceptual Hashing）概述

感知哈希与加密哈希不同：
- **加密哈希**: 输入微小变化导致输出剧烈变化
- **感知哈希**: 相似内容产生相似的哈希值
- 能够容忍：旋转、倾斜、对比度调整、不同压缩格式

> **来源**: [pHash.org](https://www.phash.org/) | [Wikipedia - Perceptual hashing](https://en.wikipedia.org/wiki/Perceptual_hashing)

### 6.2 视频指纹方案（Node.js）

**node-video-hash** 的工作原理：
1. 使用 FFmpeg 在固定间隔截取帧
2. 对每帧进行感知哈希
3. 合并所有帧哈希生成最终哈希（默认 SHA256）

```javascript
// 需要安装 FFmpeg
const videoHash = require('video-hash');

const hash = await videoHash('video.mp4');
// 返回唯一的视频指纹
```

> **来源**: [GitHub - node-video-hash](https://github.com/KyleRoss/node-video-hash)

### 6.3 浏览器端简化方案

由于浏览器不能运行 FFmpeg，可以使用简化方案：

```javascript
// 方案1：文件元数据组合
function getVideoIdentifier(file) {
  return {
    name: file.name,
    size: file.size,
    lastModified: file.lastModified,
    type: file.type
  };
}

// 方案2：使用 Canvas 提取首帧进行哈希
async function getFirstFrameHash(videoUrl) {
  const video = document.createElement('video');
  video.src = videoUrl;
  await video.play();
  video.pause();
  video.currentTime = 0.1; // 跳过可能的黑屏

  const canvas = document.createElement('canvas');
  canvas.width = 64;  // 小尺寸足够
  canvas.height = 64;
  const ctx = canvas.getContext('2d');
  ctx.drawImage(video, 0, 0, 64, 64);

  // 简单的像素哈希
  const imageData = ctx.getImageData(0, 0, 64, 64);
  // ... 计算哈希
}
```

### 6.4 哈希比较：汉明距离

```javascript
// 比较两个感知哈希的相似度
function hammingDistance(hash1, hash2) {
  let distance = 0;
  for (let i = 0; i < hash1.length; i++) {
    if (hash1[i] !== hash2[i]) distance++;
  }
  return distance;
}

// 距离判断：
// 0-3: 非常相似（可能是同一视频）
// 4-10: 相似
// >10: 不同视频
```

---

## 7. AI 辅助方案（未来参考）

### 7.1 浏览器端姿态估计模型

TensorFlow.js 提供三个主要模型：

| 模型 | 关键点数 | 速度 | 适用场景 |
|------|----------|------|----------|
| **MoveNet Lightning** | 17 | 50+ FPS | 实时应用，低延迟 |
| **MoveNet Thunder** | 17 | 较慢 | 高精度需求 |
| **BlazePose** | 33 | 中等 | 需要手部/面部细节 |

> **来源**: [TensorFlow Blog - MoveNet](https://blog.tensorflow.org/2021/05/next-generation-pose-detection-with-movenet-and-tensorflowjs.html)

### 7.2 基础使用示例

```javascript
import * as poseDetection from '@tensorflow-models/pose-detection';

// 创建检测器
const detector = await poseDetection.createDetector(
  poseDetection.SupportedModels.MoveNet,
  { modelType: poseDetection.movenet.modelType.SINGLEPOSE_LIGHTNING }
);

// 检测姿态
const poses = await detector.estimatePoses(videoElement);

// 返回的关键点
poses[0].keypoints.forEach(keypoint => {
  console.log(keypoint.name, keypoint.x, keypoint.y, keypoint.score);
});
```

### 7.3 关键帧检测的研究方向

学术研究的自动阶段分割方法：

| 方法 | 输入 | 特点 |
|------|------|------|
| **深度神经网络序列分类** | 传感器数据 | 在线检测，支持边界状态定义 |
| **关键帧提取 + CNN** | 视频帧 | 先 FCN 提取 ROI，再 CNN 估计姿态概率 |
| **聚类 + 多特征融合** | 视频 | 基于场景聚类提取关键帧 |

> **来源**: [MDPI - On-Line Detection and Segmentation of Sports Motions](https://www.mdpi.com/1424-8220/18/3/913)

### 7.4 实现建议

#### 短期方案（无 AI）
```
用户手动标注 → 存储到 localStorage → 用于 MCQ 诊断
```

#### 中期方案（轻量 AI 辅助）
```
1. 使用 MoveNet 检测关键点
2. 监测脚部关键点位置变化 → 检测分腿垫步
3. 监测手腕速度峰值 → 估计击球点
4. 提供 AI 建议，用户确认/调整
```

#### 长期方案（全自动）
```
1. 训练专门的网球动作分类模型
2. 使用 Temporal Action Localization 技术
3. 自动分割并标注每个动作阶段
```

### 7.5 JS AI Body Tracker 库

一个封装好的浏览器端姿态估计库：

```javascript
// 支持 MoveNet、PoseNet、BlazePose
// 无需 Node.js，直接在浏览器运行
import { BodyTracker } from 'js-ai-body-tracker';

const tracker = new BodyTracker('movenet');
await tracker.load();

const pose = await tracker.detect(videoElement);
```

> **来源**: [GitHub - js-ai-body-tracker](https://github.com/szczyglis-dev/js-ai-body-tracker)

---

## 8. 推荐方案与实施建议

### 8.1 标注流程优化建议

基于调研结果，对你现有设计的优化建议：

#### 引导文案优化

| 原文案 | 建议改为 | 原因 |
|--------|----------|------|
| "分腿垫步" | "双脚同时落地" | 用物理事件替代术语 ✓ |
| "击球点" | "球拍碰到球的那一刻" | 更直观 ✓ |
| "准备阶段" | "落地前" | 用户更容易理解时间概念 |

#### 视觉引导建议

```
推荐方式：简笔画 + 文字描述
├── 不要使用真实视频截图（避免用户找"一模一样"的画面）
├── 使用抽象的动作轮廓图
├── 标注关键身体部位（脚、球拍、球）
└── 可参考 Kinovea 的人体模型工具设计
```

### 8.2 UI 组件推荐

#### 进度条标记设计

```javascript
// 推荐的标记 UI 结构
const MarkerUI = {
  // 进度条上的标记点
  markers: [
    { time: t1, color: '#4CAF50', icon: '👟', label: '落地' },
    { time: t2, color: '#2196F3', icon: '🎾', label: '击球' }
  ],

  // 鼠标悬停预览
  hoverPreview: {
    showThumbnail: true,
    showTime: true,
    showLabel: true
  },

  // 键盘快捷键
  shortcuts: {
    'Space': 'toggle play/pause',
    'ArrowLeft': 'seek -1 frame',
    'ArrowRight': 'seek +1 frame',
    ',': 'seek -0.1s (fine)',
    '.': 'seek +0.1s (fine)',
    '1': 'mark t1',
    '2': 'mark t2'
  }
};
```

### 8.3 localStorage 数据结构（最终版）

```javascript
const VideoAnnotationSchema = {
  // 主键：用于快速查找
  key: "tennis_v1_{videoIdentifier}",

  // 数据结构
  value: {
    // 视频识别信息
    video: {
      name: String,        // 文件名
      size: Number,        // 字节数
      duration: Number,    // 时长（秒）
      lastModified: Number // 文件修改时间戳
    },

    // 标注数据
    annotations: {
      t1: Number | null,   // 分腿垫步时间点
      t2: Number,          // 击球时间点（必填）
      hasPhase1: Boolean   // 是否有准备阶段
    },

    // 诊断状态
    diagnosis: {
      selectedStroke: Number,  // 选择分析第几次击球
      completedQuestions: [],  // 已完成的问题ID
      answers: {}              // 答案记录
    },

    // 元数据
    meta: {
      version: 1,
      createdAt: String,   // ISO 时间
      updatedAt: String,
      appVersion: String
    }
  }
};
```

### 8.4 技术实现清单

#### 必须实现
- [ ] HTML5 video 播放器自定义控件
- [ ] 进度条点击/拖拽定位
- [ ] 标记点的添加/编辑/删除
- [ ] 标记点的视觉反馈（进度条上的点）
- [ ] localStorage 存储与读取
- [ ] 同文件自动加载历史标注

#### 建议实现
- [ ] 键盘快捷键（逐帧、快进、标记）
- [ ] 片段循环播放（t1-t2）
- [ ] 播放速度控制（0.25x - 2x）
- [ ] 标记时的帧预览/缩略图

#### 未来考虑
- [ ] MoveNet 姿态检测辅助
- [ ] 自动检测脚落地/球拍接触
- [ ] 视频指纹去重

### 8.5 性能优化建议

```javascript
// timeupdate 事件节流
let lastUpdateTime = 0;
video.addEventListener('timeupdate', function() {
  const now = Date.now();
  if (now - lastUpdateTime < 50) return; // 50ms 节流
  lastUpdateTime = now;

  // 更新 UI
  updateProgressBar(video.currentTime);
  checkLoopBoundary(video.currentTime);
});

// 使用 requestAnimationFrame 更新 UI
function smoothProgressUpdate() {
  updateProgressBar(video.currentTime);
  if (!video.paused) {
    requestAnimationFrame(smoothProgressUpdate);
  }
}
video.addEventListener('play', smoothProgressUpdate);
```

---

## 参考资源汇总

### 学术资源
- [PMC - Biomechanical Analysis of Tennis Forehand](https://pmc.ncbi.nlm.nih.gov/articles/PMC9225835/)
- [PMC - Biomechanics and Tennis](https://pmc.ncbi.nlm.nih.gov/articles/PMC2577481/)
- [MDPI - On-Line Detection and Segmentation of Sports Motions](https://www.mdpi.com/1424-8220/18/3/913)

### 软件工具
- [Kinovea - 免费开源](https://www.kinovea.org/)
- [SwingVision - 网球AI分析](https://swing.vision/)
- [OnForm - 运动视频分析](https://onform.com/)
- [Dartfish - 专业分析](https://www.dartfish.com/)

### 开发资源
- [Video.js](https://github.com/videojs/video.js)
- [videojs-abloop](https://github.com/phhu/videojs-abloop)
- [videojs-annotation-comments](https://github.com/contently/videojs-annotation-comments)
- [TensorFlow.js Pose Detection](https://github.com/tensorflow/tfjs-models/tree/master/pose-detection)
- [js-ai-body-tracker](https://github.com/szczyglis-dev/js-ai-body-tracker)

### 技术文档
- [MDN - HTMLMediaElement.currentTime](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/currentTime)
- [web.dev - requestVideoFrameCallback](https://web.dev/requestvideoframecallback-rvfc/)
- [NN/g - Video UX Guidelines](https://www.nngroup.com/articles/instructional-video-guidelines/)

---

> **文档版本**: 1.0
> **最后更新**: 2024-12-14
