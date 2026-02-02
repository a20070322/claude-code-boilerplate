# Alova API 模块完整示例

## 1. Mock 模块

```typescript
// src/api/mock/modules/user.ts
import { defineMock } from '@alova/mock'

export default defineMock({
  // 查询用户列表
  '/api/user/list': ({ data }) => {
    const { page = 1, pageSize = 10, keyword = '' } = data
    return {
      code: 200,
      message: 'success',
      data: {
        list: Array.from({ length: pageSize }, (_, i) => ({
          id: String((page - 1) * pageSize + i + 1),
          name: `用户${(page - 1) * pageSize + i + 1}`,
          email: `user${(page - 1) * pageSize + i + 1}@example.com`,
          avatar: 'https://via.placeholder.com/100',
        })),
        total: 100,
      },
    }
  },

  // 查询用户详情
  '/api/user/detail': ({ data }) => ({
    code: 200,
    message: 'success',
    data: {
      id: data.id,
      name: '用户1',
      email: 'user1@example.com',
      avatar: 'https://via.placeholder.com/100',
    },
  }),

  // 创建用户
  '[POST]/api/user/create': ({ data }) => ({
    code: 200,
    message: '创建成功',
    data: {
      id: String(Date.now()),
      ...data,
    },
  }),

  // 更新用户
  '[PUT]/api/user/update': ({ data }) => ({
    code: 200,
    message: '更新成功',
    data: {
      ...data,
      updateTime: new Date().toISOString(),
    },
  }),

  // 删除用户
  '[DELETE]/api/user/delete': ({ data }) => ({
    code: 200,
    message: '删除成功',
    data: {
      id: data.id,
    },
  }),
})
```

## 2. API 实例

```typescript
// src/api/user.ts
import { alovaInstance } from '@/utils/alova'
import type { UserResponse, UserListResponse, UserParams } from './types'

// 查询用户列表
export const getUserListApi = (params: UserParams) =>
  alovaInstance.Get<UserListResponse>('/api/user/list', {
    params,
  })

// 查询用户详情
export const getUserDetailApi = (id: string) =>
  alovaInstance.Get<UserResponse>('/api/user/detail', {
    params: { id },
  })

// 创建用户
export const createUserApi = (data: Partial<User>) =>
  alovaInstance.Post<UserResponse>('/api/user/create', data)

// 更新用户
export const updateUserApi = (data: User) =>
  alovaInstance.Put<UserResponse>('/api/user/update', data)

// 删除用户
export const deleteUserApi = (id: string) =>
  alovaInstance.Delete<UserResponse>('/api/user/delete', {
    params: { id },
  })
```

## 3. 类型定义

```typescript
// src/api/types.ts
export interface User {
  id: string
  name: string
  email: string
  avatar: string
  createTime?: string
  updateTime?: string
}

export interface UserParams {
  page?: number
  pageSize?: number
  keyword?: string
}

export interface UserResponse {
  code: number
  message: string
  data: User
}

export interface UserListResponse {
  code: number
  message: string
  data: {
    list: User[]
    total: number
  }
}
```

## 4. 在组件中使用

```vue
<script setup lang="ts">
import { getUserListApi } from '@/api/user'
import { useGlobalToast } from '@/composables/useGlobalToast'

const { toast } = useGlobalToast()

// 使用 useRequest Hook
const {
  data,
  loading,
  send: loadUserList,
} = useRequest(
  () => getUserListApi({ page: 1, pageSize: 10 }),
  {
    immediate: true,
  }
)

// 错误处理
watchEffect(() => {
  if (error.value) {
    toast.error(error.value.message)
  }
})
</script>

<template>
  <view v-if="loading">加载中...</view>
  <view v-else>
    <view v-for="user in data?.data.list" :key="user.id">
      {{ user.name }}
    </view>
  </view>
</template>
```

## 5. 在 Composable 中使用

```typescript
// src/composables/useUser.ts
import { getUserListApi, getUserDetailApi } from '@/api/user'
import { useGlobalToast } from './useGlobalToast'

export function useUser() {
  const { toast } = useGlobalToast()

  const list = ref([])
  const loading = ref(false)

  // 加载列表
  const loadList = async (params?: any) => {
    loading.value = true
    try {
      const res = await getUserListApi(params)
      list.value = res.data.list
    } catch (error) {
      toast.error('加载失败')
    } finally {
      loading.value = false
    }
  }

  // 加载详情
  const loadDetail = async (id: string) => {
    try {
      const res = await getUserDetailApi(id)
      return res.data
    } catch (error) {
      toast.error('加载失败')
      return null
    }
  }

  return {
    list,
    loading,
    loadList,
    loadDetail,
  }
}
```
