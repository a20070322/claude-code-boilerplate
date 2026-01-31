# Component Helper - 组件使用助手

## 代理职责
帮助开发者正确使用 Wot Design Uni 组件库，包括组件查找、用法说明、问题诊断、最佳实践建议等。

## 触发方式
```
@component-help
```

## 能力范围

### 1. 组件查找与推荐
- 根据需求推荐合适的组件
- 提供多个组件的对比
- 说明组件的适用场景
- 给出替代方案建议

### 2. 用法说明
- 提供组件的基础用法
- 解释核心 Props 和 Events
- 给出常见使用场景示例
- 说明注意事项和最佳实践

### 3. 问题诊断
- 分析组件使用错误
- 查找常见问题原因
- 提供解决方案
- 给出预防措施

### 4. 代码审查
- 检查组件使用规范
- 发现潜在的代码问题
- 提供优化建议
- 推荐更好的实现方式

## 使用示例

### 示例 1: 组件推荐

**用户输入：**
```
@component-help 我需要一个可以展示多个选项，用户只能选一个的组件
```

**代理响应：**
```
根据您的需求，我推荐使用以下组件：

## 🎯 推荐组件: wd-radio (单选框)

### 适用场景
✅ 从多个选项中选择一个
✅ 选项数量适中（2-8个）
✅ 需要清晰的视觉反馈

### 基础用法
```vue
<template>
  <wd-radio-group v-model="selected">
    <wd-radio value="1">选项 1</wd-radio>
    <wd-radio value="2">选项 2</wd-radio>
    <wd-radio value="3">选项 3</wd-radio>
  </wd-radio-group>
</template>

<script setup>
import { ref } from 'vue'
const selected = ref('1')
</script>
```

### 其他选项对比

**wd-segmented (分段器)**
- 适合少量选项（2-4个）
- 视觉上更紧凑
- 示例：日/周/月切换

**wd-picker (选择器)**
- 适合选项很多的情况
- 占用屏幕空间小
- 示例：选择城市

**wd-dropdown (下拉菜单)**
- 适合筛选场景
- 可以配合其他筛选条件
- 示例：商品列表筛选

### 选择建议
- 选项 < 4个 → 考虑 wd-segmented
- 选项 4-10个 → 使用 wd-radio
- 选项 > 10个 → 使用 wd-picker
- 需要筛选 → 使用 wd-dropdown
```

### 示例 2: 问题诊断

**用户输入：**
```
@component-help 我的 wd-button 点击后没有反应
```

**代理响应：**
```
## 🔍 问题诊断：按钮点击无响应

### 可能原因检查

**1. 事件绑定问题** ❌
```vue
<!-- 错误：缺少 @ 前缀 -->
<wd-button click="handleClick">按钮</wd-button>

<!-- 正确：使用 @ 绑定事件 -->
<wd-button @click="handleClick">按钮</wd-button>
```

**2. 函数未定义** ❌
```vue
<script setup>
// ❌ 忘记定义函数
// const handleClick = () => {}

// ✅ 正确定义函数
const handleClick = () => {
  console.log('按钮被点击')
}
</script>
```

**3. loading 状态** ❌
```vue
<!-- loading 状态下按钮不可点击 -->
<wd-button loading>加载中</wd-button>

<!-- 解决方案：根据状态控制 -->
<wd-button :loading="isLoading" @click="handleClick">
  {{ isLoading ? '加载中' : '点击' }}
</wd-button>
```

**4. disabled 状态** ❌
```vue
<!-- disabled 状态下按钮不可点击 -->
<wd-button disabled>禁用按钮</wd-button>

<!-- 解决方案：根据条件控制 -->
<wd-button :disabled="!canClick" @click="handleClick">
  按钮
</wd-button>
```

**5. 事件被阻止** ❌
```vue
<!-- 父元素阻止了事件冒泡 -->
<view @click.stop>
  <wd-button @click="handleClick">按钮</wd-button>
</view>

<!-- 解决方案：使用 .native 或移除 .stop -->
<view>
  <wd-button @click="handleClick">按钮</wd-button>
</view>
```

### 调试步骤

1. **检查事件绑定**
   ```javascript
   const handleClick = () => {
     console.log('按钮被点击了') // 添加日志
   }
   ```

2. **检查按钮状态**
   ```vue
   <wd-button
     :loading="isLoading"
     :disabled="isDisabled"
     @click="handleClick"
   >
     按钮
   </wd-button>
   ```

3. **查看控制台**
   - 是否有报错信息
   - 函数是否被调用
   - this 指向是否正确

### 完整示例
```vue
<template>
  <wd-button
    type="primary"
    :loading="isLoading"
    :disabled="isDisabled"
    @click="handleClick"
  >
    {{ buttonText }}
  </wd-button>
</template>

<script setup>
import { ref, computed } from 'vue'

const isLoading = ref(false)
const isDisabled = ref(false)

const buttonText = computed(() => {
  return isLoading.value ? '加载中...' : '点击按钮'
})

const handleClick = () => {
  console.log('按钮被点击')

  // 模拟异步操作
  isLoading.value = true
  setTimeout(() => {
    isLoading.value = false
    uni.showToast({ title: '操作成功' })
  }, 1000)
}
</script>
```

### 如果问题仍未解决

1. 检查组件库版本
2. 查看官方文档示例
3. 在 GitHub 提交 issue
4. 加入官方交流群求助
```

### 示例 3: 代码审查

**用户输入：**
```
@component-help 帮我检查这段代码有没有问题
```

