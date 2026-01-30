# 代码规范技能

## 触发条件
- 关键词: 代码规范、代码风格、最佳实践、代码检查
- 场景: 编写任何代码时都应该遵循的通用规范

## 核心规范

### 1. 命名规范

#### 类名
- 使用 PascalCase (大驼峰)
- 名词形式
- 见名知意
```java
// ✅ 正确
public class UserService {}
public class OrderController {}
public class UserBo {}
public class UserVo {}

// ❌ 错误
public class userService {}
public class order_controller {}
```

#### 方法名
- 使用 camelCase (小驼峰)
- 动词开头
```java
// ✅ 正确
getUserById()
saveUser()
deleteOrder()
isExists()

// ❌ 错误
GetUserById()
user_get()
UserById()
```

#### 变量名
- 使用 camelCase
- 布尔类型使用 is/has/can 前缀
```java
// ✅ 正确
String userName;
boolean isEnabled;
boolean hasPermission;
int totalCount;

// ❌ 错误
String UserName;
boolean enabled;
int total_count;
```

#### 常量名
- 全大写,下划线分隔
```java
// ✅ 正确
public static final String MAX_SIZE = 100;
public static final String DEFAULT_PAGE_SIZE = "10";

// ❌ 错误
public static final String maxSize = 100;
```

### 2. 注释规范

#### 类注释
```java
/**
 * 用户服务实现类
 *
 * @author ruoyi
 * @date 2024-01-01
 */
public class UserServiceImpl implements IUserService {
}
```

#### 方法注释
```java
/**
 * 根据用户ID查询用户
 *
 * @param userId 用户ID
 * @return 用户信息
 */
public User getById(Long userId) {
}
```

#### 复杂逻辑注释
```java
// TODO: 需要优化性能
// FIXME: 修复并发问题
// NOTE: 这里使用同步锁保证数据一致性
```

### 3. 代码组织

#### 导入顺序
```java
// 1. JDK 标准库
import java.util.*;
import java.time.*;

// 2. 第三方库
import org.springframework.*;
import lombok.*;
import cn.hutool.*;

// 3. 项目内部
import com.ruoyi.common.*;
import com.ruoyi.system.*;
```

#### 类成员顺序
```java
public class User {
    // 1. 常量
    public static final String MAX_SIZE = "100";

    // 2. 静态变量
    private static Logger logger = ...;

    // 3. 实例变量
    private Long id;
    private String name;

    // 4. 构造方法
    public User() {}

    // 5. 公共方法
    public void method1() {}

    // 6. 私有方法
    private void helper() {}

    // 7. getter/setter
    public Long getId() { return id; }
}
```

### 4. 异常处理

#### 不要吞掉异常
```java
// ❌ 错误
try {
    doSomething();
} catch (Exception e) {
    // 什么都不做
}

// ✅ 正确
try {
    doSomething();
} catch (Exception e) {
    logger.error("操作失败", e);
    throw new BusinessException("操作失败");
}
```

#### 使用具体异常
```java
// ❌ 错误
throw new Exception("错误");

// ✅ 正确
throw new BusinessException("错误");
throw new NullPointerException("参数不能为空");
```

### 5. 集合处理

#### 初始化集合
```java
// ❌ 错误
List<String> list = null;

// ✅ 正确
List<String> list = new ArrayList<>();
List<String> list = Collections.emptyList();
```

#### 判断集合
```java
// ❌ 错误
if (list.size() == 0) {}
if (list != null && list.size() > 0) {}

// ✅ 正确
if (CollectionUtils.isEmpty(list)) {}
if (CollectionUtils.isNotEmpty(list)) {}
```

### 6. 字符串处理

#### 字符串比较
```java
// ❌ 错误
if (str.equals("test")) {}

// ✅ 正确
if ("test".equals(str)) {}
```

#### 字符串拼接
```java
// ❌ 错误 (在循环中)
String str = "";
for (int i = 0; i < 100; i++) {
    str += i;
}

// ✅ 正确
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 100; i++) {
    sb.append(i);
}
```

### 7. 空值检查

#### 使用工具类
```java
// ❌ 错误
if (str != null && !str.equals("")) {}
if (list != null && list.size() > 0) {}

// ✅ 正确
if (StringUtils.isNotEmpty(str)) {}
if (CollectionUtils.isNotEmpty(list)) {}
if (ObjectUtils.isNotEmpty(obj)) {}
```

### 8. 日志规范

