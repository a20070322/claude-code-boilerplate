---
name: langchain-agent
description: 开发 LangChain 智能体
---

# LangChain 智能体开发技能

## 使用场景
- 构建对话式 AI 助手
- 实现工具调用 Agent
- 创建自主决策系统
- 开发多步骤任务执行

## 代码模板

### ReAct Agent
```python
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain.agents import create_react_agent, AgentExecutor
from langchain import hub

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义工具
from langchain.tools import Tool
from langchain_community.utilities import SerpAPIWrapper

search = SerpAPIWrapper()
search_tool = Tool(
    name="Search",
    func=search.run,
    description="用于搜索互联网信息"
)

tools = [search_tool]

# 获取提示模板
prompt = hub.pull("hwchase17/react")

# 创建 Agent
agent = create_react_agent(llm, tools, prompt)

# 创建 Agent 执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=5
)

# 运行
result = agent_executor.invoke({
    "input": "最新的人工智能发展动态是什么?"
})
```

### 工具调用 Agent (推荐)
```python
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain.tools import tool

# 定义工具
@tool
def calculator(expression: str) -> str:
    \"\"\"执行数学计算表达式\"\"\"
    try:
        result = eval(expression)
        return f"结果: {result}"
    except Exception as e:
        return f"计算错误: {e}"

@tool
def search(query: str) -> str:
    \"\"\"搜索信息\"\"\"
    # 实现搜索逻辑
    return f"关于 {query} 的搜索结果"

tools = [calculator, search]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义提示
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。使用可用的工具来回答问题。"),
    ("placeholder", "{chat_history}"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=10
)

# 运行
result = agent_executor.invoke({
    "input": "计算 123 * 456"
})
```

### 带记忆的 Agent
```python
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain.memory import ConversationBufferMemory
from langchain.tools import tool

# 定义工具
@tool
def get_weather(city: str) -> str:
    \"\"\"获取城市天气\"\"\"
    return f"{city} 今天晴朗，25°C"

tools = [get_weather]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 添加记忆
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。"),
    ("placeholder", "{chat_history}"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建带记忆的执行器
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True
)

agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    memory=memory,
    verbose=True
)

# 运行
result1 = agent_executor.invoke({"input": "北京天气怎么样?"})
result2 = agent_executor.invoke({"input": "那上海呢?"})
```

## 禁止事项 ⭐重要

- ❌ 不要使用 `AgentType` - 已弃用，使用 `create_tool_calling_agent`
- ❌ 不要使用 `initialize_agent` - 已弃用，使用新的 Agent API
- ❌ 不要让 Agent 无限循环 - 必须设置 `max_iterations`
- ❌ 不要忽略错误处理 - 必须设置 `handle_parsing_errors=True`
- ❌ 不要在工具函数中使用阻塞操作 - 使用异步

## 检查清单 ⭐重要

- [ ] 是否使用了新版 Agent API (create_tool_calling_agent)?
- [ ] 工具是否有清晰的描述?
- [ ] 工具参数是否有类型注解?
- [ ] 是否设置了 max_iterations?
- [ ] 是否启用了错误处理?
- [ ] 工具函数是否有文档字符串?
- [ ] 是否添加了记忆组件 (如需要)?
- [ ] 是否进行了安全验证?

## 注意事项

### 工具设计原则
1. **单一职责** - 每个工具只做一件事
2. **清晰描述** - 工具描述要详细准确
3. **类型安全** - 参数必须有类型注解
4. **错误处理** - 工具内部要处理异常

### Agent 安全性
```python
# 限制工具使用权限
from langchain.prebuilt import ToolExecutor

# 验证输入
@tool
def sensitive_operation(data: str) -> str:
    if not is_authorized(data):
        return "未授权操作"
    # 执行操作
```

### 性能优化
- 使用异步工具
- 批量处理请求
- 添加结果缓存
- 限制思考步数

### 调试 Agent
```python
# 使用 verbose=True 查看详细输出
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True  # 开启详细日志
)

# 查看中间步骤
result = agent_executor.invoke({"input": "..."})
print(result["intermediate_steps"])
```

## 最佳实践

1. **工具命名** - 使用清晰、描述性的工具名称
2. **工具描述** - 详细说明工具的用途和适用场景
3. **参数验证** - 验证工具输入的有效性
4. **返回格式** - 统一工具返回的数据格式
5. **错误恢复** - 提供有用的错误信息
6. **测试** - 单独测试每个工具
7. **监控** - 记录 Agent 的决策过程
