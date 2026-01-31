---
name: langgraph-basic
description: LangGraph 基础图结构技能 - StateGraph、节点、边的基础用法
---

# LangGraph 基础图结构

## 使用场景

当需要实现以下功能时触发此技能：

- **基础图构建**: 创建简单的 StateGraph
- **节点定义**: 定义图中的处理节点
- **边连接**: 连接节点形成工作流
- **状态定义**: 定义图的 TypedDict 状态
- **简单流程**: 线性或条件分支的工作流

## 架构模式

### 基础图结构

```
┌─────────┐
│  Start  │
└────┬────┘
     │
     ▼
┌─────────┐
│  Node1  │
└────┬────┘
     │
     ▼
┌─────────┐
│  Node2  │
└────┬────┘
     │
     ▼
┌─────────┐
│   End   │
└─────────┘
```

## 代码模板

### 模板 1: 最简单的图

```python
from typing import TypedDict
from langgraph.graph import StateGraph, END

# 1. 定义状态
class GraphState(TypedDict):
    """图状态"""
    input: str
    output: str

# 2. 定义节点
def node_1(state: GraphState) -> GraphState:
    """节点 1"""
    print("节点 1 执行")
    return {"output": f"处理了: {state['input']}"}

def node_2(state: GraphState) -> GraphState:
    """节点 2"""
    print("节点 2 执行")
    return {"output": f"{state['output']} -> 完成"}

# 3. 构建图
workflow = StateGraph(GraphState)

# 添加节点
workflow.add_node("node1", node_1)
workflow.add_node("node2", node_2)

# 添加边
workflow.set_entry_point("node1")
workflow.add_edge("node1", "node2")
workflow.add_edge("node2", END)

# 4. 编译
app = workflow.compile()

# 5. 使用
if __name__ == "__main__":
    result = app.invoke({"input": "测试"})
    print(result)
```

### 模板 2: 带条件分支的图

```python
from typing import TypedDict, Literal
from langgraph.graph import StateGraph, END

class GraphState(TypedDict):
    """图状态"""
    value: int
    result: str

def process_node(state: GraphState) -> GraphState:
    """处理节点"""
    value = state["value"]
    print(f"处理值: {value}")
    return {}

def route_node(state: GraphState) -> Literal["positive", "negative"]:
    """路由节点"""
    value = state["value"]
    if value > 0:
        return "positive"
    else:
        return "negative"

def positive_node(state: GraphState) -> GraphState:
    """正值处理"""
    return {"result": "正值"}

def negative_node(state: GraphState) -> GraphState:
    """负值处理"""
    return {"result": "负值"}

# 构建图
workflow = StateGraph(GraphState)
workflow.add_node("process", process_node)
workflow.add_node("positive", positive_node)
workflow.add_node("negative", negative_node)

workflow.set_entry_point("process")

# 添加条件边
workflow.add_conditional_edges(
    "process",
    route_node,
    {
        "positive": "positive",
        "negative": "negative"
    }
)

workflow.add_edge("positive", END)
workflow.add_edge("negative", END)

app = workflow.compile()

# 使用
result = app.invoke({"value": 10})
print(result)  # {'value': 10, 'result': '正值'}
```

### 模板 3: 带多个状态的复杂图

```python
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage
from langgraph.graph import StateGraph, END
import operator

class ComplexState(TypedDict):
    """复杂状态"""
    messages: Annotated[Sequence[BaseMessage], operator.add]
    user_input: str
    processed: bool
    count: int

def input_node(state: ComplexState) -> ComplexState:
    """输入节点"""
    print(f"接收输入: {state['user_input']}")
    return {"processed": False}

def process_node(state: ComplexState) -> ComplexState:
    """处理节点"""
    print("处理中...")
    return {
        "processed": True,
        "count": state.get("count", 0) + 1
    }

def output_node(state: ComplexState) -> ComplexState:
    """输出节点"""
    print(f"处理完成，共处理 {state['count']} 次")
    return {}

# 构建图
workflow = StateGraph(ComplexState)
workflow.add_node("input", input_node)
workflow.add_node("process", process_node)
workflow.add_node("output", output_node)

workflow.set_entry_point("input")
workflow.add_edge("input", "process")
workflow.add_edge("process", "output")
workflow.add_edge("output", END)

app = workflow.compile()
```

