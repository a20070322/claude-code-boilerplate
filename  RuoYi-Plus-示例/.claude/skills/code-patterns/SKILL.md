---
name: code-patterns
description: Use when writing or reviewing Java code to ensure it follows project coding standards.
             Covers naming conventions, code organization, exception handling, and best practices.
             Trigger keywords: 代码规范, 代码风格, 最佳实践, code review, naming
---

# 代码规范技能

## 使用场景

在编写或审查任何 Java 代码时，确保遵循统一的代码规范：
- 命名规范（类名、方法名、变量名）
- 代码组织（导入顺序、成员顺序）
- 异常处理、空值处理
- 集合处理、字符串处理
- 日志规范

## 核心规范

### 1. 命名规范

#### 类名 - PascalCase（大驼峰）
```java
// ✅ 正确
UserService, OrderController, UserBo, UserVo

// ❌ 错误
userService, order_controller
```

#### 方法名 - camelCase（小驼峰），动词开头
```java
// ✅ 正确
getUserById(), saveUser(), deleteOrder(), isExists()

// ❌ 错误
GetUserById(), user_get(), UserById()
```

#### 变量名 - camelCase
```java
// ✅ 正确
String userName;
boolean isEnabled;
int totalCount;

// ❌ 错误
String UserName;
boolean enabled;
int total_count;
```

#### 常量名 - 全大写，下划线分隔
```java
// ✅ 正确
public static final int MAX_SIZE = 100;
public static final String DEFAULT_PAGE_SIZE = "10";

// ❌ 错误
public static final int maxSize = 100;
```

**参考示例**：[examples/naming-conventions.md](examples/naming-conventions.md)

### 2. 异常处理

#### 不要吞掉异常
```java
// ❌ 错误：吞掉异常
try {
    doSomething();
} catch (Exception e) {
    // 什么都不做
}

// ✅ 正确：记录并抛出
try {
    doSomething();
} catch (Exception e) {
    logger.error("操作失败", e);
    throw new BusinessException("操作失败");
}
```

#### 使用具体异常
```java
// ❌ 错误：抛出通用 Exception
throw new Exception("错误");

// ✅ 正确：抛出具体异常
throw new BusinessException("错误");
throw new NullPointerException("参数不能为空");
```

### 3. 空值检查

#### 使用工具类
```java
// ❌ 错误：手动检查
if (str != null && !str.equals("")) {}
if (list != null && list.size() > 0) {}

// ✅ 正确：使用工具类
if (StringUtils.isNotEmpty(str)) {}
if (CollectionUtils.isNotEmpty(list)) {}
if (ObjectUtils.isNotEmpty(obj)) {}
```

### 4. 字符串处理

#### 字符串比较
```java
// ❌ 错误：可能 NPE
if (str.equals("test")) {}

// ✅ 正确：常量在前
if ("test".equals(str)) {}
```

#### 字符串拼接（循环中）
```java
// ❌ 错误：性能差
String str = "";
for (int i = 0; i < 100; i++) {
    str += i;
}

// ✅ 正确：使用 StringBuilder
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 100; i++) {
    sb.append(i);
}
```

### 5. 集合处理

#### 初始化集合
```java
// ❌ 错误：可能 NPE
List<String> list = null;

// ✅ 正确：初始化或使用空集合
List<String> list = new ArrayList<>();
List<String> list = Collections.emptyList();
```

#### 判断集合
```java
// ❌ 错误：冗长
if (list.size() == 0) {}
if (list != null && list.size() > 0) {}

// ✅ 正确：使用工具类
if (CollectionUtils.isEmpty(list)) {}
if (CollectionUtils.isNotEmpty(list)) {}
```

### 6. 日志规范

#### 使用占位符
```java
// ❌ 错误：字符串拼接
logger.debug("用户ID: " + userId + ", 用户名: " + userName);

// ✅ 正确：使用占位符
logger.debug("用户ID: {}, 用户名: {}", userId, userName);
```

