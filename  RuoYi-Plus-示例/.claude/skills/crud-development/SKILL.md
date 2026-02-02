---
name: crud-development
description: Use when developing CRUD features or business modules in Spring Boot + MyBatis-Plus applications.
             Covers Entity, Service, DAO, Controller generation following four-layer architecture.
             Trigger keywords: CRUD, 增删改查, 业务模块, Entity, Service, Controller
---

# CRUD 开发技能

## 使用场景

当需要开发新的业务功能模块，涉及增删改查操作时：
- 创建新的实体和表结构
- 开发完整的 CRUD 接口
- 实现列表查询、详情查询、新增、修改、删除功能

## 开发流程

### 步骤 1：收集需求

使用 [template.md](template.md) 收集配置信息：
- 实体名称、表名、字段定义
- 查询需求、权限配置、业务规则

### 步骤 2：生成 Entity

**关键规范**：
- 继承 `TenantEntity` 或 `BaseEntity`
- 主键使用雪花 ID：`@TableId(type = IdType.ASSIGN_ID)`
- 审计字段自动填充：`@TableField(fill = FieldFill.INSERT)`

**参考示例**：[examples/user-module.md#实体类](examples/user-module.md#实体类-userjava)

### 步骤 3：生成 BO（业务对象）

**关键规范**：
- 继承 `BaseEntity`
- 添加校验注解：`@NotBlank`、`@Size`、`@Xss`
- 标记导出字段：`@Excel`
- 添加查询参数：`params`、`beginTime`、`endTime`

**参考示例**：[examples/user-module.md#业务对象](examples/user-module.md#业务对象-userbojava)

### 步骤 4：生成 VO（视图对象）

**关键规范**：
- 使用 `@ExcelIgnoreUnannotated`（只导出标注字段）
- 字典字段使用 `@ExcelDictFormat`

**参考示例**：[examples/user-module.md#视图对象](examples/user-module.md#视图对象-uservojava)

### 步骤 5：生成 DAO

**关键规范**：
- ✅ **所有查询条件必须在 `buildQueryWrapper()` 方法中构建**
- ✅ String 模糊查询使用 `like()`
- ✅ 其他类型模糊查询使用 `likeCast()`
- ✅ 精确查询使用 `eq()`
- ✅ 范围查询使用 `between()`

**错误示例**（在 Service 层构建条件）：
```java
// ❌ 错误：Service 层构建查询条件
public List<User> list(String name) {
    LambdaQueryWrapper<User> wrapper = Wrappers.lambdaQuery();
    wrapper.like(User::getName, name); // 不应该在这里
    return userMapper.selectList(wrapper);
}
```

**正确示例**（在 DAO 层构建条件）：
```java
// ✅ 正确：DAO 层构建查询条件
@Component
@RequiredArgsConstructor
public class UserDaoImpl implements IUserDao {
    private final UserMapper userMapper;

    public List<User> list(UserBo bo) {
        LambdaQueryWrapper<User> wrapper = buildQueryWrapper(bo);
        return userMapper.selectList(wrapper);
    }

    private LambdaQueryWrapper<User> buildQueryWrapper(UserBo bo) {
        LambdaQueryWrapper<User> wrapper = Wrappers.lambdaQuery();
        wrapper.like(StringUtils.isNotBlank(bo.getName()),
            User::getName, bo.getName()); // 在这里构建
        return wrapper;
    }
}
```

**参考示例**：[examples/user-module.md#dao-实现](examples/user-module.md#dao-实现-userdaoimpljava)

### 步骤 6：生成 Service

**关键规范**：
- ✅ **Service 实现类不继承 `ServiceImpl`**
- ✅ 对象转换使用 `MapstructUtils.convert()`
- ✅ 增删改操作使用 `@Transactional`

**错误示例**（继承 ServiceImpl）：
```java
// ❌ 错误：继承 ServiceImpl
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
    implements IUserService {
    // 会导致事务代理失效
}
```

**正确示例**（不继承）：
```java
// ✅ 正确：不继承 ServiceImpl
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {
    private final UserDao userDao;
    private final UserMapper userMapper;

    @Override
    public UserVo getById(Long id) {
        User user = userMapper.selectById(id);
        return MapstructUtils.convert(user, UserVo.class);
    }
}
```

**参考示例**：[examples/user-module.md#service-实现](examples/user-module.md#service-实现-userserviceimpljava)

### 步骤 7：生成 Controller

**关键规范**：
- ✅ `@RequestMapping` 路径包含模块名和实体名
- ✅ 所有接口添加权限注解
- ✅ 权限字符串格式：`模块:操作`
- ✅ 路径格式：`/实体/操作`

**路径对比**：
```java
// ❌ 错误：通用路径
@GetMapping("/page")           // 不清楚是什么资源
@GetMapping("/{id}")            // 太通用

// ✅ 正确：包含实体名
@GetMapping("/user/list")      // 清楚是用户列表
@GetMapping("/user/{id}")      // 清楚是用户详情
```

**参考示例**：[examples/user-module.md#controller](examples/user-module.md#controller-usercontrollerjava)

## 禁止事项 ⭐重要

| 禁止项 | 原因 | 正确做法 |
|--------|------|----------|
| ❌ Service 继承 ServiceImpl | Spring 事务代理失效 | 直接实现接口，不继承 |
| ❌ 使用 BeanUtil.copyProperties() | 类型不安全 | 使用 MapstructUtils.convert() |
| ❌ Controller 使用通用路径 | RESTful 规范 | 路径包含实体名 |
| ❌ 在 Service 层构建查询条件 | 职责不清 | 在 DAO 层的 buildQueryWrapper() |
| ❌ 使用自增主键 | 分布式问题 | 使用雪花 ID |
| ❌ 在 BO 中添加业务逻辑 | 层次混乱 | 业务逻辑在 Service 层 |

## 检查清单

生成代码后，使用 `scripts/validate-crud.sh` 验证：

- [ ] Entity 是否继承 TenantEntity/BaseEntity?
- [ ] Service 是否没有继承 ServiceImpl?
- [ ] Service 层是否没有构建查询条件?
- [ ] DAO 层是否实现了 buildQueryWrapper()?
- [ ] Controller 路径是否包含实体名称?
- [ ] 是否使用 MapstructUtils 转换对象?
- [ ] 是否有权限控制注解?
- [ ] 主键是否使用雪花 ID?

## 完整示例

所有层级的完整代码实现，请参考：
- **[examples/user-module.md](examples/user-module.md)** - 完整的用户模块实现
- **[template.md](template.md)** - 配置收集表单

## 快速参考

### 四层架构
```
Controller → Service (不继承) → DAO (buildQueryWrapper) → Mapper
```

### 对象转换
```java
// Entity → VO (查询返回)
MapstructUtils.convert(entity, UserVo.class)

// BO → Entity (新增/修改)
MapstructUtils.convert(bo, User.class)
```

### 查询条件
```java
// String 模糊查询
wrapper.like(StringUtils.isNotBlank(bo.getName()),
    User::getName, bo.getName())

// 其他类型模糊查询
wrapper.likeCast(ObjectUtil.isNotNull(bo.getAge()),
    User::getAge, bo.getAge())

// 精确查询
wrapper.eq(ObjectUtil.isNotNull(bo.getStatus()),
    User::getStatus, bo.getStatus())

// 范围查询
wrapper.between(params.get("beginTime") != null,
    User::getCreateTime, params.get("beginTime"), params.get("endTime"))
```
