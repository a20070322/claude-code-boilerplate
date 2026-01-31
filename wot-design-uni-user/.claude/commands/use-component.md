# /use-component - 使用组件

## 描述
帮助用户快速查找、引入和配置 Wot Design Uni 组件。这个命令会引导用户完成组件的整个使用流程。

## 使用方法
```
/use-component <组件名称>
```

**示例：**
```
/use-component wd-button
/use-component 表单
/use-component 弹窗
```

## 执行步骤

### 步骤 1: 组件识别
- [ ] 识别用户需要使用的组件类型
- [ ] 确定组件的标准名称（wd-xxx）
- [ ] 判断组件属于哪个类别（基础/表单/反馈/布局/导航）

### 步骤 2: 文档查询
- [ ] 查询该组件的官方文档
- [ ] 提取组件的核心用法
- [ ] 获取组件的 Props、Events、Slots 定义
- [ ] 查看组件的示例代码

### 步骤 3: 代码生成
- [ ] 根据使用场景生成基础用法代码
- [ ] 添加必要的类型导入
- [ ] 包含常用的事件处理
- [ ] 提供多个使用场景示例

### 步骤 4: 配置检查
- [ ] 确认 easycom 配置是否正确
- [ ] 检查是否需要额外配置
- [ ] 提示平台兼容性注意事项

### 步骤 5: 最佳实践
- [ ] 提供该组件的最佳实践建议
- [ ] 列出常见错误和解决方案
- [ ] 给出相关组件的推荐组合

## 示例执行

**用户输入：** `/use-component 弹窗`

**执行过程：**

1. **识别组件**：确定为 `wd-dialog` 组件（反馈组件）

2. **查询文档**：
   - 基础用法：使用 `v-model` 控制显示隐藏
   - Props: title, content, show-cancel-button
   - Events: confirm, cancel
   - Slots: title, default, footer

3. **生成代码**：
```vue
<template>
  <wd-button @click="dialogVisible = true">显示弹窗</wd-button>

  <wd-dialog
    v-model="dialogVisible"
    title="提示"
    content="确定要执行此操作吗？"
    show-cancel-button
    @confirm="handleConfirm"
    @cancel="handleCancel"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'

const dialogVisible = ref(false)

const handleConfirm = () => {
  console.log('确认操作')
  dialogVisible.value = false
  // 执行业务逻辑
}

const handleCancel = () => {
  console.log('取消操作')
  dialogVisible.value = false
}
</script>
```

4. **配置检查**：
```json
// pages.json 中检查 easycom 配置
{
  "easycom": {
    "autoscan": true,
    "custom": {
      "^wd-(.*)": "wot-design-uni/components/wd-$1/wd-$1.vue"
    }
  }
}
```

5. **最佳实践**：
- ✅ 在用户操作（点击）事件中触发弹窗
- ✅ 记得处理确认和取消事件
- ✅ 使用完后关闭弹窗（设置 `v-model` 为 false）
- ❌ 不要在页面加载时自动弹出（除非有特殊需求）
- 💡 对于简单提示，考虑使用 `wd-toast` 代替

## 注意事项

### 1. 组件命名规范
- 所有组件都以 `wd-` 开头
- 使用 kebab-case 命名（如 `wd-button`）
- 不要使用 `wd` 作为组件名称前缀以外的用途

### 2. easycom 自动引入
- 确保在 `pages.json` 中配置了 easycom
- 配置后无需手动 import 组件
- 修改 pages.json 后需要重新编译

### 3. 类型支持
- 推荐使用 TypeScript
- 可以从 `wot-design-uni/components/xxx/types` 导入类型定义
- 类型提示会提高开发效率

### 4. 平台兼容性
- 某些组件在不同平台可能有差异
- 查看官方文档的"平台差异"说明
- 使用条件编译处理平台特定代码

### 5. 版本更新
- 组件库会持续更新
- 升级前查看 CHANGELOG
- 注意破坏性更新（breaking changes）

## 常见问题

**Q: 组件无法显示？**
A: 检查 easycom 配置，确认组件名称正确（wd-前缀）

**Q: 如何获取组件的 ref？**
A: 使用 ref 绑定，并导入正确的类型定义

**Q: 组件样式如何自定义？**
A: 优先使用 CSS 变量覆盖，或使用 `custom-style` 属性

**Q: 某些功能在特定平台不生效？**
A: 查看官方文档的平台差异说明，使用条件编译

## 相关命令

- `/theme-config` - 自定义组件主题
- `/check-usage` - 检查组件使用规范
