---
name: alova-api-module
description: 快速创建 Alova 请求模块和 Mock 数据
---

# Alova API 模块生成器

基于 Alova 请求库创建 API 模块和 Mock 数据。

## 创建 Mock 模块

```typescript
// src/api/mock/modules/{moduleName}.ts
import { defineMock } from '@alova/mock'

export default defineMock({
  '/api/{moduleName}/list': () => ({
    code: 200,
    message: 'success',
    data: { list: [], total: 0 },
  }),

  '[POST]/api/{moduleName}/create': ({ data }) => ({
    code: 200,
    message: '创建成功',
    data: { id: Date.now(), ...data },
  }),
})
```

## 禁止事项

- ❌ 不要直接使用 `uni.request`（应该用 Alova）
- ❌ 不要在组件中直接写请求逻辑（应该用 Store 或 Composable）
- ❌ 不要忘记错误处理
- ❌ 不要在 Mock 中硬编码敏感数据

## 检查清单

- [ ] Mock 数据格式统一（code/message/data）
- [ ] 使用 `useRequest` Hook
- [ ] 有错误处理逻辑
- [ ] 使用 GlobalFeedback 显示错误
- [ ] 响应数据有明确的类型定义
