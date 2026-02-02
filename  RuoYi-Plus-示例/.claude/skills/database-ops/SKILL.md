---
name: database-ops
description: Use when creating database tables, configuring data dictionaries, or writing SQL scripts.
             Covers table naming, field types, indexes, and SQL templates.
             Trigger keywords: SQL, 数据库, 建表, 字典, @TableName, @TableField
---

# 数据库操作技能

## 使用场景

当需要创建数据库表、配置数据字典或编写 SQL 脚本时：
- 创建新的业务表
- 设计字段和数据类型
- 创建索引
- 配置数据字典
- 生成菜单权限 SQL

## 开发流程

### 步骤 1：收集需求

使用 [template.md](template.md) 收集表设计信息：
- 表名、表前缀
- 字段定义
- 索引需求
- 字典配置
- 菜单权限

### 步骤 2：表命名规范

**表名格式**：`前缀_表名`

**表前缀**：
- `sys_` - 系统表（用户、角色、权限）
- `bus_` - 业务表（订单、优惠券、商品）
- `job_` - 定时任务表
- `gen_` - 代码生成表

**命名规则**：
- ✅ 小写字母 + 下划线：`sys_user`, `bus_order`
- ❌ 驼峰命名：`SysUser`, `busOrder`

**参考示例**：[examples/table-design.md](examples/table-design.md)

### 步骤 3：字段规范

#### 通用字段（所有表必备）
```sql
id              BIGINT          -- 主键（雪花ID）
create_by       BIGINT          -- 创建者
create_time     DATETIME        -- 创建时间
update_by       BIGINT          -- 更新者
update_time     DATETIME        -- 更新时间
remark          VARCHAR(500)    -- 备注
```

多租户表额外需要：
```sql
tenant_id       BIGINT          -- 租户ID
```

#### 字段命名
- 小写字母 + 下划线：`user_name`, `nick_name`
- 布尔字段 `is_` 前缀：`is_enabled`, `is_deleted`
- 时间字段 `_time` 后缀：`create_time`, `login_time`

#### 数据类型选择
```
字符串：
  - 固定长度: CHAR(2)   (性别、状态等)
  - 短文本: VARCHAR(50-200)
  - 长文本: TEXT
  - 超长文本: LONGTEXT

数字：
  - 主键/外键: BIGINT
  - 金额: DECIMAL(10,2)
  - 数量: INT
  - 小数: DOUBLE

时间：
  - 日期: DATE
  - 日期时间: DATETIME
  - 时间戳: TIMESTAMP
```

### 步骤 4：索引规范

**索引设计原则**：
- ✅ 主键自动创建聚簇索引
- ✅ 外键字段创建普通索引
- ✅ 经常查询的字段创建索引
- ✅ 联合索引遵循最左前缀原则
- ✅ 唯一性约束使用唯一索引

**索引命名**：
- 主键索引：`PRIMARY KEY`
- 普通索引：`idx_字段名`（如 `idx_user_name`）
- 唯一索引：`uk_字段名`（如 `uk_user_code`）

### 步骤 5：SQL 脚本模板

#### 建表语句模板
```sql
CREATE TABLE `bus_coupon` (
    `id` BIGINT NOT NULL COMMENT '主键ID',
    `coupon_name` VARCHAR(100) NOT NULL COMMENT '优惠券名称',
    `coupon_type` CHAR(1) NOT NULL COMMENT '优惠券类型',
    `discount_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '优惠金额',
    `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_coupon_type` (`coupon_type`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠券表';
```

**关键字段**：
- `NOT NULL` - 不允许 NULL
- `DEFAULT` - 默认值
- `COMMENT` - 字段注释（必须）

**参考示例**：[examples/table-design.md](examples/table-design.md)

### 步骤 6：数据字典配置

#### 字典类型 SQL
```sql
INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
VALUES ('优惠券类型', 'business_coupon_type', '0', 1, NOW(), '优惠券类型列表');
```

#### 字典数据 SQL
```sql
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark) VALUES
(1, '满减券', '1', 'business_coupon_type', '', 'primary', 'N', 1, NOW(), '满减优惠券'),
(2, '折扣券', '2', 'business_coupon_type', '', 'success', 'N', 1, NOW(), '折扣优惠券');
```

**参考示例**：[examples/dictionary-config.md](examples/dictionary-config.md)

### 步骤 7：菜单权限配置

#### 菜单 SQL 模板
```sql
-- 主菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES ('优惠券', 2000, 1, 'coupon', 'business/coupon/index', 1, 0, 'C', '0', '0', 'business:coupon:list', 'coupon', 1, NOW(), '优惠券菜单');

