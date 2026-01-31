# LangGraph 多智能体协作技能

## 技能说明

本技能专注于使用 LangGraph 构建多智能体（Multi-Agent）系统，实现多个专业 Agent 的协作与分工。

## 使用场景

### 适用场景
- 需要多个专业领域协作的复杂任务
- 需要并行处理的独立任务
- 需要层次化决策的系统
- 需要角色分工的对话系统
- 需要审核和批准的流程

### 典型应用
- 研究团队：研究员 + 批评家 + 总结者
- 内容创作：写手 + 编辑 + 审核者
- 软件开发：产品经理 + 开发者 + 测试员
- 客户服务：客服 + 主管 + 专家
- 数据分析：数据分析师 + 报告生成器 + 审核者

## 代码模板

### 模板 1: 研究团队 Multi-Agent

```python
from typing import Annotated, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage, AIMessage
from langgraph.graph import StateGraph, START, END

# 定义共享状态
class TeamState(TypedDict):
    topic: str
    research: str
    critique: str
    final_report: str

# 创建模型
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")

# Agent 1: 研究员
def researcher(state: TeamState):
    """研究主题并生成报告"""
    topic = state["topic"]

    prompt = f"""你是一个专业的研究员。请对以下主题进行深入研究:
    {topic}

    提供详细的研究报告，包括:
    1. 背景信息
    2. 关键发现
    3. 数据和证据
    4. 结论和建议

    研究报告:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"research": response.content}

# Agent 2: 批评家
def critic(state: TeamState):
    """批评研究报告"""
    research = state["research"]

    prompt = f"""你是一个严格的批评家。请批评以下研究报告:
    {research}

    指出:
    1. 逻辑漏洞
    2. 缺失的信息
    3. 需要改进的地方
    4. 不准确或不可信的论点

    批评意见:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"critique": response.content}

# Agent 3: 总结者
def synthesizer(state: TeamState):
    """整合研究和批评，生成最终报告"""
    research = state["research"]
    critique = state["critique"]

    prompt = f"""你是报告总结者。请根据以下材料生成最终报告:

    原始研究:
    {research}

    批评意见:
    {critique}

    生成一份完善的最终报告，应该:
    1. 采纳原始研究的精华
    2. 回应批评意见中的合理建议
    3. 提供平衡和全面的视角
    4. 给出清晰的可操作建议

    最终报告:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"final_report": response.content}

# 构建图
workflow = StateGraph(TeamState)
workflow.add_node("researcher", researcher)
workflow.add_node("critic", critic)
workflow.add_node("synthesizer", synthesizer)

workflow.add_edge(START, "researcher")
workflow.add_edge("researcher", "critic")
workflow.add_edge("critic", "synthesizer")
workflow.add_edge("synthesizer", END)

team = workflow.compile()
```

### 模板 2: 层次化 Multi-Agent

```python
from typing import Annotated, Literal, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage
from langgraph.graph import StateGraph, START, END

class HierarchicalState(TypedDict):
    task: str
    analysis: str
    development: str
    testing: str
    approval: str
    final_result: str

llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")

# 管理者 Agent
def manager(state: HierarchicalState):
    """分配任务给合适的专家"""
    task = state["task"]

    prompt = f"""你是项目经理。分析以下任务并确定需要哪些专家:
    {task}

    请提供任务分析和计划:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"analysis": response.content}

# 开发者 Agent
def developer(state: HierarchicalState):
    """执行开发任务"""
    task = state["task"]
    analysis = state["analysis"]

    prompt = f"""你是开发者。根据项目分析完成开发任务:

    任务: {task}
    分析: {analysis}

    提供实现方案和代码:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"development": response.content}

# 测试员 Agent
def tester(state: HierarchicalState):
    """测试开发结果"""
    development = state["development"]

    prompt = f"""你是测试员。测试以下开发成果:
    {development}

    提供测试报告和反馈:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"testing": response.content}

# 审批者 Agent
def approver(state: HierarchicalState):
    """审批结果"""
    testing = state["testing"]

    prompt = f"""你是审批者。审批以下测试报告:
    {testing}

    决定是否通过 (通过/拒绝) 并说明原因:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"approval": response.content}

def should_iterate(state: HierarchicalState) -> Literal["iterate", END]:
    """判断是否需要重新开发"""
    approval = state["approval"].lower()
    if "通过" in approval or "approved" in approval:
        return END
    return "iterate"

def finalize(state: HierarchicalState):
    """生成最终结果"""
    return {"final_result": state["development"]}

# 构建图
workflow = StateGraph(HierarchicalState)
workflow.add_node("manager", manager)
workflow.add_node("developer", developer)
workflow.add_node("tester", tester)
workflow.add_node("approver", approver)
workflow.add_node("finalize", finalize)

workflow.add_edge(START, "manager")
workflow.add_edge("manager", "developer")
workflow.add_edge("developer", "tester")
workflow.add_edge("tester", "approver")
workflow.add_conditional_edges(
    "approver",
    should_iterate,
    {
        "iterate": "developer",
        END: "finalize"
    }
)

workflow.add_edge("finalize", END)

team = workflow.compile()
```

### 模板 3: 并行 Multi-Agent

