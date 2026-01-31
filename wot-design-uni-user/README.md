# Wot Design Uni 使用配置

> 🎨 让 AI 像一个熟练的 Wot Design Uni 开发者一样工作

## 简介

这是一个专为 **使用** Wot Design Uni 组件库的 uni-app 项目设计的 Claude Code 配置模板。

**⚠️ 注意：** 这是一个**使用配置**，不是开发配置。如果你需要开发或维护 wot-design-uni 组件库本身，请使用其他配置。

## 包含内容

### 🎯 核心特性
- ✅ **强制技能评估** - 自动识别需要的组件类型并激活对应技能
- ✅ **完整的技能体系** - 5 大类组件技能（基础/表单/反馈/布局/导航）
- ✅ **快捷命令** - 3 个斜杠命令快速完成常见任务
- ✅ **智能代理** - 组件使用助手提供实时帮助
- ✅ **规范检查** - 自动检查组件使用规范

### 📁 配置文件
```
.claude/
├── settings.json              # 核心配置
├── CLAUDE.md                  # 项目规范
├── hooks/                     # 生命周期钩子
│   ├── session-start.mjs     # 会话启动
│   ├── user-prompt-submit.mjs # 强制技能评估 ⭐
│   └── stop.mjs              # 任务总结
├── skills/                    # 使用技能
│   ├── basic-component       # 基础组件
│   ├── form-component        # 表单组件
│   ├── feedback-component    # 反馈组件
│   ├── layout-component      # 布局组件
│   └── navigation-component  # 导航组件
├── commands/                  # 斜杠命令
│   ├── use-component.md      # 使用组件
│   ├── theme-config.md       # 主题配置
│   └── check-usage.md        # 检查规范
└── agents/                    # 代理
    └── component-helper      # 组件助手
```

## 技术栈

- **框架**: uni-app
- **Vue 版本**: Vue 3
- **开发语言**: TypeScript
- **UI 组件库**: wot-design-uni v1.14.0
- **支持平台**: 微信小程序、支付宝小程序、H5、APP 等

## 快速开始

### 1. 安装依赖

```bash
# npm
npm i wot-design-uni sass -D

# yarn
yarn add wot-design-uni
yarn add sass -D

# pnpm
pnpm add wot-design-uni
pnpm add sass -D
```

**⚠️ 重要：** Sass 版本必须 <= 1.78.0

### 2. 配置 easycom

在 `pages.json` 中添加：

```json
{
  "easycom": {
    "autoscan": true,
    "custom": {
      "^wd-(.*)": "wot-design-uni/components/wd-$1/wd-$1.vue"
    }
  }
}
```

### 3. 复制配置文件

将 `.claude` 目录复制到你的项目根目录。

### 4. 启动开发

```bash
# 启动开发服务器
npm run dev:mp-weixin  # 微信小程序
npm run dev:h5         # H5
```

## 核心特性

### 🎯 强制技能评估

当你请求创建或修改组件相关代码时，AI 会自动评估并激活对应的技能：

```
你: "创建一个表单页面"

AI: ## 步骤 1 - 技能评估
✅ usage-form-component - 是 - 需要使用表单组件
✅ usage-basic-component - 是 - 需要使用按钮等基础组件

AI: ## 步骤 2 - 激活技能
[激活 usage-form-component 技能]
[激活 usage-basic-component 技能]

AI: ## 步骤 3 - 实施任务
[根据技能规范创建表单页面]
```

### 📦 5 大组件技能

| 技能 | 说明 | 包含组件 |
|------|------|----------|
| usage-basic-component | 基础组件 | button, icon, cell, avatar, badge, tag, divider |
| usage-form-component | 表单组件 | form, input, picker, checkbox, radio, switch, upload, rate |
| usage-feedback-component | 反馈组件 | dialog, toast, loading, popup, action-sheet, notify |
| usage-layout-component | 布局组件 | row/col, divider, card, collapse, grid, sticky, backtop |
| usage-navigation-component | 导航组件 | tabs, tabbar, navbar, sidebar, steps, pagination |

