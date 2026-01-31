// 用户提示提交钩子 - 强制技能评估
export async function userPromptSubmit(context) {
  const { prompt } = context;

  // 如果是斜杠命令，直接放行
  if (prompt.trim().startsWith('/')) {
    return { proceed: true };
  }

  // 定义 LangGraph 开发相关的关键词
  const langgraphKeywords = [
    // 核心概念
    'graph', 'state', 'node', 'edge',
    'langgraph', 'stategraph',

    // 模式
    'react', 'agent', 'multi-agent', 'chain',
    'workflow', 'pipeline',

    // 组件
    'tool', 'toolnode', 'bind_tools',
    'messagenode', 'reduc',

    // 功能
    'conditional', 'checkpoint', 'memory',
    'stream', 'invoke', 'batch',

    // 应用场景
    'chatbot', 'assistant', 'workflow',
    'automation', 'agentic',

    // 相关
    'langchain', 'llm', 'tool calling',
    'reasoning', 'action'
  ];

  // 检查是否涉及 LangGraph 开发
  const hasLanggraphKeyword = langgraphKeywords.some(keyword =>
    prompt.toLowerCase().includes(keyword.toLowerCase())
  );

  // 如果涉及 LangGraph 开发，强制技能评估
  if (hasLanggraphKeyword) {
    return {
      proceed: false,
      message: `
## 指令:强制技能激活流程

### 步骤 1 - 技能评估
针对以下技能，请评估是否适用：

**基础图结构技能** (langgraph-basic)
- 是否涉及：StateGraph、节点定义、边连接

**ReAct 模式技能** (langgraph-react)
- 是否涉及：ReAct 循环、工具调用、多步推理

**Agent 模式技能** (langgraph-agent)
- 是否涉及：Agent 实现、工具绑定、决策循环

**多 Agent 系统技能** (langgraph-multi-agent)
- 是否涉及：多个 Agent、Agent 协作、子图

**状态管理技能** (langgraph-state)
- 是否涉及：状态定义、状态更新、状态传递

### 步骤 2 - 激活
如果任何技能为"是" → 立即激活对应技能
如果所有技能为"否" → 说明"无需 LangGraph 技能"并继续

### 步骤 3 - 实施任务
只有在步骤 2 完成后，才能开始实现。
      `
    };
  }

  // 其他任务直接放行
  return { proceed: true };
}
