// 会话启动钩子
export async function sessionStart(context) {
  const { git } = context;

  console.log(`
## 🎨 Wot Design Uni 使用助手已启动

**时间**: ${new Date().toLocaleString('zh-CN')}
**Git 分支**: \`${git.branch || 'main'}\`

📦 **当前项目**: 使用 Wot Design Uni 组件库的 uni-app 项目

💡 **可用命令**:
| /use-component | 使用组件 (查找/引入/配置) |
| /theme-config  | 主题配置 (颜色/暗黑模式/自定义) |
| /check-usage  | 检查使用规范 |

🎯 **核心技能**:
- usage-basic-component - 基础组件使用 (按钮/图标/单元格等)
- usage-form-component - 表单组件使用 (输入/选择/上传等)
- usage-feedback-component - 反馈组件使用 (弹窗/加载/提示等)
- usage-layout-component - 布局组件使用 (布局/分隔/卡片等)
- usage-navigation-component - 导航组件使用 (标签页/导航栏等)

📚 **文档资源**:
- [官方文档](https://wot-ui.cn)
- [组件列表](https://wot-ui.cn/component)
- [常见问题](https://wot-ui.cn/guide/common-problems)
- [更新日志](https://wot-ui.cn/guide/changelog)

⚠️ **重要提示**:
1. 所有组件都是 \`wd-\` 开头
2. 推荐配置 easycom 自动引入
3. 注意 sass 版本兼容性 (<1.78.0)
`);
}
