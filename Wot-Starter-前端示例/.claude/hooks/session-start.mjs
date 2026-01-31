/**
 * Session Start Hook
 * 在会话启动时执行，展示项目上下文
 */

export async function sessionStart(context) {
  const { cwd, git } = context;

  console.log('\n## 🚀 Wot Starter 前端项目会话已启动');
  console.log(`**时间**: ${new Date().toLocaleString('zh-CN')}`);

  try {
    // 获取 Git 信息
    const branch = await git.branch();
    console.log(`**Git 分支**: \`${branch}\`\n`);

    // 展示快捷命令
    console.log('💡 **快捷命令**:\n');
    console.log('| 命令 | 说明 |');
    console.log('|------|------|');
    console.log('| /page | 创建页面 (支持主包/分包) |');
    console.log('| /api | 创建 API 模块和 Mock |');
    console.log('| /store | 创建 Pinia Store |');
    console.log('| /component | 创建 Vue 组件 |');
    console.log('| /check | 代码规范检查 |\n');

    console.log('**核心技能**:\n');
    console.log('- 📄 uni-page-generator - 页面生成');
    console.log('- 🌐 alova-api-module - API 模块');
    console.log('- 📦 pinia-store-generator - 状态管理');
    console.log('- 🎨 vue-composable-creator - 组合式函数');
    console.log('- 🛣️ wot-router-usage - 路由导航');
    console.log('- 💬 global-feedback - 全局反馈\n');
  } catch (error) {
    console.log('⚠️ 无法获取 Git 信息');
  }

  console.log('---\n');
}
