---
name: usage-layout-component
description: 布局组件使用技能 - 布局容器、分隔线、卡片、折叠面板等布局组件的正确使用方法
---

# Wot Design Uni - 布局组件使用

## 使用场景
当需要使用以下布局组件时触发此技能：
- 布局容器 (wd-row, wd-col)
- 分隔线 (wd-divider)
- 卡片 (wd-card)
- 折叠面板 (wd-collapse)
- 网格 (wd-grid)
- 粘性布局 (wd-sticky)
- 回到顶部 (wd-backtop)

## 组件使用模板

### 1. 布局容器 (wd-row, wd-col)

```vue
<template>
  <!-- 基础用法 -->
  <wd-row>
    <wd-col span="8">
      <view class="col-content">span: 8</view>
    </wd-col>
    <wd-col span="8">
      <view class="col-content">span: 8</view>
    </wd-col>
    <wd-col span="8">
      <view class="col-content">span: 8</view>
    </wd-col>
  </wd-row>

  <!-- 间距 -->
  <wd-row gutter="20">
    <wd-col span="12">
      <view class="col-content">gutter: 20</view>
    </wd-col>
    <wd-col span="12">
      <view class="col-content">gutter: 20</view>
    </wd-col>
  </wd-row>

  <!-- 偏移 -->
  <wd-row>
    <wd-col span="8">
      <view class="col-content">span: 8</view>
    </wd-col>
    <wd-col span="8" offset="8">
      <view class="col-content">offset: 8</view>
    </wd-col>
  </wd-row>

  <!-- 响应式 -->
  <wd-row>
    <wd-col :xs="8" :sm="6" :md="4" :lg="3">
      <view class="col-content">响应式</view>
    </wd-col>
    <wd-col :xs="4" :sm="6" :md="8" :lg="9">
      <view class="col-content">响应式</view>
    </wd-col>
  </wd-row>
</template>

<style scoped>
.col-content {
  background-color: #d3dce6;
  color: #fff;
  text-align: center;
  padding: 20px;
  margin-bottom: 10px;
  border-radius: 4px;
}
</style>
```

### 2. 分隔线 (wd-divider)

```vue
<template>
  <!-- 基础用法 -->
  <wd-text>文本</wd-text>
  <wd-divider />
  <wd-text>文本</wd-text>

  <!-- 带文字 -->
  <wd-divider>文字</wd-divider>

  <!-- 内容位置 -->
  <wd-divider content-position="left">左侧文字</wd-divider>
  <wd-divider content-position="right">右侧文字</wd-divider>

  <!-- 虚线 -->
  <wd-divider dashed>虚线分隔</wd-divider>

  <!-- 自定义颜色 -->
  <wd-divider custom-style="color: #3b82f6">自定义颜色</wd-divider>

  <!-- 自定义间距 -->
  <wd-divider :custom-style="{ margin: '20px 0' }">自定义间距</wd-divider>
</template>
```

### 3. 卡片 (wd-card)

```vue
<template>
  <!-- 基础用法 -->
  <wd-card title="卡片标题">
    这是卡片内容
  </wd-card>

  <!-- 带图片 -->
  <wd-card title="商品卡片">
    <template #thumbnail>
      <image src="https://example.com/image.png" mode="aspectFill" />
    </template>
    这是卡片内容
  </wd-card>

  <!-- 自定义标题 -->
  <wd-card>
    <template #title>
      <view class="custom-title">自定义标题</view>
    </template>
    这是卡片内容
  </wd-card>

  <!-- 带操作 -->
  <wd-card title="卡片标题">
    这是卡片内容
    <template #footer>
      <wd-button size="small" type="primary">操作按钮</wd-button>
    </template>
  </wd-card>

  <!-- 阴影样式 -->
  <wd-card title="有阴影" shadow>
    这是卡片内容
  </wd-card>
</template>

<style scoped>
.custom-title {
  font-size: 18px;
  font-weight: bold;
  color: #3b82f6;
}
</style>
```

### 4. 折叠面板 (wd-collapse)

