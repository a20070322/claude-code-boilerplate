# /theme-config - 主题配置

## 描述
帮助用户配置 Wot Design Uni 的主题，包括颜色定制、暗黑模式、CSS 变量覆盖等。

## 使用方法
```
/theme-config <配置类型>
```

**示例：**
```
/theme-config color      # 颜色定制
/theme-config dark       # 暗黑模式
/theme-config custom     # 自定义变量
```

## 执行步骤

### 步骤 1: 了解主题系统
- [ ] 介绍 Wot Design Uni 的主题定制方式
- [ ] 说明 CSS 变量的作用
- [ ] 解释主题变量的层级关系

### 步骤 2: 颜色定制
- [ ] 介绍主题颜色变量
- [ ] 提供主色调配置示例
- [ ] 展示完整的颜色变量列表

### 步骤 3: 暗黑模式
- [ ] 配置暗黑模式支持
- [ ] 设置暗黑模式下的颜色变量
- [ ] 实现模式切换功能

### 步骤 4: CSS 变量覆盖
- [ ] 展示如何覆盖组件样式
- [ ] 提供常用变量列表
- [ ] 给出实际配置示例

### 步骤 5: 配置验证
- [ ] 检查配置文件位置
- [ ] 验证变量语法正确性
- [ ] 测试主题效果

## 示例执行

### 场景 1: 主色调定制

**用户输入：** `/theme-config color`

**执行过程：**

1. **创建主题变量文件**：
```css
/* theme.css */
:root {
  /* 主色调 */
  --wd-color-theme: #3b82f6;
  --wd-color-theme-light: #60a5fa;
  --wd-color-theme-lighter: #93c5fd;
  --wd-color-theme-dark: #2563eb;
  --wd-color-theme-darker: #1d4ed8;

  /* 功能色 */
  --wd-color-success: #10b981;
  --wd-color-warning: #f59e0b;
  --wd-color-danger: #ef4444;
  --wd-color-info: #6b7280;
}
```

2. **在 App.vue 中引入**：
```vue
<script setup>
import '@/theme.css'
</script>
```

3. **应用效果**：
- 所有组件的主色调变为蓝色
- 按钮、链接、选中状态等自动应用新颜色

### 场景 2: 暗黑模式配置

**用户输入：** `/theme-config dark`

**执行过程：**

1. **配置暗黑模式变量**：
```css
/* theme-dark.css */
@media (prefers-color-scheme: dark) {
  :root {
    --wd-color-bg: #1a1a1a;
    --wd-color-bg-page: #000000;
    --wd-color-text: #ffffff;
    --wd-color-text-placeholder: #999999;
    --wd-color-border: #333333;
  }
}

/* 或者手动控制 */
.dark {
  --wd-color-bg: #1a1a1a;
  --wd-color-bg-page: #000000;
  --wd-color-text: #ffffff;
  --wd-color-text-placeholder: #999999;
  --wd-color-border: #333333;
}
```

2. **实现切换功能**：
```vue
<template>
  <wd-cell title="暗黑模式">
    <wd-switch v-model="isDark" @change="toggleDark" />
  </wd-cell>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const isDark = ref(false)

onMounted(() => {
  // 检查系统主题设置
  const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
  isDark.value = mediaQuery.matches
})

const toggleDark = (value) => {
  if (value) {
    document.body.classList.add('dark')
    uni.setStorageSync('theme', 'dark')
  } else {
    document.body.classList.remove('dark')
    uni.setStorageSync('theme', 'light')
  }
}
</script>
```

### 场景 3: 组件样式定制

**用户输入：** `/theme-config custom`

**执行过程：**

1. **自定义按钮样式**：
```css
/* 覆盖按钮圆角 */
--wd-button-border-radius: 8px;

/* 覆盖按钮高度 */
--wd-button-height-large: 48px;
--wd-button-height-medium: 40px;
--wd-button-height-small: 32px;

/* 覆盖输入框样式 */
--wd-input-bg-color: #f5f5f5;
--wd-input-border-radius: 8px;
```

