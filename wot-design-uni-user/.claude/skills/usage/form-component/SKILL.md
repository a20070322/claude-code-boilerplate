---
name: usage-form-component
description: 表单组件使用技能 - 输入框、表单、选择器、上传、评分等表单组件的正确使用方法
---

# Wot Design Uni - 表单组件使用

## 使用场景
当需要使用以下表单组件时触发此技能：
- 输入框 (wd-input, wd-textarea)
- 表单 (wd-form)
- 复选框 (wd-checkbox)
- 单选框 (wd-radio)
- 开关 (wd-switch)
- 选择器 (wd-picker, wd-col-picker)
- 评分 (wd-rate)
- 上传 (wd-upload)
- 步进器 (wd-stepper)
- 滑块 (wd-slider)
- 日期时间选择 (wd-datetime-picker)

## 组件使用模板

### 1. 表单验证 (wd-form)

```vue
<template>
  <wd-form ref="formRef" :model="formData" :rules="rules">
    <wd-input
      v-model="formData.name"
      label="姓名"
      placeholder="请输入姓名"
      prop="name"
      required
    />

    <wd-input
      v-model="formData.mobile"
      label="手机号"
      placeholder="请输入手机号"
      prop="mobile"
      type="number"
      required
    />

    <wd-textarea
      v-model="formData.remark"
      label="备注"
      placeholder="请输入备注"
      prop="remark"
    />

    <wd-button type="primary" @click="handleSubmit">提交</wd-button>
  </wd-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { FormInstance } from 'wot-design-uni/components/wd-form/types'

const formRef = ref<FormInstance>()
const formData = ref({
  name: '',
  mobile: '',
  remark: ''
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

const handleSubmit = async () => {
  try {
    await formRef.value?.validate()
    console.log('表单验证通过', formData.value)
  } catch (error) {
    console.log('表单验证失败', error)
  }
}
</script>
```

### 2. 输入框 (wd-input)

```vue
<template>
  <!-- 基础用法 -->
  <wd-input v-model="value" label="输入框" placeholder="请输入内容" />

  <!-- 禁用状态 -->
  <wd-input v-model="value" label="禁用" disabled />

  <!-- 只读状态 -->
  <wd-input v-model="value" label="只读" readonly />

  <!-- 必填项 -->
  <wd-input v-model="value" label="必填" required />

  <!-- 清空按钮 -->
  <wd-input v-model="value" label="清空" clearable />

  <!-- 字数限制 -->
  <wd-input v-model="value" label="字数" maxlength="10" show-word-limit />

  <!-- 密码框 -->
  <wd-input v-model="value" label="密码" type="password" show-password />

  <!-- 数字输入 -->
  <wd-input v-model="value" label="数字" type="number" />

  <!-- 带图标 -->
  <wd-input v-model="value" label="图标" prefix-icon="search" />
  <wd-input v-model="value" label="图标" suffix-icon="calendar" />

  <!-- 错误提示 -->
  <wd-input v-model="value" label="错误" error="输入有误" />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const value = ref('')
</script>
```

### 3. 选择器 (wd-picker)

```vue
<template>
  <!-- 基础用法 -->
  <wd-picker v-model="value" :columns="columns" label="选择器" />

  <!-- 多列选择 -->
  <wd-picker v-model="value1" :columns="columnsMulti" label="多列选择" />

  <!-- 级联选择 -->
  <wd-picker v-model="value2" :columns="columnsCascader" label="级联选择" />

  <!-- 禁用选项 -->
  <wd-picker
    v-model="value3"
    :columns="columnsDisabled"
    label="禁用选项"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const value = ref('选项1')

const columns = [
  { label: '选项1', value: '1' },
  { label: '选项2', value: '2' },
  { label: '选项3', value: '3' }
]

// 多列
const value1 = ref(['1', 'a'])
const columnsMulti = [
  [
    { label: '选项1', value: '1' },
    { label: '选项2', value: '2' }
  ],
  [
    { label: '选项A', value: 'a' },
    { label: '选项B', value: 'b' }
  ]
]

// 级联
const value2 = ref(['1', '1-1', '1-1-1'])
const columnsCascader = [
  {
    label: '选项1',
    value: '1',
    children: [
      {
        label: '选项1-1',
        value: '1-1',
        children: [
          { label: '选项1-1-1', value: '1-1-1' },
          { label: '选项1-1-2', value: '1-1-2' }
        ]
      }
    ]
  }
]
</script>
```

