# /store - Pinia Store 创建命令

## 描述
创建符合 Wot Starter 规范的 Pinia Store

## 使用方法
```
/store 创建用户状态管理
/store 添加购物车 Store
```

## 执行步骤

### 步骤 1: 激活技能
```
必须激活: pinia-store-generator
可能需要: alova-api-module (如果需要调用 API)
```

### 步骤 2: 确定 Store 类型
- [ ] 简单状态 (使用 ref/reactive)
- [ ] Pinia Store (Options API 推荐)
- [ ] 带持久化的 Store
- [ ] 结合 API 的 Store

### 步骤 3: 创建 Store 文件
在 `src/store/` 创建 `{moduleName}Store.ts`：

```typescript
// src/store/{moduleName}Store.ts
import { defineStore } from 'pinia'

export const use{ModuleName}Store = defineStore('{moduleName}', {
  state: () => ({
    data: null,
    loading: false,
    error: null,
  }),

  getters: {
    isLoaded: (state) => state.data !== null,
    hasError: (state) => state.error !== null,
  },

  actions: {
    setData(data: any) {
      this.data = data
    },

    async fetchData() {
      this.loading = true
      this.error = null
      try {
        const { data } = await useRequest(Apis.xxx.getData())
        this.data = data.value
      } catch (err) {
        this.error = err as Error
      } finally {
        this.loading = false
      }
    },

    reset() {
      this.$reset()
    },
  },
})
```

### 步骤 4: 添加类型定义
```typescript
// src/types/{moduleName}.ts
export interface {ModuleName}State {
  data: {DataType} | null
  loading: boolean
  error: Error | null
}
```

### 步骤 5: 配置持久化（可选）
```typescript
import { createPersistedState } from '@/store/persist'

export const use{ModuleName}Store = defineStore('{moduleName}', {
  state: () => ({
    token: '',
    userInfo: null,
  }),

  actions: {
    setToken(token: string) {
      this.token = token
    },
  },

  // 启用持久化
  persist: createPersistedState({
    key: '{moduleName}-storage',
    paths: ['token', 'userInfo'],  // 只持久化指定字段
  }),
})
```

### 步骤 6: 在组件中使用
```vue
<script setup lang="ts">
const {moduleName}Store = use{ModuleName}Store()

// 访问状态
const data = computed(() => {moduleName}Store.data)
const loading = computed(() => {moduleName}Store.loading)

// 调用 action
onMounted(() => {
  {moduleName}Store.fetchData()
})
</script>
```

## 禁止事项
- ❌ 不要在 Store 中直接调用 `uni.xxx` API
- ❌ 不要在 Store 中进行复杂的业务逻辑
- ❌ 不要持久化敏感数据 (如密码、token)
- ❌ 不要在 getters 中进行异步操作

## 检查清单
- [ ] Store 文件名使用 `{moduleName}Store.ts` 格式
- [ ] 导出函数使用 `use{ModuleName}Store` 命名
- [ ] 状态定义清晰，类型明确
- [ ] Actions 包含错误处理
- [ ] 复杂逻辑封装到 Composable 中
- [ ] 持久化配置正确

## 示例执行

用户输入:
```
/store 创建购物车状态管理，需要添加商品、删除商品、计算总价
```

AI 执行流程:
```
### 步骤 1: 激活技能
激活 pinia-store-generator 技能

### 步骤 2: 确定 Store 类型
购物车需要：
- 状态管理 (商品列表)
- 计算属性 (总价)
- 持久化 (保存到本地)

### 步骤 3: 创建 Store
创建: src/store/cartStore.ts

定义 state:
- items: CartItem[] - 商品列表
- loading: boolean - 加载状态

定义 getters:
- totalPrice - 总价
- totalCount - 总数量
- isEmpty - 是否为空

定义 actions:
- addItem - 添加商品
- removeItem - 删除商品
- updateQuantity - 更新数量
- clear - 清空购物车

### 步骤 4: 配置持久化
使用 createPersistedState 持久化 items

### 步骤 5: 在组件中使用
展示购物车组件如何使用 Store

### 步骤 6: 测试验证
[提供测试步骤]
```

## 注意事项
1. Store 文件名使用 `{moduleName}Store.ts` 格式
2. 导出的函数使用 `use{ModuleName}Store` 命名
3. 复杂逻辑建议封装到 composable 中
4. 敏感数据不要持久化到本地存储
5. 使用 `storeToRefs` 保持响应性