2. **自定义卡片样式**：
```css
/* 卡片阴影 */
--wd-card-box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);

/* 卡片圆角 */
--wd-card-border-radius: 12px;

/* 卡片内边距 */
--wd-card-padding: 16px;
```

## 主题变量完整列表

### 颜色变量

```css
/* 主色调 */
--wd-color-theme: #05c685;
--wd-color-theme-light: #34d399;
--wd-color-theme-lighter: #6ee7b7;
--wd-color-theme-dark: #04ac73;
--wd-color-theme-darker: #039262;

/* 文字颜色 */
--wd-color-text: #303133;
--wd-color-text-regular: #606266;
--wd-color-text-secondary: #909399;
--wd-color-text-placeholder: #c0c4cc;
--wd-color-text-disabled: #c0c4cc;

/* 背景颜色 */
--wd-color-bg: #ffffff;
--wd-color-bg-page: #f5f5f5;
--wd-color-bg-disabled: #ebebee;

/* 边框颜色 */
--wd-color-border: #dcdfe6;
--wd-color-border-light: #e4e7ed;

/* 功能色 */
--wd-color-success: #07c160;
--wd-color-warning: #ff976a;
--wd-color-danger: #ee0a24;
--wd-color-info: #909399;
```

### 组件变量

```css
/* 按钮 */
--wd-button-border-radius: 4px;
--wd-button-height-large: 48px;
--wd-button-height-medium: 40px;
--wd-button-height-small: 32px;

/* 输入框 */
--wd-input-height: 40px;
--wd-input-bg-color: #ffffff;
--wd-input-border-radius: 4px;

/* 卡片 */
--wd-card-padding: 20px;
--wd-card-border-radius: 8px;

/* 弹窗 */
--wd-dialog-border-radius: 16px;
--wd-dialog-width: 85%;
```

## 配置方式

### 方式 1: 全局 CSS 文件

1. 创建 `theme.css` 文件
2. 定义 CSS 变量
3. 在 `App.vue` 中引入

```vue
<!-- App.vue -->
<script setup>
import './theme.css'
</script>
```

### 方式 2: 页面级别

```vue
<template>
  <view class="custom-theme">
    <!-- 页面内容 -->
  </view>
</template>

<style>
.custom-theme {
  --wd-color-theme: #3b82f6;
  --wd-button-border-radius: 8px;
}
</style>
```

### 方式 3: 组件级别

```vue
<template>
  <wd-button custom-class="custom-button">按钮</wd-button>
</template>

<style>
.custom-button {
  --wd-button-bg-color: #3b82f6;
  --wd-button-border-radius: 8px;
}
</style>
```

## 注意事项

### 1. 变量作用域
- `:root` 定义全局变量
- 特定类名定义局部变量
- 局部变量优先级高于全局变量

### 2. 变量命名
- 必须以 `--wd-` 开头
- 使用 kebab-case 命名
- 遵循组件库的命名规范

### 3. 浏览器兼容
- CSS 变量需要现代浏览器支持
- uni-app 已处理兼容性问题
- 小程序环境完全支持

### 4. 性能优化
- 避免频繁切换主题
- 使用类名切换而非修改变量值
- 暗黑模式使用媒体查询自动切换

### 5. 版本升级
- 组件库更新可能新增变量
- 删除变量的可能性较低
- 升级后检查主题效果

## 常见问题

**Q: 修改颜色不生效？**
A: 检查变量名是否正确，是否以 `--wd-` 开头

**Q: 如何只修改某个组件的样式？**
A: 使用 `custom-class` 属性，为该组件添加单独的样式类

**Q: 暗黑模式如何持久化？**
A: 使用 `uni.setStorageSync()` 保存用户选择，启动时恢复

**Q: CSS 变量在小程序中不生效？**
A: 确保使用最新版本的 HBuilderX 和 uni-app

## 相关命令

- `/use-component` - 查看组件的可用 CSS 变量
- `/check-usage` - 检查主题配置是否正确