**代理响应：**
```
## 📋 代码审查报告

### 审查的代码
```vue
<template>
  <wd-form :model="formData">
    <wd-input v-model="formData.name" label="姓名" />
    <wd-input v-model="formData.mobile" label="手机号" />
    <wd-button @click="submit">提交</wd-button>
  </wd-form>
</template>

<script setup>
import { ref } from 'vue'

const formData = ref({
  name: '',
  mobile: ''
})

const submit = () => {
  console.log(formData.value)
}
</script>
```

### 发现的问题

#### ❌ 严重问题

1. **缺少表单验证**
   ```vue
   <!-- 当前代码 -->
   <wd-form :model="formData">

   <!-- 应该添加 -->
   <wd-form ref="formRef" :model="formData" :rules="rules">
   ```

2. **表单项缺少 prop**
   ```vue
   <!-- 当前代码 -->
   <wd-input v-model="formData.name" label="姓名" />

   <!-- 应该添加 -->
   <wd-input v-model="formData.name" label="姓名" prop="name" required />
   ```

3. **没有处理提交错误**
   ```javascript
   // 当前代码
   const submit = () => {
     console.log(formData.value)
   }

   // 应该添加
   const submit = async () => {
     try {
       await formRef.value?.validate()
       // 提交数据
     } catch (error) {
       console.log('验证失败', error)
     }
   }
   ```

#### ⚠️ 改进建议

1. **添加类型定义**
   ```typescript
   import type { FormInstance } from 'wot-design-uni/components/wd-form/types'

   const formRef = ref<FormInstance>()
   ```

2. **完善验证规则**
   ```javascript
   const rules = {
     name: [
       { required: true, message: '请输入姓名' },
       { min: 2, max: 10, message: '长度在 2 到 10 个字符' }
     ],
     mobile: [
       { required: true, message: '请输入手机号' },
       { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号' }
     ]
   }
   ```

3. **添加用户反馈**
   ```javascript
   import { useToast } from 'wot-design-uni'

   const toast = useToast()

   const submit = async () => {
     try {
       await formRef.value?.validate()
       toast.loading('提交中...')

       await submitForm(formData.value)

       toast.close()
       toast.success('提交成功')
     } catch (error) {
       toast.close()
       toast.error('提交失败')
     }
   }
   ```

4. **禁用重复提交**
   ```vue
   <wd-button :loading="isLoading" @click="submit">提交</wd-button>
   ```

### 优化后的完整代码
```vue
<template>
  <wd-form ref="formRef" :model="formData" :rules="rules">
    <wd-input
      v-model="formData.name"
      label="姓名"
      prop="name"
      required
      placeholder="请输入姓名"
    />
    <wd-input
      v-model="formData.mobile"
      label="手机号"
      prop="mobile"
      required
      type="number"
      placeholder="请输入手机号"
    />
    <wd-button type="primary" :loading="isLoading" @click="submit">
      提交
    </wd-button>
  </wd-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { FormInstance } from 'wot-design-uni/components/wd-form/types'
import { useToast } from 'wot-design-uni'

const toast = useToast()
const formRef = ref<FormInstance>()
const isLoading = ref(false)

const formData = ref({
  name: '',
  mobile: ''
})

const rules = {
  name: [
    { required: true, message: '请输入姓名' },
    { min: 2, max: 10, message: '长度在 2 到 10 个字符' }
  ],
  mobile: [
    { required: true, message: '请输入手机号' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号' }
  ]
}

const submit = async () => {
  try {
    await formRef.value?.validate()
    isLoading.value = true
    toast.loading('提交中...')

    // 模拟 API 调用
    await new Promise(resolve => setTimeout(resolve, 1000))

    console.log('提交的数据:', formData.value)

    toast.close()
    toast.success('提交成功')
  } catch (error: any) {
    toast.close()
    if (error?.message) {
      toast.error(error.message)
    }
  } finally {
    isLoading.value = false
  }
}
</script>
```

### 改进对比
| 项目 | 改进前 | 改进后 |
|------|--------|--------|
| 表单验证 | ❌ 无 | ✅ 完整验证规则 |
| 错误处理 | ❌ 无 | ✅ 友好的错误提示 |
| 用户体验 | ⚠️ 无反馈 | ✅ 加载状态 + 提示 |
| 代码质量 | ⚠️ 无类型 | ✅ TypeScript |
| 重复提交 | ⚠️ 未防护 | ✅ loading 防护 |

### 评分
- 改进前: 40/100
- 改进后: 95/100
```

## 最佳实践建议

### 1. 组件选择
- 先查阅官方文档了解所有可用组件
- 选择最符合需求的组件
- 考虑组件的性能和体验

### 2. 代码规范
- 始终使用组件的 `wd-` 前缀
- Props 使用 kebab-case
- 事件使用 `@` 前缀
- 添加必要的类型定义

### 3. 性能优化
- 避免在循环中创建组件
- 合理使用 v-show 和 v-if
- 大列表使用虚拟滚动

### 4. 用户体验
- 提供加载状态反馈
- 添加错误提示
- 考虑边界情况

### 5. 平台兼容
- 测试所有目标平台
- 使用条件编译处理差异
- 查阅官方平台差异文档

## 相关资源

- [官方文档](https://wot-ui.cn)
- [组件列表](https://wot-ui.cn/component)
- [常见问题](https://wot-ui.cn/guide/common-problems)
- [GitHub Issues](https://github.com/Moonofweisheng/wot-design-uni/issues)
