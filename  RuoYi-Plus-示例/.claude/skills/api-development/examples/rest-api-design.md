# RESTful API 设计完整示例

> 展示完整的 Controller 接口设计、Bo/Vo 定义、权限配置

## 1. Controller 接口

### UserController.java

```java
package com.ruoyi.web.controller.system;

import cn.dev33.satoken.annotation.SaCheckPermission;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.log.annotation.Log;
import com.ruoyi.common.log.enums.BusinessType;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;
import com.ruoyi.system.service.IUserService;

import java.util.List;

/**
 * 用户信息控制器
 *
 * @author ruoyi
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/system/user")
public class UserController extends BaseController {

    private final IUserService userService;

    /**
     * 查询用户列表
     */
    @SaCheckPermission("system:user:list")
    @GetMapping("/list")
    public TableDataInfo<UserVo> list(UserBo bo, PageQuery pageQuery) {
        return userService.list(bo, pageQuery);
    }

    /**
     * 查询用户详情
     */
    @SaCheckPermission("system:user:query")
    @GetMapping("/{id}")
    public R<UserVo> getInfo(@PathVariable Long id) {
        return R.ok(userService.getById(id));
    }

    /**
     * 新增用户
     */
    @SaCheckPermission("system:user:add")
    @Log(title = "用户管理", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated(AddGroup.class) @RequestBody UserBo bo) {
        return toAjax(userService.insert(bo));
    }

    /**
     * 修改用户
     */
    @SaCheckPermission("system:user:edit")
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody UserBo bo) {
        return toAjax(userService.update(bo));
    }

    /**
     * 删除用户
     */
    @SaCheckPermission("system:user:remove")
    @Log(title = "用户管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toAjax(userService.delete(ids));
    }

    /**
     * 重置密码
     */
    @SaCheckPermission("system:user:resetPwd")
    @Log(title = "重置密码", businessType = BusinessType.UPDATE)
    @PutMapping("/resetPwd")
    public R<Void> resetPwd(@RequestBody UserBo bo) {
        return toAjax(userService.resetPwd(bo));
    }

    /**
     * 导出用户
     */
    @SaCheckPermission("system:user:export")
    @Log(title = "用户管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(UserBo bo, HttpServletResponse response) {
        List<UserVo> list = userService.list(bo);
        ExcelUtil.exportExcel(list, "用户数据", UserVo.class, response);
    }
}
```

### 关键点说明

1. **URL 设计规范**
   - 使用名词复数：`/system/user`（resource 是单数但路径代表集合）
   - 查询列表：`GET /list`
   - 查询详情：`GET /{id}`
   - 新增：`POST /`（请求体包含数据）
   - 修改：`PUT /`（请求体包含数据）
   - 删除：`DELETE /{ids}`（支持批量）

2. **HTTP 方法映射**
   - 查询操作：`@GetMapping`
   - 新增操作：`@PostMapping`
   - 修改操作：`@PutMapping`
   - 删除操作：`@DeleteMapping`

3. **路径参数 vs 查询参数**
   - 路径参数：`@PathVariable` - 资源标识
   - 查询参数：自动绑定到 Bo - 筛选条件
   - 请求体：`@RequestBody` - 提交数据

4. **权限注解**
   - 格式：`模块:资源:操作`
   - `system:user:list` - 查询列表
   - `system:user:query` - 查询详情
   - `system:user:add` - 新增
   - `system:user:edit` - 修改
   - `system:user:remove` - 删除

5. **返回格式**
   - 列表查询：`TableDataInfo<UserVo>`（包含分页）
   - 详情查询：`R<UserVo>`（单个对象）
   - 操作结果：`R<Void>`（成功/失败）

## 2. Bo 定义

### UserBo.java

```java
package com.ruoyi.system.domain.bo;

import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;
import lombok.EqualsAndHashCode;
import com.ruoyi.system.domain.User;
import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.Length;

/**
 * 用户信息业务对象
 *
 * @author ruoyi
 */
@Data
@EqualsAndHashCode(callSuper = true)
@AutoMapper(target = User.class)
public class UserBo extends BaseBo {

    /**
     * 用户ID
     */
    @NotNull(message = "用户ID不能为空", groups = { EditGroup.class })
    private Long userId;

    /**
     * 用户账号
     */
    @NotBlank(message = "用户账号不能为空", groups = { AddGroup.class, EditGroup.class })
    @Length(min = 0, max = 30, message = "用户账号长度不能超过30个字符")
    private String userName;

    /**
     * 用户昵称
     */
    @Length(min = 0, max = 30, message = "用户昵称长度不能超过30个字符")
    private String nickName;

    /**
     * 用户邮箱
     */
    @NotBlank(message = "用户邮箱不能为空", groups = { AddGroup.class, EditGroup.class })
    @Email(message = "邮箱格式不正确")
    @Length(min = 0, max = 50, message = "用户邮箱长度不能超过50个字符")
    private String email;

    /**
     * 手机号码
     */
    @Pattern(regexp = "^1[3|4|5|6|7|8|9][0-9]\\d{8}$", message = "手机号码格式不正确")
    private String phonenumber;

    /**
     * 用户性别（0男 1女 2未知）
     */
    private String sex;

    /**
     * 帐号状态（0正常 1停用）
     */
    private String status;

    /**
     * 岗位ID组
     */
    private Long[] postIds;

    /**
     * 角色ID组
     */
    private Long[] roleIds;

    /**
     * 密码（新增时必填）
     */
    @NotBlank(message = "用户密码不能为空", groups = { AddGroup.class })
    @Length(min = 6, max = 20, message = "用户密码长度必须介于6和20之间")
    private String password;
}
```

