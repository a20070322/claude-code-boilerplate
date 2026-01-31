---
name: usage-navigation-component
description: 导航组件使用技能 - 标签页、导航栏、侧边栏、面包屑等导航组件的正确使用方法
---

# Wot Design Uni - 导航组件使用

## 使用场景
当需要使用以下导航组件时触发此技能：
- 标签页 (wd-tabs)
- 标签栏 (wd-tabbar)
- 导航栏 (wd-navbar)
- 侧边栏 (wd-sidebar)
- 面包屑 (wd-breadcrumb)
- 步骤条 (wd-steps)

## 组件使用模板

### 1. 标签页 (wd-tabs)

```vue
<template>
  <!-- 基础用法 -->
  <wd-tabs v-model="active1" @change="handleChange">
    <wd-tab title="标签1" name="1">
      内容1
    </wd-tab>
    <wd-tab title="标签2" name="2">
      内容2
    </wd-tab>
    <wd-tab title="标签3" name="3">
      内容3
    </wd-tab>
  </wd-tabs>

  <!-- 粘性布局 -->
  <wd-tabs v-model="active2" sticky>
    <wd-tab title="标签1" name="1">内容1</wd-tab>
    <wd-tab title="标签2" name="2">内容2</wd-tab>
    <wd-tab title="标签3" name="3">内容3</wd-tab>
  </wd-tabs>

  <!-- 禁用标签 -->
  <wd-tabs v-model="active3">
    <wd-tab title="标签1" name="1">内容1</wd-tab>
    <wd-tab title="标签2" name="2" disabled>内容2</wd-tab>
    <wd-tab title="标签3" name="3">内容3</wd-tab>
  </wd-tabs>

  <!-- 滚动导航 -->
  <wd-tabs v-model="active4" slidable="always">
    <wd-tab v-for="item in 10" :key="item" :title="`标签${item}`" :name="item">
      内容{{ item }}
    </wd-tab>
  </wd-tabs>

  <!-- 自定义标题 -->
  <wd-tabs v-model="active5">
    <wd-tab name="1">
      <template #title>
        <view>自定义标题 <wd-icon name="check-circle" /></view>
      </template>
      内容1
    </wd-tab>
    <wd-tab title="标签2" name="2">内容2</wd-tab>
  </wd-tabs>

  <!-- 徽标提示 -->
  <wd-tabs v-model="active6">
    <wd-tab title="标签1" name="1">
      <template #title>
        <view>标签1 <wd-badge content="5" /></view>
      </template>
      内容1
    </wd-tab>
    <wd-tab title="标签2" name="2">内容2</wd-tab>
  </wd-tabs>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const active1 = ref('1')
const active2 = ref('1')
const active3 = ref('1')
const active4 = ref(1)
const active5 = ref('1')
const active6 = ref('1')

const handleChange = (value: string | number) => {
  console.log('当前选中：', value)
}
</script>
```

### 2. 标签栏 (wd-tabbar)

```vue
<template>
  <!-- 基础用法 -->
  <wd-tabbar v-model="active1" @change="handleChange">
    <wd-tabbar-item title="首页" icon="home" />
    <wd-tabbar-item title="分类" icon="category" />
    <wd-tabbar-item title="购物车" icon="cart" />
    <wd-tabbar-item title="我的" icon="user" />
  </wd-tabbar>

  <!-- 徽标 -->
  <wd-tabbar v-model="active2">
    <wd-tabbar-item title="首页" icon="home" />
    <wd-tabbar-item title="消息" icon="message" :badge="5" />
    <wd-tabbar-item title="购物车" icon="cart" is-dot />
    <wd-tabbar-item title="我的" icon="user" />
  </wd-tabbar>

  <!-- 自定义图标 -->
  <wd-tabbar v-model="active3">
    <wd-tabbar-item title="首页">
      <template #icon>
        <wd-icon name="home" />
      </template>
    </wd-tabbar-item>
    <wd-tabbar-item title="我的">
      <template #icon>
        <wd-icon name="user" />
      </template>
    </wd-tabbar-item>
  </wd-tabbar>

  <!-- 固定底部 -->
  <wd-tabbar v-model="active4" fixed safe-area-inset-bottom>
    <wd-tabbar-item title="首页" icon="home" />
    <wd-tabbar-item title="我的" icon="user" />
  </wd-tabbar>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const active1 = ref(0)
const active2 = ref(0)
const active3 = ref(0)
const active4 = ref(0)

const handleChange = (value: number) => {
  console.log('当前选中：', value)
  // 这里可以切换页面
}
</script>
```

