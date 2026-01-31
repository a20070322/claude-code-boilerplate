# LangGraph 项目配置

## 项目概述

本项目是一个 LangGraph 开发模板，提供了开箱即用的 LangGraph 应用开发配置和最佳实践。

LangGraph 是一个用于构建有状态、多参与者应用程序的框架，特别适合构建基于 LLM 的智能体和工作流。

## 技术栈说明

### 核心技术
- **LangGraph**: 状态图框架，用于构建复杂的工作流
- **LangChain**: LLM 应用框架，提供模型、工具等基础组件
- **Python 3.11+**: 主要开发语言
- **Anthropic Claude**: 推荐使用的 LLM 模型

### 依赖包
```python
# 核心依赖
langgraph>=0.2.0
langchain-core>=0.3.0
langchain-anthropic>=0.2.0

# 可选依赖
langgraph-checkpoint-postgres  # PostgreSQL 持久化
langgraph-checkpoint-redis     # Redis 持久化
```

## 核心规范

### 代码风格
- 遵循 PEP 8 规范
- 使用类型注解（Type Hints）
- 所有函数必须有文档字符串
- 使用有意义的变量名

### 状态管理规范
1. 所有状态必须继承 `TypedDict`
2. 列表字段必须使用 `Annotated` 定义更新逻辑
3. 避免在状态中存储大对象
4. 使用 Optional 标记可选字段

### 节点函数规范
1. 必须有类型注解
2. 参数类型必须与状态匹配
3. 返回值必须是字典
4. 不得直接修改输入状态
5. 必须处理异常

### 图构建规范
1. 使用 `StateGraph` 构建图
2. 明确定义所有节点和边
3. 条件边返回值必须是字符串或 END
4. 长时间运行的图必须使用 checkpointer

## 快捷命令

### /graph - 创建 LangGraph 图
```bash
/graph <图类型> <配置选项>
```

**图类型:**
- `react` - React Agent 图
- `multi-agent` - 多智能体协作图
- `sequential` - 顺序执行图
- `conditional` - 条件分支图
- `parallel` - 并行执行图

**示例:**
```bash
/graph react --tools --memory
/graph multi-agent --persistence sqlite
```

### /agent - 创建智能体
```bash
/agent <智能体类型> <配置选项>
```

**智能体类型:**
- `react` - ReAct 模式智能体
- `tool-calling` - 工具调用智能体
- `planning` - 规划执行智能体
- `reflection` - 反思优化智能体

**示例:**
```bash
/agent react --model claude-3-5-sonnet-20241022 --tools search,calculator
/agent planning --max-steps 5
```

### /state - 定义状态
```bash
/state <状态类型> <配置选项>
```

**状态类型:**
- `simple` - 简单状态
- `message` - 消息状态
- `complex` - 复杂状态
- `reducer` - 带 reducer 的状态
- `pydantic` - Pydantic 模型状态

**示例:**
```bash
/state message --fields "messages,user_id,session_id"
/state reducer --reducer custom
```

### /check-graph - 验证图配置
```bash
/check-graph <验证级别> <检查选项>
```

**验证级别:**
- `quick` - 快速检查
- `standard` - 标准检查（推荐）
- `thorough` - 彻底检查
- `strict` - 严格检查

**示例:**
```bash
/check-graph standard --all
/check-graph strict --state --nodes --edges
```

## 技能列表

### langgraph-react
**技能描述:** 创建和管理 React Agent

**使用场景:**
- 构建智能对话代理
- 实现 ReAct (Reasoning + Acting) 模式
- 需要多轮推理和工具调用

**调用方式:**
```
使用 langgraph-react 技能创建一个 React Agent
```

### langgraph-agent
**技能描述:** 开发各类智能体

**使用场景:**
- React Agent 开发
- 规划执行 Agent
- 反思优化 Agent

**调用方式:**
```
使用 langgraph-agent 技能设计一个规划 Agent
```

### langgraph-multi-agent
**技能描述:** 构建多智能体系统

**使用场景:**
- 多专业领域协作
- 并行任务处理
- 层次化决策系统

**调用方式:**
```
使用 langgraph-multi-agent 技能创建研究团队
```

### langgraph-state
**技能描述:** 状态管理

**使用场景:**
- 定义状态结构
- 实现 reducer
- 配置持久化

**调用方式:**
```
使用 langgraph-state 技能定义状态
```

## 开发流程

### 1. 创建新项目

```bash
# 使用 /graph 命令创建基础图
/graph react --tools --memory

# 使用 /agent 命令创建智能体
/agent react --model claude-3-5-sonnet-20241022

# 使用 /state 命令定义状态
/state message --fields "messages,user_id,session_id"
```

### 2. 开发节点

```python
def my_node(state: MyState) -> dict:
    """
    节点描述

    Args:
        state: 当前状态

    Returns:
        状态更新
    """
    try:
        # 处理逻辑
        result = process_data(state["input"])
        return {"output": result}
    except Exception as e:
        logger.error(f"处理失败: {e}")
        return {"error": str(e)}
```

### 3. 构建图

```python
from langgraph.graph import StateGraph, START, END

workflow = StateGraph(MyState)
workflow.add_node("node_a", node_a)
workflow.add_node("node_b", node_b)
workflow.add_edge(START, "node_a")
workflow.add_conditional_edges(
    "node_a",
    should_continue,
    {"continue": "node_b", END: END}
)
workflow.add_edge("node_b", END)

app = workflow.compile()
```

### 4. 验证配置

```bash
# 验证图配置
/check-graph standard --all

# 验证状态定义
/check-graph --state

# 验证节点函数
/check-graph --nodes
```

