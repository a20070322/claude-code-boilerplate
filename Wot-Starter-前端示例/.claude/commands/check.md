# /check - 代码规范检查命令

## 描述
检查代码是否符合 Wot Starter 规范

## 使用方法
```
check                  # 检查所有变更
check <文件/目录>      # 检查指定文件
check --fix           # 自动修复问题
```

## 检查项

### 1. 样式检查
- [ ] 是否使用 UnoCSS 原子化样式？
- [ ] 是否避免使用 `<style>` 中的复杂样式？
- [ ] 是否使用 wot-design-uni 组件？

### 2. API 检查
- [ ] 是否使用 Alova 发送请求？
- [ ] 是否使用 `useRequest` Hook？
- [ ] 是否有错误处理？

### 3. 状态管理检查
- [ ] Store 是否符合 Pinia 规范？
- [ ] 是否使用 `storeToRefs` 保持响应性？
- [ ] 复杂逻辑是否封装到 Composable？

### 4. 路由检查
- [ ] 是否使用 `useRouter()` 导航？
- [ ] 页面是否使用 `definePage` 宏？
- [ ] TabBar 页面是否配置 `layout: 'tabbar'`？

### 5. 组件检查
- [ ] 是否使用 `<script setup>` 语法？
- [ ] Props 和 Emits 是否有类型定义？
- [ ] 是否使用 GlobalFeedback 处理交互？

### 6. 代码质量
- [ ] 是否有 TypeScript 类型错误？
- [ ] 是否有 ESLint 警告？
- [ ] 是否有未使用的变量？

## 执行步骤

### 步骤 1: 运行类型检查
```bash
pnpm type-check
```

### 步骤 2: 运行代码检查
```bash
pnpm lint:fix
```

### 步骤 3: 人工审查
使用检查清单逐项检查代码

### 步骤 4: 生成报告
输出检查结果和修复建议

## 示例输出

```
## 📋 代码检查报告

### ✅ 通过项
- [x] 使用 UnoCSS 原子化样式
- [x] 使用 wot-design-uni 组件
- [x] 使用 Alova 发送请求

### ⚠️ 警告项
- [ ] 缺少错误处理
  建议: 使用 useGlobalToast 显示错误信息
- [ ] Store 未使用 storeToRefs
  修复: const { data } = storeToRefs(store)

### ❌ 错误项
- [ ] 使用了 uni.showToast
  修复: const { show } = useGlobalToast()
  替换: show('提示信息')

### 修复命令
pnpm lint:fix
```

## 注意事项
1. 提交代码前必须执行检查
2. 自动修复只能解决格式问题
3. 逻辑问题需要人工审查
4. 建议使用 @code-reviewer 进行深度审查
