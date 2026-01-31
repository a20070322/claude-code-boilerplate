---
name: usage-basic-component
description: 基础组件使用技能 - 按钮、图标、头像、徽标、标签等基础组件的正确使用方法
---

# Wot Design Uni - 基础组件使用

## 使用场景
当需要使用以下基础组件时触发此技能：
- 按钮 (wd-button)
- 图标 (wd-icon)
- 单元格 (wd-cell)
- 头像 (wd-avatar)
- 徽标 (wd-badge)
- 标签 (wd-tag)
- 分割线 (wd-divider)

## 组件使用模板

### 1. 按钮 (wd-button)

```vue
<template>
  <!-- 基础用法 -->
  <wd-button type="primary">主要按钮</wd-button>
  <wd-button type="success">成功按钮</wd-button>
  <wd-button type="warning">警告按钮</wd-button>
  <wd-button type="error">危险按钮</wd-button>
  <wd-button type="default">默认按钮</wd-button>

  <!-- 不同尺寸 -->
  <wd-button size="small">小按钮</wd-button>
  <wd-button size="medium">中等按钮</wd-button>
  <wd-button size="large">大按钮</wd-button>

  <!-- 朴素按钮 -->
  <wd-button plain>朴素按钮</wd-button>

  <!-- 圆角按钮 -->
  <wd-button round>圆角按钮</wd-button>

  <!-- 图标按钮 -->
  <wd-button icon="check-circle">带图标</wd-button>

  <!-- 加载状态 -->
  <wd-button loading>加载中</wd-button>

  <!-- 禁用状态 -->
  <wd-button disabled>禁用按钮</wd-button>

  <!-- 块级按钮 -->
  <wd-button block>块级按钮</wd-button>
</template>

<script setup lang="ts">
// 按钮事件
const handleClick = () => {
  console.log('按钮被点击')
}
</script>
```

### 2. 图标 (wd-icon)

```vue
<template>
  <!-- 使用内置图标 -->
  <wd-icon name="check-circle" color="#34d399" size="20px"></wd-icon>
  <wd-icon name="close-circle" color="#ef4444" size="24px"></wd-icon>
  <wd-icon name="warning-circle" color="#f59e0b" size="28px"></wd-icon>

  <!-- 自定义颜色和大小 -->
  <wd-icon name="location" custom-style="color: #3b82f6; font-size: 32px"></wd-icon>

  <!-- 图标类名 -->
  <wd-icon name="star" custom-class="custom-icon"></wd-icon>
</template>

<style>
.custom-icon {
  color: #8b5cf6;
  font-size: 40px;
}
</style>
```

### 3. 单元格 (wd-cell)

```vue
<template>
  <!-- 基础用法 -->
  <wd-cell title="单元格" value="内容"></wd-cell>

  <!-- 带图标 -->
  <wd-cell title="单元格" icon="location"></wd-cell>

  <!-- 只读 -->
  <wd-cell title="单元格" value="内容" readonly></wd-cell>

  <!-- 可点击 -->
  <wd-cell title="单元格" value="内容" is-link @click="handleClick"></wd-cell>

  <!-- 垂直居中 -->
  <wd-cell title="单元格" value="内容" center></wd-cell>

  <!-- 分组使用 -->
  <wd-group>
    <wd-cell title="姓名" value="张三"></wd-cell>
    <wd-cell title="手机号" value="13800138000"></wd-cell>
    <wd-cell title="地址" is-link @click="handleClick"></wd-cell>
  </wd-group>
</template>
```

### 4. 头像 (wd-avatar)

```vue
<template>
  <!-- 基础用法 -->
  <wd-avatar src="https://example.com/avatar.png"></wd-avatar>

  <!-- 不同尺寸 -->
  <wd-avatar size="small">小</wd-avatar>
  <wd-avatar size="medium">中</wd-avatar>
  <wd-avatar size="large">大</wd-avatar>

  <!-- 圆形头像 -->
  <wd-avatar round>头像</wd-avatar>

  <!-- 自定义背景色 -->
  <wd-avatar custom-style="background-color: #3b82f6">U</wd-avatar>

  <!-- 图片加载失败 -->
  <wd-avatar src="invalid-url" alt-text="加载失败"></wd-avatar>
</template>
```

### 5. 徽标 (wd-badge)

```vue
<template>
  <!-- 基础用法 -->
  <wd-badge content="5">
    <wd-button>按钮</wd-button>
  </wd-badge>

  <!-- 最大值 -->
  <wd-badge content="99" max="10">
    <wd-button>按钮</wd-button>
  </wd-badge>

  <!-- 红点 -->
  <wd-badge is-dot>
    <wd-button>按钮</wd-button>
  </wd-badge>

  <!-- 自定义颜色 -->
  <wd-badge content="NEW" custom-style="background-color: #10b981">
    <wd-button>按钮</wd-button>
  </wd-badge>
</template>
```

### 6. 标签 (wd-tag)

```vue
<template>
  <!-- 基础用法 -->
  <wd-tag>标签</wd-tag>
  <wd-tag type="primary">标签</wd-tag>
  <wd-tag type="success">标签</wd-tag>
  <wd-tag type="warning">标签</wd-tag>
  <wd-tag type="danger">标签</wd-tag>

  <!-- 空心标签 -->
  <wd-tag plain>标签</wd-tag>

  <!-- 可关闭 -->
  <wd-tag closable @close="handleClose">标签</wd-tag>

  <!-- 不同尺寸 -->
  <wd-tag size="small">小标签</wd-tag>
  <wd-tag size="medium">中标签</wd-tag>
  <wd-tag size="large">大标签</wd-tag>
</template>

<script setup lang="ts">
const handleClose = () => {
  console.log('标签关闭')
}
</script>
```

## 禁止事项 ⭐重要

- ❌ 不要使用非 `wd-` 前缀的组件名称
- ❌ 不要忘记在 `pages.json` 中配置 easycom
- ❌ 不要使用不存在的图标名称（先查阅文档）
- ❌ 不要在按钮上同时使用 `loading` 和 `disabled` 属性
- ❌ 不要在单元格内容过长时使用 `value` 属性，应使用默认插槽

## 检查清单 ⭐重要

- [ ] 是否查阅了官方文档确认组件用法
- [ ] 组件名称是否以 `wd-` 开头
- [ ] 是否配置了 easycom 自动引入
- [ ] Props 属性名称是否正确（注意 kebab-case）
- [ ] 事件名称是否正确（注意 @ 前缀）
- [ ] 是否测试了目标平台
- [ ] 样式是否需要自定义（使用 CSS 变量或 custom-style）

## 注意事项

### 图标使用
1. 查看官方文档确认可用的图标名称
2. 可以使用 `custom-style` 自定义颜色和大小
3. 图标大小建议使用 px 单位

### 按钮使用
1. `type` 属性决定按钮颜色类型
2. `plain` 属性可以创建朴素按钮
3. `block` 属性使按钮宽度占满父容器
4. `loading` 和 `disabled` 不要同时使用

### 单元格使用
1. 建议使用 `wd-group` 组件包裹多个单元格
2. `is-link` 属性显示右侧箭头
3. `center` 属性使内容垂直居中
4. 长内容使用默认插槽而非 `value` 属性

## 参考文档

- [Button 按钮](https://wot-ui.cn/component/button)
- [Icon 图标](https://wot-ui.cn/component/icon)
- [Cell 单元格](https://wot-ui.cn/component/cell)
- [Avatar 头像](https://wot-ui.cn/component/avatar)
- [Badge 徽标](https://wot-ui.cn/component/badge)
- [Tag 标签](https://wot-ui.cn/component/tag)