### 关键点说明

1. **分组验证**
   - `AddGroup.class` - 新增时的验证规则
   - `EditGroup.class` - 修改时的验证规则
   - 例如：`userId` 在新增时不验证，修改时必填

2. **验证注解**
   - `@NotNull` - 不能为 null
   - `@NotBlank` - 不能为空字符串
   - `@Email` - 邮箱格式
   - `@Pattern` - 正则表达式验证
   - `@Length` - 长度限制

3. **继承 BaseBo**
   - 自动包含分页参数
   - 自动包含排序参数
   - 自动包含时间范围参数

## 3. Vo 定义

### UserVo.java

```java
package com.ruoyi.system.domain.vo;

import io.github.linpeilie.annotations.AutoMappers;
import lombok.Data;
import com.ruoyi.system.domain.User;
import com.ruoyi.system.domain.bo.UserBo;
import java.util.Date;

/**
 * 用户信息视图对象
 *
 * @author ruoyi
 */
@Data
@AutoMappers({
    @AutoMapper(target = User.class),
    @AutoMapper(target = UserBo.class)
})
public class UserVo {

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 用户账号
     */
    private String userName;

    /**
     * 用户昵称
     */
    private String nickName;

    /**
     * 用户邮箱
     */
    private String email;

    /**
     * 手机号码
     */
    private String phonenumber;

    /**
     * 用户性别（0男 1女 2未知）
     */
    private String sex;

    /**
     * 帐号状态（0正常 1停用）
     */
    private String status;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 部门名称
     */
    private String deptName;

    /**
     * 角色组
     */
    private String roles;

    /**
     * 岗位组
     */
    private String posts;
}
```

### 关键点说明

1. **用途**
   - 用于返回给前端的数据
   - 不包含敏感信息（如密码）
   - 可以包含关联对象（如部门名称）

2. **与 Bo 的区别**
   - Bo：接收前端参数，包含验证规则
   - Vo：返回给前端，包含展示数据
   - Entity：数据库映射

## 4. Service 接口

### IUserService.java

```java
package com.ruoyi.system.service;

import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;
import java.util.List;

/**
 * 用户服务接口
 *
 * @author ruoyi
 */
public interface IUserService {

    /**
     * 查询用户列表
     */
    TableDataInfo<UserVo> list(UserBo bo, PageQuery pageQuery);

    /**
     * 查询用户详情
     */
    UserVo getById(Long id);

    /**
     * 新增用户
     */
    int insert(UserBo bo);

    /**
     * 修改用户
     */
    int update(UserBo bo);

    /**
     * 删除用户
     */
    int delete(Long[] ids);

    /**
     * 重置密码
     */
    int resetPwd(UserBo bo);
}
```

## 5. 统一返回格式

### R.java

```java
package com.ruoyi.common.core.domain;

import lombok.Data;

/**
 * 统一返回结果
 *
 * @author ruoyi
 */
@Data
public class R<T> {

    /**
     * 状态码
     */
    private int code;

    /**
     * 返回消息
     */
    private String msg;

    /**
     * 返回数据
     */
    private T data;

    /**
     * 成功返回
     */
    public static <T> R<T> ok() {
        return ok(null);
    }

    /**
     * 成功返回（带数据）
     */
    public static <T> R<T> ok(T data) {
        R<T> rsp = new R<>();
        rsp.setCode(200);
        rsp.setMsg("操作成功");
        rsp.setData(data);
        return rsp;
    }

    /**
     * 失败返回
     */
    public static <T> R<T> fail(String msg) {
        R<T> rsp = new R<>();
        rsp.setCode(500);
        rsp.setMsg(msg);
        return rsp;
    }

    /**
     * 失败返回（带状态码）
     */
    public static <T> R<T> fail(int code, String msg) {
        R<T> rsp = new R<>();
        rsp.setCode(code);
        rsp.setMsg(msg);
        return rsp;
    }
}
```