### 4. 复选框 (wd-checkbox)

```vue
<template>
  <!-- 基础用法 -->
  <wd-checkbox v-model="checked1">复选框</wd-checkbox>

  <!-- 禁用状态 -->
  <wd-checkbox v-model="checked2" disabled>禁用</wd-checkbox>

  <!-- 复选框组 -->
  <wd-checkbox-group v-model="checkboxGroup">
    <wd-checkbox value="a">选项 A</wd-checkbox>
    <wd-checkbox value="b">选项 B</wd-checkbox>
    <wd-checkbox value="c" disabled>选项 C（禁用）</wd-checkbox>
  </wd-checkbox-group>

  <!-- 单元格中使用 -->
  <wd-cell title="复选框">
    <wd-checkbox v-model="checked3" shape="square" />
  </wd-cell>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const checked1 = ref(false)
const checked2 = ref(true)
const checked3 = ref(false)
const checkboxGroup = ref(['a'])
</script>
```

### 5. 单选框 (wd-radio)

```vue
<template>
  <!-- 基础用法 -->
  <wd-radio-group v-model="radio" @change="handleChange">
    <wd-radio value="1">选项 1</wd-radio>
    <wd-radio value="2">选项 2</wd-radio>
  </wd-radio-group>

  <!-- 禁用状态 -->
  <wd-radio value="3" disabled>选项 3（禁用）</wd-radio>

  <!-- 单元格中使用 -->
  <wd-cell title="单选框">
    <wd-radio-group v-model="radio1" shape="button">
      <wd-radio value="a">选项 A</wd-radio>
      <wd-radio value="b">选项 B</wd-radio>
    </wd-radio-group>
  </wd-cell>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const radio = ref('1')
const radio1 = ref('a')

const handleChange = (value: string) => {
  console.log('选中值：', value)
}
</script>
```

### 6. 开关 (wd-switch)

```vue
<template>
  <!-- 基础用法 -->
  <wd-switch v-model="checked" />

  <!-- 禁用状态 -->
  <wd-switch v-model="checked1" disabled />

  <!-- 加载状态 -->
  <wd-switch v-model="checked2" loading />

  <!-- 自定义颜色 -->
  <wd-switch
    v-model="checked3"
    active-color="#07c160"
    inactive-color="#ee0a24"
  />

  <!-- 单元格中使用 -->
  <wd-cell title="开关">
    <wd-switch v-model="checked4" size="small" />
  </wd-cell>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const checked = ref(true)
const checked1 = ref(false)
const checked2 = ref(true)
const checked3 = ref(false)
const checked4 = ref(true)
</script>
```

### 7. 上传 (wd-upload)

```vue
<template>
  <!-- 基础用法 -->
  <wd-upload
    v-model="fileList"
    :action="action"
    :limit="3"
    @change="handleChange"
  />

  <!-- 图片预览 -->
  <wd-upload
    v-model="fileList1"
    :action="action"
    :before-remove="beforeRemove"
  />

  <!-- 自定义上传 -->
  <wd-upload
    v-model="fileList2"
    :multiple="true"
    :before-upload="beforeUpload"
    @oversize="handleOversize"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { UploadFile } from 'wot-design-uni/components/wd-upload/types'

const action = 'https://example.com/upload'
const fileList = ref<UploadFile[]>([])
const fileList1 = ref<UploadFile[]>([])
const fileList2 = ref<UploadFile[]>([])

const handleChange = ({ fileList }: { fileList: UploadFile[] }) => {
  console.log('文件列表：', fileList)
}

const beforeRemove = (file: UploadFile) => {
  return uni.showModal({
    title: '提示',
    content: '确定删除该文件吗？'
  })
}

const beforeUpload = (file: UploadFile) => {
  // 文件大小限制 5MB
  if (file.size && file.size > 5 * 1024 * 1024) {
    uni.showToast({
      title: '文件大小不能超过 5MB',
      icon: 'none'
    })
    return false
  }
  return true
}

const handleOversize = () => {
  uni.showToast({
    title: '文件大小不能超过 5MB',
    icon: 'none'
  })
}
</script>
```

### 8. 评分 (wd-rate)

