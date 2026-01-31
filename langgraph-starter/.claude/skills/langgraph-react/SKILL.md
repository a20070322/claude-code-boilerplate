# LangGraph React Agent 技能

## 技能说明

本技能专门用于创建和管理基于 LangGraph 的 React Agent 应用。React Agent 是 LangGraph 中最常用的代理模式，能够动态决定使用哪些工具来完成任务。

## 使用场景

### 适用场景
- 需要构建智能对话代理
- 实现 ReAct (Reasoning + Acting) 模式
- 需要多轮推理和工具调用
- 构建问答系统或任务执行助手
- 需要动态决策流程

### 典型应用
- 聊天机器人
- 研究助手
- 数据分析助手
- 客服自动化
- 代码助手

## 代码模板

### 模板 1: 基础 React Agent

```python
from typing import Annotated, Literal, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.tools import tool
from langchain_core.messages import HumanMessage
from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.memory import MemorySaver

# 1. 定义状态
class AgentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]

# 2. 定义工具
@tool
def search(query: str) -> str:
    """搜索信息"""
    return "搜索结果: " + query

@tool
def calculator(expression: str) -> str:
    """计算数学表达式"""
    try:
        result = eval(expression)
        return f"结果: {result}"
    except:
        return "计算错误"

tools = [search, calculator]

# 3. 创建模型
model = ChatAnthropic(model="claude-3-5-sonnet-20241022")
model_with_tools = model.bind_tools(tools)

# 4. 定义节点函数
def should_continue(state: AgentState) -> Literal["tools", END]:
    messages = state["messages"]
    last_message = messages[-1]
    if last_message.tool_calls:
        return "tools"
    return END

def call_model(state: AgentState):
    messages = state["messages"]
    response = model_with_tools.invoke(messages)
    return {"messages": [response]}

# 5. 构建图
workflow = StateGraph(AgentState)

# 添加节点
workflow.add_node("agent", call_model)
workflow.add_node("tools", ToolNode(tools))

# 添加边
workflow.add_edge(START, "agent")
workflow.add_conditional_edges(
    "agent",
    should_continue,
)

# 6. 编译图（带记忆）
memory = MemorySaver()
app = workflow.compile(checkpointer=memory, interrupt_before=["tools"])

# 7. 运行
config = {"configurable": {"thread_id": "conversation-1"}}
result = app.invoke(
    {"messages": [HumanMessage(content="搜索最新 AI 新闻")]},
    config
)
print(result["messages"][-1].content)
```

### 模板 2: 带 System Prompt 的 React Agent

```python
from typing import Annotated, TypedDict
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_anthropic import ChatAnthropic
from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import ToolNode

# 定义状态
class AgentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]

# 定义 System Prompt
system_prompt = """你是一个专业的 AI 助手，擅长：
1. 搜索和分析信息
2. 进行数学计算
3. 提供清晰的解释

使用工具时，要明确说明你的意图和结果。"""

prompt = ChatPromptTemplate.from_messages([
    ("system", system_prompt),
    MessagesPlaceholder(variable_name="messages"),
])

# 创建模型
model = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)
model_with_prompt = prompt | model

# 定义节点
def call_model(state: AgentState):
    messages = state["messages"]
    response = model_with_prompt.invoke({"messages": messages})
    return {"messages": [response]}

# 构建图
workflow = StateGraph(AgentState)
workflow.add_node("agent", call_model)
workflow.add_node("tools", ToolNode(tools))
workflow.add_edge(START, "agent")
workflow.add_conditional_edges(
    "agent",
    lambda state: "tools" if state["messages"][-1].tool_calls else END
)

app = workflow.compile()
```

### 模板 3: 带历史记录的 React Agent