```vue
<template>
  <!-- 基础用法 -->
  <wd-collapse v-model="activeNames">
    <wd-collapse-item title="标题1" name="1">
      这是内容1
    </wd-collapse-item>
    <wd-collapse-item title="标题2" name="2">
      这是内容2
    </wd-collapse-item>
    <wd-collapse-item title="标题3" name="3">
      这是内容3
    </wd-collapse-item>
  </wd-collapse>

  <!-- 手风琴模式 -->
  <wd-collapse v-model="activeName1" accordion>
    <wd-collapse-item title="标题1" name="1">
      这是内容1
    </wd-collapse-item>
    <wd-collapse-item title="标题2" name="2">
      这是内容2
    </wd-collapse-item>
  </wd-collapse>

  <!-- 禁用状态 -->
  <wd-collapse v-model="activeNames2">
    <wd-collapse-item title="正常" name="1">
      正常内容
    </wd-collapse-item>
    <wd-collapse-item title="禁用" name="2" disabled>
      禁用内容
    </wd-collapse-item>
  </wd-collapse>

  <!-- 自定义标题 -->
  <wd-collapse v-model="activeNames3">
    <wd-collapse-item name="1">
      <template #title>
        <view>自定义标题 <wd-icon name="check-circle" /></view>
      </template>
      这是内容
    </wd-collapse-item>
  </wd-collapse>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const activeNames = ref(['1'])
const activeName1 = ref('1')
const activeNames2 = ref(['1'])
const activeNames3 = ref(['1'])
</script>
```

### 5. 网格 (wd-grid)

```vue
<template>
  <!-- 基础用法 -->
  <wd-grid :column-num="3">
    <wd-grid-item icon="location" text="文字" />
    <wd-grid-item icon="search" text="文字" />
    <wd-grid-item icon="check-circle" text="文字" />
  </wd-grid>

  <!-- 自定义列数 -->
  <wd-grid :column-num="4" :border="true">
    <wd-grid-item icon="location" text="文字" />
    <wd-grid-item icon="search" text="文字" />
    <wd-grid-item icon="check-circle" text="文字" />
    <wd-grid-item icon="warning-circle" text="文字" />
  </wd-grid>

  <!-- 自定义内容 -->
  <wd-grid :column-num="3" :gutter="10">
    <wd-grid-item :badge="{ content: '99' }">
      <wd-icon name="location" custom-style="font-size: 32px" />
      <template #text>
        <view class="grid-text">自定义文字</view>
      </template>
    </wd-grid-item>
    <wd-grid-item>
      <wd-icon name="search" custom-style="font-size: 32px" />
      <template #text>
        <view class="grid-text">自定义文字</view>
      </template>
    </wd-grid-item>
  </wd-grid>

  <!-- 可点击 -->
  <wd-grid :column-num="3" clickable @click="handleGridClick">
    <wd-grid-item icon="location" text="点击" />
    <wd-grid-item icon="search" text="点击" />
    <wd-grid-item icon="check-circle" text="点击" />
  </wd-grid>
</template>

<script setup lang="ts">
const handleGridClick = (data: any) => {
  console.log('点击网格：', data)
}
</script>

<style scoped>
.grid-text {
  margin-top: 8px;
  font-size: 14px;
}
</style>
```

### 6. 粘性布局 (wd-sticky)

```vue
<template>
  <!-- 基础用法 -->
  <wd-sticky>
    <wd-button type="primary">吸顶按钮</wd-button>
  </wd-sticky>

  <!-- 指定容器 -->
  <wd-sticky :offset-top="50">
    <wd-button type="success">距离顶部50px</wd-button>
  </wd-sticky>

  <!-- 吸顶时回调 -->
  <wd-sticky @scroll="handleScroll">
    <view class="sticky-content">吸顶内容</view>
  </wd-sticky>
</template>

<script setup lang="ts">
const handleScroll = (isFixed: boolean) => {
  console.log('是否吸顶：', isFixed)
}
</script>

<style scoped>
.sticky-content {
  background-color: #fff;
  padding: 10px;
  text-align: center;
}
</style>
```

