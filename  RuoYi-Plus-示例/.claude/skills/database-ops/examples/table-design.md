# 数据库表设计完整示例

> 展示完整的建表 SQL、字典配置、菜单权限配置

## 1. 建表 SQL

### 优惠券表（bus_coupon）

```sql
-- ----------------------------
-- 优惠券表
-- ----------------------------
DROP TABLE IF EXISTS `bus_coupon`;
CREATE TABLE `bus_coupon` (
    `id` BIGINT NOT NULL COMMENT '主键ID',
    `tenant_id` BIGINT DEFAULT NULL COMMENT '租户ID',
    `coupon_name` VARCHAR(100) NOT NULL COMMENT '优惠券名称',
    `coupon_type` CHAR(1) NOT NULL COMMENT '优惠券类型: 1-满减 2-折扣 3-立减',
    `discount_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '优惠金额',
    `discount_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '折扣率',
    `min_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '最低消费金额',
    `max_discount` DECIMAL(10,2) DEFAULT NULL COMMENT '最大优惠金额',
    `total_count` INT NOT NULL DEFAULT 0 COMMENT '发行总量',
    `remain_count` INT NOT NULL DEFAULT 0 COMMENT '剩余数量',
    `user_limit` INT NOT NULL DEFAULT 1 COMMENT '每人限领数量',
    `start_time` DATETIME NOT NULL COMMENT '开始时间',
    `end_time` DATETIME NOT NULL COMMENT '结束时间',
    `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '状态: 0-未开始 1-进行中 2-已结束 3-已失效',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '删除标志: 0-正常 2-删除',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建者',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` BIGINT DEFAULT NULL COMMENT '更新者',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    KEY `idx_tenant_id` (`tenant_id`),
    KEY `idx_coupon_name` (`coupon_name`),
    KEY `idx_coupon_type` (`coupon_type`),
    KEY `idx_start_time` (`start_time`),
    KEY `idx_end_time` (`end_time`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠券表';
```

### 关键点说明

1. **主键使用 BIGINT**
   - 支持雪花 ID（BIGINT）
   - 不使用自增（`AUTO_INCREMENT`）

2. **字符集和排序规则**
   - `CHARSET=utf8mb4` - 支持表情符号
   - `COLLATE=utf8mb4_unicode_ci` - 不区分大小写

3. **字段注释**
   - 每个字段都有 `COMMENT`
   - 说明字段的用途和取值

4. **索引设计**
   - `idx_tenant_id` - 多租户查询
   - `idx_coupon_name` - 按名称搜索
   - `idx_status` - 按状态筛选
   - `idx_start_time/end_time` - 时间范围查询

5. **软删除标记**
   - `del_flag` - 逻辑删除而非物理删除

## 2. 数据字典配置

### 字典类型 SQL

```sql
-- 优惠券类型
INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
VALUES ('优惠券类型', 'business_coupon_type', '0', 1, NOW(), '优惠券类型列表');

-- 优惠券状态
INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
VALUES ('优惠券状态', 'business_coupon_status', '0', 1, NOW(), '优惠券状态列表');
```

### 字典数据 SQL

```sql
-- 优惠券类型
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark) VALUES
(1, '满减券', '1', 'business_coupon_type', '', 'primary', 'N', 1, NOW(), '满足条件减金额'),
(2, '折扣券', '2', 'business_coupon_type', '', 'success', 'N', 1, NOW(), '打折优惠'),
(3, '立减券', '3', 'business_coupon_type', '', 'warning', 'N', 1, NOW(), '直接减免');

-- 优惠券状态
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark) VALUES
(1, '未开始', '0', 'business_coupon_status', '', 'info', 'N', 1, NOW(), '活动未开始'),
(2, '进行中', '1', 'business_coupon_status', '', 'primary', 'N', 1, NOW(), '活动进行中'),
(3, '已结束', '2', 'business_coupon_status', '', 'danger', 'N', 1, NOW(), '活动已结束'),
(4, '已失效', '3', 'business_coupon_status', '', 'danger', 'N', 1, NOW(), '活动已失效');
```

## 3. 菜单权限配置

### 菜单 SQL

```sql
-- 主菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES ('优惠券', 2000, 1, 'coupon', 'business/coupon/index', 1, 0, 'C', '0', '0', 'business:coupon:list', 'coupon', 1, NOW(), '优惠券菜单');