```python
from typing import Annotated, TypedDict
from langchain_anthropic import ChatAnthropic
from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.sqlite import SqliteSaver
from langgraph.prebuilt import ToolNode

class AgentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]
    user_id: str
    session_id: str

def create_agent(user_id: str, session_id: str):
    """创建带持久化的 Agent"""
    model = ChatAnthropic(model="claude-3-5-sonnet-20241022")
    model_with_tools = model.bind_tools(tools)

    def call_model(state: AgentState):
        messages = state["messages"]
        response = model_with_tools.invoke(messages)
        return {"messages": [response]}

    workflow = StateGraph(AgentState)
    workflow.add_node("agent", call_model)
    workflow.add_node("tools", ToolNode(tools))
    workflow.add_edge(START, "agent")
    workflow.add_conditional_edges(
        "agent",
        lambda state: "tools" if state["messages"][-1].tool_calls else END
    )

    # 使用 SQLite 持久化
    memory = SqliteSaver.from_conn_string("agent_memory.db")
    app = workflow.compile(checkpointer=memory)

    return app
```

## 禁止事项

1. **禁止跳过状态定义**: 必须明确定义 `AgentState`，不要使用隐式状态
2. **禁止在条件边中使用复杂逻辑**: 条件边应该简单明了，复杂逻辑放在节点函数中
3. **禁止忽略错误处理**: 工具调用可能失败，必须添加适当的错误处理
4. **禁止硬编码配置**: 使用环境变量或配置文件管理 API keys 和配置
5. **禁止缺少类型注解**: 所有函数参数和返回值必须有类型注解
6. **禁止在图中直接修改状态**: 状态更新必须通过返回新状态完成
7. **禁止忽略内存管理**: 长时间运行的 Agent 必须使用 checkpointer

## 检查清单

### 创建前检查
- [ ] 明确 Agent 的职责边界
- [ ] 列出需要的工具列表
- [ ] 设计状态结构
- [ ] 规划图的结构（节点和边）

### 代码实现检查
- [ ] 状态类型定义完整
- [ ] 所有节点函数有类型注解
- [ ] 工具函数有清晰的文档字符串
- [ ] 条件边逻辑清晰
- [ ] 添加了适当的错误处理
- [ ] 配置了 checkpointer（如需要）

### 测试检查
- [ ] 测试单轮对话
- [ ] 测试多轮对话
- [ ] 测试工具调用场景
- [ ] 测试边界条件
- [ ] 验证记忆功能正常

## 注意事项

### 状态管理
- 状态更新是累加的，不是替换的
- 使用 `Annotated` 定义状态的更新逻辑
- 复杂状态应该拆分为多个字段

### 工具设计
- 工具函数必须有清晰的文档字符串（用于模型理解）
- 工具参数必须有类型注解和默认值
- 工具应该快速返回，避免长时间阻塞
- 工具失败应该返回有意义的错误信息

### 条件边
- 条件边的返回值必须是字符串（节点名称）或 END
- 条件判断应该基于状态，不应该有副作用
- 多个条件分支使用 `add_conditional_edges`

### 性能优化
- 使用流式输出提升用户体验
- 合理设置超时时间
- 避免在节点中进行重量计算
- 考虑使用异步工具提升并发性能

### 安全考虑
- 验证工具输入参数
- 限制工具的访问权限
- 记录 Agent 的行为日志
- 实施速率限制

## 常见问题

**Q: 如何处理工具调用失败？**
A: 在工具函数中捕获异常，返回错误信息。Agent 会根据错误信息决定下一步行动。

**Q: 如何限制 Agent 的调用次数？**
A: 在状态中添加 `step_count` 字段，每次调用递增，使用条件边检查是否超过限制。

**Q: 如何添加人工审核？**
A: 使用 `interrupt_before` 参数在特定节点前中断，等待人工确认后继续。

**Q: 如何调试 Agent 行为？**
A: 使用 `debug=True` 编译图，或者添加日志节点记录中间状态。

## 相关资源

- [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
- [React Agent 指南](https://langchain-ai.github.io/langgraph/tutorials/react_agent/)
- [ToolNode 文档](https://langchain-ai.github.io/langgraph/reference/prebuilt/#toolnode)
