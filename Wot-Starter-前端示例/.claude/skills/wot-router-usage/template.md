# 路由使用配置表

> @wot-ui/router 使用指南

## 🚀 基础用法

```typescript
const router = useRouter()

// 跳转
router.push({ name: 'page-name' })

// 带参数
router.push({ name: 'detail', query: { id: '123' } })

// 替换
router.replace({ name: 'home' })

// 返回
router.back()
```

## 📝 参数获取

```typescript
const route = router.currentRoute.value
const query = route.query
const id = query.id as string
```

## ⚠️ 禁止事项

- ❌ 不要使用 `uni.navigateTo`
- ❌ 不要使用 `uni.redirectTo`
- ❌ 不要使用 `uni.switchTab`
- ✅ 统一使用 `useRouter()`

---
