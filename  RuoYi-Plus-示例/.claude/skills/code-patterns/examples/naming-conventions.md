# 命名规范完整示例

> 展示 Java 代码中各种命名规范的使用

## 类命名规范

### 实体类（Entity）
```java
/**
 * 用户实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class User extends TenantEntity {
    // ✅ 类名：大驼峰，名词
    // ✅ 表名：小写 + 下划线
}
```

### 业务对象（BO）
```java
/**
 * 用户业务对象
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class UserBo extends BaseEntity {
    // ✅ 类名：实体名 + Bo（大驼峰）
}
```

### 视图对象（VO）
```java
/**
 * 用户视图对象
 */
@Data
public class UserVo implements Serializable {
    // ✅ 类名：实体名 + Vo（大驼峰）
}
```

### Controller
```java
/**
 * 用户控制器
 */
@RestController
@RequestMapping("/system/user")
public class UserController {
    // ✅ 类名：实体名 + Controller（大驼峰）
    // ✅ 路径：小写 + 斜杠
}
```

### Service
```java
/**
 * 用户服务接口
 */
public interface IUserService {
    // ✅ 接口名：I + 实体名 + Service（大驼峰）
}

/**
 * 用户服务实现
 */
@Service
public class UserServiceImpl implements IUserService {
    // ✅ 实现类名：实体名 + ServiceImpl（大驼峰）
}
```

### DAO/Mapper
```java
/**
 * 用户DAO接口
 */
public interface IUserDao extends BaseMapper<User> {
    // ✅ 接口名：I + 实体名 + Dao（大驼峰）
}

/**
 * 用户DAO实现
 */
@Component
public class UserDaoImpl implements IUserDao {
    // ✅ 实现类名：实体名 + DaoImpl（大驼峰）
}
```

## 方法命名规范

### CRUD 方法
```java
/**
 * 根据ID查询
 * ✅ 方法名：get + 实体名 + By + 条件
 */
public User getById(Long userId) {}

/**
 * 查询列表
 * ✅ 方法名：list
 */
public List<User> list(UserBo bo) {}

/**
 * 保存
 * ✅ 方法名：save / insert
 */
public Boolean save(UserBo bo) {}

/**
 * 更新
 * ✅ 方法名：update / edit
 */
public Boolean update(UserBo bo) {}

/**
 * 删除
 * ✅ 方法名：delete / remove
 */
public Boolean delete(Long[] userIds) {}
```

### 布尔方法
```java
/**
 * ✅ 方法名：is / has / can 开头
 */
public boolean isEnabled() {}
public boolean hasPermission() {}
public boolean canAccess() {}
```

### 转换方法
```java
/**
 * ✅ 方法名：to + 目标类型
 */
public UserVo toVo(User entity) {}
public User toEntity(UserVo vo) {}
```

## 变量命名规范

### 成员变量
```java
public class User {
    // ✅ 基本类型：小驼峰
    private Long userId;
    private String userName;
    private Integer age;

    // ✅ 布尔类型：is / has 前缀
    private boolean isEnabled;
    private boolean hasPermission;

    // ❌ 错误示例
    private Long UserID;          // 不应全大写
    private String username;      // 不应连写
    private boolean enabled;      // 布尔应有 is 前缀
}
```

### 集合变量
```java
public class UserService {
    // ✅ 集合变量：复数形式或 List 后缀
    private List<User> userList;
    private Set<String> permissionSet;
    private Map<Long, User> userMap;

    // ❌ 错误示例
    private List<User> users;      // 不够具体
    private List<User> user;       // 应该用复数
}
```

### 常量命名
```java
public class Constants {
    // ✅ 常量：全大写，下划线分隔
    public static final String MAX_SIZE = "100";
    public static final String DEFAULT_PAGE_SIZE = "10";
    public static final int CACHE_EXPIRE_TIME = 3600;

    // ❌ 错误示例
    public static final String maxSize = "100";      // 应该全大写
    public static final int cacheExpireTime = 3600;  // 应该全大写
}
```

## 包命名规范

```java
// ✅ 包名：全小写，域名反转
package com.ruoyi.system.domain;
package com.ruoyi.system.service.impl;
package com.ruoyi.system.controller;
package com.ruoyi.common.utils;

// ❌ 错误示例
package com.RuoYi.System;         // 不应大写
package com.ruoyi.system_domain;   // 不应使用下划线
```

## 测试类命名

```java
/**
 * 用户服务测试
 */
class UserServiceTest {
    // ✅ 测试类名：被测试类 + Test
}

/**
 * 用户服务集成测试
 */
class UserServiceIntegrationTest {
    // ✅ 集成测试：被测试类 + IntegrationTest
}
```