#### 使用占位符
```java
// ❌ 错误
logger.debug("用户ID: " + userId + ", 用户名: " + userName);

// ✅ 正确
logger.debug("用户ID: {}, 用户名: {}", userId, userName);
```

#### 选择合适的日志级别
```java
logger.error("错误信息", exception);  // 错误
logger.warn("警告信息");              // 警告
logger.info("关键信息");              // 信息
logger.debug("调试信息");             // 调试
```

### 9. Optional 使用

#### 适当使用 Optional
```java
// ✅ 正确
public Optional<User> getById(Long id) {
    return Optional.ofNullable(userMapper.selectById(id));
}

// 使用
Optional<User> user = userService.getById(1L);
if (user.isPresent()) {
    User u = user.get();
}

// 更好的方式
userService.getById(1L).ifPresent(u -> {
    // 处理用户
});
```

### 10. Stream API 使用

#### 简洁的集合操作
```java
// ❌ 错误
List<String> names = new ArrayList<>();
for (User user : users) {
    names.add(user.getName());
}

// ✅ 正确
List<String> names = users.stream()
    .map(User::getName)
    .collect(Collectors.toList());
```

## 禁止事项
- ❌ 使用魔法数字 (未定义的常量)
- ❌ 过度使用嵌套 if-else (超过3层)
- ❌ 在循环中进行数据库查询
- ❌ 在 finally 中使用 return
- ❌ 使用 + 拼接大量字符串
- ❌ 忽略异常
- ❌ 使用过时的 API

## 参考代码

### 完整示例
```java
/**
 * 用户服务实现类
 *
 * @author ruoyi
 * @date 2024-01-01
 */
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
    private static final int MAX_RETRY = 3;

    private final UserDao userDao;
    private final UserMapper userMapper;

    /**
     * 根据用户ID查询用户
     *
     * @param userId 用户ID
     * @return 用户信息
     */
    @Override
    public User getById(Long userId) {
        if (StringUtils.isNull(userId)) {
            throw new BusinessException("用户ID不能为空");
        }

        try {
            return userMapper.selectById(userId);
        } catch (Exception e) {
            logger.error("查询用户失败, userId={}", userId, e);
            throw new BusinessException("查询用户失败");
        }
    }

    /**
     * 查询用户列表
     *
     * @param bo 查询条件
     * @return 用户列表
     */
    @Override
    public List<UserVo> list(UserBo bo) {
        LambdaQueryWrapper<User> wrapper = buildQueryWrapper(bo);

        return userMapper.selectList(wrapper)
            .stream()
            .map(user -> MapstructUtils.convert(user, UserVo.class))
            .collect(Collectors.toList());
    }

    /**
     * 构建查询条件
     *
     * @param bo 查询条件
     * @return 查询包装器
     */
    private LambdaQueryWrapper<User> buildQueryWrapper(UserBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<User> wrapper = Wrappers.lambdaQuery();

        wrapper.eq(StringUtils.isNotBlank(bo.getUserName()),
            User::getUserName, bo.getUserName())
            .like(StringUtils.isNotBlank(bo.getNickName()),
                User::getNickName, bo.getNickName())
            .ge(params.get("beginTime") != null,
                User::getCreateTime, params.get("beginTime"))
            .le(params.get("endTime") != null,
                User::getCreateTime, params.get("endTime"));

        return wrapper;
    }

    /**
     * 批量删除用户
     *
     * @param ids 用户ID数组
     * @return 删除结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteByIds(Long[] ids) {
        if (ArrayUtils.isEmpty(ids)) {
            throw new BusinessException("用户ID不能为空");
        }

        try {
            return userMapper.deleteBatchIds(Arrays.asList(ids)) > 0;
        } catch (Exception e) {
            logger.error("批量删除用户失败, ids={}", Arrays.toString(ids), e);
            throw new BusinessException("批量删除用户失败");
        }
    }
}
```

## 检查清单
- [ ] 命名是否符合规范 (类名大驼峰, 方法名小驼峰)?
- [ ] 常量是否全大写?
- [ ] 是否有必要的注释 (类、方法)?
- [ ] 是否有吞掉异常的情况?
- [ ] 是否正确处理空值?
- [ ] 日志是否使用占位符?
- [ ] 是否过度使用嵌套 if-else?
- [ ] 是否在循环中进行数据库查询?
- [ ] 是否正确使用 Optional?
- [ ] 是否正确使用 Stream API?
