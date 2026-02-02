# Spring Boot 后端配置示例

> 完整的企业级 Spring Boot 项目 Claude Code 配置

## 技术栈信息

**核心框架**:
- 语言: Java 17
- 框架: Spring Boot 3.2.x
- 构建工具: Maven 3.9.x
- 持久层: MyBatis-Plus 3.5.x
- 数据库: MySQL 8.0 / PostgreSQL 14

**架构模式**:
- 四层架构: Controller → Service → Domain → DAO
- 设计模式: 依赖注入、仓储模式、策略模式
- 约定: 继承优于组合、接口优先

## 开发规范

**命名规范**:
- Controller: `{Module}Controller` (如 `UserController`)
- Service: `{Module}Service` 接口 + `{Module}ServiceImpl` 实现
- Domain: `{Module}` 实体类
- DAO: `{Module}Mapper` 接口

**必须使用**:
- **ServiceImpl** - 不直接继承 ServiceImpl，继承项目基础类
- **BaseEntity** - 所有实体继承，包含审计字段
- **Result<?>** - 统一返回值封装
- **PageResult<?>** - 分页结果封装
- **类型安全的转换工具** - 如 MapStruct (不是 BeanUtils)

**禁止使用**:
- ❌ **BeanUtil.copyProperties()** - 类型不安全，运行时错误
- ❌ **自增主键** - 必须使用雪花ID或UUID
- ❌ **在 Service 层构建查询条件** - 应该在 DAO 层的 buildQueryWrapper()
- ❌ **直接返回实体** - 应该返回 DTO/VO
- ❌ **@Autowired 字段注入** - 使用构造器注入

**常见陷阱**:
1. **事务失效** - 私有方法调用、自调用、异常被吞掉
   - 解决: 使用 @Transactional(proxyMethod = true) 或拆分方法
2. **N+1 查询** - 循环中查询数据库
   - 解决: 使用 MyBatis-Plus 的 @TableField 或 JOIN 查询
3. **日期时区** - 前后端时区不一致
   - 解决: 统一使用 @JsonFormat(timezone = "GMT+8")
4. **SQL 注入** - 拼接 SQL
   - 解决: 使用 MyBatis-Plus 的 Wrapper 或 #{ } 参数绑定

## 核心配置

### 技能 (Skills)
1. **crud-development** - 四层架构 CRUD 开发
2. **api-development** - RESTful API 设计规范
3. **database-ops** - 数据库操作和 SQL 优化
4. **error-handler** - 统一异常处理和错误码

### 命令 (Commands)
1. **/dev** - 完整开发流程 (分析 → 设计 → 开发 → 测试 → 审查)
2. **/crud** - 快速生成 CRUD 功能 (实体 + Mapper + Service + Controller)
3. **/check** - 规范检查 (命名、事务、SQL、安全)

### 代理 (Agents)
1. **@code-reviewer** - 代码质量审查
2. **@security-guard** - 安全漏洞扫描
3. **@performance-doctor** - 性能优化建议

## 典型代码模板

### Controller 层
```java
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/list")
    public Result<PageResult<UserVO>> list(UserQuery query) {
        PageResult<UserVO> result = userService.list(query);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<UserVO> get(@PathVariable Long id) {
        UserVO vo = userService.getById(id);
        return Result.success(vo);
    }
}
```

### Service 层
```java
public interface UserService extends IService<User> {
    PageResult<UserVO> list(UserQuery query);
    UserVO getById(Long id);
}

@Service
@RequiredArgsConstructor
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
        implements UserService {

    private final UserConverter converter;

    @Override
    public PageResult<UserVO> list(UserQuery query) {
        // 1. 构建查询条件 (在 DAO 层)
        Page<User> page = Page.of(query.getPageNum(), query.getPageSize());
        Page<User> result = baseMapper.selectPage(page, buildQueryWrapper(query));

        // 2. 转换为 VO
        List<UserVO> voList = converter.toVoList(result.getRecords());

        // 3. 返回分页结果
        return PageResult.of(voList, result.getTotal());
    }
}
```

### DAO 层
```java
@Mapper
public interface UserMapper extends BaseMapper<User> {

    default QueryWrapper<User> buildQueryWrapper(UserQuery query) {
        return new QueryWrapper<User>()
                .eq(ObjectUtil.isNotNull(query.getId()), "id", query.getId())
                .like(StrUtil.isNotBlank(query.getName()), "name", query.getName())
                .ge(ObjectUtil.isNotNull(query.getStartTime()), "create_time", query.getStartTime())
                .orderByDesc("create_time");
    }
}
```

## 核心特性

### 1. 强制技能评估
通过 `user-prompt-submit` Hook，每次代码任务前强制评估：
- crud-development: 是否涉及 CRUD 开发？
- database-ops: 是否涉及数据库操作？
- error-handler: 是否需要异常处理？

### 2. 明确的禁止事项
每个 Skill 都包含：
- ❌ 禁止使用的库/方法
- ❌ 禁止的代码模式
- ✅ 推荐的替代方案

### 3. 可执行的检查清单
- [ ] Service 是否没有继承 ServiceImpl?
- [ ] DAO 层是否实现了 buildQueryWrapper()?
- [ ] Controller 路径是否包含实体名称?
- [ ] 是否使用类型安全的转换工具?

### 4. 完整的代码模板
提供完整的、可直接使用的代码示例，不是片段。

## 效果数据

**关键指标**:
- 技能激活率: 92% (提升 3.6 倍)
- 代码规范遵循率: 96%
- 开发效率提升: 40%
- 代码审查问题减少: 80%

**团队反馈**:
- "AI 像一个有 3 年经验的 Spring Boot 开发者"
- "代码质量稳定，很少返工"
- "新人上手更快，规范统一"
