# Methodology — 陌生项目考古的方法论

> SKILL.md 是 what + when + workflow；本文档是 how 的细节。AI 在 Step 1-2 卡住时回来查这里。

---

## 1. 技术栈识别

按 lockfile 优先级判断（lockfile 比 manifest 更准）：

| Lockfile | 推断 |
|---|---|
| `package-lock.json` / `pnpm-lock.yaml` / `yarn.lock` | Node.js |
| `Pipfile.lock` / `poetry.lock` / `uv.lock` | Python |
| `go.sum` | Go |
| `Cargo.lock` | Rust |
| `Gemfile.lock` | Ruby |
| `composer.lock` | PHP |
| `pom.xml` + `target/` | Java (Maven) |

然后看 manifest 的 dependencies，识别框架：

| 关键依赖 | 框架 |
|---|---|
| `react` / `next` / `vite` / `vue` / `svelte` | 前端 SPA |
| `express` / `koa` / `fastify` / `nest` | Node 后端 |
| `django` / `flask` / `fastapi` | Python 后端 |
| `gin` / `echo` / `fiber` / `chi` | Go 后端 |
| `prisma` / `typeorm` / `sequelize` / `sqlalchemy` / `gorm` | ORM |

---

## 2. 入口识别

按语言/框架查找：

```bash
# Node
find . -maxdepth 3 -name "index.*" -o -name "main.*" -o -name "server.*" -o -name "app.*" | grep -v node_modules

# Python
find . -maxdepth 3 -name "main.py" -o -name "app.py" -o -name "manage.py" -o -name "wsgi.py" -o -name "asgi.py"

# Go
find . -path "*/cmd/*/main.go" -o -path "./main.go"

# 全语言：看 package.json scripts.start / Makefile run 目标 / Dockerfile CMD
```

---

## 3. 路由/API 提取

### Node (Express/Koa)
```bash
grep -rEn "(app|router)\.(get|post|put|delete|patch)\(['\"]" --include="*.ts" --include="*.js" src/ 2>/dev/null
```

### Python (Flask/FastAPI)
```bash
grep -rEn "@app\.(get|post|put|delete)|@router\.(get|post|put|delete)|@app\.route" --include="*.py" 2>/dev/null
```

### Go (Gin/Echo/Chi)
```bash
grep -rEn "(GET|POST|PUT|DELETE|PATCH)\(['\"]" --include="*.go" 2>/dev/null
```

### Java (Spring)
```bash
grep -rEn "@(Get|Post|Put|Delete|Request)Mapping" --include="*.java" 2>/dev/null
```

输出到 `contracts/api/_inferred.md` 时，按"服务/模块"分组，不要按字母序。

---

## 4. 数据模型提取

```bash
# Django/SQLAlchemy
find . -name "models.py" -o -name "models/*.py" | xargs cat

# Prisma
cat prisma/schema.prisma 2>/dev/null

# TypeORM
find . -name "*.entity.ts"

# GORM
grep -rEn "type \w+ struct" --include="*.go" | head -30
```

填入 `product/inferred-features.md` 的"核心实体"段。

---

## 5. Git 考古技巧

```bash
# 最近活跃的文件（看团队在卷哪里）
git log --since="3 months ago" --name-only --pretty=format: | grep -v "^$" | sort | uniq -c | sort -rn | head -20

# 主要贡献者
git shortlog -sn -e | head -10

# 重大节点（merge commit + 长 message）
git log --merges --oneline -20

# 某文件的演进史（怀疑某模块时用）
git log --follow --oneline <file>

# 找谁最懂某个文件
git shortlog -sn -e -- <file>
```

把活跃模块 top 3 写到 `progress/current.md` 的"近期活跃"段。

---

## 6. 隐藏信号挖掘

```bash
# 技术债（这些往往是真实痛点）
grep -rEn "TODO|FIXME|HACK|XXX|DEPRECATED|@deprecated" --include="*.ts" --include="*.py" --include="*.go" 2>/dev/null | head -50

# 临时修复（往往是隐藏地雷）
grep -rEn "临时|hotfix|workaround|hack|绕过" 2>/dev/null | head -20

# 环境变量（外部依赖一目了然）
cat .env.example 2>/dev/null
grep -rEn "process\.env\.|os\.environ\.|os\.getenv" --include="*.ts" --include="*.py" | head -30
```

这些 90% 会变成 `progress/lessons_inferred.md` 的素材。

---

## 7. 测试是最诚实的文档

读测试比读代码先：
- 测试名 = 期望行为的自然语言描述
- 测试 setup = 真实数据形态
- 测试断言 = 业务规则

抽样读 2-3 个核心测试，往往比读 500 行业务代码更快理解意图。

---

## 8. 何时停止深读

- 已经能写出 `onboarding-report.md` 5 段（业务/架构/启动/常见改动/地雷）→ 停
- 30 分钟到 → 停
- 已读源码 > 5000 行 → 停（再读边际效益下降）
- 卡在某个奇怪设计超过 10 分钟 → 停，写进 `uncertainty.md`

**停下来比读完整更重要**。考古不是写论文。

---

## 9. 三段标记的使用示例

```markdown
### 鉴权机制
- ✅ JWT，secret 在 `JWT_SECRET` 环境变量（src/auth.ts:12）
- ✅ token 24h 过期（src/auth.ts:34）
- ⚠️ refresh token 机制看起来是手搓的，没用标准库（src/auth.ts:80-120）
- ❓ 不清楚为啥没用 Passport.js，可能是历史原因 → uncertainty.md
```

---

## 10. 调用其他 superpower skill

考古过程中如果发现：
- 项目结构特别复杂，需要先头脑风暴 → 用 `brainstorming`
- 想搭建测试环境验证假设 → 用 `test-driven-development`
- 发现明显 bug 想顺手验证 → 用 `systematic-debugging`

但**主线必须是考古**，不要被支线带跑。
