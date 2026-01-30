# 数据库操作技能

## 触发条件
- 关键词: SQL、数据库、建表、字典、@TableName、@TableField
- 场景: 创建数据库表、配置数据字典、编写 SQL 脚本

## 核心规范

### 1. 表命名规范
- 使用小写字母和下划线: `sys_user`, `bus_order`
- 表前缀:
  - `sys_` - 系统表
  - `bus_` - 业务表
  - `job_` - 定时任务表
  - `gen_` - 代码生成表

### 2. 字段规范

#### 通用字段 (所有表必备)
```sql
id              BIGINT          主键 (雪花ID)
tenant_id       BIGINT          租户ID (多租户表必备)
create_by       BIGINT          创建者
create_time     DATETIME        创建时间
update_by       BIGINT          更新者
update_time     DATETIME        更新时间
remark          VARCHAR(500)    备注
```

#### 字段命名
- 使用小写字母和下划线: `user_name`, `nick_name`
- 布尔类型使用 `is_` 前缀: `is_enabled`, `is_deleted`
- 时间类型使用 `_time` 后缀: `create_time`, `login_time`

#### 数据类型选择
```
字符串:
  - 固定长度: CHAR(2)   (性别、状态等)
  - 短文本: VARCHAR(50-200)
  - 长文本: TEXT
  - 超长文本: LONGTEXT

数字:
  - 主键/外键: BIGINT
  - 金额: DECIMAL(10,2)
  - 数量: INT
  - 小数: DOUBLE

时间:
  - 日期: DATE
  - 日期时间: DATETIME
  - 时间戳: TIMESTAMP
```

### 3. 索引规范
- 主键自动创建聚簇索引
- 外键字段创建普通索引
- 经常查询的字段创建索引
- 联合索引遵循最左前缀原则
- 唯一性约束使用唯一索引

### 4. SQL 脚本规范

#### 建表语句模板
```sql
-- 创建业务表
CREATE TABLE `bus_coupon` (
    `id` BIGINT NOT NULL COMMENT '主键ID',
    `tenant_id` BIGINT DEFAULT NULL COMMENT '租户ID',
    `coupon_name` VARCHAR(100) NOT NULL COMMENT '优惠券名称',
    `coupon_type` CHAR(1) NOT NULL COMMENT '优惠券类型: 1-满减 2-折扣 3-立减',
    `discount_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '优惠金额',
    `min_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '最低消费金额',
    `total_count` INT NOT NULL DEFAULT 0 COMMENT '发行总量',
    `remain_count` INT NOT NULL DEFAULT 0 COMMENT '剩余数量',
    `start_time` DATETIME NOT NULL COMMENT '开始时间',
    `end_time` DATETIME NOT NULL COMMENT '结束时间',
    `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '状态: 0-未开始 1-进行中 2-已结束',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标志: 0-正常 2-删除',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建者',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新者',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    KEY `idx_tenant_id` (`tenant_id`),
    KEY `idx_coupon_type` (`coupon_type`),
    KEY `idx_start_time` (`start_time`),
    KEY `idx_end_time` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠券表';
```

#### 菜单SQL模板
```sql
-- 菜单 SQL
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES
('优惠券', 2000, 1, 'coupon', 'business/coupon/index', 1, 0, 'C', '0', '0', 'business:coupon:list', 'coupon', 1, NOW(), 1, NOW(), '优惠券菜单');

-- 按钮 SQL
SELECT @parent_id := menu_id FROM sys_menu WHERE menu_name = '优惠券' AND parent_id = 2000;

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark) VALUES
('优惠券查询', @parent_id, 1, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:query', '#', 1, NOW(), ''),
('优惠券新增', @parent_id, 2, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:add', '#', 1, NOW(), ''),
('优惠券修改', @parent_id, 3, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:edit', '#', 1, NOW(), ''),
('优惠券删除', @parent_id, 4, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:remove', '#', 1, NOW(), ''),
('优惠券导出', @parent_id, 5, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:export', '#', 1, NOW(), '');
```

### 5. 数据字典配置

#### 字典类型 SQL
```sql
INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
VALUES ('优惠券类型', 'business_coupon_type', '0', 1, NOW(), '优惠券类型');

INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
VALUES ('优惠券状态', 'business_coupon_status', '0', 1, NOW(), '优惠券状态');
```

#### 字典数据 SQL
```sql
-- 优惠券类型
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark) VALUES
(1, '满减券', '1', 'business_coupon_type', '', 'primary', 'N', 1, NOW(), '满减优惠券'),
(2, '折扣券', '2', 'business_coupon_type', '', 'success', 'N', 1, NOW(), '折扣优惠券'),
(3, '立减券', '3', 'business_coupon_type', '', 'warning', 'N', 1, NOW(), '立减优惠券');

-- 优惠券状态
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark) VALUES
(1, '未开始', '0', 'business_coupon_status', '', 'info', 'N', 1, NOW(), '未开始'),
(2, '进行中', '1', 'business_coupon_status', '', 'primary', 'N', 1, NOW(), '进行中'),
(3, '已结束', '2', 'business_coupon_status', '', 'danger', 'N', 1, NOW(), '已结束');
```

## 禁止事项
- ❌ 使用保留字作为表名或字段名: `order`, `group`, `user`
- ❌ 表名或字段名使用驼峰命名: `userName`, `sysUser`
- ❌ 使用外键约束 (影响性能)
- ❌ 字段设置为 NULL 而无默认值
- ❌ 缺少通用字段: create_time, update_time
- ❌ 使用 TEXT/BLOB 作为主键

## 参考代码

### Entity 映射示例
```java
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("bus_coupon")
public class Coupon extends TenantEntity {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    private String couponName;

    @TableField("coupon_type")
    private String couponType;

    private BigDecimal discountAmount;

    private BigDecimal minAmount;

    private Integer totalCount;

    private Integer remainCount;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private String status;

    @TableField("del_flag")
    private String delFlag;
}
```

### 查询条件构建示例
```java
private LambdaQueryWrapper<Coupon> buildQueryWrapper(CouponBo bo) {
    Map<String, Object> params = bo.getParams();
    LambdaQueryWrapper<Coupon> wrapper = Wrappers.lambdaQuery();
    wrapper.eq(StringUtils.isNotBlank(bo.getCouponType()),
        Coupon::getCouponType, bo.getCouponType())
        .eq(StringUtils.isNotBlank(bo.getStatus()),
        Coupon::getStatus, bo.getStatus())
        .ge(params.get("beginStartTime") != null,
        Coupon::getStartTime, params.get("beginStartTime"))
        .le(params.get("endStartTime") != null,
        Coupon::getStartTime, params.get("endStartTime"))
        .like(StringUtils.isNotBlank(bo.getCouponName()),
        Coupon::getCouponName, bo.getCouponName());
    return wrapper;
}
```

## 检查清单
- [ ] 表名是否符合命名规范 (小写+下划线)?
- [ ] 是否包含所有通用字段 (id, create_time, update_time)?
- [ ] 字段类型是否合理?
- [ ] 是否创建了必要的索引?
- [ ] 主键是否使用 BIGINT?
- [ ] 是否配置了字符集和排序规则 (utf8mb4_unicode_ci)?
- [ ] 是否有注释?
- [ ] 是否配置了数据字典?
- [ ] 是否配置了菜单权限?