### 7. 回到顶部 (wd-backtop)

```vue
<template>
  <!-- 基础用法 -->
  <view style="height: 500px;">
    <wd-backtop></wd-backtop>
    <view v-for="item in 50" :key="item">内容 {{ item }}</view>
  </view>

  <!-- 自定义位置 -->
  <view style="height: 500px;">
    <wd-backtop right="40" bottom="40"></wd-backtop>
  </view>

  <!-- 自定义图标 -->
  <view style="height: 500px;">
    <wd-backtop>
      <wd-icon name="arrow-up" custom-style="color: #fff" />
    </wd-backtop>
  </view>

  <!-- 自定义显示距离 -->
  <view style="height: 500px;">
    <wd-backtop :visibility-height="300"></wd-backtop>
  </view>
</template>
```

## 禁止事项 ⭐重要

- ❌ 不要在 `wd-row` 中直接使用非 `wd-col` 的子元素
- ❌ 不要让 `wd-col` 的 `span` 总和超过 24
- ❌ 不要在 `wd-collapse` 中同时使用 `v-model` 和 `accordion`
- ❌ 不要在 `wd-grid` 中设置过大的 `column-num`（建议不超过 5）
- ❌ 不要在 `wd-sticky` 中嵌套使用多个粘性布局
- ❌ 不要忘记在长页面中使用 `wd-backtop` 提升用户体验
- ❌ 不要在 `wd-card` 中放置过大的图片导致布局错乱

## 检查清单 ⭐重要

- [ ] 布局组件的 span 值是否合理（总和不超过 24）
- [ ] 是否正确设置了响应式断点（xs/sm/md/lg）
- [ ] 卡片内容是否过长（考虑使用滚动）
- [ ] 折叠面板的初始展开状态是否合理
- [ ] 网格列数是否适合屏幕宽度
- [ ] 粘性布局的 offset-top 是否合理
- [ ] 是否在不同屏幕尺寸下测试了布局效果

## 注意事项

### 布局容器
1. `wd-row` 的子元素应该是 `wd-col`
2. `span` 总和应该是 24（12+12、8+8+8、6+6+6+6 等）
3. `gutter` 设置列之间的间距（单位 px）
4. 响应式断点：xs(<576px)、sm(≥576px)、md(≥768px)、lg(≥992px)

### 分隔线
1. 使用 `content-position` 控制文字位置
2. `dashed` 属性创建虚线样式
3. 可以使用 `custom-style` 自定义颜色和间距

### 卡片
1. 使用 `thumbnail` 插槽放置缩略图
2. 使用 `footer` 插槽放置底部操作按钮
3. `shadow` 属性添加阴影效果
4. 可以自定义 `title` 插槽

### 折叠面板
1. `accordion` 模式只能展开一项
2. 使用 `v-model` 绑定展开的面板名称数组
3. `disabled` 属性禁用某个面板
4. 可以自定义 `title` 插槽

### 网格
1. `column-num` 设置列数（默认 3）
2. `gutter` 设置网格间距
3. `clickable` 属性使网格可点击
4. 可以使用 `badge` 属性添加徽标

### 粘性布局
1. `offset-top` 设置距离顶部的距离
2. 监听 `scroll` 事件获取吸顶状态
3. 注意在 scroll-view 中使用时的兼容性

### 回到顶部
1. `visibility-height` 设置滚动多少距离后显示（默认 200）
2. `right` 和 `bottom` 设置位置
3. 可以自定义插槽内容替换默认图标
4. 只在 scroll-view 或页面滚动时生效

## 参考文档

- [Row 行](https://wot-ui.cn/component/row)
- [Divider 分割线](https://wot-ui.cn/component/divider)
- [Card 卡片](https://wot-ui.cn/component/card)
- [Collapse 折叠面板](https://wot-ui.cn/component/collapse)
- [Grid 网格](https://wot-ui.cn/component/grid)
- [Sticky 粘性布局](https://wot-ui.cn/component/sticky)
- [Backtop 回到顶部](https://wot-ui.cn/component/backtop)
