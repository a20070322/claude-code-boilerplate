# 用户模块 CRUD 实现案例

> 完整的用户管理模块实现，展示如何遵循四层架构开发规范

## 实体类 (User.java)

```java
package com.ruoyi.system.domain;

import com.ruoyi.common.tenant.core.TenantEntity;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户对象 sys_user
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class User extends TenantEntity {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long userId;

    /** 用户账号 */
    private String userName;

    /** 用户昵称 */
    private String nickName;

    /** 用户邮箱 */
    private String email;

    /** 手机号码 */
    private String phonenumber;

    /** 用户性别 */
    private String sex;

    /** 帐号状态（0正常 1停用） */
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;
}
```

## 业务对象 (UserBo.java)

```java
package com.ruoyi.system.domain.bo;

import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.validate.AddGroup;
import com.ruoyi.common.core.validate.EditGroup;
import com.ruoyi.common.excel.annotation.Excel;
import com.ruoyi.common.xss.annotation.Xss;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

/**
 * 用户业务对象 sys_user
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class UserBo extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    private Long userId;

    /** 用户账号 */
    @Xss(message = "用户账号不能包含脚本字符")
    @NotBlank(message = "用户账号不能为空", groups = { AddGroup.class, EditGroup.class })
    @Size(min = 0, max = 30, message = "用户账号长度不能超过30个字符")
    @Excel(name = "用户账号")
    private String userName;

    /** 用户昵称 */
    @Xss(message = "用户昵称不能包含脚本字符")
    @Size(min = 0, max = 30, message = "用户昵称长度不能超过30个字符")
    @Excel(name = "用户昵称")
    private String nickName;

    /** 用户邮箱 */
    @NotBlank(message = "用户邮箱不能为空", groups = { EditGroup.class })
    @Email(message = "邮箱格式不正确")
    @Size(min = 0, max = 50, message = "邮箱长度不能超过50个字符")
    @Excel(name = "用户邮箱")
    private String email;

    /** 手机号码 */
    @NotBlank(message = "手机号码不能为空", groups = { EditGroup.class })
    @Size(min = 0, max = 11, message = "手机号码长度不能超过11个字符")
    @Excel(name = "手机号码")
    private String phonenumber;

    /** 用户性别 */
    @Excel(name = "用户性别", readConverterExp = "0=男,1=女,2=未知")
    private String sex;

    /** 帐号状态（0正常 1停用） */
    @Excel(name = "帐号状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 搜索值 */
    @Excel(name = "搜索值")
    private String searchValue;

    /** 开始时间 */
    @Excel(name = "开始时间")
    private String params;

    /** 结束时间 */
    @Excel(name = "结束时间")
    private String beginTime;

    /** 结束时间 */
    private String endTime;
}
```

## 视图对象 (UserVo.java)

```java
package com.ruoyi.system.domain.vo;

import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.ruoyi.common.excel.annotation.ExcelDictFormat;
import com.ruoyi.common.excel.convert.ExcelDictConvert;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 用户视图对象 sys_user
 */
@Data
@ExcelIgnoreUnannotated
public class UserVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    @ExcelProperty(value = "用户ID")
    private Long userId;

    /** 用户账号 */
    @ExcelProperty(value = "用户账号")
    private String userName;

    /** 用户昵称 */
    @ExcelProperty(value = "用户昵称")
    private String nickName;

    /** 用户邮箱 */
    @ExcelProperty(value = "用户邮箱")
    private String email;

    /** 手机号码 */
    @ExcelProperty(value = "手机号码")
    private String phonenumber;

    /** 用户性别 */
    @ExcelProperty(value = "用户性别", converter = ExcelDictConvert.class)
    @ExcelDictFormat(dictType = "sys_user_sex")
    private String sex;

    /** 帐号状态（0正常 1停用） */
    @ExcelProperty(value = "帐号状态", converter = ExcelDictConvert.class)
    @ExcelDictFormat(dictType = "sys_normal_disable")
    private String status;

    /** 最后登录时间 */
    @ExcelProperty(value = "最后登录时间")
    private Date loginDate;
}
```

## DAO 接口 (IUserDao.java)

```java
package com.ruoyi.system.mapper;

import com.ruoyi.common.core.mapper.BaseMapper;
import com.ruoyi.system.domain.User;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;

/**
 * 用户Mapper接口
 */
public interface IUserDao extends BaseMapper<User> {

    /**
     * 查询用户列表
     */
    TableDataInfo<UserVo> selectList(UserBo bo);
}
```

## DAO 实现 (UserDaoImpl.java)

