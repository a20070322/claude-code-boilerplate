# Vue Composable 完整示例

## Composable 定义

```typescript
// src/composables/useUser.ts
import { ref } from 'vue'
import { getUserInfoApi } from '@/api/user'
import { useGlobalToast } from './useGlobalToast'

export function useUser() {
  const { toast } = useGlobalToast()

  const userInfo = ref<User | null>(null)
  const loading = ref(false)

  // 加载用户信息
  const loadUserInfo = async () => {
    loading.value = true
    try {
      const data = await getUserInfoApi()
      userInfo.value = data
    } catch (error) {
      toast.error('加载失败')
    } finally {
      loading.value = false
    }
  }

  return {
    userInfo,
    loading,
    loadUserInfo,
  }
}
```

## 在组件中使用

```vue
<script setup lang="ts">
import { useUser } from '@/composables/useUser'

const { userInfo, loading, loadUserInfo } = useUser()

onMounted(() => {
  loadUserInfo()
})
</script>
```
