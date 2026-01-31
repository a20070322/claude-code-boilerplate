# Wot Design Uni 使用规范

## 项目概述

本项目使用 **Wot Design Uni** 组件库，这是一个基于 Vue3 + TypeScript 构建的 uni-app 组件库，提供 70+ 高质量组件，支持多端运行（微信小程序、支付宝小程序、H5、APP 等）。

## 技术栈

- **框架**: uni-app
- **Vue 版本**: Vue 3
- **开发语言**: TypeScript
- **UI 组件库**: wot-design-uni
- **包管理器**: npm / yarn / pnpm
- **CSS 预处理**: Sass（注意版本 < 1.78.0）

## 核心规范

### 组件使用规范

1. **组件命名**
   - 所有组件必须以 `wd-` 开头
   - 使用 kebab-case 命名（如 `wd-button`）
   - 不得使用无前缀的组件名称

2. **Props 使用**
   - Props 属性名使用 kebab-case
   - 绑定变量使用 `v-model` 或 `:` 前缀
   - 布尔值属性可以简写

3. **事件绑定**
   - 所有事件必须使用 `@` 前缀
   - 事件名使用 kebab-case
   - 正确处理事件回调

4. **类型定义**
   - 推荐使用 TypeScript
   - 从组件类型文件导入类型定义
   - 避免使用 `any` 类型

### 代码规范

1. **模板结构**
   ```vue
   <template>
     <!-- 组件结构清晰 -->
     <wd-button @click="handleClick">按钮</wd-button>
   </template>

   <script setup lang="ts">
   // 1. 导入
   import { ref } from 'vue'
   import type { FormInstance } from 'wot-design-uni/components/wd-form/types'

   // 2. 定义
   const value = ref('')

   // 3. 方法
   const handleClick = () => {
     console.log('点击')
   }
   </script>

   <style scoped>
   /* 组件样式 */
   </style>
   ```

2. **组件引入**
   ```json
   // pages.json
   {
     "easycom": {
       "autoscan": true,
       "custom": {
         "^wd-(.*)": "wot-design-uni/components/wd-$1/wd-$1.vue"
       }
     }
   }
   ```

3. **样式定制**
   - 优先使用 CSS 变量
   - 使用 `custom-style` 属性
   - 避免直接修改组件内部样式

## 快捷命令

### /use-component
使用组件（查找/引入/配置）

**用法：**
```
/use-component <组件名称>
```

**示例：**
```
/use-component 弹窗      # 查找弹窗组件用法
/use-component wd-button # 查看具体组件
```

### /theme-config
主题配置（颜色/暗黑模式/自定义）

**用法：**
```
/theme-config <配置类型>
```

**示例：**
```
/theme-config color  # 颜色定制
/theme-config dark   # 暗黑模式
```

### /check-usage
检查使用规范

**用法：**
```
/check-usage [检查范围]
```

**示例：**
```
/check-usage         # 检查整个项目
/check-usage pages/  # 检查指定目录
```

## 技能 (Skills)

### 基础组件技能 (usage-basic-component)
**触发场景：** 使用按钮、图标、头像、徽标、标签等基础组件

**包含组件：**
- wd-button - 按钮
- wd-icon - 图标
- wd-cell - 单元格
- wd-avatar - 头像
- wd-badge - 徽标
- wd-tag - 标签
- wd-divider - 分割线

### 表单组件技能 (usage-form-component)
**触发场景：** 使用输入框、表单、选择器、上传、评分等表单组件

**包含组件：**
- wd-form - 表单
- wd-input - 输入框
- wd-textarea - 文本域
- wd-picker - 选择器
- wd-checkbox - 复选框
- wd-radio - 单选框
- wd-switch - 开关
- wd-upload - 上传
- wd-rate - 评分
- wd-datetime-picker - 日期时间选择

### 反馈组件技能 (usage-feedback-component)
**触发场景：** 使用弹窗、提示、加载、通知等反馈组件

**包含组件：**
- wd-dialog - 弹窗
- wd-toast - 轻提示
- wd-loading - 加载
- wd-popup - 弹出层
- wd-action-sheet - 操作菜单
- wd-notify - 消息通知
- wd-dropdown - 下拉菜单

### 布局组件技能 (usage-layout-component)
**触发场景：** 使用布局容器、分隔线、卡片、折叠等布局组件

**包含组件：**
- wd-row/wd-col - 布局容器
- wd-divider - 分隔线
- wd-card - 卡片
- wd-collapse - 折叠面板
- wd-grid - 网格
- wd-sticky - 粘性布局
- wd-backtop - 回到顶部

### 导航组件技能 (usage-navigation-component)
**触发场景：** 使用标签页、导航栏、侧边栏等导航组件

**包含组件：**
- wd-tabs - 标签页
- wd-tabbar - 标签栏
- wd-navbar - 导航栏
- wd-sidebar - 侧边栏
- wd-steps - 步骤条
- wd-pagination - 分页

