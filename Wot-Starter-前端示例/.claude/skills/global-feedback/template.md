# 全局反馈组件使用指南

> Wot Starter 提供的全局反馈组件

## 🔔 Toast 提示

```typescript
const { toast } = useGlobalToast()

toast.success('成功')
toast.error('失败')
toast.warning('警告')
toast.info('提示')
```

## 💬 Message 消息

```typescript
const { message } = useGlobalMessage()

message.success('成功消息')
message.error('错误消息')
```

## ⏳ Loading 加载

```typescript
const { loading } = useGlobalLoading()

loading.show()
loading.hide()
```

## 🔘 Modal 确认

```typescript
const { modal } = useGlobalModal()

const confirmed = await modal.confirm({
  title: '确认删除？',
  message: '删除后无法恢复',
})
```

## ⚠️ 禁止事项

- ❌ 不要使用 `uni.showToast`（用 `toast`）
- ❌ 不要使用 `uni.showLoading`（用 `loading`）
- ❌ 不要使用 `uni.showModal`（用 `modal`）

---
