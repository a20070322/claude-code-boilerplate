# API 开发技能

## 触发条件
- 关键词: API、RESTful、接口设计、@GetMapping、@PostMapping
- 场景: 设计和实现 RESTful API 接口

## 核心规范

### 1. RESTful 设计原则

#### URL 设计
- 使用名词复数: `/users` (不是 `/user`)
- 层级结构: `/users/{userId}/orders/{orderId}`
- 小写字母,单词用连字符分隔: `/user-profiles`

#### HTTP 方法映射
```
GET    /users         - 查询列表
GET    /users/{id}    - 查询单个
POST   /users         - 新增
PUT    /users/{id}    - 修改 (全量)
PATCH  /users/{id}    - 修改 (部分)
DELETE /users/{id}    - 删除
```

### 2. 统一返回格式

#### 成功响应
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": { ... }
}
```

#### 分页响应
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [ ... ],
  "total": 100
}
```

#### 失败响应
```json
{
  "code": 500,
  "msg": "系统错误"
}
```

### 3. Controller 规范
- 使用 `@RestController` 注解
- 类级别使用 `@RequestMapping("/模块名")`
- 方法级别使用具体的 HTTP 方法注解
- 必须有权限控制: `@PreAuthorize`
- 必须有日志记录: `@Log`

### 4. 参数验证
- 使用 `@Validated` 或 `@Valid` 触发验证
- 使用 JSR-303 验证注解: `@NotNull`, `@NotBlank`, `@Email` 等
- 分组验证: 创建、修改使用不同分组

### 5. 异常处理
- 不在 Controller 中 try-catch
- 使用全局异常处理器
- 自定义业务异常

## 禁止事项
- ❌ URL 使用动词: `/getUsers`, `/createUser`
- ❌ 在 URL 中传递复杂参数
- ❌ Controller 中包含业务逻辑
- ❌ 返回值不统一 (有的返回 R, 有的返回实体)
- ❌ 缺少权限控制

## 参考代码

### Controller 完整示例
```java
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "用户管理", description = "用户管理接口")
public class UserController {

    private final IUserService userService;

    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermi('user:list')")
    @Operation(summary = "查询用户列表")
    @Log(title = "用户管理", businessType = BusinessType.QUERY)
    public TableDataInfo<UserVo> list(UserBo bo, PageQuery pageQuery) {
        return userService.list(bo, pageQuery.build());
    }

    @GetMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('user:query')")
    @Operation(summary = "查询用户详情")
    public R<UserVo> getInfo(@PathVariable Long id) {
        return R.ok(userService.getById(id));
    }

    @PostMapping
    @PreAuthorize("@ss.hasPermi('user:add')")
    @Operation(summary = "新增用户")
    @Log(title = "用户管理", businessType = BusinessType.INSERT)
    public R<Void> add(@Validated @RequestBody UserBo bo) {
        return toAjax(userService.insert(bo));
    }

    @PutMapping
    @PreAuthorize("@ss.hasPermi('user:edit')")
    @Operation(summary = "修改用户")
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    public R<Void> edit(@Validated @RequestBody UserBo bo) {
        return toAjax(userService.update(bo));
    }

    @DeleteMapping("/{ids}")
    @PreAuthorize("@ss.hasPermi('user:remove')")
    @Operation(summary = "删除用户")
    @Log(title = "用户管理", businessType = BusinessType.DELETE)
    public R<Void> remove(@PathVariable Long[] ids) {
        return toAjax(userService.deleteIds(ids));
    }
}
```

### BO (Business Object) 验证示例
```java
@Data
public class UserBo extends Bo {

    @NotNull(message = "用户ID不能为空", groups = { Edit.class })
    private Long userId;

    @NotBlank(message = "用户名不能为空")
    @Length(min = 2, max = 20, message = "用户名长度必须在2-20个字符之间")
    private String userName;

    @NotBlank(message = "昵称不能为空")
    private String nickName;

    @Email(message = "邮箱格式不正确")
    private String email;

    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phonenumber;

    /**
     * 创建分组
     */
    public interface Create {}

    /**
     * 修改分组
     */
    public interface Edit {}
}
```

### VO (View Object) 示例
```java
@Data
public class UserVo extends Vo {

    private Long userId;
    private String userName;
    private String nickName;
    private String email;
    private String phonenumber;

    // 扩展字段
    private String deptName;
    private Date createTime;
}
```

## 检查清单
- [ ] URL 是否使用名词复数?
- [ ] HTTP 方法是否正确映射?
- [ ] 是否统一返回格式 (R<T> 或 TableDataInfo)?
- [ ] 是否有权限控制注解?
- [ ] 是否有日志记录注解?
- [ ] 参数是否使用 JSR-303 验证?
- [ ] Controller 中是否不包含业务逻辑?
- [ ] 是否有 Swagger/OpenAPI 注解?
