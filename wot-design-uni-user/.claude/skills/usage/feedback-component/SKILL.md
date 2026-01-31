---
name: usage-feedback-component
description: 反馈组件使用技能 - 弹窗、提示、加载、通知、下拉菜单等反馈组件的正确使用方法
---

# Wot Design Uni - 反馈组件使用

## 使用场景
当需要使用以下反馈组件时触发此技能：
- 弹窗 (wd-dialog, wd-popup)
- 轻提示 (wd-toast)
- 加载 (wd-loading)
- 操作菜单 (wd-action-sheet)
- 消息通知 (wd-notify)
- 下拉刷新 (wd-refresh-control)
- 下拉菜单 (wd-dropdown)

## 组件使用模板

### 1. 弹窗 (wd-dialog)

```vue
<template>
  <wd-button @click="showDialog1">基础弹窗</wd-button>
  <wd-button @click="showDialog2">确认弹窗</wd-button>
  <wd-button @click="showDialog3">提示弹窗</wd-button>

  <!-- 基础弹窗 -->
  <wd-dialog
    v-model="dialogVisible1"
    title="标题"
    content="这是一段内容"
  />

  <!-- 确认弹窗 -->
  <wd-dialog
    v-model="dialogVisible2"
    title="提示"
    content="确定要删除吗？"
    show-cancel-button
    @confirm="handleConfirm"
    @cancel="handleCancel"
  />

  <!-- 提示弹窗 -->
  <wd-dialog
    v-model="dialogVisible3"
    title="成功"
    content="操作成功！"
    :show-cancel-button="false"
    @confirm="dialogVisible3 = false"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const dialogVisible1 = ref(false)
const dialogVisible2 = ref(false)
const dialogVisible3 = ref(false)

const showDialog1 = () => {
  dialogVisible1.value = true
}

const showDialog2 = () => {
  dialogVisible2.value = true
}

const showDialog3 = () => {
  dialogVisible3.value = true
}

const handleConfirm = () => {
  console.log('确认')
  dialogVisible2.value = false
}

const handleCancel = () => {
  console.log('取消')
  dialogVisible2.value = false
}
</script>
```

### 2. 轻提示 (wd-toast)

```vue
<template>
  <wd-button @click="showToast1">成功提示</wd-button>
  <wd-button @click="showToast2">失败提示</wd-button>
  <wd-button @click="showToast3">加载提示</wd-button>
  <wd-button @click="showToast4">自定义图标</wd-button>
</template>

<script setup lang="ts">
import { useToast } from 'wot-design-uni'

const toast = useToast()

const showToast1 = () => {
  toast.success('操作成功')
}

const showToast2 = () => {
  toast.error('操作失败')
}

const showToast3 = () => {
  toast.loading('加载中...')

  // 3秒后关闭
  setTimeout(() => {
    toast.close()
  }, 3000)
}

const showToast4 = () => {
  toast.show({
    msg: '自定义内容',
    icon: 'check-circle',
    iconColor: '#34d399'
  })
}
</script>
```

### 3. 加载 (wd-loading)

```vue
<template>
  <!-- 内联使用 -->
  <wd-loading>加载中...</wd-loading>

  <!-- 自定义颜色 -->
  <wd-loading color="#3b82f6">自定义颜色</wd-loading>

  <!-- 自定义大小 -->
  <wd-loading size="24px">小尺寸</wd-loading>
  <wd-loading size="40px">中尺寸</wd-loading>
  <wd-loading size="50px">大尺寸</wd-loading>

  <!-- 全屏加载 -->
  <wd-button @click="showFullScreenLoading">全屏加载</wd-button>
</template>

<script setup lang="ts">
import { useToast } from 'wot-design-uni'

const toast = useToast()

const showFullScreenLoading = () => {
  toast.loading({
    msg: '加载中...',
    loadingType: 'circle'
  })

  setTimeout(() => {
    toast.close()
  }, 2000)
}
</script>
```

### 4. 弹出层 (wd-popup)

