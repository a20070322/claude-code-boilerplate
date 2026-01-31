# LangGraph 智能体开发技能

## 技能说明

本技能专注于 LangGraph 中的各类智能体（Agent）开发模式，包括 React Agent、函数调用 Agent、规划执行 Agent 等多种模式。

## 使用场景

### 适用场景
- 构建任务型对话系统
- 实现复杂的多步骤任务
- 需要工具调用的智能助手
- 构建 ReAct (Reasoning + Acting) 系统
- 实现自主规划与执行

### 智能体类型选择
- **React Agent**: 需要推理+行动的场景
- **Function Calling**: 简单的工具调用
- **Planning Agent**: 复杂任务分解
- **Reflection Agent**: 需要自我反思和改进

## 代码模板

### 模板 1: 基础函数调用 Agent

```python
from typing import Annotated, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.tools import tool
from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import create_react_agent

# 定义工具
@tool
def get_weather(city: str) -> str:
    """获取指定城市的天气信息"""
    return f"{city} 今天晴天，温度 25°C"

@tool
def get_time(timezone: str) -> str:
    """获取指定时区的当前时间"""
    from datetime import datetime
    return f"当前时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"

tools = [get_weather, get_time]

# 创建模型
model = ChatAnthropic(model="claude-3-5-sonnet-20241022")

# 创建 React Agent
agent = create_react_agent(model, tools)

# 运行
response = agent.invoke({
    "messages": [("user", "北京现在天气怎么样？")]
})
print(response["messages"][-1].content)
```

### 模板 2: 规划-执行 Agent

```python
from typing import Annotated, List, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage, AIMessage
from langgraph.graph import StateGraph, START, END
from pydantic import BaseModel, Field

# 定义状态
class PlanState(TypedDict):
    task: str
    plan: List[str]
    executed_steps: List[str]
    result: str

# 定义规划模型
class Plan(BaseModel):
    steps: List[str] = Field(
        description="完成任务所需的步骤列表"
    )

# 创建模型
model = ChatAnthropic(model="claude-3-5-sonnet-20241022")
planner = model.with_structured_output(Plan)

def create_plan(state: PlanState):
    """创建执行计划"""
    task = state["task"]
    plan = planner.invoke(f"为以下任务创建执行计划: {task}")
    return {"plan": plan.steps}

def execute_step(state: PlanState):
    """执行当前步骤"""
    plan = state["plan"]
    executed = state["executed_steps"]

    if not executed:
        next_step = plan[0]
    else:
        next_idx = len(executed)
        if next_idx < len(plan):
            next_step = plan[next_idx]
        else:
            return {"result": "所有步骤已完成"}

    # 模拟执行
    result = f"已执行: {next_step}"
    return {"executed_steps": executed + [next_step], "result": result}

def should_continue(state: PlanState):
    """判断是否继续"""
    return "continue" if len(state["executed_steps"]) < len(state["plan"]) else END

# 构建图
workflow = StateGraph(PlanState)
workflow.add_node("planner", create_plan)
workflow.add_node("executor", execute_step)
workflow.add_edge(START, "planner")
workflow.add_edge("planner", "executor")
workflow.add_conditional_edges(
    "executor",
    should_continue,
    {
        "continue": "executor",
        END: END
    }
)

agent = workflow.compile()
```

### 模板 3: 反思 Agent (Reflection Agent)

```python
from typing import Annotated, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage, AIMessage
from langgraph.graph import StateGraph, START, END

class ReflectionState(TypedDict):
    task: str
    answer: str
    reflection: str
    iterations: int

# 创建模型
model = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0.7)

def generate_answer(state: ReflectionState):
    """生成答案"""
    task = state["task"]
    reflection = state.get("reflection", "")

    prompt = f"""任务: {task}

{f'之前的反思: {reflection}' if reflection else ''}

请提供你的答案:"""

    response = model.invoke([HumanMessage(content=prompt)])
    return {"answer": response.content, "iterations": state.get("iterations", 0) + 1}

def reflect(state: ReflectionState):
    """反思答案质量"""
    task = state["task"]
    answer = state["answer"]

    prompt = f"""任务: {task}
答案: {answer}

请反思这个答案:
1. 是否完整回答了问题？
2. 是否有改进空间？
3. 如果需要改进，应该如何改进？

反思:"""

    response = model.invoke([HumanMessage(content=prompt)])
    return {"reflection": response.content}

def should_continue(state: ReflectionState):
    """判断是否继续改进"""
    iterations = state.get("iterations", 0)
    max_iterations = 3

    if iterations >= max_iterations:
        return END

    reflection = state.get("reflection", "").lower()
    if "满意" in reflection or "不需要改进" in reflection:
        return END

    return "continue"

# 构建图
workflow = StateGraph(ReflectionState)
workflow.add_node("generate", generate_answer)
workflow.add_node("reflect", reflect)
workflow.add_edge(START, "generate")
workflow.add_edge("generate", "reflect")
workflow.add_conditional_edges(
    "reflect",
    should_continue,
    {
        "continue": "generate",
        END: END
    }
)

agent = workflow.compile()
```

