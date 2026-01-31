# /agent - LangGraph 智能体创建命令

## 命令描述

`/agent` 命令用于创建和配置 LangGraph 智能体（Agent）。支持多种智能体类型，包括 React Agent、工具调用 Agent、规划 Agent 等。

## 使用方法

```
/agent <智能体类型> <配置选项>
```

### 智能体类型
- `react` - ReAct 模式智能体（推理+行动）
- `tool-calling` - 工具调用智能体
- `planning` - 规划执行智能体
- `reflection` - 反思优化智能体
- `custom` - 自定义智能体

### 配置选项
- `--model <模型>` - 指定 LLM 模型
- `--tools <工具列表>` - 添加工具
- `--system-prompt <提示词>` - 设置系统提示词
- `--temperature <温度>` - 设置温度参数
- `--max-steps <步数>` - 设置最大执行步数
- `--memory` - 启用记忆功能

## 执行步骤

### 步骤 1: 确认智能体类型
选择适合你需求的智能体类型：
```
1. React Agent - 最通用，适合对话和工具使用
2. Tool Calling - 简单工具调用
3. Planning - 复杂任务规划
4. Reflection - 需要优化的场景
```

### 步骤 2: 配置模型
选择或配置 LLM：
```python
from langchain_anthropic import ChatAnthropic

model = ChatAnthropic(
    model="claude-3-5-sonnet-20241022",
    temperature=0.7
)
```

### 步骤 3: 添加工具
定义智能体使用的工具：
```python
from langchain_core.tools import tool

@tool
def my_tool(param: str) -> str:
    """工具描述"""
    return f"结果: {param}"

tools = [my_tool]
```

### 步骤 4: 设置 System Prompt
定义智能体的行为和角色：
```python
system_prompt = """你是一个专业的 AI 助手。
你擅长使用工具来完成任务。
始终清晰解释你的行动。"""
```

### 步骤 5: 生成智能体代码
生成完整的智能体实现。

### 步骤 6: 创建测试用例
生成测试代码验证智能体功能。

## 示例执行

### 示例 1: 创建 React Agent

```bash
/agent react --model claude-3-5-sonnet-20241022 --tools search,calculator --memory
```

**生成的代码:**
```python
# agents/react_agent.py
from typing import Annotated, Literal, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.tools import tool
from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.memory import MemorySaver

class AgentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]

# 工具定义
@tool
def search(query: str) -> str:
    """搜索信息"""
    return f"搜索结果: {query}"

@tool
def calculator(expression: str) -> str:
    """计算数学表达式"""
    try:
        result = eval(expression)
        return f"结果: {result}"
    except:
        return "计算错误"

tools = [search, calculator]

# 模型配置
model = ChatAnthropic(
    model="claude-3-5-sonnet-20241022",
    temperature=0
)
model_with_tools = model.bind_tools(tools)

# 节点函数
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

# 构建图
workflow = StateGraph(AgentState)
workflow.add_node("agent", call_model)
workflow.add_node("tools", ToolNode(tools))
workflow.add_edge(START, "agent")
workflow.add_conditional_edges("agent", should_continue)

memory = MemorySaver()
app = workflow.compile(checkpointer=memory)
```

### 示例 2: 创建规划 Agent

```bash
/agent planning --max-steps 5 --system-prompt "你是项目规划专家"
```

**生成的代码:**
```python
# agents/planning_agent.py
from typing import Annotated, List, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage
from langgraph.graph import StateGraph, START, END
from pydantic import BaseModel, Field

class PlanState(TypedDict):
    task: str
    plan: List[str]
    executed_steps: List[str]
    step_count: int

class Plan(BaseModel):
    steps: List[str] = Field(description="执行步骤")

model = ChatAnthropic(model="claude-3-5-sonnet-20241022")
planner = model.with_structured_output(Plan)

def create_plan(state: PlanState):
    plan = planner.invoke(f"为任务创建计划: {state['task']}")
    return {"plan": plan.steps}

def execute_step(state: PlanState):
    # 执行逻辑
    step = state["plan"][len(state["executed_steps"])]
    return {
        "executed_steps": state["executed_steps"] + [step],
        "step_count": state["step_count"] + 1
    }

def should_continue(state: PlanState):
    if state["step_count"] >= 5:
        return END
    return "continue" if len(state["executed_steps"]) < len(state["plan"]) else END

workflow = StateGraph(PlanState)
workflow.add_node("planner", create_plan)
workflow.add_node("executor", execute_step)
workflow.add_edge(START, "planner")
workflow.add_edge("planner", "executor")
workflow.add_conditional_edges("executor", should_continue)
```