```java
package com.ruoyi.system.mapper.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.system.domain.User;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;
import com.ruoyi.system.mapper.IUserDao;
import com.ruoyi.system.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 用户MapperImpl
 */
@Component
@RequiredArgsConstructor
public class UserDaoImpl implements IUserDao {

    private final UserMapper userMapper;

    @Override
    public TableDataInfo<UserVo> selectList(UserBo bo) {
        LambdaQueryWrapper<User> wrapper = buildQueryWrapper(bo);
        PageQuery pageQuery = bo.build();
        Page<UserVo> result = userMapper.selectVoPage(pageQuery.build(), wrapper);
        return TableDataInfo.build(result);
    }

    private LambdaQueryWrapper<User> buildQueryWrapper(UserBo bo) {
        Map<String, Object> params = bo.getParams();
        LambdaQueryWrapper<User> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(StringUtils.isNotBlank(bo.getUserName()), User::getUserName, bo.getUserName())
            .like(StringUtils.isNotBlank(bo.getNickName()), User::getNickName, bo.getNickName())
            .eq(StringUtils.isNotBlank(bo.getStatus()), User::getStatus, bo.getStatus())
            .like(StringUtils.isNotBlank(bo.getPhonenumber()), User::getPhonenumber, bo.getPhonenumber())
            .between(params.get("beginTime") != null && params.get("endTime") != null,
                User::getCreateTime, params.get("beginTime"), params.get("endTime"))
            .orderByDesc(User::getCreateTime);
        return wrapper;
    }
}
```

## Service 接口 (IUserService.java)

```java
package com.ruoyi.system.service;

import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.system.domain.User;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;

/**
 * 用户Service接口
 */
public interface IUserService {

    /**
     * 查询用户列表
     */
    TableDataInfo<UserVo> list(UserBo bo);

    /**
     * 查询用户详情
     */
    UserVo getById(Long userId);

    /**
     * 新增用户
     */
    Boolean insert(UserBo bo);

    /**
     * 修改用户
     */
    Boolean update(UserBo bo);

    /**
     * 删除用户
     */
    Boolean delete(Long[] userIds);
}
```

## Service 实现 (UserServiceImpl.java)

```java
package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.utils.MapstructUtils;
import com.ruoyi.common.core.utils.StringUtils;
import com.ruoyi.common.satoken.utils.LoginHelper;
import com.ruoyi.system.domain.User;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;
import com.ruoyi.system.mapper.IUserDao;
import com.ruoyi.system.mapper.UserMapper;
import com.ruoyi.system.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户Service实现
 */
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {

    private final IUserDao userDao;
    private final UserMapper userMapper;

    @Override
    public TableDataInfo<UserVo> list(UserBo bo) {
        return userDao.selectList(bo);
    }

    @Override
    public UserVo getById(Long userId) {
        User user = userMapper.selectById(userId);
        return MapstructUtils.convert(user, UserVo.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insert(UserBo bo) {
        User user = MapstructUtils.convert(bo, User.class);
        user.setCreateBy(LoginHelper.getUserId().toString());
        boolean flag = userMapper.insert(user) > 0;
        if (flag) {
            bo.setUserId(user.getUserId());
        }
        return flag;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean update(UserBo bo) {
        User user = MapstructUtils.convert(bo, User.class);
        user.setUpdateBy(LoginHelper.getUserId().toString());
        return userMapper.updateById(user) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean delete(Long[] userIds) {
        return userMapper.deleteBatchIds(Arrays.asList(userIds)) > 0;
    }
}
```

## Controller (UserController.java)

```java
package com.ruoyi.system.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.common.web.core.BaseController;
import com.ruoyi.system.domain.bo.UserBo;
import com.ruoyi.system.domain.vo.UserVo;
import com.ruoyi.system.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 用户Controller
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
    public TableDataInfo<UserVo> list(UserBo bo) {
        return userService.list(bo);
    }

    /**
     * 查询用户详情
     */
    @SaCheckPermission("system:user:query")
    @GetMapping("/{userId}")
    public R<UserVo> getInfo(@PathVariable Long userId) {
        return R.ok(userService.getById(userId));
    }

    /**
     * 新增用户
     */
    @SaCheckPermission("system:user:add")
    @PostMapping()
    public R<Void> add(@Validated @RequestBody UserBo bo) {
        return toAjax(userService.insert(bo));
    }

    /**
     * 修改用户
     */
    @SaCheckPermission("system:user:edit")
    @PutMapping()
    public R<Void> edit(@Validated @RequestBody UserBo bo) {
        return toAjax(userService.update(bo));
    }

    /**
     * 删除用户
     */
    @SaCheckPermission("system:user:remove")
    @DeleteMapping("/{userIds}")
    public R<Void> remove(@PathVariable Long[] userIds) {
        return toAjax(userService.delete(userIds));
    }
}
```

## 关键要点

### 1. 四层架构清晰
- **Controller**: 只负责接收请求和返回结果
- **Service**: 业务逻辑和事务管理
- **DAO**: 查询条件构建
- **Mapper**: 数据库操作

### 2. 对象转换规范
- BO → Entity: 使用 MapstructUtils.convert()
- Entity → VO: 使用 MapstructUtils.convert()
- 不使用 BeanUtils.copyProperties()

### 3. 查询条件构建
- 所有查询条件在 DAO 层的 buildQueryWrapper() 中构建
- Service 层不涉及查询条件

### 4. 权限控制
- 所有接口都有 @SaCheckPermission 注解
- 权限字符串格式: `module:operation`

### 5. 事务管理
- 新增、修改、删除操作使用 @Transactional
- 查询操作不需要事务
