# progress/code-map.md — 代码地图

> ⚠️ 让 AI 不需要全文扫码就能定位到正确文件。控制在几百行内。
> 凡是有"业界推荐但其实错的"陷阱，标 ⚠️ 并指向 lessons.md。

## 后端
- `src/auth/` — 认证模块，OAuth2 实现
  - `login.py` — 登录入口
  - `oauth.py` — OAuth flow
- `src/api/` — REST 接口层，遵循 RESTful 规范
- `src/db/` — 数据层（SQLAlchemy）
  - `models.py` — ORM 模型
  - `migrations/` — Alembic 迁移
- `src/services/` — 业务逻辑层

## 前端
- `web/components/` — 组件库
- `web/pages/` — 页面
- `web/lib/` — 工具函数
- `web/api/` — 接口调用封装

## 配置
- `.env.example` — 环境变量模板
- `config/` — 业务配置

## 关键约束 / 陷阱（指向 lessons.md）
- ⚠️ iOS WiFi 复联**不要**用 NW Session（见 lessons L-001）
- ⚠️ 数据库迁移**不要**直接 drop column（见 lessons L-002）
