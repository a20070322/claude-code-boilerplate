# /api - API 模块创建命令

## 描述
基于 Alova 请求库创建 API 模块和 Mock 数据

## 使用方法
```
/api 创建用户相关的 API
/api 添加订单查询和创建接口
```

## 执行步骤

### 步骤 1: 激活技能
```
必须激活: alova-api-module
可能需要: global-feedback
```

### 步骤 2: 创建 Mock 模块
在 `src/api/mock/modules/` 创建 Mock 数据：

```typescript
// src/api/mock/modules/{moduleName}.ts
import { defineMock } from '@alova/mock'

export default defineMock({
  // GET 请求
  '/api/{moduleName}/list': () => {
    return {
      code: 200,
      message: 'success',
      data: {
        list: [],
        total: 0,
      },
    }
  },

  // POST 请求
  '[POST]/api/{moduleName}/create': ({ data }) => {
    return {
      code: 200,
      message: '创建成功',
      data: { id: Date.now(), ...data },
    }
  },
})
```

### 步骤 3: 注册 Mock 模块
在 `src/api/mock/mockAdapter.ts` 中注册：

```typescript
import newModuleMock from './modules/{moduleName}'

export default createAlovaMockAdapter([
  // ...其他模块
  newModuleMock,  // 注册新模块
], {
  enable: import.meta.env.DEV,
  delay: 300,
})
```

### 步骤 4: 使用 API
在组件或 Store 中使用：

```typescript
// useRequest Hook
const { data, loading, error, send } = useRequest(
  Apis.{moduleName}.getList({ page: 1, pageSize: 10 }),
  { immediate: true }
)

// usePagination Hook
const {
  data: list,
  page,
  loading,
  refresh,
} = usePagination(
  (page, pageSize) => Apis.{moduleName}.getList({ page, pageSize }),
  {
    initialPage: 1,
    initialPageSize: 10
  }
)
```

### 步骤 5: 添加错误处理
```typescript
const { data, loading, error } = useRequest(
  Apis.{moduleName}.getData(),
  {
    immediate: true,
  }
)

// 监听错误
watchEffect(() => {
  if (error.value) {
    const { showError } = useGlobalToast()
    showError('请求失败：' + error.value.message)
  }
})
```

### 步骤 6: 测试验证
- [ ] Mock 数据正常返回
- [ ] 响应类型正确
- [ ] 错误处理正常
- [ ] 加载状态正常

## 示例执行

用户输入:
```
/api 创建优惠券相关的 API，包括列表查询、创建、删除
```

AI 执行流程:
```
### 步骤 1: 激活技能
激活 alova-api-module 技能

### 步骤 2: 创建 Mock 模块
创建: src/api/mock/modules/coupon.ts

定义接口:
- GET /api/coupon/list - 获取优惠券列表
- GET /api/coupon/:id - 获取优惠券详情
- POST /api/coupon/create - 创建优惠券
- POST /api/coupon/delete/:id - 删除优惠券

### 步骤 3: 注册 Mock
在 mockAdapter.ts 中注册 coupon 模块

### 步骤 4: 在 Store 中使用
创建 useCouponStore 封装 API 调用

### 步骤 5: 在组件中使用
展示如何调用 API 和处理响应

### 步骤 6: 测试验证
[提供测试步骤]
```

## 注意事项
1. Mock 数据只在开发环境生效
2. 使用 `useRequest` 和 `usePagination` Hooks
3. 错误处理使用 `global-feedback`
4. API 定义会通过 alova-gen 自动生成
5. 响应数据必须有明确的类型定义
