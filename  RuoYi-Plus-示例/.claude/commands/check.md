# /check - 代码规范检查

## 描述
全栈代码规范检查,确保代码质量和项目规范一致性

## 使用方法
```
check
check <file_path>
check <directory_path>

例如:
check                    # 检查所有变更文件
check src/main/java     # 检查指定目录
check UserService.java  # 检查指定文件
```

## 检查项

### 后端代码检查

#### Entity 检查
- [ ] 是否继承 TenantEntity/BaseEntity?
- [ ] 主键是否使用雪花ID (IdType.ASSIGN_ID)?
- [ ] 是否使用 @TableName 注解?
- [ ] 字段是否有 @TableField 注解?
- [ ] 是否有字段注释?

#### Service 检查
- [ ] 是否继承 ServiceImpl? (应该不继承)
- [ ] 是否使用 @Service 注解?
- [ ] 是否使用 @RequiredArgsConstructor?
- [ ] 对象转换是否使用 MapstructUtils?
- [ ] 是否在 Service 层构建查询条件? (不应该)

#### DAO 检查
- [ ] 是否实现 buildQueryWrapper()?
- [ ] 查询条件是否在 buildQueryWrapper 中构建?
- [ ] String 类型是否使用 like()?
- [ ] 其他类型是否使用 likeCast()?

#### Controller 检查
- [ ] 是否使用 @RestController 注解?
- [ ] 路径是否包含实体名称?
- [ ] 是否有权限控制注解 (@PreAuthorize)?
- [ ] 是否有日志记录注解 (@Log)?
- [ ] 是否统一返回格式 (R<T> 或 TableDataInfo)?
- [ ] 参数是否使用 @Validated 验证?

### 前端代码检查

#### 组件检查
- [ ] 是否使用封装的 A* 组件? (AFormInput, AModal 等)
- [ ] 是否使用原生 el-* 组件? (不应该)
- [ ] API 调用是否使用 [err, data] 格式?

#### 样式检查
- [ ] 是否使用 rpx 单位? (移动端)
- [ ] 是否使用统一的样式变量?

#### API 检查
- [ ] 是否使用统一的请求方法?
- [ ] 是否有错误处理?

### 移动端代码检查

#### 组件检查
- [ ] 是否使用 wd-* 组件?
- [ ] useToast 是否从 @/wd 导入?
- [ ] 是否使用 rpx 单位?

## 检查流程

### 步骤 1: 获取变更文件
```bash
git status --short
```

### 步骤 2: 读取文件内容
根据文件扩展名确定检查类型:
- `.java` - 后端代码
- `.vue` - Vue 组件
- `.ts` - TypeScript
- `.js` - JavaScript

### 步骤 3: 执行检查
根据检查项逐项验证

### 步骤 4: 生成报告
输出检查结果,包括:
- ✅ 通过项
- ⚠️ 警告项
- ❌ 错误项

## 示例输出

用户输入:
```
check
```

AI 输出:
```
## 🔍 代码规范检查报告

### 📂 检查范围
检测到 5 个变更文件:
- UserService.java
- UserDaoImpl.java
- UserController.java
- user.vue
- userApi.ts

---

### ☕ 后端检查

#### ✅ UserService.java
- ✅ Entity 继承 TenantEntity
- ✅ Service 未继承 ServiceImpl
- ✅ 使用 MapstructUtils 转换对象
- ✅ 使用 @RequiredArgsConstructor

#### ⚠️ UserDaoImpl.java
- ✅ 实现了 buildQueryWrapper()
- ⚠️ [行 45] 建议使用 likeCast() 替代 like()
  ```java
  // 当前
  .like(User::getUserName, bo.getUserName())
  // 建议改为
  .likeCast(User::getUserName, bo.getUserName())
  ```

#### ✅ UserController.java
- ✅ 路径包含实体名称 (/user)
- ✅ 有权限控制注解
- ✅ 有日志记录注解
- ✅ 统一返回格式
- ✅ 参数验证

---

### 🎨 前端检查

#### ✅ user.vue
- ✅ 使用 AFormInput 替代 el-input
- ✅ 使用 AModal 替代 el-dialog
- ✅ API 调用使用 [err, data] 格式

#### ✅ userApi.ts
- ✅ 使用统一的请求方法
- ✅ 有错误处理

---

### 📊 检查总结

| 类型 | ✅ 通过 | ⚠️ 警告 | ❌ 错误 |
|------|--------|---------|--------|
| 后端 | 15     | 1       | 0      |
| 前端 | 8      | 0       | 0      |
| 总计 | 23     | 1       | 0      |

### 💡 改进建议
1. UserDaoImpl.java:45 - 使用 likeCast() 替代 like()
2. 建议添加单元测试覆盖核心逻辑
3. 建议使用 @code-reviewer 进行深度审查

### ✅ 总体评价
代码质量良好,规范遵循度高。建议修复警告项后提交。
```

## 快速修复

对于常见问题,可以自动提供修复方案:

```bash
# 自动修复格式问题
check --fix

# 只检查不修复 (dry-run)
check --dry-run

# 生成详细报告
check --verbose

# 输出到文件
check --output check-report.md
```

## 注意事项
1. 检查是静态分析,不运行代码
2. 建议在提交代码前执行检查
3. 检查通过后仍需进行功能测试
4. 对于警告项,建议修复但不强制

## 集成到 Git Hooks
可以在提交前自动执行检查:
```bash
# .git/hooks/pre-commit
#!/bin/bash
check
if [ $? -ne 0 ]; then
  echo "代码检查未通过,请修复后再提交"
  exit 1
fi
```