## 代理 (Agents)

### @component-helper
组件使用助手

**功能：**
- 根据需求推荐合适的组件
- 提供组件用法说明
- 诊断组件使用问题
- 审查组件使用规范

**使用：**
```
@component-help 我需要一个表单组件
```

## 开发流程

### 1. 使用组件

```
1. /use-component <组件名>
   → 查看组件用法和示例

2. 复制示例代码到项目中

3. 根据需求修改配置

4. /check-usage
   → 检查使用规范
```

### 2. 定制主题

```
1. /theme-config color
   → 配置主题颜色

2. 创建 theme.css 文件
   → 定义 CSS 变量

3. 在 App.vue 中引入

4. 测试主题效果
```

### 3. 解决问题

```
1. @component-help <问题描述>
   → 获取诊断和建议

2. 查看官方文档
   → 确认正确用法

3. 参考示例代码
   → 修复问题

4. /check-usage
   → 验证修复结果
```

## 代码检查清单

### 组件使用
- [ ] 组件名称是否以 `wd-` 开头
- [ ] Props 是否使用 kebab-case
- [ ] 事件是否使用 `@` 前缀
- [ ] 是否正确使用了 `v-model`
- [ ] 是否查阅了官方文档

### 表单处理
- [ ] 是否在 wd-form 中设置了 rules
- [ ] 每个 form-item 是否设置了 prop
- [ ] 是否定义了完整的验证规则
- [ ] 是否正确处理了验证失败

### 类型安全
- [ ] 是否导入了正确的类型定义
- [ ] 是否避免了 any 类型
- [ ] 是否为 ref/setRef 添加了类型
- [ ] 是否为事件回调添加了参数类型

### 性能优化
- [ ] 列表是否使用了 key
- [ ] 是否避免了不必要的重渲染
- [ ] 大数据量是否使用了分页或虚拟滚动
- [ ] 定时器是否在 onUnmounted 清理

### 平台兼容
- [ ] 是否测试了所有目标平台
- [ ] 平台特有代码是否使用了条件编译
- [ ] 是否查阅了平台差异文档
- [ ] API 是否在所有平台都可用

## 常见问题

### Q1: 组件无法显示？
**原因：** easycom 配置错误或组件名称错误

**解决：**
1. 检查 pages.json 中的 easycom 配置
2. 确认组件名称以 `wd-` 开头
3. 修改配置后重新编译

### Q2: 组件样式不生效？
**原因：** 未正确配置 CSS 变量或优先级问题

**解决：**
1. 使用 CSS 变量覆盖样式
2. 使用 `custom-style` 属性
3. 检查样式作用域

### Q3: 某些功能在特定平台不生效？
**原因：** 平台差异

**解决：**
1. 查看官方文档的平台差异说明
2. 使用条件编译处理平台特定代码
3. 测试所有目标平台

### Q4: 类型定义找不到？
**原因：** 导入路径错误

**解决：**
```typescript
// 正确的导入路径
import type { FormInstance } from 'wot-design-uni/components/wd-form/types'
```

### Q5: 表单验证不生效？
**原因：** 缺少必要的配置

**解决：**
1. 确保每个 form-item 有 prop 属性
2. 确保 ref 被正确绑定
3. 调用 validate() 方法进行验证

## 最佳实践

### 1. 组件选择
- 优先使用 Wot Design Uni 提供的组件
- 查阅官方文档了解所有可用组件
- 选择最适合需求的组件

### 2. 代码规范
- 使用 TypeScript 提供类型安全
- 遵循 kebab-case 命名规范
- 添加必要的注释

### 3. 性能优化
- 列表渲染始终添加 key
- 避免在模板中使用复杂表达式
- 合理使用 v-show 和 v-if

### 4. 用户体验
- 提供加载状态反馈
- 给出友好的错误提示
- 考虑边界情况

### 5. 平台兼容
- 测试所有目标平台
- 使用条件编译处理差异
- 避免使用平台特有 API

## 参考资源

- [官方文档](https://wot-ui.cn)
- [组件列表](https://wot-ui.cn/component)
- [快速上手](https://wot-ui.cn/guide/quick-use)
- [常见问题](https://wot-ui.cn/guide/common-problems)
- [更新日志](https://wot-ui.cn/guide/changelog)
- [GitHub](https://github.com/Moonofweisheng/wot-design-uni)

## 版本要求

- **Node.js**: >= 14.0.0
- **HBuilderX**: >= 3.6.0
- **Vue**: 3.x
- **Sass**: <= 1.78.0（重要：Dart Sass 3.0.0 废弃了部分 API）
- **wot-design-uni**: >= 1.0.0

## 更新日志

- 2026-01-31: 创建配置模板
- 基于 wot-design-uni v1.14.0
