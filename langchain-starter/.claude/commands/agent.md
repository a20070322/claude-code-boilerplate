# /agent - 创建 LangChain 智能体

## 描述
创建一个 LangChain 智能体，支持 ReAct、工具调用等多种模式。智能体可以自主使用工具完成任务。

## 使用方法
```
/agent <智能体类型> [配置选项]
```

**智能体类型:**
- `tool-calling` - 工具调用智能体 (推荐)
- `react` - ReAct 模式智能体
- `planning` - 规划执行智能体

**配置选项:**
- `--tools <工具列表>` - 指定工具
- `--memory <记忆类型>` - 添加记忆
- `--max-steps <数量>` - 最大执行步数

**示例:**
```
/agent tool-calling --tools search,calculator
/agent react --memory conversation --max-steps 10
/agent planning --tools web_search,code_exec
```

## 执行步骤

### 步骤 1: 设计智能体
- [ ] 确定智能体类型
- [ ] 列出需要的工具
- [ ] 定义系统角色
- [ ] 设计执行流程

### 步骤 2: 创建工具
使用 langchain-agent 技能创建工具:
- [ ] 使用 @tool 装饰器
- [ ] 添加类型注解
- [ ] 编写详细描述
- [ ] 实现错误处理

### 步骤 3: 构建智能体
- [ ] 选择合适的 LLM
- [ ] 配置提示模板
- [ ] 创建智能体
- [ ] 配置执行器
- [ ] 设置限制参数

### 步骤 4: 添加记忆 (可选)
- [ ] 选择记忆类型
- [ ] 配置持久化
- [ ] 设置 session 管理

### 步骤 5: 测试验证
- [ ] 测试每个工具
- [ ] 测试简单任务
- [ ] 测试复杂任务
- [ ] 验证错误处理

### 步骤 6: 部署监控
- [ ] 添加日志记录
- [ ] 配置追踪
- [ ] 设置告警

## 示例执行

### 示例 1: 工具调用智能体
```python
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain.tools import tool

# 定义工具
@tool
def search(query: str) -> str:
    """搜索互联网信息"""
    return f"关于 {query} 的搜索结果"

@tool
def calculator(expression: str) -> str:
    """计算数学表达式"""
    try:
        result = eval(expression)
        return f"结果: {result}"
    except Exception as e:
        return f"错误: {e}"

tools = [search, calculator]

# 配置 LLM 和提示
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。"),
    ("placeholder", "{chat_history}"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建智能体
agent = create_tool_calling_agent(llm, tools, prompt)
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=10
)

# 运行
result = agent_executor.invoke({"input": "计算 123 * 456"})
```

### 示例 2: 带记忆的智能体
```python
from langchain.memory import ConversationBufferMemory
from langchain.agents import create_tool_calling_agent, AgentExecutor

# 添加记忆
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

# 多轮对话
result1 = agent_executor.invoke({"input": "搜索 LangChain"})
result2 = agent_executor.invoke({"input": "它的主要特点是什么?"})
```

## 注意事项

### 安全性
- [ ] 验证工具输入
- [ ] 限制危险操作
- [ ] 添加权限检查
- [ ] 记录审计日志

### 性能
- [ ] 限制执行步数
- [ ] 设置超时
- [ ] 使用异步工具
- [ ] 实现结果缓存

### 可靠性
- [ ] 启用错误处理
- [ ] 添加重试机制
- [ ] 实现回退策略
- [ ] 监控执行状态

### 工具设计原则
1. **单一职责** - 每个工具做一件事
2. **清晰描述** - 详细说明工具功能
3. **参数验证** - 验证输入有效性
4. **错误处理** - 返回有意义的错误

## 常见问题

**Q: 如何防止无限循环?**
A: 设置 `max_iterations` 参数

**Q: 如何调试智能体?**
A: 使用 `verbose=True` 查看详细输出

**Q: 如何限制工具使用?**
A: 在工具函数中添加权限检查

## 相关技能
- langchain-agent - 智能体开发核心技能
- langchain-prompt - 提示模板设计
- langchain-memory - 记忆组件配置