```vue
<template>
  <wd-button @click="showPopup1 = true">顶部弹出</wd-button>
  <wd-button @click="showPopup2 = true">底部弹出</wd-button>
  <wd-button @click="showPopup3 = true">居中弹出</wd-button>

  <!-- 顶部弹出 -->
  <wd-popup
    v-model="showPopup1"
    position="top"
    :close-on-click-modal="true"
  >
    <view class="popup-content">顶部弹出内容</view>
  </wd-popup>

  <!-- 底部弹出 -->
  <wd-popup
    v-model="showPopup2"
    position="bottom"
    :close-on-click-modal="true"
  >
    <view class="popup-content">底部弹出内容</view>
  </wd-popup>

  <!-- 居中弹出 -->
  <wd-popup
    v-model="showPopup3"
    position="center"
    :close-on-click-modal="true"
  >
    <view class="popup-content-center">居中弹出内容</view>
  </wd-popup>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const showPopup1 = ref(false)
const showPopup2 = ref(false)
const showPopup3 = ref(false)
</script>

<style scoped>
.popup-content {
  padding: 20px;
  background-color: #fff;
}

.popup-content-center {
  width: 200px;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  text-align: center;
}
</style>
```

### 5. 操作菜单 (wd-action-sheet)

```vue
<template>
  <wd-button @click="showActionSheet">显示操作菜单</wd-button>

  <wd-action-sheet
    v-model="actionSheetVisible"
    :actions="actions"
    @select="handleSelect"
    @cancel="actionSheetVisible = false"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { ActionSheetAction } from 'wot-design-uni/components/wd-action-sheet/types'

const actionSheetVisible = ref(false)

const actions = ref<ActionSheetAction[]>([
  { name: '选项1' },
  { name: '选项2' },
  { name: '选项3', subname: '副文本' },
  { name: '禁用选项', disabled: true }
])

const showActionSheet = () => {
  actionSheetVisible.value = true
}

const handleSelect = (action: ActionSheetAction, index: number) => {
  console.log('选中：', action, index)
  actionSheetVisible.value = false
}
</script>
```

### 6. 消息通知 (wd-notify)

```vue
<template>
  <wd-button @click="showNotify1">成功通知</wd-button>
  <wd-button @click="showNotify2">错误通知</wd-button>
  <wd-button @click="showNotify3">警告通知</wd-button>
  <wd-button @click="showNotify4">自定义位置</wd-button>
</template>

<script setup lang="ts">
import { useNotify } from 'wot-design-uni'

const notify = useNotify()

const showNotify1 = () => {
  notify.success('操作成功')
}

const showNotify2 = () => {
  notify.error('操作失败')
}

const showNotify3 = () => {
  notify.warning('警告信息')
}

const showNotify4 = () => {
  notify.show({
    msg: '自定义位置通知',
    position: 'bottom',
    duration: 3000
  })
}
</script>
```

### 7. 下拉菜单 (wd-dropdown)

```vue
<template>
  <wd-dropdown>
    <wd-dropdown-item v-model="value1" :options="option1" />
    <wd-dropdown-item v-model="value2" :options="option2" />
  </wd-dropdown>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const value1 = ref(0)
const value2 = ref('a')

const option1 = [
  { label: '全部商品', value: 0 },
  { label: '新款商品', value: 1 },
  { label: '活动商品', value: 2 }
]

const option2 = [
  { label: '默认排序', value: 'a' },
  { label: '好评排序', value: 'b' },
  { label: '销量排序', value: 'c' }
]
</script>
```

### 8. 循环滚动 (wd-notify-roll)

```vue
<template>
  <wd-notify-roll :data="noticeData" @click="handleNoticeClick" />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const noticeData = ref([
  { id: 1, text: '这是一条通知内容1' },
  { id: 2, text: '这是一条通知内容2' },
  { id: 3, text: '这是一条通知内容3' }
])

const handleNoticeClick = (item: any) => {
  console.log('点击通知：', item)
}
</script>
```

## 禁止事项 ⭐重要

