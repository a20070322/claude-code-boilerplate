/**
 * User Prompt Submit Hook
 * 强制技能评估流程 - 确保 AI 遵循项目规范
 */

export async function userPromptSubmit(context) {
  const { prompt } = context;

  // 如果是斜杠命令，直接放行
  if (prompt.trim().startsWith('/')) {
    return { proceed: true };
  }

  // 检查是否是代码相关任务
  const codeKeywords = [
    '创建', '生成', '写', '实现', '开发', '添加',
    '页面', '组件', 'API', 'Store', '路由', '状态',
    'page', 'component', 'api', 'store', 'router'
  ];

  const isCodeTask = codeKeywords.some(keyword =>
    prompt.toLowerCase().includes(keyword.toLowerCase())
  );

  if (!isCodeTask) {
    return { proceed: true };
  }

  // 自动激活相关技能，不阻止执行
  console.log('\n💡 检测到代码任务，AI 将自动使用相关技能');
  return { proceed: true };
}
