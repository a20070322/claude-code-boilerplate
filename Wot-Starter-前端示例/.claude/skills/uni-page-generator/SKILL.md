---
name: uni-page-generator
description: Use when creating uni-app pages in Wot Starter projects. Covers page structure, routing, layout configuration, and best practices.
             Trigger keywords: 页面、page、uni-app、路由、definePage
---

# uni-app 页面生成器

## 使用场景

- 创建主包页面 (`src/pages/`)
- 创建分包页面 (`src/subPages/`, `src/subEcharts` 等)
- 配置页面路由和布局

## 开发流程

### 步骤 1：确定页面位置

**页面位置规则**：
- TabBar 页面 → `src/pages/{name}/index.vue`
- 普通主包页面 → `src/pages/{name}/index.vue`
- 分包页面 → `src/subPages/{name}/index.vue`

### 步骤 2：配置 definePage 宏

**基础页面配置**：
```vue
<script setup lang="ts">
definePage({
  name: 'page-name',        // 路由名称，用于编程式导航
  layout: 'default',        // 布局：'default' | 'tabbar'
  style: {
    navigationBarTitleText: '页面标题',
  },
})
</script>
```

**TabBar 页面配置**：
```vue
<script setup lang="ts">
definePage({
  name: 'home',
  layout: 'tabbar',         // TabBar 页面必须使用 tabbar 布局
  style: {
    navigationBarTitleText: '首页',
  },
})
</script>
```

**参考示例**：[examples/page-templates.md](examples/page-templates.md)

### 步骤 3：页面跳转

```typescript
const router = useRouter()

// ✅ 正确：使用 name 跳转
router.push({ name: 'detail' })

// ✅ 正确：使用 path 跳转
router.push('/subPages/detail/index')

// ✅ 正确：带参数跳转
router.push({ name: 'detail', query: { id: '123' } })

// ❌ 错误：不要使用 uni.navigateTo
uni.navigateTo({ url: '/pages/detail/index' })
```

### 步骤 4：样式规范

```vue
<template>
  <!-- ✅ 正确：使用 UnoCSS 原子化样式 -->
  <view class="p-3 flex items-center justify-center">
    <text class="text-primary">内容</text>
  </view>

  <!-- ❌ 错误：不要使用复杂 class -->
  <view class="custom-container">
    <text class="custom-text">内容</text>
  </view>
</template>

<style scoped>
/* ❌ 禁止：不要使用 style 标签写样式 */
.custom-container {
  padding: 12px;
}
</style>
```

## 禁止事项 ⭐重要

| 禁止项 | 原因 | 正确做法 |
|--------|------|----------|
| ❌ 使用 `uni.navigateTo` | 不符合项目路由规范 | 使用 `useRouter()` |
| ❌ 忘记配置 `definePage` | 页面无法正常注册 | 每个页面必须配置 |
| ❌ 使用 `<style>` 标签 | 应该用 UnoCSS | 使用原子化样式 |
| ❌ TabBar 页面不用 tabbar 布局 | 布局错误 | 使用 `layout: 'tabbar'` |
| ❌ 在页面中写过多业务逻辑 | 难以维护 | 封装到 composable |

## 检查清单 ⭐重要

- [ ] 页面文件名固定为 `index.vue`
- [ ] 使用 `definePage` 宏配置页面
- [ ] 配置了正确的 `name`（用于导航）
- [ ] 配置了正确的 `layout`
- [ ] 配置了导航栏标题
- [ ] 使用 UnoCSS 原子化样式
- [ ] 使用 `useRouter()` 进行导航
- [ ] 分包目录已在 `vite.config.ts` 中注册
- [ ] TabBar 页面使用 `layout: 'tabbar'`

## 分包配置

### vite.config.ts 中注册分包

```typescript
export default defineConfig({
  plugins: [
    uni({
      subPackages: [
        {
          root: 'src/subPages',
          pages: [
            {
              path: 'detail/index',
              style: {
                navigationBarTitleText: '详情',
              },
            },
          ],
        },
      ],
    }),
  ],
})
```

## 完整示例

详细的页面示例，请参考：
- **[examples/page-templates.md](examples/page-templates.md)** - 各种页面模板
- **[examples/routing-guide.md](examples/routing-guide.md)** - 路由使用指南
- **[template.md](template.md)** - 页面配置表

## 快速参考

### definePage 配置项
```typescript
definePage({
  name: 'page-name',      // 必需：路由名称
  layout: 'default',      // 可选：default | tabbar
  style: {
    navigationBarTitleText: '标题',  // 导航栏标题
    navigationBarBackgroundColor: '#fff',  // 背景色
  },
})
```

### 路由跳转
```typescript
router.push({ name: 'page-name' })
router.push('/subPages/detail/index')
router.push({ name: 'detail', query: { id: '123' } })
router.replace({ name: 'home' })
router.back()
```

### 页面位置
```
src/pages/{name}/index.vue     # 主包
src/subPages/{name}/index.vue  # 分包
```