## 禁止事项

1. **禁止混淆 Agent 类型**: 明确选择合适的 Agent 模式，不要混用
2. **禁止过度复杂化**: 简单任务不要使用复杂的多步骤 Agent
3. **禁止缺少停止条件**: Agent 必须有明确的终止条件
4. **禁止忽略迭代限制**: 反思类 Agent 必须限制最大迭代次数
5. **禁止硬编码工具列表**: 工具应该可配置和可扩展
6. **禁止缺少错误恢复**: Agent 应该能够从错误中恢复
7. **禁止不验证输出**: Agent 的输出应该进行验证和过滤

## 检查清单

### Agent 设计检查
- [ ] 明确 Agent 的职责和边界
- [ ] 选择合适的 Agent 类型
- [ ] 定义清晰的状态结构
- [ ] 设计合理的停止条件
- [ ] 规划错误处理策略

### 实现检查
- [ ] 状态类型定义完整
- [ ] 所有节点函数有类型注解
- [ ] 添加了迭代次数限制
- [ ] 实现了错误处理
- [ ] 配置了适当的超时
- [ ] 添加了日志记录

### 测试检查
- [ ] 测试正常执行路径
- [ ] 测试错误场景
- [ ] 测试边界条件
- [ ] 验证停止条件
- [ ] 测试多轮对话
- [ ] 性能测试

## 注意事项

### Agent 类型选择
- **React Agent**: 最通用，适合大多数场景
- **Planning Agent**: 适合复杂、多步骤任务
- **Reflection Agent**: 适合需要优化的生成任务
- **Multi-Agent**: 适合需要分工协作的复杂任务

### 状态设计
- 状态应该包含所有必要的信息
- 避免状态过于复杂
- 使用 TypedDict 定义清晰的结构
- 考虑状态的序列化和持久化

### 节点设计
- 每个节点应该只做一件事
- 节点函数应该是纯函数（无副作用）
- 使用类型注解提高可读性
- 添加文档字符串说明功能

### 边的设计
- 条件边应该简单清晰
- 避免复杂的条件逻辑
- 提供默认路径
- 考虑添加循环检测

### 性能优化
- 使用流式输出
- 实现并行执行
- 缓存重复计算
- 优化工具调用

### 安全性
- 验证所有输入
- 限制资源使用
- 实施访问控制
- 记录审计日志

## 常见问题

**Q: React Agent 和 Function Calling 有什么区别？**
A: React Agent 会进行推理（Reasoning）然后行动（Acting），而 Function Calling 更直接，适合简单的工具调用。

**Q: 如何防止 Agent 无限循环？**
A: 在状态中添加 `step_count` 字段，每次调用递增，使用条件边检查是否超过限制。

**Q: Reflection Agent 应该迭代多少次？**
A: 通常 2-3 次就够了。过多次数不会带来明显改进，反而增加成本。

**Q: 如何测试 Agent 的行为？**
A: 编写单元测试测试各个节点，编写集成测试测试完整流程，使用模拟工具进行测试。

## 最佳实践

1. **从简单开始**: 先实现基础功能，再逐步添加复杂特性
2. **充分测试**: Agent 的行为难以预测，需要充分测试
3. **添加日志**: 详细的日志有助于调试和理解 Agent 行为
4. **限制资源**: 设置超时、预算等限制防止失控
5. **人工干预**: 对重要决策添加人工审核节点
6. **持续监控**: 部署后持续监控 Agent 的表现

## 相关资源

- [LangGraph Agents 指南](https://langchain-ai.github.io/langgraph/tutorials/agentic_persona/)
- [Agent 类型比较](https://langchain-ai.github.io/langgraph/concepts/agentic_concepts/)
- [创建自定义 Agent](https://langchain-ai.github.io/langgraph/how_to/create_agent/)
