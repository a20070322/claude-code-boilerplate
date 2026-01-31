# /component - Vue 组件创建命令

## 描述
创建符合 Wot Starter 规范的 Vue 3 组件

## 使用方法
```
/component 创建用户头像组件
/component 添加订单卡片组件
```

## 执行步骤

### 步骤 1: 激活技能
```
必须激活: vue-composable-creator
可能需要: global-feedback
```

### 步骤 2: 确定组件类型
- [ ] 业务组件 (放在 `src/components/`)
- [ ] 页面组件 (放在页面的 `components/` 目录)
- [ ] 通用组件 (可复用)

### 步骤 3: 创建组件文件
```vue
<template>
  <view class="{component-name} p-3">
    <!-- 使用 wot-design-uni 组件 -->
    <wd-button type="primary" @click="handleClick">
      {{ text }}
    </wd-button>
  </view>
</template>

<script setup lang="ts">
// 定义 Props
interface Props {
  text?: string
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  text: '按钮',
  disabled: false,
})

// 定义 Emits
interface Emits {
  (e: 'click', value: string): void
}

const emit = defineEmits<Emits>()

// 事件处理
function handleClick() {
  emit('click', 'clicked')
}
</script>

<style scoped lang="scss">
// 尽量使用 UnoCSS，这里只写特殊样式
.{component-name} {
  // 特殊样式
}
</style>
```

### 步骤 4: 添加组件逻辑
- [ ] 使用 Composables 封装逻辑
- [ ] 使用 Store 管理状态
- [ ] 使用 Alova 调用 API
- [ ] 使用 GlobalFeedback 处理交互

### 步骤 5: 自动导入配置
组件会通过 `unplugin-auto-import` 自动导入，无需手动 import

### 步骤 6: 测试验证
- [ ] 组件渲染正常
- [ ] Props 传递正确
- [ ] Events 触发正确
- [ ] 样式显示正确

## 禁止事项
- ❌ 不要使用 scoped styles 的复杂选择器
- ❌ 不要直接在组件中调用 `uni.showToast`
- ❌ 不要在组件中硬编码样式值
- ❌ 不要在组件中写复杂的业务逻辑

## 检查清单
- [ ] 使用 `<script setup>` 语法
- [ ] Props 和 Emits 有明确的类型定义
- [ ] 使用 UnoCSS 原子化样式
- [ ] 使用 wot-design-uni 组件
- [ ] 事件处理使用 GlobalFeedback
- [ ] 复杂逻辑封装到 Composable

## 注意事项
1. 优先使用 wot-design-uni 组件
2. 使用 UnoCSS 原子化样式
3. 复杂逻辑封装到 Composable
4. 组件命名使用大驼峰 (PascalCase)
5. 文件名使用短横线命名 (kebab-case)
