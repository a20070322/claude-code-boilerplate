---
name: uni-page-generator
description: 基于项目规范快速生成 uni-app 页面
---

# uni-app 页面生成器

快速创建符合 wot-starter 项目规范的 uni-app 页面。

## 使用场景

- 创建主包页面 (`src/pages/`)
- 创建分包页面 (`src/subPages/`, `src/subEcharts` 等)
- 自动配置路由和布局

## 页面模板

### 基础页面

```vue
<script setup lang="ts">
definePage({
  name: '页面名称',           // 路由 name，用于编程式导航
  layout: 'default',         // 布局：'default' | 'tabbar'
  style: {
    navigationBarTitleText: '页面标题',
  },
})

const router = useRouter()
</script>

<template>
  <view class="p-3">
    <!-- 页面内容 -->
  </view>
</template>
```

### TabBar 页面

```vue
<script setup lang="ts">
definePage({
  name: 'home',
  layout: 'tabbar',          // 使用 tabbar 布局
  style: {
    navigationBarTitleText: '首页',
  },
})
</script>

<template>
  <view class="box-border py-3">
    <!-- TabBar 页面内容 -->
  </view>
</template>
```

## 目录结构

```
src/
├── pages/              # 主包页面（TabBar 页面）
│   ├── index/
│   │   └── index.vue
│   └── about/
│       └── index.vue
├── subPages/           # 分包页面
│   ├── router/
│   ├── request/
│   └── ...
└── subEcharts/         # ECharts 分包
```

## 创建步骤

1. **确定页面位置**
   - TabBar 页面 → `src/pages/{name}/index.vue`
   - 普通页面 → `src/subPages/{name}/index.vue`

2. **使用 definePage 宏**
   - 配置 `name` 用于编程式导航
   - 配置 `layout` 选择布局
   - 配置 `style` 设置导航栏

3. **页面跳转**
```typescript
const router = useRouter()

// 使用 name 跳转
router.push({ name: 'detail' })

// 使用 path 跳转
router.push('/subPages/detail/index')

// 带参数跳转
router.push({ name: 'detail', query: { id: '123' } })
```

## 禁止事项

- ❌ 不要使用 `uni.navigateTo`（应该用 `useRouter()`）
- ❌ 不要忘记配置 `definePage` 宏
- ❌ 不要在主包页面中使用分包组件
- ❌ 不要使用非 UnoCSS 的复杂样式
- ❌ 不要在页面中写过多的业务逻辑（应该封装到 composable）

## 检查清单

- [ ] 页面文件名固定为 `index.vue`
- [ ] 使用 `definePage` 宏配置页面
- [ ] 配置了正确的 `name`（用于导航）
- [ ] 配置了正确的 `layout`
- [ ] 配置了导航栏标题
- [ ] 使用 UnoCSS 原子化样式
- [ ] 使用 `useRouter()` 进行导航
- [ ] 分包目录已在 `vite.config.ts` 中注册
- [ ] TabBar 页面使用 `layout: 'tabbar'`

## 注意事项

- 分包目录需在 `vite.config.ts` 的 `subPackages` 中注册
- 页面文件名固定为 `index.vue`
- 使用 UnoCSS 原子化样式
- 路由跳转使用 `useRouter()` 而不是 `uni.navigateTo()`