### 3. 导航栏 (wd-navbar)

```vue
<template>
  <!-- 基础用法 -->
  <wd-navbar title="标题" />

  <!-- 返回按钮 -->
  <wd-navbar
    title="标题"
    left-arrow
    @click-left="handleClickLeft"
  />

  <!-- 自定义内容 -->
  <wd-navbar title="标题">
    <template #left>
      <wd-icon name="arrow-left" @click="handleClickLeft" />
    </template>
    <template #right>
      <wd-icon name="search" @click="handleClickRight" />
    </template>
  </wd-navbar>

  <!-- 固定顶部 -->
  <wd-navbar
    title="固定顶部"
    fixed
    placeholder
  />

  <!-- 自定义颜色 -->
  <wd-navbar
    title="自定义颜色"
    custom-style="background-color: #3b82f6; color: #fff"
  />
</template>

<script setup lang="ts">
const handleClickLeft = () => {
  uni.navigateBack()
}

const handleClickRight = () => {
  console.log('点击右侧按钮')
}
</script>
```

### 4. 侧边栏 (wd-sidebar)

```vue
<template>
  <view class="sidebar-container">
    <!-- 基础用法 -->
    <wd-sidebar v-model="active1">
      <wd-sidebar-item title="标签1" name="1" />
      <wd-sidebar-item title="标签2" name="2" />
      <wd-sidebar-item title="标签3" name="3" />
    </wd-sidebar>

    <!-- 徽标提示 -->
    <wd-sidebar v-model="active2">
      <wd-sidebar-item title="标签1" name="1" />
      <wd-sidebar-item title="标签2" name="2" badge="5" />
      <wd-sidebar-item title="标签3" name="3" is-dot />
    </wd-sidebar>

    <!-- 禁用选项 -->
    <wd-sidebar v-model="active3">
      <wd-sidebar-item title="标签1" name="1" />
      <wd-sidebar-item title="标签2" name="2" disabled />
      <wd-sidebar-item title="标签3" name="3" />
    </wd-sidebar>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const active1 = ref('1')
const active2 = ref('1')
const active3 = ref('1')
</script>

<style scoped>
.sidebar-container {
  display: flex;
  height: 100vh;
}
</style>
```

### 5. 步骤条 (wd-steps)

```vue
<template>
  <!-- 基础用法 -->
  <wd-steps :current="active1">
    <wd-step title="步骤1" description="步骤描述" />
    <wd-step title="步骤2" description="步骤描述" />
    <wd-step title="步骤3" description="步骤描述" />
  </wd-steps>

  <!-- 竖向步骤条 -->
  <wd-steps :current="active2" direction="vertical">
    <wd-step title="步骤1" description="步骤描述" />
    <wd-step title="步骤2" description="步骤描述" />
    <wd-step title="步骤3" description="步骤描述" />
  </wd-steps>

  <!-- 自定义图标 -->
  <wd-steps :current="active3">
    <wd-step>
      <template #icon>
        <wd-icon name="check-circle" />
      </template>
      <template #title>
        <view>步骤1</view>
      </template>
      <template #description>
        <view>步骤描述</view>
      </template>
    </wd-step>
    <wd-step title="步骤2" description="步骤描述" />
    <wd-step title="步骤3" description="步骤描述" />
  </wd-steps>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const active1 = ref(1)
const active2 = ref(1)
const active3 = ref(1)
</script>
```

### 6. 分页 (wd-pagination)

```vue
<template>
  <!-- 基础用法 -->
  <wd-pagination
    v-model="current1"
    :total="50"
    :page-size="10"
    @change="handleChange"
  />

  <!-- 显示总条数 -->
  <wd-pagination
    v-model="current2"
    :total="50"
    :page-size="10"
    show-page-size
  />

  <!-- 简洁模式 -->
  <wd-pagination
    v-model="current3"
    :total="50"
    :page-size="10"
    mode="simple"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const current1 = ref(1)
const current2 = ref(1)
const current3 = ref(1)

const handleChange = (value: number) => {
  console.log('当前页：', value)
}
</script>
```

## 禁止事项 ⭐重要

- ❌ 不要在 `wd-tabs` 中混用 `v-model` 字符串和数字类型
- ❌ 不要在 `wd-tabbar` 中放置过多图标（建议不超过 5 个）
- ❌ 不要忘记处理 `wd-navbar` 的返回事件
- ❌ 不要在 `wd-sidebar` 中嵌套使用其他导航组件
- ❌ 不要在 `wd-steps` 中设置错误的 `current` 值（超出范围）
- ❌ 不要在固定导航栏时忘记添加 `placeholder`
- ❌ 不要在移动端使用桌面端的导航模式