-- 按钮权限
SELECT @parent_id := menu_id FROM sys_menu WHERE menu_name = '优惠券' AND parent_id = 2000;

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark) VALUES
('优惠券查询', @parent_id, 1, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:query', '#', 1, NOW(), ''),
('优惠券新增', @parent_id, 2, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:add', '#', 1, NOW(), ''),
('优惠券修改', @parent_id, 3, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:edit', '#', 1, NOW(), ''),
('优惠券删除', @parent_id, 4, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:remove', '#', 1, NOW(), ''),
('优惠券导出', @parent_id, 5, '#', '', 1, 0, 'F', '0', '0', 'business:coupon:export', '#', 1, NOW(), '');
```

### 权限字符串格式

**格式**：`模块:操作`

**示例**：
- `business:coupon:list` - 优惠券列表
- `business:coupon:query` - 优惠券查询
- `business:coupon:add` - 优惠券新增
- `business:coupon:edit` - 优惠券修改
- `business:coupon:remove` - 优惠券删除
- `business:coupon:export` - 优惠券导出

## 4. Entity 类映射

### Java Entity 类

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

    private BigDecimal discountRate;

    private BigDecimal minAmount;

    private BigDecimal maxDiscount;

    private Integer totalCount;

    private Integer remainCount;

    private Integer userLimit;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private String status;

    @TableField("del_flag")
    private String delFlag;

    @TableField(fill = FieldFill.INSERT)
    private Long createBy;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Long updateBy;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    private String remark;
}
```

### 关键点说明

1. **@TableName 注解**
   - 指定数据库表名
   - 驼峰类名映射到下划线表名

2. **@TableId 注解**
   - 指定主键字段
   - `type = IdType.ASSIGN_ID` - 雪花 ID

3. **@TableField 注解**
   - 映射字段名（下划线 → 驼峰）
   - `fill = FieldFill.INSERT` - 插入时自动填充
   - `fill = FieldFill.INSERT_UPDATE` - 插入和更新时自动填充

4. **继承 TenantEntity**
   - 自动包含 `tenant_id` 字段
   - 支持多租户

## 5. 查询条件构建

### buildQueryWrapper 方法

```java
private LambdaQueryWrapper<Coupon> buildQueryWrapper(CouponBo bo) {
    Map<String, Object> params = bo.getParams();
    LambdaQueryWrapper<Coupon> wrapper = Wrappers.lambdaQuery();

    // 精确查询
    wrapper.eq(StringUtils.isNotBlank(bo.getCouponType()),
        Coupon::getCouponType, bo.getCouponType())
        .eq(StringUtils.isNotBlank(bo.getStatus()),
            Coupon::getStatus, bo.getStatus());

    // 模糊查询
    wrapper.like(StringUtils.isNotBlank(bo.getCouponName()),
        Coupon::getCouponName, bo.getCouponName());

    // 范围查询
    wrapper.ge(params.get("beginStartTime") != null,
        Coupon::getStartTime, params.get("beginStartTime"))
        .le(params.get("endStartTime") != null,
            Coupon::getStartTime, params.get("endStartTime"));

    // 排序
    wrapper.orderByDesc(Coupon::getCreateTime);

    return wrapper;
}
```

### 关键点说明

1. **精确查询使用 `.eq()**
   - 用于状态、类型等精确匹配

2. **模糊查询使用 `.like()`**
   - 用于名称等模糊匹配
   - String 类型字段

3. **范围查询使用 `.ge()` / `.le()`**
   - 用于时间范围查询
   - 配合 params 参数使用

4. **排序**
   - `orderByDesc()` - 降序
   - `orderByAsc()` - 升序

## 快速参考

### 常见字段类型

```sql
-- 主键
BIGINT NOT NULL COMMENT '主键ID'

-- 字符串
VARCHAR(100) COMMENT '名称'
CHAR(1) COMMENT '状态'

-- 数字
INT COMMENT '数量'
DECIMAL(10,2) COMMENT '金额'

-- 时间
DATETIME COMMENT '创建时间'
DATE COMMENT '生日'
```

### 索引创建

```sql
-- 普通索引
KEY `idx_status` (`status`)

-- 唯一索引
UNIQUE KEY `uk_code` (`code`)

-- 联合索引
KEY `idx_type_status` (`type`, `status`)
```

### 字典配置

```sql
-- 字典类型
INSERT INTO sys_dict_type (dict_name, dict_type, status, remark)
VALUES ('状态', 'module_status', '0', '模块状态');

-- 字典数据
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class) VALUES
(1, '正常', '0', 'module_status', '', 'primary'),
(2, '停用', '1', 'module_status', '', 'danger');
```
