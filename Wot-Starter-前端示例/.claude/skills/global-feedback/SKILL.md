---
name: global-feedback
description: 全局反馈组件（Toast/Message/Loading）使用指南
---

# 全局反馈组件

wot-starter 提供了全局 Toast、Message、Loading 组件，支持跨页面调用。

## useGlobalToast

```typescript
const { show, success, error, info, warning } = useGlobalToast()

success('操作成功')
error('操作失败')
```

## useGlobalMessage

```typescript
const { confirm } = useGlobalMessage()

confirm({
  title: '提示',
  msg: '确定要删除吗？',
  success() { console.log('确定') },
  fail() { console.log('取消') },
})
```

## useGlobalLoading

```typescript
const { show, hide } = useGlobalLoading()

show('加载中...')
hide()
```

## 禁止事项

- ❌ 不要使用 `uni.showToast`（应该用 `useGlobalToast()`）
- ❌ 不要使用 `uni.showModal`（应该用 `useGlobalMessage()`）
- ❌ 不要使用 `uni.showLoading`（应该用 `useGlobalLoading()`）
- ❌ 不要在循环中连续弹出多个 Toast

## 检查清单

- [ ] 使用 `useGlobalToast()` 而不是 `uni.showToast`
- [ ] 使用 `useGlobalMessage()` 而不是 `uni.showModal`
- [ ] 使用 `useGlobalLoading()` 而不是 `uni.showLoading`
- [ ] 错误信息有明确的提示
- [ ] Loading 状态正确关闭
