# CRUD 开发技能

## 触发条件
- 关键词: CRUD、增删改查、业务模块、Entity、Service、DAO、Controller
- 场景: 开发新的业务功能模块

## 核心规范

### 1. 四层架构
```
Controller → Service (不继承) → DAO (buildQueryWrapper) → Mapper
```

### 2. Entity 规范
- 必须继承 TenantEntity (如果是多租户系统) 或 BaseEntity
- 主键使用雪花 ID (Long 类型),不使用自增
- 使用 JPA/MyBatis 注解
- 字段必须有明确的数据库映射

### 3. Service 规范
- **禁止继承 ServiceImpl**
- **禁止在 Service 层构建查询条件** (必须在 DAO 层)
- 对象转换必须使用 MapstructUtils.convert() 或类似工具
- 业务逻辑封装在 Service 层

### 4. DAO 规范
- 查询条件必须在 buildQueryWrapper() 方法中构建
- String 类型使用 like(),其他类型使用 likeCast()
- 复杂查询使用 XML 映射文件

### 5. Controller 规范
- 路径必须包含实体名称 (如 `/user/list`, `/coupon/add`)
- 统一返回格式: R<T>
- 必须有权限控制注解 (@PreAuthorize)

## 禁止事项
- ❌ Service 继承 ServiceImpl
- ❌ 使用 BeanUtil.copyProperties() (应使用类型安全的转换工具)
- ❌ Controller 使用通用路径如 `/page`、`/{id}`
- ❌ 在 Service 层构建查询条件
- ❌ 使用自增主键

## 参考代码

### Entity 示例
```java
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class User extends TenantEntity {
    @TableId(type = IdType.ASSIGN_ID)
    private Long userId;

    private String userName;
    private String nickName;

    @TableField(fill = FieldFill.INSERT)
    private Long createBy;
}
```

### Service 示例
```java
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {

    private final UserDao userDao;
    private final UserMapper userMapper;

    @Override
    public TableDataInfo<UserVo> list(UserBo bo) {
        // 查询逻辑在 DAO 层
        return userDao.selectList(bo);
    }

    @Override
    public User getById(Long id) {
        // 使用 MapstructUtils 转换
        return MapstructUtils.convert(userMapper.selectById(id), User.class);
    }
}
```

### DAO 示例
```java
@Component
@RequiredArgsConstructor
public class UserDaoImpl implements IUserDao {

    private final UserMapper userMapper;

    @Override
    public TableDataInfo<UserVo> selectList(UserBo bo) {
        // 在这里构建查询条件
        LambdaQueryWrapper<User> wrapper = buildQueryWrapper(bo);
        Page<UserVo> result = userMapper.selectVoPage(bo.build(), wrapper);
        return TableDataInfo.build(result);
    }

    private LambdaQueryWrapper<User> buildQueryWrapper(UserBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<User> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(StringUtils.isNotBlank(bo.getUserName()),
            User::getUserName, bo.getUserName())
            .like(StringUtils.isNotBlank(bo.getNickName()),
                User::getNickName, bo.getNickName());
        return wrapper;
    }
}
```

### Controller 示例
```java
@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final IUserService userService;

    @GetMapping("/list")
    @PreAuthorize("@ss.hasPermi('user:list')")
    public TableDataInfo<UserVo> list(UserBo bo) {
        return userService.list(bo);
    }

    @GetMapping("/{id}")
    @PreAuthorize("@ss.hasPermi('user:query')")
    public R<User> getInfo(@PathVariable Long id) {
        return R.ok(userService.getById(id));
    }
}
```

## 检查清单
- [ ] Entity 是否继承 TenantEntity/BaseEntity?
- [ ] Service 是否没有继承 ServiceImpl?
- [ ] Service 层是否没有构建查询条件?
- [ ] DAO 层是否实现了 buildQueryWrapper()?
- [ ] Controller 路径是否包含实体名称?
- [ ] 是否使用 MapstructUtils 或类似工具转换对象?
- [ ] 是否有权限控制注解?
- [ ] 主键是否使用雪花 ID?