#### 选择合适的日志级别
```java
logger.error("错误信息", exception);  // 错误
logger.warn("警告信息");              // 警告
logger.info("关键信息");              // 信息
logger.debug("调试信息");             // 调试
```

**参考示例**：[examples/logging-best-practices.md](examples/logging-best-practices.md)

### 7. Optional 使用

```java
// ✅ 返回 Optional
public Optional<User> getById(Long id) {
    return Optional.ofNullable(userMapper.selectById(id));
}

// ✅ 使用 ifPresent
userService.getById(1L).ifPresent(u -> {
    // 处理用户
});

// ❌ 避免：直接调用 get()
User user = userService.getById(1L).get(); // 可能 NPE
```

### 8. Stream API 使用

```java
// ❌ 错误：传统循环
List<String> names = new ArrayList<>();
for (User user : users) {
    names.add(user.getName());
}

// ✅ 正确：使用 Stream
List<String> names = users.stream()
    .map(User::getName)
    .collect(Collectors.toList());
```

**参考示例**：[examples/stream-api-usage.md](examples/stream-api-usage.md)

### 9. 代码组织

#### 导入顺序
```java
// 1. JDK 标准库
import java.util.*;
import java.time.*;

// 2. 第三方库
import org.springframework.*;
import lombok.*;

// 3. 项目内部
import com.ruoyi.common.*;
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

## 禁止事项 ⭐重要

| 禁止项 | 原因 | 正确做法 |
|--------|------|----------|
| ❌ 魔法数字 | 可读性差 | 定义常量 |
| ❌ 嵌套 if-else 超过 3 层 | 难以维护 | 提前返回/策略模式 |
| ❌ 在循环中查询数据库 | 性能问题 | 批量查询 |
| ❌ 在 finally 中使用 return | 语法错误 | 使用 try-with-resources |
| ❌ 用 + 拼接大量字符串 | 性能差 | 使用 StringBuilder |
| ❌ 忽略异常 | 难以调试 | 至少记录日志 |
| ❌ 使用过时的 API | 维护问题 | 使用新 API |

## 检查清单

使用 `scripts/check-style.sh` 验证代码规范：

- [ ] 命名符合规范（类名大驼峰，方法名小驼峰）
- [ ] 常量全大写，下划线分隔
- [ ] 有必要的注释（类、公共方法）
- [ ] 没有吞掉异常
- [ ] 正确处理空值
- [ ] 日志使用占位符
- [ ] 没有过深的嵌套（≤3 层）
- [ ] 不在循环中查询数据库
- [ ] 正确使用工具类（StringUtils、CollectionUtils）

## 完整示例

详细的代码规范示例，请参考：
- **[examples/naming-conventions.md](examples/naming-conventions.md)** - 命名规范
- **[examples/logging-best-practices.md](examples/logging-best-practices.md)** - 日志最佳实践
- **[examples/stream-api-usage.md](examples/stream-api-usage.md)** - Stream API 使用
- **[examples/complete-service.md](examples/complete-service.md)** - 完整的 Service 示例

## 快速参考

### 常用工具类
```java
// 字符串
StringUtils.isNotEmpty(str)
StringUtils.isBlank(str)

// 集合
CollectionUtils.isNotEmpty(list)
CollectionUtils.isEmpty(set)

// 对象
ObjectUtils.isNotEmpty(obj)
ObjectUtil.isNull(obj)
```

### 日志模板
```java
logger.error("操作失败, userId={}", userId, e);  // 带异常
logger.info("用户登录, userName={}", userName);   // 关键信息
logger.debug("查询参数, bo={}", bo);               // 调试信息
```

### 异常处理模板
```java
try {
    // 业务逻辑
} catch (BusinessException e) {
    throw e;
} catch (Exception e) {
    logger.error("操作失败", e);
    throw new BusinessException("系统错误");
}
```
