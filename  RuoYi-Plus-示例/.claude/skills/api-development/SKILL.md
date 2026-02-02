---
name: api-development
description: Use when designing or implementing RESTful APIs in Spring Boot applications.
             Covers URL design, HTTP methods, request/response formats, and best practices.
             Trigger keywords: API, RESTful, 接口设计, @GetMapping, @PostMapping
---

# API 开发技能

## 使用场景

当需要设计或实现 RESTful API 接口时：
- 设计新的 API 端点
- 定义 URL 结构和 HTTP 方法
- 规范请求参数和响应格式
- 配置权限和错误处理

## 开发流程

### 步骤 1：收集需求

使用 [template.md](template.md) 收集 API 设计信息：
- 资源名称（如 User、Coupon、Order）
- 需要的操作（CRUD）
- 权限要求
- 特殊业务逻辑

### 步骤 2：URL 设计规范

**RESTful URL 设计**：

```java
// ✅ 正确：使用名词复数
@GetMapping("/users")           // 查询列表
@GetMapping("/users/{id}")      // 查询单个
@PostMapping("/users")        // 新增
@PutMapping("/users/{id}")      // 修改
@DeleteMapping("/users/{id}")   // 删除

// ❌ 错误：使用单数或动词
@GetMapping("/user")           // 应该用复数
@GetMapping("/getUser")        // 不应包含动词
```

**层级结构**：
```java
// ✅ 正确：资源嵌套
@GetMapping("/users/{userId}/orders")
@GetMapping("/users/{userId}/orders/{orderId}")

// ✅ 正确：使用连字符
@GetMapping("/user-profiles")
@GetMapping("/order-items")
```

**参考示例**：[examples/rest-api-design.md](examples/rest-api-design.md)

### 步骤 3：HTTP 方法映射

| 操作 | HTTP 方法 | URL | 说明 |
|------|-----------|-----|------|
| 查询列表 | GET | /users | 分页查询 |
| 查询单个 | GET | /users/{id} | 详情查询 |
| 新增 | POST | /users | 创建资源 |
| 修改 | PUT | /users/{id} | 全量更新 |
| 删除 | DELETE | /users/{id} | 删除资源 |

**错误示例**：
```java
// ❌ 错误：使用 POST 修改
@PostMapping("/users/{id}")  // 应该用 PUT

// ❌ 错误：使用 GET 删除
@GetMapping("/users/{id}/delete")  // 应该用 DELETE
```

### 步骤 4：统一返回格式

#### 成功响应
```java
@RestController
public class UserController {
    @GetMapping("/users/{id}")
    public R<User> getInfo(@PathVariable Long id) {
        return R.ok(userService.getById(id));
    }
}
```

**返回格式**：
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "userId": 1,
    "userName": "admin"
  }
}
```

#### 分页响应
```java
@GetMapping("/users")
public TableDataInfo<UserVo> list(UserBo bo) {
    return userService.list(bo);
}
```

**返回格式**：
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [...],
  "total": 100
}
```

#### 失败响应
```java
@GetMapping("/users/{id}")
public R<User> getInfo(@PathVariable Long id) {
    User user = userService.getById(id);
    if (user == null) {
        return R.fail("用户不存在");
    }
    return R.ok(user);
}
```

**返回格式**：
```json
{
  "code": 500,
  "msg": "用户不存在"
}
```

### 步骤 5：参数验证

#### 路径参数
```java
@GetMapping("/users/{id}")
public R<UserVo> getInfo(@PathVariable Long id) {
    return R.ok(userService.getById(id));
}
```

#### 查询参数
```java
@GetMapping("/users")
public TableDataInfo<UserVo> list(
    @RequestParam(defaultValue = "1") Integer pageNum,
    @RequestParam(defaultValue = "10") Integer pageSize,
    UserBo bo
) {
    return userService.list(bo);
}
```

#### 请求体参数
```java
@PostMapping("/users")
public R<Void> add(@Validated @RequestBody UserBo bo) {
    return toAjax(userService.insert(bo));
}
```

### 步骤 6：权限控制

```java
@RestController
@RequestMapping("/system/user")
public class UserController {

    @SaCheckPermission("system:user:list")
    @GetMapping("/list")
    public TableDataInfo<UserVo> list(UserBo bo) {
        return userService.list(bo);
    }

    @SaCheckPermission("system:user:add")
    @PostMapping
    public R<Void> add(@Validated @RequestBody UserBo bo) {
        return toAjax(userService.insert(bo));
    }
}
```

**权限字符串格式**：`模块:资源:操作`
- `system:user:list` - 用户列表查询
- `system:user:add` - 用户新增
- `system:user:edit` - 用户修改
- `system:user:remove` - 用户删除

### 步骤 7：异常处理

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ServiceException.class)
    public R<Void> handleServiceException(ServiceException e) {
        log.error("业务异常: {}", e.getMessage());
        return R.fail(e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public R<Void> handleException(Exception e) {
        log.error("系统异常: {}", e.getMessage(), e);
        return R.fail("系统错误");
    }
}
```

## 禁止事项 ⭐重要

| 禁止项 | 原因 | 正确做法 |
|--------|------|----------|
| ❌ URL 使用单数或动词 | 不符合 RESTful | 使用复数名词（/users） |
| ❌ POST 用于修改 | 不符合 HTTP 语义 | PUT 用于修改，POST 用于创建 |
| ❌ GET 用于删除 | 不符合 HTTP 语义 | DELETE 用于删除 |
| ❌ URL 包含动词 | 不符合 RESTful | `/users/{id}` 不是 `/getUser` |
| ❌ 缺少权限注解 | 安全风险 | 所有接口都要加权限注解 |
| ❌ 返回格式不统一 | 前端处理困难 | 使用统一的 R<T> 返回 |
| ❌ 缺少参数验证 | 数据校验问题 | 使用 @Validated 校验 |

## 检查清单

使用 `scripts/validate-api.sh` 验证 API：

- [ ] URL 符合 RESTful 规范（名词复数）
- [ ] HTTP 方法使用正确
- [ ] 有统一的返回格式
- [ ] 路径参数使用 @PathVariable
- [ ] 查询参数使用 @RequestParam
- [ ] 请求体使用 @RequestBody
- [ ] 有权限控制注解
- [ ] 有参数校验注解

## 完整示例

详细的 API 示例，请参考：
- **[examples/rest-api-design.md](examples/rest-api-design.md)** - RESTful API 完整示例
- **[examples/api-doc.md](examples/api-doc.md)** - API 文档示例
- **[template.md](template.md)** - API 设计配置表

## 快速参考

### URL 设计
```
GET    /users              - 查询列表
GET    /users/{id}          - 查询单个
POST   /users              - 新增
PUT    /users/{id}          - 修改
DELETE /users/{id}       - 删除
```

### 权限注解
```java
@SaCheckPermission("system:user:list")   // 查询列表
@SaCheckPermission("system:user:query")   // 查询详情
@SaCheckPermission("system:user:add")    // 新增
@SaCheckPermission("system:user:edit")   // 修改
@SaCheckPermission("system:user:remove") // 删除
```

### 返回格式
```java
// 成功
R.ok(data)

// 失败
R.fail("错误信息")

// 转换为 Ajax 响应
toAjax(result)
```