## 检查清单 ⭐重要

- [ ] 标签页的 `v-model` 类型是否正确（string 或 number）
- [ ] 标签栏的图标是否在所有平台都能正常显示
- [ ] 导航栏是否正确处理了返回逻辑
- [ ] 侧边栏是否配合了合适的内容区域
- [ ] 步骤条的当前步骤是否正确
- [ ] 固定导航时是否添加了占位元素
- [ ] 是否在不同屏幕尺寸下测试了导航效果

## 注意事项

### 标签页
1. 使用 `v-model` 绑定当前激活的标签
2. `sticky` 属性使标签栏吸顶
3. `slidable` 属性控制是否滚动（auto/always/never）
4. 可以通过 `title` 插槽自定义标题内容

### 标签栏
1. 通常固定在页面底部
2. `fixed` 属性固定位置
3. `safe-area-inset-bottom` 适配 iPhone X 等底部安全区域
4. 可以使用 `badge` 或 `is-dot` 添加徽标

### 导航栏
1. 通常固定在页面顶部
2. `left-arrow` 显示左侧返回箭头
3. `fixed` 属性固定位置
4. `placeholder` 添加占位元素，防止内容被遮挡
5. 可以自定义左右两侧的插槽内容

### 侧边栏
1. 通常与内容区域并列显示
2. 使用 `v-model` 绑定当前选中的菜单项
3. 可以使用 `badge` 或 `is-dot` 添加徽标
4. `disabled` 属性禁用某个选项

### 步骤条
1. `current` 设置当前步骤（从 0 开始）
2. `direction` 设置方向（horizontal/vertical）
3. 可以自定义图标插槽
4. 适合展示任务流程或订单状态

### 分页
1. `v-model` 绑定当前页码
2. `total` 设置总条数
3. `page-size` 设置每页条数
4. `mode` 设置显示模式（simple/complex）
5. `show-page-size` 显示每页条数选择器

## 最佳实践

### 1. 页面导航结构
```vue
<template>
  <view class="page">
    <!-- 顶部导航 -->
    <wd-navbar
      title="标题"
      left-arrow
      fixed
      placeholder
      @click-left="handleBack"
    />

    <!-- 标签页 -->
    <wd-tabs v-model="activeTab" sticky>
      <wd-tab title="标签1" name="1">
        内容1
      </wd-tab>
      <wd-tab title="标签2" name="2">
        内容2
      </wd-tab>
    </wd-tabs>

    <!-- 底部标签栏 -->
    <wd-tabbar v-model="activeTabbar" fixed safe-area-inset-bottom>
      <wd-tabbar-item title="首页" icon="home" />
      <wd-tabbar-item title="我的" icon="user" />
    </wd-tabbar>
  </view>
</template>
```

### 2. 左侧导航 + 内容区域
```vue
<template>
  <view class="container">
    <wd-sidebar v-model="activeSidebar">
      <wd-sidebar-item title="菜单1" name="1" />
      <wd-sidebar-item title="菜单2" name="2" />
    </wd-sidebar>
    <view class="content">
      <!-- 内容区域 -->
    </view>
  </view>
</template>

<style scoped>
.container {
  display: flex;
  height: 100vh;
}

.content {
  flex: 1;
  overflow-y: auto;
}
</style>
```

### 3. 步骤流程展示
```vue
<template>
  <view class="step-container">
    <wd-steps :current="currentStep">
      <wd-step title="填写信息" description="完善基本信息" />
      <wd-step title="验证身份" description="完成身份认证" />
      <wd-step title="完成" description="注册成功" />
    </wd-steps>

    <view class="step-content">
      <!-- 步骤内容 -->
    </view>

    <view class="step-actions">
      <wd-button v-if="currentStep > 0" @click="prev">上一步</wd-button>
      <wd-button v-if="currentStep < 2" type="primary" @click="next">
        下一步
      </wd-button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const currentStep = ref(0)

const next = () => {
  currentStep.value++
}

const prev = () => {
  currentStep.value--
}
</script>
```

## 参考文档

- [Tabs 标签页](https://wot-ui.cn/component/tabs)
- [Tabbar 标签栏](https://wot-ui.cn/component/tabbar)
- [Navbar 导航栏](https://wot-ui.cn/component/navbar)
- [Sidebar 侧边栏](https://wot-ui.cn/component/sidebar)
- [Steps 步骤条](https://wot-ui.cn/component/steps)
- [Pagination 分页](https://wot-ui.cn/component/pagination)
