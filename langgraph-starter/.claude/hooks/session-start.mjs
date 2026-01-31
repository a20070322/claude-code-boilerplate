// 会话启动钩子
export async function sessionStart(context) {
  const { git } = context;

  console.log(`
## 🔄 LangGraph 开发助手已启动

**时间**: ${new Date().toLocaleString('zh-CN')}
**Git 分支**: \`${git.branch || 'main'}\`

📦 **当前项目**: LangGraph 应用开发

💡 **可用命令**:
| /graph      | 创建 LangGraph（图结构/节点/边）|
| /agent      | 创建 Agent（智能体模式）|
| /state      | 状态管理（状态定义/更新/传递）|
| /check-graph| 检查图结构（验证/优化/调试）|

🎯 **核心技能**:
- langgraph-basic - 基础图结构（StateGraph/节点/边）
- langgraph-react - ReAct 模式（推理+行动循环）
- langgraph-agent - Agent 模式（工具调用/决策）
- langgraph-multi-agent - 多 Agent 系统（协作/通信）
- langgraph-state - 状态管理（TypedDict/Reducer）

📚 **LangGraph 资源**:
- [官方文档](https://langchain-ai.github.io/langgraph/)
- [教程](https://langchain-ai.github.io/langgraph/tutorials/)
- [API 参考](https://langchain-ai.github.io/langgraph/reference/)
- [示例](https://github.com/langchain-ai/langgraph/tree/main/examples)

⚠️ **重要提示**:
1. 总是使用 TypedDict 定义状态
2. 状态字段必须使用 Annotated 和 operator.add
3. 节点函数返回新状态，不要修改原状态
4. 使用 bind_tools() 绑定工具到 LLM
`);
}
