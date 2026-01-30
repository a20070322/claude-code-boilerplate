# /crud - 快速生成CRUD代码

## 描述
从现有数据库表一键生成完整的四层架构代码

## 使用方法
```
crud <表名>

例如:
crud sys_user
crud bus_coupon
crud bus_order
```

## 生成内容

### 后端代码
- [ ] Entity: `xxx/domain/EntityName.java`
- [ ] BO: `xxx/domain/bo/EntityNameBo.java`
- [ ] VO: `xxx/domain/vo/EntityNameVo.java`
- [ ] DAO接口: `xxx/dao/IEntityNameDao.java`
- [ ] DAO实现: `xxx/dao/impl/EntityNameDaoImpl.java`
- [ ] Mapper: `xxx/mapper/EntityNameMapper.java`
- [ ] Service接口: `xxx/service/IEntityNameService.java`
- [ ] Service实现: `xxx/service/impl/EntityNameServiceImpl.java`
- [ ] Controller: `xxx/controller/EntityNameController.java`

### 前端代码 (如果需要)
- [ ] API定义: `api/xxx.ts`
- [ ] 类型定义: `types/xxx.ts`
- [ ] 页面组件: `views/xxx/index.vue`

## 执行步骤

### 步骤 1: 读取表结构
```sql
SHOW CREATE TABLE <表_name>;
DESC <table_name>;
```

### 步骤 2: 激活相关技能
- `crud-development` - CRUD开发规范
- `api-development` - API设计规范
- `database-ops` - 数据库操作规范

### 步骤 3: 生成后端代码
根据表结构自动生成:
1. Entity - 映射数据库表
2. BO - 接收前端参数
3. VO - 返回前端数据
4. DAO - 数据访问层
5. Service - 业务逻辑层
6. Controller - 控制器层

遵循规范:
- Entity 继承 TenantEntity/BaseEntity
- Service 不继承 ServiceImpl
- DAO 实现 buildQueryWrapper()
- Controller 路径包含实体名

### 步骤 4: 生成前端代码 (可选)
- API 定义使用统一的请求方法
- 页面组件使用封装的 A* 组件
- 配置路由和权限

### 步骤 5: 代码审查
使用 `@code-reviewer` 审查生成的代码

## 示例

用户输入:
```
crud bus_coupon
```

AI 输出:
```
✅ 读取表结构: bus_coupon

📋 表信息:
- 表名: bus_coupon (优惠券表)
- 字段数: 16
- 主键: id
- 索引: 4 个

🚀 开始生成代码...

✅ 生成 Entity: Coupon.java
   路径: ruoyi-modules/business/domain/Coupon.java

✅ 生成 BO: CouponBo.java
   路径: ruoyi-modules/business/domain/bo/CouponBo.java

✅ 生成 VO: CouponVo.java
   路径: ruoyi-modules/business/domain/vo/CouponVo.java

✅ 生成 DAO接口: ICouponDao.java
   路径: ruoyi-modules/business/dao/ICouponDao.java

✅ 生成 DAO实现: CouponDaoImpl.java
   路径: ruoyi-modules/business/dao/impl/CouponDaoImpl.java

✅ 生成 Mapper: CouponMapper.java
   路径: ruoyi-modules/business/mapper/CouponMapper.java

✅ 生成 Service接口: ICouponService.java
   路径: ruoyi-modules/business/service/ICouponService.java

✅ 生成 Service实现: CouponServiceImpl.java
   路径: ruoyi-modules/business/service/impl/CouponServiceImpl.java

✅ 生成 Controller: CouponController.java
   路径: ruoyi-modules/business/controller/CouponController.java

📦 共生成 9 个文件

💡 下一步操作:
- 使用 @code-reviewer 审查代码
- 启动服务测试接口
- 提交代码: git add . && git commit -m "feat: 优惠券管理"
```

## 注意事项
1. 确保表结构符合规范 (有通用字段)
2. 如果表有关联关系,需要手动处理
3. 生成后需要检查字段类型和注释
4. 复杂业务逻辑需要手动补充
5. 建议生成后立即进行代码审查

## 自定义选项
可以添加参数自定义生成:
```
crud <table_name> [--no-vo] [--no-bo] [--frontend]

例如:
crud bus_coupon --no-vo          # 不生成 VO
crud bus_coupon --frontend       # 同时生成前端代码
```
