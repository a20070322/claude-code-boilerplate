---
name: vue-composable-creator
description: 快速创建 Vue 3 组合式函数
---

# Vue Composable 创建器

快速创建符合 wot-starter 项目规范的 Vue 3 组合式函数。

## 基础模板

```typescript
// src/composables/use{Name}.ts
import { ref, computed } from 'vue'

export function use{Name}() {
  const state = ref<StateType>(initialValue)
  const loading = ref(false)

  function doSomething() {
    // 业务逻辑
  }

  return {
    state,
    loading,
    doSomething,
  }
}
```

## 禁止事项

- ❌ 不要在 Composable 中直接操作 DOM（应该在组件中）
- ❌ 不要在 Composable 中使用 `this`
- ❌ 不要在 Composable 中创建过多的响应式状态（影响性能）
- ❌ 不要忘记清理副作用（如事件监听器）

## 检查清单

- [ ] 文件名使用 `use{Name}.ts` 格式
- [ ] 导出函数使用 `use{Name}` 命名
- [ ] 有明确的类型定义
- [ ] 返回值保持响应性
- [ ] 有清理副作用逻辑（如需要）
- [ ] 在 `onUnmounted` 中清理资源
