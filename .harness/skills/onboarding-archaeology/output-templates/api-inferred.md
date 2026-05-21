# API 反向推测清单（待人工复核）

> 本文件由 onboarding-archaeology skill 通过扫描路由代码反向生成。
> 每个端点都给出 `源文件:行号` 引用，但**请求/响应字段是 AI 推测的**，可能不全或错误。
> 复核确认后，请将本文件改名为 `<service-name>.md` 并去掉 `_inferred` 后缀。

---

## 服务概览

- **服务名**：✅ / ⚠️ {推测的服务名}
- **基地址**：✅ / ⚠️ {从 main/server 文件提取}
- **协议**：REST / GraphQL / RPC
- **鉴权**：✅ / ⚠️ {JWT / Session / API Key}

---

## 端点清单（按模块分组）

### 模块 A — {模块名}

#### `GET /api/xxx`
- **源**：`src/routes/xxx.ts:L42`
- **用途**：⚠️ {推测}
- **请求**：⚠️ 推测无参数
- **响应**：⚠️ 推测 `{ id, name }`
- **鉴权**：✅ 需要（中间件 `requireAuth` 在 L40）
- ❓ 不确定字段类型，需复核

#### `POST /api/xxx`
- ...

### 模块 B — ...

---

## 推测过程

- 扫描命令：`grep -rEn "app\.(get|post|put|delete)" src/`
- 共找到 X 个路由
- Y 个路由能从代码直接读出 request/response 形态
- Z 个路由的字段是从调用方/测试反推的

---

**onboarding-archaeology 自动生成于 {YYYY-MM-DD HH:MM}。请人工复核后晋升为正式契约。**