### TableDataInfo.java

```java
package com.ruoyi.common.mybatis.core.page;

import lombok.Data;
import java.util.List;

/**
 * 分页返回结果
 *
 * @author ruoyi
 */
@Data
public class R<T> {

    /**
     * 状态码
     */
    private int code;

    /**
     * 返回消息
     */
    private String msg;

    /**
     * 返回数据
     */
    private T data;

    /**
     * 成功返回
     */
    public static <T> R<T> ok() {
        return ok(null);
    }

    /**
     * 成功返回（带数据）
     */
    public static <T> R<T> ok(T data) {
        R<T> rsp = new R<>();
        rsp.setCode(200);
        rsp.setMsg("操作成功");
        rsp.setData(data);
        return rsp;
    }

    /**
     * 失败返回
     */
    public static <T> R<T> fail(String msg) {
        R<T> rsp = new R<>();
        rsp.setCode(500);
        rsp.setMsg(msg);
        return rsp;
    }

    /**
     * 失败返回（带状态码）
     */
    public static <T> R<T> fail(int code, String msg) {
        R<T> rsp = new R<>();
        rsp.setCode(code);
        rsp.setMsg(msg);
        return rsp;
    }
}
```

## 6. 权限配置 SQL

### 菜单权限

```sql
-- 主菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES ('用户管理', 1, 1, 'user', 'system/user/index', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 1, NOW(), '用户管理菜单');

-- 按钮权限
SELECT @parent_id := menu_id FROM sys_menu WHERE menu_name = '用户管理' AND parent_id = 1;

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark) VALUES
('用户查询', @parent_id, 1, '#', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 1, NOW(), ''),
('用户新增', @parent_id, 2, '#', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 1, NOW(), ''),
('用户修改', @parent_id, 3, '#', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 1, NOW(), ''),
('用户删除', @parent_id, 4, '#', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 1, NOW(), ''),
('用户导出', @parent_id, 5, '#', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 1, NOW(), ''),
('重置密码', @parent_id, 6, '#', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 1, NOW(), '');
```

### 权限字符串格式

**格式**：`模块:资源:操作`

**示例**：
- `system:user:list` - 用户列表查询
- `system:user:query` - 用户详情查询
- `system:user:add` - 用户新增
- `system:user:edit` - 用户修改
- `system:user:remove` - 用户删除
- `system:user:export` - 用户导出
- `system:user:resetPwd` - 重置密码

## 7. API 调用示例

### 查询列表

```bash
GET /system/user/list?pageNum=1&pageSize=10&userName=admin
```

**响应**：
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "userId": 1,
      "userName": "admin",
      "nickName": "管理员",
      "email": "admin@example.com",
      "status": "0"
    }
  ],
  "total": 100
}
```

### 查询详情

```bash
GET /system/user/1
```

**响应**：
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "userId": 1,
    "userName": "admin",
    "nickName": "管理员",
    "email": "admin@example.com",
    "status": "0"
  }
}
```

### 新增

```bash
POST /system/user
Content-Type: application/json

{
  "userName": "testuser",
  "nickName": "测试用户",
  "email": "test@example.com",
  "password": "123456"
}
```

**响应**：
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 修改

```bash
PUT /system/user
Content-Type: application/json

{
  "userId": 1,
  "userName": "admin",
  "nickName": "超级管理员",
  "email": "admin@example.com"
}
```

**响应**：
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 删除

```bash
DELETE /system/user/1,2,3
```

**响应**：
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

## 快速参考

### URL 设计规范

```
GET    /system/user/list         - 查询列表
GET    /system/user/{id}         - 查询详情
POST   /system/user              - 新增
PUT    /system/user              - 修改
DELETE /system/user/{ids}        - 删除
POST   /system/user/export       - 导出
```

### 参数传递方式

```java
// 路径参数
@GetMapping("/{id}")
public R<UserVo> getInfo(@PathVariable Long id)

// 查询参数
@GetMapping("/list")
public TableDataInfo<UserVo> list(UserBo bo)

// 请求体参数
@PostMapping
public R<Void> add(@RequestBody UserBo bo)
```

### 返回格式选择

```java
// 单个对象
R<UserVo>

// 列表（分页）
TableDataInfo<UserVo>

// 操作结果
R<Void>
```

### 权限注解

```java
@SaCheckPermission("system:user:list")   // 查询列表
@SaCheckPermission("system:user:query")  // 查询详情
@SaCheckPermission("system:user:add")    // 新增
@SaCheckPermission("system:user:edit")   // 修改
@SaCheckPermission("system:user:remove") // 删除
```
