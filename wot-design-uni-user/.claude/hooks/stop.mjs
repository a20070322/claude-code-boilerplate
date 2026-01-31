// 任务停止钩子 - 代码使用检查
export async function stop(context) {
  const { files, toolsUsed } = context;

  // 检查是否修改了 .vue 文件
  const vueFiles = files.filter(f => f.path.endsWith('.vue'));

  if (vueFiles.length > 0) {
    console.log(`
## 📋 Wot Design Uni 使用检查清单

### ✅ 组件引入检查
- [ ] 是否使用 easycom 自动引入 (wd-前缀)
- [ ] 是否在 pages.json 中配置 easycom
- [ ] 组件名称是否符合规范 (wd-component-name)

### ✅ 组件使用规范
- [ ] 是否查阅了官方文档示例
- [ ] 是否使用了正确的 Props 属性
- [ ] 是否正确处理了 Events 事件
- [ ] 是否使用了正确的 Slots 插槽

### ✅ 样式和主题
- [ ] 是否需要自定义主题变量
- [ ] 是否考虑了暗黑模式
- [ ] 是否使用了 CSS 变量覆盖样式

### ✅ 平台兼容性
- [ ] 是否测试了目标平台 (小程序/H5/APP)
- [ ] 是否注意了平台差异
- [ ] 是否使用了条件编译 (如需要)

### 📝 建议操作
1. 运行项目查看效果
2. 使用 @component-helper 检查组件使用
3. 查看 [官方文档](https://wot-ui.cn) 确认用法
4. 如有问题查看 [常见问题](https://wot-ui.cn/guide/common-problems)

### 🔗 快捷链接
- [组件文档](https://wot-ui.cn/component)
- [快速上手](https://wot-ui.cn/guide/quick-use)
- [主题定制](https://wot-ui.cn/guide/custom-theme)
    `);
  }
}