- ❌ 不要在非用户操作的场景下直接弹出 `wd-dialog`（应该在点击事件中触发）
- ❌ 不要同时打开多个弹窗或弹出层
- ❌ 不要忘记在合适的时机关闭 `wd-toast`（特别是 loading 类型）
- ❌ 不要在 `wd-popup` 中使用过大的内容导致超出屏幕
- ❌ 不要混淆 `wd-dialog` 和 `wd-popup` 的使用场景
- ❌ 不要在 `wd-action-sheet` 中放置过多选项（建议不超过 6 个）
- ❌ 不要在页面销毁时还保留着未关闭的弹窗

## 检查清单 ⭐重要

- [ ] 是否在正确的时机触发反馈组件（用户操作后）
- [ ] 是否正确处理了弹窗的确认和取消事件
- [ ] 是否在合适时机关闭了 toast（特别是 loading）
- [ ] 弹窗内容是否过长（考虑使用滚动）
- [ ] 是否为用户提供了明确的操作反馈
- [ ] 是否测试了不同屏幕尺寸下的显示效果
- [ ] 是否考虑了暗黑模式下的样式

## 注意事项

### Dialog 使用
1. 适合需要用户确认的场景（删除、确认等）
2. 使用 `v-model` 控制显示隐藏
3. 可以设置 `show-cancel-button` 显示取消按钮
4. 记得处理 `confirm` 和 `cancel` 事件

### Toast 使用
1. 使用 `useToast()` Composable 调用
2. `success`、`error`、`warning` 是常用快捷方法
3. `loading` 类型需要手动调用 `close()` 关闭
4. 默认显示 2 秒，可通过 `duration` 修改

### Popup 使用
1. 有三个位置：`top`、`bottom`、`center`
2. `close-on-click-modal` 控制点击遮罩是否关闭
3. 适合自定义内容的弹出场景
4. 注意内容高度，避免超出屏幕

### Action Sheet 使用
1. 适合多个操作选项的场景
2. 选项数量建议不超过 6 个
3. 可以设置 `disabled` 禁用某个选项
4. 可以使用 `subname` 添加副文本

### Notify 使用
1. 使用 `useNotify()` Composable 调用
2. 有四个位置：`top`、`bottom`、`center`（默认 top）
3. 适合页面级的通知提示
4. 可以设置 `duration` 控制显示时长

## 最佳实践

### 1. 删除确认
```vue
<script setup lang="ts">
const handleDelete = () => {
  uni.showModal({
    title: '提示',
    content: '确定要删除吗？',
    success: (res) => {
      if (res.confirm) {
        // 执行删除操作
      }
    }
  })
}
</script>
```

### 2. 表单提交
```vue
<script setup lang="ts">
import { useToast } from 'wot-design-uni'

const toast = useToast()

const handleSubmit = async () => {
  try {
    toast.loading('提交中...')

    await submitForm()

    toast.close()
    toast.success('提交成功')
  } catch (error) {
    toast.close()
    toast.error('提交失败')
  }
}
</script>
```

### 3. 异步操作反馈
```vue
<script setup lang="ts">
import { useToast } from 'wot-design-uni'

const toast = useToast()

const asyncOperation = async () => {
  toast.loading({
    msg: '加载中...',
    loadingType: 'circle'
  })

  try {
    await fetchData()
    toast.close()
    toast.success('加载成功')
  } catch (error) {
    toast.close()
    toast.error('加载失败')
  }
}
</script>
```

## 参考文档

- [Dialog 弹窗](https://wot-ui.cn/component/dialog)
- [Toast 轻提示](https://wot-ui.cn/component/toast)
- [Loading 加载](https://wot-ui.cn/component/loading)
- [Popup 弹出层](https://wot-ui.cn/component/popup)
- [Action Sheet 操作菜单](https://wot-ui.cn/component/action-sheet)
- [Notify 消息通知](https://wot-ui.cn/component/notify)
- [Dropdown 下拉菜单](https://wot-ui.cn/component/dropdown)