## 禁止事项 ⭐重要

- ❌ **不要忘记状态类型注解**
  - 错误: `class GraphState: value: int`
  - 正确: `class GraphState(TypedDict): value: int`
  - 原因: 必须继承 TypedDict

- ❌ **不要在节点中修改状态**
  - 错误: `state["value"] = 10`
  - 正确: `return {"value": 10}`
  - 原因: LangGraph 需要不可变性

- ❌ **不要忽略边连接**
  - 错误: 添加节点后忘记连接边
  - 正确: 每个节点都要有入口和出口
  - 原因: 孤立节点无法执行

- ❌ **不要忘记编译**
  - 错误: 定义完图就使用
  - 正确: `app = workflow.compile()`
  - 原因: 必须编译后才能调用

- ❌ **不要混合使用边类型**
  - 错误: 同时使用 add_edge 和条件边
  - 正确: 明确使用一种边类型
  - 原因: 会导致图结构混乱

## 检查清单 ⭐重要

### 状态定义
- [ ] 是否继承 TypedDict？
- [ ] 所有字段是否有类型注解？
- [ ] Sequence 字段是否使用 operator.add？
- [ ] 字段命名是否清晰？

### 节点定义
- [ ] 节点函数是否接收 state？
- [ ] 是否返回状态字典？
- [ ] 是否没有修改原 state？
- [ ] 节点职责是否单一？

### 边定义
- [ ] 是否设置了入口点？
- [ ] 所有节点是否都连接？
- [ ] 条件边是否返回明确值？
- [ ] 是否有终止条件？

### 编译和使用
- [ ] 是否调用了 compile()？
- [ ] invoke 参数是否正确？
- [ ] 是否测试了基本流程？
- [ ] 是否打印了中间结果？

## 注意事项

### 1. 状态设计原则

**好的状态设计**：
```python
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage
import operator

class GoodState(TypedDict):
    # ✅ 使用 Annotated 和 operator.add
    messages: Annotated[Sequence[BaseMessage], operator.add]
    # ✅ 类型明确
    count: int
    # ✅ 字段命名清晰
    is_complete: bool
```

**不好的状态设计**：
```python
class BadState(TypedDict):
    # ❌ 缺少 operator.add
    messages: list
    # ❌ 类型不明确
    data: object
    # ❌ 命名模糊
    x: str
```

### 2. 节点设计原则

**好的节点**：
```python
def good_node(state: GraphState) -> GraphState:
    """✅ 职责单一"""
    value = state["value"]
    processed = value * 2
    return {"result": processed}
```

**不好的节点**：
```python
def bad_node(state: GraphState) -> GraphState:
    """❌ 职责过多"""
    # 处理数据
    result = state["value"] * 2

    # 还做了其他事
    print(result)

    # 还访问数据库
    db.save(result)

    return {"result": result}
```

### 3. 调试技巧

```python
# 打印图结构
from langgraph.graph import StateGraph

# 打印图的 Mermaid 表示
print(workflow.get_graph().print_ascii())

# 流式查看执行过程
for event in app.stream({"input": "test"}):
    print(f"节点: {event}")
    print(f"状态: {event[event.keys()[0]]}")
```

### 4. 常见模式

**线性流程**：
```python
workflow.add_edge("A", "B")
workflow.add_edge("B", "C")
workflow.add_edge("C", END)
```

**条件分支**：
```python
workflow.add_conditional_edges(
    "node",
    lambda x: "positive" if x["value"] > 0 else "negative",
    {
        "positive": "pos_node",
        "negative": "neg_node"
    }
)
```

**循环结构**：
```python
workflow.add_edge("process", "check")
workflow.add_conditional_edges(
    "check",
    lambda x: "continue" if x["done"] else END
)
```

## 参考资源

- [LangGraph 概念](https://langchain-ai.github.io/langgraph/concepts/)
- [StateGraph 文档](https://langchain-ai.github.io/langgraph/reference/graphs/#langgraph.graph.StateGraph)
- [低级指南](https://langchain-ai.github.io/langgraph/how-tos/#low-level)
- [示例代码](https://github.com/langchain-ai/langgraph/tree/main/examples)
