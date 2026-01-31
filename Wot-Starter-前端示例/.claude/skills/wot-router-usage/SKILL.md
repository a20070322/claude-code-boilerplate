---
name: wot-router-usage
description: '@wot-ui/router 轻量级路由库使用指南'
---

# @wot-ui/router 使用指南

专为 uni-app 设计的轻量级路由库，提供类似 Vue Router 的 API。

## 基础导航

```typescript
const router = useRouter()

// 字符串路径
router.push('/pages/detail/index')

// 对象形式
router.push({ name: 'detail' })

// 带参数
router.push({ name: 'detail', query: { id: '123' } })
```

## 禁止事项

- ❌ 不要使用 `uni.navigateTo`（应该用 `router.push()`）
- ❌ 不要使用 `uni.redirectTo`（应该用 `router.replace()`）
- ❌ 不要使用 `uni.navigateBack`（应该用 `router.back()`）
- ❌ 不要在 TabBar 页面使用 `redirectTo`（应该用 `reLaunch`）

## 检查清单

- [ ] 使用 `useRouter()` 而不是 `uni.navigateTo`
- [ ] 使用 `useRoute()` 获取路由信息
- [ ] TabBar 页面使用 `reLaunch: true`
- [ ] 路由配置在 `definePage` 中
- [ ] 分包页面已在 `vite.config.ts` 中注册
