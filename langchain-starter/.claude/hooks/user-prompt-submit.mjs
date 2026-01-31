/**
 * 强制技能评估钩子 - 确保在写代码前评估相关技能
 */
export async function userPromptSubmit(context) {
  const prompt = (context.userPrompt || "").trim();

  // 如果是斜杠命令，放行
  if (prompt.startsWith("/")) {
    return { proceed: true };
  }

  // 如果是使用代理命令，放行
  if (prompt.startsWith("@")) {
    return { proceed: true };
  }

  // 检测是否是代码任务
  const codeTaskPatterns = [
    /创建|写|生成|构建|实现|开发/i,
    /chain|agent|prompt|retriever|memory/i,
    /链|智能体|代理|提示|检索|记忆/i,
    /langchain/i,
    /llm|chat/i,
  ];

  const isCodeTask = codeTaskPatterns.some(pattern => pattern.test(prompt));

  if (isCodeTask) {
    return {
      proceed: false,
      message: `
## 指令:强制技能激活流程(必须执行)

### 步骤 1 - 评估
针对以下每个技能,陈述: [技能名] - 是/否 - [理由]

可用技能列表:
- langchain-chain - 构建链
- langchain-agent - 开发智能体
- langchain-prompt - 管理提示模板
- langchain-retriever - 实现检索器
- langchain-memory - 配置记忆组件

### 步骤 2 - 激活
如果任何技能为"是" → 立即使用 Skill() 工具激活
如果所有技能为"否" → 说明"不需要技能"并继续

### 步骤 3 - 实现
只有在步骤 2 完成后,才能开始实现。
      `
    };
  }

  return { proceed: true };
}
