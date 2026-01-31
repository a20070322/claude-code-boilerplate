# /page - 页面创建命令

## 描述
按照 Wot Starter 规范快速创建 uni-app 页面，支持主包和分包页面

## 使用方法
```
/page 创建用户设置页面
/page 添加订单详情页面到 subPages 分包
/page 创建带 TabBar 的首页
```

## 执行步骤

### 步骤 1: 确定页面类型
- [ ] 主包页面 (`src/pages/`)
- [ ] 分包页面 (`src/subPages/` 或其他分包)
- [ ] TabBar 页面 (使用 `layout: 'tabbar'`)

### 步骤 2: 激活技能
```
必须激活: uni-page-generator
可能需要: wot-router-usage, global-feedback
```

### 步骤 3: 生成页面代码
按照 `uni-page-generator` 技能规范生成：

```vue
<script setup lang="ts">
definePage({
  name: '页面名称',           // 路由 name，用于编程式导航
  layout: 'default',         // 布局：'default' | 'tabbar'
  style: {
    navigationBarTitleText: '页面标题',
  },
})

const router = useRouter()
</script>

<template>
  <view class="p-3">
    <!-- 页面内容 -->
  </view>
</template>
```

### 步骤 4: 配置路由
- [ ] 确认页面路径
- [ ] 如果是分包，在 `vite.config.ts` 中注册
- [ ] 使用 `useRouter()` 进行导航测试

### 步骤 5: 添加页面逻辑
- [ ] 引入必要的 API (使用 Alova)
- [ ] 引入 Store (使用 Pinia)
- [ ] 添加全局反馈 (使用 GlobalToast/Message)
- [ ] 使用 UnoCSS 样式

### 步骤 6: 测试验证
- [ ] 运行 `pnpm dev:h5` 或 `pnpm dev:mp-weixin`
- [ ] 测试页面跳转
- [ ] 测试路由导航
- [ ] 验证样式显示

## 示例执行

用户输入:
```
/page 创建用户个人中心页面，需要显示用户信息、订单列表、设置入口
```

AI 执行流程:
```
### 步骤 1: 确定页面类型
这是一个用户中心页面，应该是主包 TabBar 页面

### 步骤 2: 激活技能
激活 uni-page-generator 技能

### 步骤 3: 生成页面结构
创建: src/pages/profile/index.vue

### 步骤 4: 配置路由
definePage({
  name: 'profile',
  layout: 'tabbar',
  style: {
    navigationBarTitleText: '个人中心',
  },
})

### 步骤 5: 添加页面逻辑
- 引入 useUserStore 获取用户信息
- 引入 Alova API 获取订单列表
- 使用 wot-design-uni 组件渲染 UI
- 使用 UnoCSS 添加样式

### 步骤 6: 测试验证
[提供测试命令和验证步骤]
```

## 注意事项
1. 页面文件名固定为 `index.vue`
2. 分包目录需在 `vite.config.ts` 的 `subPackages` 中注册
3. TabBar 页面使用 `layout: 'tabbar'`
4. 必须使用 UnoCSS 原子化样式
5. 路由跳转使用 `useRouter()` 而不是 `uni.navigateTo()`
