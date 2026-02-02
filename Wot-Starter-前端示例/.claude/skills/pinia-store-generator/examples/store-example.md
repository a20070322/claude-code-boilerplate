# Pinia Store 完整示例

## Store 定义

```typescript
// src/store/useUserStore.ts
import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', () => {
  // State
  const userInfo = ref<User | null>(null)
  const token = ref('')

  // Actions
  const setUserInfo = (info: User) => {
    userInfo.value = info
  }

  const setToken = (value: string) => {
    token.value = value
  }

  const logout = () => {
    userInfo.value = null
    token.value = ''
  }

  return {
    userInfo,
    token,
    setUserInfo,
    setToken,
    logout,
  }
}, {
  // 持久化配置
  persist: {
    key: 'user-store',
    storage: localStorage,
    paths: ['userInfo', 'token'],
  },
})
```

## 在组件中使用

```vue
<script setup lang="ts">
import { useUserStore } from '@/store/useUserStore'

const userStore = useUserStore()

// 读取状态
console.log(userStore.userInfo)
console.log(userStore.token)

// 调用方法
userStore.setUserInfo({ name: 'admin' })
userStore.logout()
</script>
```