-- 按钮（权限）
SELECT @parent_id := menu_id FROM sys_menu WHERE menu_name = '优惠券' AND parent_id = 2000;

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark) VALUES
('优惠券查询', @parent_id, 1, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:query', '#', 1, NOW(), ''),
('优惠券新增', @parent_id, 2, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:add', '#', 1, NOW(), ''),
('优惠券修改', @parent_id, 3, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:edit', '#', 1, NOW(), '');
```

**权限字符串格式**：`模块:操作`（如 `business:coupon:query`）

**参考示例**：[examples/menu-config.md](examples/menu-config.md)

## 禁止事项 ⭐重要

| 禁止项 | 原因 | 正确做法 |
|--------|------|----------|
| ❌ 使用保留字作为表名 | SQL 关键字冲突 | 使用 `bus_order` 不是 `order` |
| ❌ 表名或字段名使用驼峰 | 不符合规范 | 使用 `user_name` 不是 `userName` |
| ❌ 使用外键约束 | 影响性能 | 应用层维护关联关系 |
| ❌ 字段设置为 NULL 无默认值 | 插入可能报错 | 设置默认值或 NOT NULL |
| ❌ 缺少通用字段 | 审计和追踪问题 | 包含 create_time, update_time |
| ❌ 使用 TEXT/BLOB 作为主键 | 性能问题 | 使用 BIGINT |
| ❌ 缺少字段注释 | 难以维护 | 每个字段都要 COMMENT |

## 检查清单

使用 `scripts/validate-sql.sh` 验证 SQL：

- [ ] 表名符合命名规范（小写+下划线）
- [ ] 包含所有通用字段（id, create_time, update_time）
- [ ] 字段类型合理（主键 BIGINT，金额 DECIMAL）
- [ ] 创建了必要的索引
- [ ] 主键使用 BIGINT
- [ ] 配置字符集 utf8mb4_unicode_ci
- [ ] 所有字段都有注释
- [ ] 配置了数据字典
- [ ] 配置了菜单权限

## 完整示例

详细的 SQL 示例，请参考：
- **[examples/table-design.md](examples/table-design.md)** - 完整建表 SQL
- **[examples/dictionary-config.md](examples/dictionary-config.md)** - 字典配置
- **[examples/menu-config.md](examples/menu-config.md)** - 菜单权限配置
- **[template.md](template.md)** - 数据库设计表

## 快速参考

### 常用表前缀
- `sys_` - 系统表
- `bus_` - 业务表
- `job_` - 定时任务

### 字段类型速查
```sql
-- 主键
BIGINT NOT NULL COMMENT '主键ID'

-- 字符串
VARCHAR(100) COMMENT '名称'
CHAR(1) COMMENT '状态'

-- 金额
DECIMAL(10,2) COMMENT '金额'

-- 时间
DATETIME COMMENT '创建时间'
DATE COMMENT '生日'
```

### 索引创建
```sql
-- 普通索引
KEY `idx_user_name` (`user_name`)

-- 唯一索引
UNIQUE KEY `uk_user_code` (`user_code`)

-- 联合索引
KEY `idx_type_status` (`coupon_type`, `status`)
```
