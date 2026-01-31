# LangGraph Starter Template

一个开箱即用的 LangGraph 应用开发模板，提供完整的配置、技能和最佳实践。

## 简介

LangGraph 是一个用于构建有状态、多参与者应用程序的框架，特别适合构建基于 LLM 的智能体和工作流。本模板提供了：

- 🚀 快速启动的项目结构
- 📚 丰富的开发技能和命令
- ✅ 完整的最佳实践指南
- 🔍 自动化的配置验证
- 🎯 开箱即用的代码模板

## 技术栈

- **Python**: 3.11+
- **LangGraph**: >=0.2.0
- **LangChain**: >=0.3.0
- **Anthropic Claude**: 推荐的 LLM 模型

## 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 文件，添加你的 API 密钥
```

### 3. 创建你的第一个图

使用 Claude Code 的 `/graph` 命令：

```
/graph react --tools --memory
```

### 4. 验证配置

```
/check-graph standard --all
```

## 项目结构

```
langgraph-starter/
├── .claude/              # Claude Code 配置
│   ├── CLAUDE.md         # 项目规范
│   ├── skills/           # 开发技能
│   ├── commands/         # 快捷命令
│   └── agents/           # 代理配置
├── graphs/               # 图定义
├── agents/               # 智能体节点
├── state/                # 状态定义
├── tools/                # 工具函数
├── tests/                # 测试文件
└── requirements.txt      # 依赖列表
```

## 核心功能

### 技能 (Skills)

#### langgraph-react
创建和管理 React Agent（推理+行动模式）

**使用场景:**
- 智能对话系统
- 多轮工具调用
- 任务执行助手

#### langgraph-agent
开发各类智能体

**支持类型:**
- React Agent
- 工具调用 Agent
- 规划执行 Agent
- 反思优化 Agent

#### langgraph-multi-agent
构建多智能体协作系统

**应用场景:**
- 专业团队协作
- 并行任务处理
- 层次化决策

#### langgraph-state
状态管理

**功能:**
- 状态定义
- Reducer 实现
- 持久化配置

### 命令 (Commands)

#### /graph
创建 LangGraph 图结构

```bash
/graph <图类型> <配置选项>
```

**示例:**
```bash
/graph react --tools --memory
/graph multi-agent --persistence sqlite
```

#### /agent
创建智能体

```bash
/agent <智能体类型> <配置选项>
```

**示例:**
```bash
/agent react --model claude-3-5-sonnet-20241022
/agent planning --max-steps 5
```

#### /state
定义状态

```bash
/state <状态类型> <配置选项>
```

**示例:**
```bash
/state message --fields "messages,user_id,session_id"
/state reducer --reducer custom
```

#### /check-graph
验证配置

```bash
/check-graph <验证级别> <检查选项>
```

**示例:**
```bash
/check-graph standard --all
/check-graph strict --state --nodes
```

## 代码示例

### 创建 React Agent

```python
from typing import Annotated, Literal, TypedDict
from langchain_anthropic import ChatAnthropic
from langchain_core.tools import tool
from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import ToolNode

class AgentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]

@tool
def search(query: str) -> str:
    """搜索信息"""
    return f"搜索结果: {query}"

model = ChatAnthropic(model="claude-3-5-sonnet-20241022")
model_with_tools = model.bind_tools([search])

def call_model(state: AgentState):
    response = model_with_tools.invoke(state["messages"])
    return {"messages": [response]}

def should_continue(state: AgentState) -> Literal["tools", END]:
    if state["messages"][-1].tool_calls:
        return "tools"
    return END

workflow = StateGraph(AgentState)
workflow.add_node("agent", call_model)
workflow.add_node("tools", ToolNode([search]))
workflow.add_edge(START, "agent")
workflow.add_conditional_edges("agent", should_continue)

app = workflow.compile()
```

### 创建多智能体系统

```python
from typing import TypedDict
from langchain_anthropic import ChatAnthropic
from langgraph.graph import StateGraph, START, END

class TeamState(TypedDict):
    topic: str
    research: str
    critique: str
    final_report: str

llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")

def researcher(state: TeamState):
    response = llm.invoke(f"研究: {state['topic']}")
    return {"research": response.content}

def critic(state: TeamState):
    response = llm.invoke(f"批评: {state['research']}")
    return {"critique": response.content}

def synthesizer(state: TeamState):
    response = llm.invoke(f"综合: {state['research']} + {state['critique']}")
    return {"final_report": response.content}

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

## 最佳实践

### 1. 状态管理
- 使用 TypedDict 定义状态
- 为列表字段指定更新逻辑
- 避免在状态中存储大对象

### 2. 节点设计
- 保持节点函数简单
- 添加类型注解
- 处理异常情况

### 3. 图构建
- 明确定义所有节点和边
- 条件边返回字符串或 END
- 使用 checkpointer 持久化状态

### 4. 测试
- 单独测试每个节点
- 测试完整的执行流程
- 验证边界条件

## 开发流程

1. **规划**: 确定图的结构和节点
2. **创建**: 使用 `/graph` 命令创建基础结构
3. **实现**: 实现节点函数和工具
4. **验证**: 使用 `/check-graph` 验证配置
5. **测试**: 编写并运行测试
6. **部署**: 部署到生产环境

## 配置验证

使用 `/check-graph` 命令验证配置：

```bash
# 快速检查
/check-graph quick

# 标准检查（推荐）
/check-graph standard --all

# 严格检查
/check-graph strict --all
```

检查项目包括：
- ✅ 状态定义完整性
- ✅ 节点函数类型注解
- ✅ 边连接正确性
- ✅ 错误处理
- ✅ 最佳实践

## 故障排除

### 常见问题

**Q: 图无法编译**
A: 检查节点函数的返回值是否是字典，键是否在状态中定义

**Q: 状态更新不生效**
A: 确认返回的字典键名与状态定义一致

**Q: 无限循环**
A: 添加步数计数器，在条件边中检查限制

**Q: 工具调用失败**
A: 检查工具参数类型，添加错误处理

### 调试技巧

1. 使用 `debug=True` 编译图
2. 添加日志节点
3. 可视化图结构
4. 单独测试节点

## 相关资源

- [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
- [LangChain 文档](https://python.langchain.com/)
- [Anthropic Claude API](https://docs.anthropic.com/)
- [示例项目](https://github.com/langchain-ai/langgraph/tree/main/examples)

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 联系方式

如有问题或建议，请通过 GitHub Issues 联系。

---

**Happy Coding with LangGraph! 🚀**