### 示例 3: 创建反思 Agent

```bash
/agent reflection --max-steps 3 --temperature 0.7
```

**生成的代码:**
```python
# agents/reflection_agent.py
from typing import Annotated, Literal, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage
from langgraph.graph import StateGraph, START, END

class ReflectionState(TypedDict):
    task: str
    answer: str
    reflection: str
    iterations: int

model = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0.7)

def generate_answer(state: ReflectionState):
    prompt = f"任务: {state['task']}\n{state.get('reflection', '')}"
    response = model.invoke([HumanMessage(content=prompt)])
    return {"answer": response.content, "iterations": state["iterations"] + 1}

def reflect(state: ReflectionState):
    prompt = f"任务: {state['task']}\n答案: {state['answer']}\n请反思:"
    response = model.invoke([HumanMessage(content=prompt)])
    return {"reflection": response.content}

def should_continue(state: ReflectionState) -> Literal["continue", END]:
    if state["iterations"] >= 3:
        return END
    if "满意" in state.get("reflection", ""):
        return END
    return "continue"

workflow = StateGraph(ReflectionState)
workflow.add_node("generate", generate_answer)
workflow.add_node("reflect", reflect)
workflow.add_edge(START, "generate")
workflow.add_edge("generate", "reflect")
workflow.add_conditional_edges("reflect", should_continue)
```

## 注意事项

### 工具设计
- 工具必须有清晰的文档字符串
- 参数必须有类型注解和描述
- 工具应该快速返回
- 添加适当的错误处理

### System Prompt
- 明确智能体的角色和职责
- 指定工具使用规范
- 设置输出格式要求
- 定义边界和安全规则

### 温度设置
- `0.0 - 0.3`: 确定性任务（代码、计算）
- `0.4 - 0.7`: 创造性任务（写作、头脑风暴）
- `0.8 - 1.0`: 高度创造性（创意写作）

### 步数限制
- React Agent: 通常 10-20 步
- Planning Agent: 根据任务复杂度，通常 5-10 步
- Reflection Agent: 2-4 次迭代即可

### 记忆管理
- 使用 `thread_id` 标识会话
- 定期清理过期记忆
- 考虑记忆大小限制

## 智能体最佳实践

### 1. 选择合适的智能体类型
- **简单工具调用**: Tool Calling Agent
- **需要推理**: React Agent
- **复杂任务**: Planning Agent
- **需要优化**: Reflection Agent

### 2. 工具组织
- 按功能分组工具
- 提供清晰的工具描述
- 限制单次工具调用数量
- 处理工具失败场景

### 3. 错误处理
```python
@tool
def safe_tool(input: str) -> str:
    try:
        # 工具逻辑
        return result
    except Exception as e:
        return f"错误: {str(e)}"
```

### 4. 性能优化
- 使用流式输出
- 批量处理工具调用
- 缓存重复查询
- 设置合理的超时

## 故障排除

### 问题 1: 智能体不使用工具
**原因:** 工具描述不清晰或 System Prompt 不明确
**解决:** 改进工具文档，调整提示词

### 问题 2: 智能体陷入循环
**原因:** 缺少停止条件
**解决:** 添加 `max_steps` 限制

### 问题 3: 工具调用失败
**原因:** 参数类型不匹配
**解决:** 检查工具参数的类型注解

### 问题 4: 记忆不生效
**原因:** thread_id 不一致
**解决:** 确保使用相同的 config

## 高级用法

### 动态工具选择
```python
def get_tools(context: str) -> list:
    if "代码" in context:
        return [code_executor]
    elif "搜索" in context:
        return [search_tool]
    return []
```

### 工具链
```python
@tool
def tool_chain(input: str) -> str:
    # 调用多个工具
    result1 = tool_a.invoke(input)
    result2 = tool_b.invoke(result1)
    return result2
```

### 人工审核
```python
# 在关键节点前中断
app = workflow.compile(
    checkpointer=memory,
    interrupt_before=["critical_action"]
)
```

## 相关命令

- `/graph` - 创建完整的图结构
- `/state` - 定义状态
- `/check-graph` - 验证配置

## 相关资源

- [Agent 指南](https://langchain-ai.github.io/langgraph/tutorials/agent_executor/)
- [React Agent](https://langchain-ai.github.io/langgraph/tutorials/react_agent/)