### ⚡ 3 个快捷命令

#### /use-component - 使用组件
```
/use-component 弹窗
→ 自动查找弹窗组件
→ 提供完整用法示例
→ 说明注意事项
```

#### /theme-config - 主题配置
```
/theme-config color
→ 配置主题颜色
→ 创建 CSS 变量文件
→ 提供配置示例
```

#### /check-usage - 检查规范
```
/check-usage
→ 检查组件使用规范
→ 生成详细报告
→ 提供修复建议
```

### 🤖 智能代理

#### @component-helper
组件使用助手，帮助你：
- 根据需求推荐合适的组件
- 提供组件用法说明
- 诊断组件使用问题
- 审查组件使用规范

```
@component-help 我需要一个表单组件
→ 推荐合适的组件
→ 提供使用示例
→ 说明最佳实践
```

## 与其他配置对比

| 配置类型 | 适用场景 | 包含内容 |
|---------|---------|---------|
| **Wot Starter (前端)** | 开发 uni-app 应用 | 页面/API/Store/路由等开发技能 |
| **Wot Design Uni User (本配置)** | 使用 wot-design-uni 组件库 | 组件使用/主题配置/规范检查 |

## 使用示例

### 示例 1: 创建表单页面

```
你: 创建一个登录表单页面

AI: [评估技能]
→ usage-form-component ✅
→ usage-feedback-component ✅

AI: [激活技能并实施]

<template>
  <wd-form ref="formRef" :model="formData" :rules="rules">
    <wd-input
      v-model="formData.username"
      label="用户名"
      prop="username"
      required
    />
    <wd-input
      v-model="formData.password"
      label="密码"
      prop="password"
      type="password"
      required
    />
    <wd-button type="primary" @click="handleLogin">登录</wd-button>
  </wd-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { FormInstance } from 'wot-design-uni/components/wd-form/types'
import { useToast } from 'wot-design-uni'

const toast = useToast()
const formRef = ref<FormInstance>()
const formData = ref({
  username: '',
  password: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名' }
  ],
  password: [
    { required: true, message: '请输入密码' }
  ]
}

const handleLogin = async () => {
  try {
    await formRef.value?.validate()
    toast.loading('登录中...')
    // 登录逻辑
  } catch (error) {
    toast.error('请填写完整信息')
  }
}
</script>
```

### 示例 2: 定制主题

```
你: /theme-config color

AI: [执行主题配置命令]

→ 创建 theme.css 文件
→ 定义主题颜色变量
→ 提供配置说明

/* theme.css */
:root {
  --wd-color-theme: #3b82f6;
  --wd-color-theme-light: #60a5fa;
  --wd-color-theme-dark: #2563eb;
}

/* 在 App.vue 中引入 */
<script setup>
import './theme.css'
</script>
```

### 示例 3: 检查代码规范

```
你: /check-usage

AI: [执行规范检查]

## 检查报告
- 检查文件数: 25
- 问题总数: 12

❌ 错误: 3
- 组件名称错误 (2 处)
- 表单验证缺少 prop (1 处)

⚠️ 警告: 7
- 缺少类型定义 (3 处)
- 列表缺少 key (2 处)
- 平台兼容性问题 (2 处)

💡 提示: 2
- 建议使用虚拟滚动
- 建议添加错误处理

综合评分: ⭐⭐⭐⭐ (81/100)
```

## 核心规范

### 组件使用规范

1. **组件命名**
   ```vue
   ✅ <wd-button>按钮</wd-button>
   ❌ <button>按钮</button>
   ❌ <wd_button>按钮</wd_button>
   ```

2. **Props 使用**
   ```vue
   ✅ <wd-input v-model="value" label="输入" maxlength="10" />
   ❌ <wd-input v-model="value" label="输入" maxLength="10" />
   ```

3. **事件绑定**
   ```vue
   ✅ <wd-button @click="handleClick">按钮</wd-button>
   ❌ <wd-button click="handleClick">按钮</wd-button>
   ```