```python
from typing import Annotated, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage
from langgraph.graph import StateGraph, START, END

class ParallelState(TypedDict):
    topic: str
    perspective1: str
    perspective2: str
    perspective3: str
    consensus: str

llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")

# 专家 1: 技术视角
def technical_expert(state: ParallelState):
    topic = state["topic"]

    prompt = f"""你是技术专家。从技术角度分析:
    {topic}

    提供技术分析和建议:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"perspective1": response.content}

# 专家 2: 商业视角
def business_expert(state: ParallelState):
    topic = state["topic"]

    prompt = f"""你是商业专家。从商业角度分析:
    {topic}

    提供商业分析和建议:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"perspective2": response.content}

# 专家 3: 用户体验视角
def ux_expert(state: ParallelState):
    topic = state["topic"]

    prompt = f"""你是 UX 专家。从用户体验角度分析:
    {topic}

    提供用户体验分析和建议:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"perspective3": response.content}

# 共识生成者
def consensus_builder(state: ParallelState):
    """整合多视角生成共识"""
    p1 = state["perspective1"]
    p2 = state["perspective2"]
    p3 = state["perspective3"]

    prompt = f"""整合以下三个视角，生成综合建议:

    技术视角:
    {p1}

    商业视角:
    {p2}

    用户体验视角:
    {p3}

    生成一个平衡各方关注点的综合建议:"""

    response = llm.invoke([HumanMessage(content=prompt)])
    return {"consensus": response.content}

# 构建图（并行执行）
workflow = StateGraph(ParallelState)
workflow.add_node("technical", technical_expert)
workflow.add_node("business", business_expert)
workflow.add_node("ux", ux_expert)
workflow.add_node("consensus", consensus_builder)

# 从 START 并行启动三个专家
workflow.add_edge(START, "technical")
workflow.add_edge(START, "business")
workflow.add_edge(START, "ux")

# 三个专家都完成后进入共识生成
workflow.add_edge("technical", "consensus")
workflow.add_edge("business", "consensus")
workflow.add_edge("ux", "consensus")
workflow.add_edge("consensus", END)

team = workflow.compile()
```

## 禁止事项

1. **禁止职责重叠**: 每个 Agent 应该有明确的职责边界
2. **禁止缺少协调**: 必须有机制协调多个 Agent 的行动
3. **禁止无限循环**: Agent 之间的协作必须有终止条件
4. **禁止状态混乱**: 共享状态必须清晰定义更新规则
5. **禁止忽略并行冲突**: 并行 Agent 可能产生冲突结果，需要解决机制
6. **禁止过度分工**: 过多 Agent 会增加复杂度和成本
7. **禁止缺少监控**: 必须监控每个 Agent 的行为和输出

## 检查清单

### 设计检查
- [ ] 明确每个 Agent 的职责
- [ ] 定义清晰的协作流程
- [ ] 设计合理的共享状态
- [ ] 规划终止条件
- [ ] 考虑冲突解决机制

### 实现检查
- [ ] 每个 Agent 独立可测试
- [ ] 状态更新逻辑清晰
- [ ] 添加了并发控制（如需要）
- [ ] 实现了错误处理
- [ ] 配置了适当的超时
- [ ] 添加了详细日志

### 测试检查
- [ ] 测试单个 Agent 行为
- [ ] 测试 Agent 间协作
- [ ] 测试并行执行场景
- [ ] 测试错误恢复
- [ ] 验证终止条件
- [ ] 性能测试

## 注意事项

### Agent 设计原则
- **单一职责**: 每个 Agent 只负责一个特定领域
- **明确接口**: Agent 之间通过状态通信，不要直接调用
- **独立测试**: 每个 Agent 应该可以独立测试
- **可替换性**: Agent 应该是可替换的模块

### 协作模式
- **顺序协作**: Agent 按顺序处理（适合有依赖关系的任务）
- **并行协作**: Agent 同时处理（适合独立任务）
- **层次协作**: 有管理者协调的协作（适合复杂任务）
- **循环协作**: Agent 之间反复迭代（适合需要优化的任务）

### 状态管理
- 共享状态应该最小化
- 使用 TypedDict 明确定义结构
- 明确状态更新规则（累加 vs 替换）
- 考虑状态的序列化和持久化

### 性能优化
- 并行执行独立任务
- 缓存重复计算
- 使用流式输出
- 限制 Agent 的响应长度

### 安全性
- 验证 Agent 输出
- 限制资源使用
- 实施访问控制
- 记录审计日志

## 常见问题

**Q: 应该使用多少个 Agent？**
A: 通常 3-5 个是合理的。过少无法体现分工优势，过多增加复杂度。

**Q: 如何处理 Agent 意见不一致？**
A: 添加仲裁者（Arbiter）Agent 或使用投票机制。

**Q: 并行 Agent 如何同步？**
A: LangGraph 会自动等待所有输入边都完成才执行节点。

**Q: 如何调试 Multi-Agent 系统？**
A: 为每个 Agent 添加详细日志，使用 `debug=True` 编译图，单独测试每个 Agent。

## 最佳实践

1. **从简单开始**: 先实现 2-3 个 Agent 的协作，再逐步扩展
2. **明确职责**: 每个 Agent 的职责应该在 System Prompt 中明确
3. **充分测试**: Multi-Agent 系统的交互复杂，需要充分测试
4. **添加监控**: 监控每个 Agent 的执行时间和资源使用
5. **考虑成本**: 多 Agent 系统的 API 调用成本较高
6. **优雅降级**: 某个 Agent 失败时系统仍能部分工作

## 进阶技巧

### 动态 Agent 选择
根据任务类型动态选择和组合 Agent。

### Agent 通信协议
定义标准化的 Agent 通信协议和消息格式。

### Agent 学习机制
让 Agent 从历史协作中学习改进。

### Human-in-the-Loop
在关键决策点添加人工干预。

## 相关资源

- [Multi-Agent 指南](https://langchain-ai.github.io/langgraph/tutorials/multi_agent/)
- [Agent 协作模式](https://langchain-ai.github.io/langgraph/concepts/multi_agent/)
- [构建 Multi-Agent 系统](https://langchain-ai.github.io/langgraph/how_to/multi_agent/)
