/**
 * Stop Hook
 * 在任务结束时生成总结报告
 */

export async function stop(context) {
  console.log('\n---\n');
  console.log('## 📋 任务完成总结\n');

  console.log('✅ **检查清单**:\n');
  console.log('- [ ] 代码符合 Wot Starter 规范');
  console.log('- [ ] 使用 UnoCSS 原子化样式');
  console.log('- [ ] API 使用 Alova 请求');
  console.log('- [ ] Store 符合 Pinia 规范');
  console.log('- [ ] 组件使用 wot-design-uni');
  console.log('- [ ] 路由使用 @wot-ui/router');
  console.log('- [ ] 已执行本地测试\n');

  console.log('📝 **建议操作**:\n');
  console.log('1. 使用 `@code-reviewer` 审查代码质量');
  console.log('2. 运行 `pnpm lint:fix` 修复代码风格');
  console.log('3. 运行 `pnpm type-check` 检查类型');
  console.log('4. 提交前测试各端功能\n');

  console.log('💡 **常用命令**:\n');
  console.log('```bash');
  console.log('pnpm dev:h5              # H5 开发');
  console.log('pnpm dev:mp-weixin       # 微信小程序开发');
  console.log('pnpm lint:fix            # 修复代码风格');
  console.log('pnpm type-check          # 类型检查');
  console.log('```\n');
}