4. **类型定义**
   ```typescript
   ✅ import type { FormInstance } from 'wot-design-uni/components/wd-form/types'
   ❌ // 不导入类型定义
   ```

### 代码规范

1. **模板结构清晰**
2. **正确使用 v-model**
3. **添加必要的类型定义**
4. **提供用户反馈（toast/dialog）**
5. **处理错误情况**

## 最佳实践

### 1. 组件选择
- 优先使用 Wot Design Uni 提供的组件
- 查阅官方文档了解所有可用组件
- 选择最适合需求的组件

### 2. 表单处理
- 每个 form-item 必须设置 prop
- 定义完整的验证规则
- 正确处理验证失败

### 3. 性能优化
- 列表渲染始终添加 key
- 避免不必要的重渲染
- 大数据量使用分页或虚拟滚动

### 4. 用户体验
- 提供加载状态反馈
- 给出友好的错误提示
- 考虑边界情况

### 5. 平台兼容
- 测试所有目标平台
- 使用条件编译处理差异
- 查阅平台差异文档

## 常见问题

### Q: 组件无法显示？
**A:** 检查 easycom 配置和组件名称（必须 wd- 开头）

### Q: 样式如何自定义？
**A:** 优先使用 CSS 变量或 custom-style 属性

### Q: 某些功能在特定平台不生效？
**A:** 查看官方文档的平台差异说明，使用条件编译

### Q: 如何获取组件的类型定义？
**A:** 从 `wot-design-uni/components/组件名/types` 导入

### Q: 表单验证不生效？
**A:** 确保每个 form-item 有 prop 属性，并且 ref 正确绑定

## 限制说明

### 此配置不包含
- ❌ 页面路由管理（应使用 Wot Starter 配置）
- ❌ API 请求封装（应使用 Wot Starter 配置）
- ❌ 状态管理（应使用 Wot Starter 配置）
- ❌ 组件库开发（这是使用配置，不是开发配置）

### 此配置专注于
- ✅ Wot Design Uni 组件的正确使用
- ✅ 组件使用规范检查
- ✅ 主题配置和样式定制
- ✅ 组件使用问题诊断

## 进阶使用

### 组合使用建议

如果你的项目需要完整的开发能力，建议：

1. **使用 Wot Starter 配置** 作为基础
   - 包含页面/API/Store/路由等开发技能
   - 适合从零开始的项目

2. **叠加 Wot Design Uni User 配置**
   - 增强组件使用能力
   - 提供组件规范检查
   - 更好的组件使用体验

### 配置合并方法

将本配置的内容合并到你的 `.claude` 目录：

```
.claude/
├── skills/
│   ├── page-development/      # 来自 Wot Starter
│   ├── api-development/       # 来自 Wot Starter
│   └── usage/                 # 来自本配置 ⭐
│       ├── basic-component/
│       ├── form-component/
│       ├── feedback-component/
│       ├── layout-component/
│       └── navigation-component/
├── commands/
│   ├── /page                  # 来自 Wot Starter
│   ├── /api                   # 来自 Wot Starter
│   ├── /use-component         # 来自本配置 ⭐
│   ├── /theme-config          # 来自本配置 ⭐
│   └── /check-usage           # 来自本配置 ⭐
└── ...
```

## 参考资源

- [Wot Design Uni 官方文档](https://wot-ui.cn)
- [组件列表](https://wot-ui.cn/component)
- [快速上手](https://wot-ui.cn/guide/quick-use)
- [常见问题](https://wot-ui.cn/guide/common-problems)
- [GitHub 仓库](https://github.com/Moonofweisheng/wot-design-uni)

## 版本

- **wot-design-uni**: v1.14.0
- **配置版本**: v1.0.0
- **更新日期**: 2026-01-31

## 许可证

MIT License

---

**💡 提示：** 这是一个专注于**使用** Wot Design Uni 组件库的配置。如果你需要开发完整的 uni-app 应用，建议使用 Wot Starter 配置。
