---
id: KNOW-20251222-backend-stack-learning
type: tech_blog
created_at: 2025-12-22
cards:
  - CARD-20251222-0007
  - CARD-20251222-0008
  - CARD-20251222-0009
  - CARD-20251222-0010
sensitivity: public
---

# 后端技术栈：概念地图与最小学习路径

## One Paragraph Takeaway

后端技术栈可按四层理解：Runtime（框架/RPC）→ Data（存储/缓存/消息）→ Infra（容器/编排）→ Delivery（CI/CD）（CARD-20251222-0007）。学习路径应分阶段推进：容器 → 缓存消息 → 编排（CARD-20251222-0008）。选型决策上，Kafka vs RabbitMQ 取决于是否需要事件重放和高吞吐（CARD-20251222-0009）；Kubernetes 是否 overkill 取决于服务规模和伸缩需求（CARD-20251222-0010）。

## The Essence

```
┌─────────────────────────────────────────────────────────────┐
│  Delivery Layer        Git, Jenkins                         │
├─────────────────────────────────────────────────────────────┤
│  Infrastructure Layer  Docker, K8s, Nginx, Nacos/ZK         │
├─────────────────────────────────────────────────────────────┤
│  Data Layer            MySQL/PG, Redis, ES, Kafka/RabbitMQ  │
├─────────────────────────────────────────────────────────────┤
│  Runtime Layer         Spring Boot, gRPC, Dubbo             │
└─────────────────────────────────────────────────────────────┘

Learning Path (CARD-20251222-0008):
Phase 1: Docker + MySQL ──► Phase 2: Redis + MQ ──► Phase 3: K8s + Nginx
```

## Minimal Learning Path

根据 CARD-20251222-0008，对于有 Docker/MySQL/Git 基础的学习者：

| 阶段 | 重点 | 验证实验 |
|------|------|----------|
| Phase 1 | 容器与数据库巩固 | Docker 部署 MySQL + 简单 API |
| Phase 2 | 缓存与消息入门 | API 加 Redis 缓存 + Kafka 写日志 |
| Phase 3 | 编排与可观测进阶 | K8s 多副本 + Nginx 负载均衡 |

**暂缓学习**：gRPC/Dubbo、Nacos/ZK、ES、Jenkins — 等触发条件出现再学。

## Decision Boundaries

### Kafka vs RabbitMQ（CARD-20251222-0009）

| 场景 | 选择 |
|------|------|
| 需要事件重放/审计日志 | Kafka |
| 吞吐量 > 10 万/秒 | Kafka |
| 需要灵活路由/消息优先级 | RabbitMQ |
| 运维复杂度敏感 | RabbitMQ |

**快速判断**：消息消费后还需要吗？需要重放 → Kafka；不需要 → RabbitMQ。

### Kubernetes vs Docker Compose（CARD-20251222-0010）

| 场景 | 选择 |
|------|------|
| 服务 ≥ 5 + 需精细伸缩 | Kubernetes |
| 服务 < 5，单机够用 | Docker Compose |
| 边缘/IoT/CI 环境 | K3s |
| 事件驱动，无需管基础设施 | Serverless |

**快速判断**：需要跨机器自动调度吗？不需要 → 先 Docker Compose。