### 5. 测试

```python
# 测试图
def test_graph():
    app = workflow.compile()
    result = app.invoke({"input": "测试"})
    assert result["output"] is not None
```

### 6. 部署

```bash
# 最终验证
/check-graph strict --all

# 部署前检查清单
- [ ] 所有类型注解完整
- [ ] 错误处理已添加
- [ ] 日志记录已配置
- [ ] 性能已优化
- [ ] 安全已检查
- [ ] 测试已通过
```

## 代码检查清单

### 状态定义
- [ ] 继承自 TypedDict
- [ ] 所有字段有类型注解
- [ ] 列表字段使用 Annotated
- [ ] 可选字段使用 Optional
- [ ] 避免过度嵌套

### 节点函数
- [ ] 参数有类型注解
- [ ] 返回值有类型注解
- [ ] 有文档字符串
- [ ] 有错误处理
- [ ] 不直接修改输入状态
- [ ] 返回有效的状态更新

### 图构建
- [ ] 所有节点已添加
- [ ] START 连接正确
- [ ] 条件边返回值正确
- [ ] 没有孤立节点（除非有意）
- [ ] 没有无限循环
- [ ] 使用了 checkpointer（如需要）

### 工具函数
- [ ] 有清晰的文档字符串
- [ ] 参数有类型注解
- [ ] 有输入验证
- [ ] 有错误处理
- [ ] 返回类型正确

### 最佳实践
- [ ] 使用环境变量配置
- [ ] 添加了日志记录
- [ ] 实现了监控
- [ ] 配置了超时
- [ ] 添加了速率限制
- [ ] 实现了缓存

### 安全性
- [ ] API 密钥不硬编码
- [ ] 输入已验证
- [ ] 没有注入漏洞
- [ ] 敏感数据已加密
- [ ] 有访问控制

## 项目结构

```
langgraph-starter/
├── .claude/
│   ├── CLAUDE.md              # 项目配置（本文件）
│   ├── skills/                # 技能目录
│   │   ├── langgraph-react/
│   │   ├── langgraph-agent/
│   │   ├── langgraph-multi-agent/
│   │   └── langgraph-state/
│   ├── commands/              # 命令目录
│   │   ├── graph.md
│   │   ├── agent.md
│   │   ├── state.md
│   │   └── check-graph.md
│   └── agents/                # 代理目录
│       └── graph-reviewer/
├── graphs/                    # 图定义
│   ├── __init__.py
│   ├── react_agent.py
│   └── multi_agent.py
├── agents/                    # 智能体节点
│   ├── __init__.py
│   ├── researcher.py
│   └── critic.py
├── state/                     # 状态定义
│   ├── __init__.py
│   └── states.py
├── tools/                     # 工具函数
│   ├── __init__.py
│   └── common_tools.py
├── tests/                     # 测试文件
│   ├── __init__.py
│   └── test_graphs.py
├── requirements.txt           # 依赖列表
├── .env.example               # 环境变量示例
└── README.md                  # 项目说明
```

## 配置文件

### requirements.txt
```
langgraph>=0.2.0
langchain-core>=0.3.0
langchain-anthropic>=0.2.0
python-dotenv>=1.0.0
```

### .env.example
```bash
# Anthropic API
ANTHROPIC_API_KEY=your_api_key_here

# Model Configuration
DEFAULT_MODEL=claude-3-5-sonnet-20241022
MODEL_TEMPERATURE=0.7

# Checkpointer Configuration
CHECKPOINTER_TYPE=sqlite
DATABASE_URL=sqlite:///state.db

# Log Configuration
LOG_LEVEL=INFO
LOG_FILE=logs/langgraph.log
```

## 开发建议

### 1. 从简单开始
先创建简单的顺序图，理解基本概念后再逐步增加复杂度。

### 2. 充分测试
LangGraph 的行为可能难以预测，需要充分测试各种场景。

### 3. 使用可视化
使用 LangGraph 的可视化功能理解图的结构和执行流程。

### 4. 添加日志
详细的日志有助于调试和理解图的执行过程。

### 5. 限制资源
设置超时、步数限制等，防止无限循环或资源耗尽。

### 6. 人工干预
对关键决策点使用 `interrupt_before` 添加人工审核。

## 常见问题

### Q: 如何选择合适的图类型？
A:
- 简单流程 → Sequential
- 需要决策 → Conditional
- 需要并行 → Parallel
- 对话系统 → React Agent
- 复杂任务 → Multi-Agent

### Q: 状态应该是累加还是替换？
A:
- 消息历史 → 累加
- 当前状态 → 替换
- 计数器 → 累加
- 结果 → 替换

### Q: 如何防止无限循环？
A:
1. 在状态中添加 `step_count` 字段
2. 在条件边中检查步数限制
3. 使用 `interrupt_before` 中断执行

### Q: 如何调试图的执行？
A:
1. 使用 `debug=True` 编译图
2. 添加日志节点
3. 使用 `get_graph()` 可视化
4. 单独测试每个节点

## 相关资源

- [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
- [LangChain 文档](https://python.langchain.com/)
- [Anthropic Claude API](https://docs.anthropic.com/)
- [示例项目](https://github.com/langchain-ai/langgraph/tree/main/examples)

## 获取帮助

如遇问题，可以：
1. 查阅技能文档（`/skills` 目录）
2. 使用命令文档（`/commands` 目录）
3. 查看 [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
4. 在项目中提问

## 版本历史

- v1.0.0 - 初始版本
  - 基础技能和命令
  - 项目模板
  - 最佳实践指南