```vue
<template>
  <!-- 基础用法 -->
  <wd-rate v-model="value" />

  <!-- 自定义图标 -->
  <wd-rate v-model="value1" icon="heart" />

  <!-- 半星 -->
  <wd-rate v-model="value2" :half-icon="true" allow-half />

  <!-- 禁用状态 -->
  <wd-rate v-model="value3" disabled />

  <!-- 只读状态 -->
  <wd-rate v-model="value4" readonly />

  <!-- 自定义颜色 -->
  <wd-rate
    v-model="value5"
    active-color="#ffd21e"
    inactive-color="#c8c9cc"
  />

  <!-- 显示分数 -->
  <wd-rate v-model="value6" :show-score="true" />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const value = ref(3)
const value1 = ref(3)
const value2 = ref(3.5)
const value3 = ref(3)
const value4 = ref(4)
const value5 = ref(5)
const value6 = ref(4)
</script>
```

### 9. 日期时间选择 (wd-datetime-picker)

```vue
<template>
  <!-- 日期选择 -->
  <wd-datetime-picker
    v-model="dateValue"
    type="date"
    label="选择日期"
  />

  <!-- 时间选择 -->
  <wd-datetime-picker
    v-model="timeValue"
    type="time"
    label="选择时间"
  />

  <!-- 日期时间选择 -->
  <wd-datetime-picker
    v-model="datetimeValue"
    type="datetime"
    label="选择日期时间"
  />

  <!-- 限制范围 -->
  <wd-datetime-picker
    v-model="dateValue1"
    type="date"
    label="限制范围"
    :min-date="minDate"
    :max-date="maxDate"
  />

  <!-- 格式化显示 -->
  <wd-datetime-picker
    v-model="dateValue2"
    type="date"
    label="格式化"
    :formatter="formatter"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const dateValue = ref(new Date())
const timeValue = ref('12:00')
const datetimeValue = ref(new Date())

const minDate = new Date(2020, 0, 1)
const maxDate = new Date(2025, 11, 31)
const dateValue1 = ref(new Date())

const dateValue2 = ref(new Date())

const formatter = (type: string, value: number) => {
  if (type === 'year') {
    return `${value}年`
  }
  if (type === 'month') {
    return `${value}月`
  }
  if (type === 'day') {
    return `${value}日`
  }
  return value
}
</script>
```

## 禁止事项 ⭐重要

- ❌ 不要忘记在 `wd-form` 中给每个表单项设置 `prop` 属性
- ❌ 不要使用 `wd-input` 的 `value` 属性，应该使用 `v-model`
- ❌ 不要在 `wd-picker` 中混淆 `label` 和 `value`
- ❌ 不要在 `wd-upload` 中忘记设置 `action` 上传地址
- ❌ 不要在表单验证规则中使用错误的验证方式
- ❌ 不要在复选框组中混用 `v-model` 和 `value`
- ❌ 不要忘记导入正确的类型定义

## 检查清单 ⭐重要

- [ ] 是否正确使用 `v-model` 绑定值
- [ ] 表单项是否设置了正确的 `prop` 属性
- [ ] 验证规则是否正确定义
- [ ] 选择器的 `columns` 数据格式是否正确
- [ ] 上传组件是否配置了 `action` 地址
- [ ] 是否处理了错误状态
- [ ] 是否测试了表单验证功能
- [ ] 是否添加了必要的错误提示

## 注意事项

### 表单验证
1. 必须给每个表单项设置 `prop` 属性，对应 `formData` 中的字段
2. 验证规则中的 `pattern` 使用正则表达式
3. 异步验证可以使用返回 Promise 的方式

### 输入框
1. 使用 `type` 属性控制输入类型（text, number, password 等）
2. `show-word-limit` 需要配合 `maxlength` 使用
3. `clearable` 属性会在有内容时显示清空按钮

### 选择器
1. 单列选择器 `v-model` 绑定单个值
2. 多列选择器 `v-model` 绑定数组
3. 级联选择器需要 `children` 属性构建层级关系

### 上传
1. 记得配置 `action` 上传接口地址
2. 使用 `limit` 限制上传数量
3. 使用 `before-upload` 在上传前校验文件

## 参考文档

- [Form 表单](https://wot-ui.cn/component/form)
- [Input 输入框](https://wot-ui.cn/component/input)
- [Picker 选择器](https://wot-ui.cn/component/picker)
- [Checkbox 复选框](https://wot-ui.cn/component/checkbox)
- [Radio 单选框](https://wot-ui.cn/component/radio)
- [Switch 开关](https://wot-ui.cn/component/switch)
- [Upload 上传](https://wot-ui.cn/component/upload)
- [Rate 评分](https://wot-ui.cn/component/rate)
- [Datetime-picker 日期时间选择](https://wot-ui.cn/component/datetime-picker)
