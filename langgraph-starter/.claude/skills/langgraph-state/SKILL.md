# LangGraph 状态管理技能

## 技能说明

本技能专注于 LangGraph 中的状态管理，包括状态定义、状态更新、状态持久化等核心概念。

## 使用场景

### 适用场景
- 需要在多个节点间共享数据
- 需要保持对话历史
- 需要持久化状态
- 需要复杂的更新逻辑
- 需要处理并发更新

### 状态类型
- **简单状态**: 基本类型（字符串、数字等）
- **列表状态**: 消息列表等可累加数据
- **嵌套状态**: 复杂的嵌套结构
- **可选状态**: 使用 Optional 的可选字段

## 代码模板

### 模板 1: 基础状态管理

```python
from typing import Annotated, TypedDict
from langgraph.graph import StateGraph, START, END

# 定义状态
class GraphState(TypedDict):
    # 字符串字段
    query: str
    # 列表字段（带累加逻辑）
    messages: Annotated[list, lambda x, y: x + y]
    # 可选字段
    result: str | None
    # 计数器
    step_count: int

def node_a(state: GraphState):
    """节点 A"""
    query = state["query"]
    return {
        "messages": [f"处理查询: {query}"],
        "step_count": state.get("step_count", 0) + 1
    }

def node_b(state: GraphState):
    """节点 B"""
    messages = state["messages"]
    last_message = messages[-1]
    return {
        "result": f"最终结果: {last_message}",
        "step_count": state["step_count"] + 1
    }

# 构建图
workflow = StateGraph(GraphState)
workflow.add_node("node_a", node_a)
workflow.add_node("node_b", node_b)
workflow.add_edge(START, "node_a")
workflow.add_edge("node_a", "node_b")
workflow.add_edge("node_b", END)

app = workflow.compile()
```

### 模板 2: 复杂状态更新

```python
from typing import Annotated, TypedDict, List
from operator import add
from langgraph.graph import StateGraph, START, END

class ComplexState(TypedDict):
    # 列表累加
    messages: Annotated[List[str], add]
    # 自定义更新逻辑
    findings: Annotated[List[dict], lambda x, y: x + y]
    # 条件更新
    approved: bool
    # 嵌套结构
    metadata: dict

def update_findings(state: ComplexState):
    """更新发现列表"""
    new_finding = {
        "step": len(state["findings"]) + 1,
        "content": "新发现",
        "timestamp": "2024-01-01"
    }
    return {
        "findings": [new_finding],
        "messages": [f"添加发现 {new_finding['step']}"]
    }

def conditional_update(state: ComplexState):
    """条件性更新"""
    if state["approved"]:
        return {
            "messages": ["已批准"],
            "metadata": {"status": "completed"}
        }
    else:
        return {
            "messages": ["需要审批"],
            "metadata": {"status": "pending"}
        }

workflow = StateGraph(ComplexState)
workflow.add_node("update", update_findings)
workflow.add_node("conditional", conditional_update)
workflow.add_edge(START, "update")
workflow.add_edge("update", "conditional")
workflow.add_edge("conditional", END)

app = workflow.compile()
```

### 模板 3: 带持久化的状态管理

```python
from typing import Annotated, TypedDict
from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.sqlite import SqliteSaver
from langgraph.checkpoint.memory import MemorySaver

class PersistentState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]
    user_id: str
    session_id: str
    context: dict

def process_with_memory(state: PersistentState):
    """处理并更新状态（会持久化）"""
    messages = state["messages"]
    user_id = state["user_id"]

    # 可以访问历史状态
    context = state.get("context", {})

    new_message = f"为用户 {user_id} 处理消息"
    return {
        "messages": [new_message],
        "context": {**context, "last_action": new_message}
    }

# 使用 SQLite 持久化
checkpointer = SqliteSaver.from_conn_string("state.db")

workflow = StateGraph(PersistentState)
workflow.add_node("process", process_with_memory)
workflow.add_edge(START, "process")
workflow.add_edge("process", END)

# 编译时添加 checkpointer
app = workflow.compile(checkpointer=checkpointer)

# 运行时指定 thread_id
config = {"configurable": {"thread_id": "user-123"}}
result = app.invoke(
    {
        "messages": ["你好"],
        "user_id": "user-123",
        "session_id": "session-1"
    },
    config
)

# 后续可以继续这个会话
result2 = app.invoke(
    {"messages": ["你好"]},
    config  # 相同的 config 会恢复之前的状态
)
```

### 模板 4: 状态 reducer 模式

```python
from typing import Annotated, TypedDict, List
from operator import add
from langgraph.graph import StateGraph, START, END

# 定义 reducer 函数
def merge_findings(existing: List[dict], new: List[dict]) -> List[dict]:
    """合并发现列表，去重"""
    existing_ids = {f["id"] for f in existing}
    merged = existing.copy()

    for item in new:
        if item["id"] not in existing_ids:
            merged.append(item)
        else:
            # 更新已存在的项
            for i, existing_item in enumerate(merged):
                if existing_item["id"] == item["id"]:
                    merged[i] = item
                    break

    return merged

def append_unique(existing: List[str], new: List[str]) -> List[str]:
    """追加唯一字符串"""
    return existing + [x for x in new if x not in existing]

class ReducerState(TypedDict):
    # 使用预定义的 add reducer
    counter: Annotated[int, add]
    messages: Annotated[List[str], add]
    # 使用自定义 reducer
    findings: Annotated[List[dict], merge_findings]
    tags: Annotated[List[str], append_unique]
    # 替换模式（默认）
    current_status: str

def node_with_reducer(state: ReducerState):
    """使用 reducer 的节点"""
    return {
        "counter": 1,
        "messages": ["新消息"],
        "findings": [{"id": 1, "content": "发现1"}],
        "tags": ["important"],
        "current_status": "processing"
    }

workflow = StateGraph(ReducerState)
workflow.add_node("process", node_with_reducer)
workflow.add_edge(START, "process")
workflow.add_edge("process", END)

app = workflow.compile()
```

### 模板 5: 使用 Pydantic 模型

```python
from typing import Annotated, List
from pydantic import BaseModel, Field
from langgraph.graph import StateGraph, START, END

# 定义 Pydantic 模型
class Message(BaseModel):
    role: str = Field(description="消息角色")
    content: str = Field(description="消息内容")
    timestamp: str = Field(description="时间戳")

class AnalysisResult(BaseModel):
    score: float = Field(description="分析分数")
    insights: List[str] = Field(description="洞察列表")
    confidence: float = Field(description="置信度")

class TypedState(TypedDict):
    messages: Annotated[List[Message], lambda x, y: x + y]
    analysis: AnalysisResult | None
    status: str

def process_typed(state: TypedState):
    """处理类型化状态"""
    new_message = Message(
        role="assistant",
        content="回复内容",
        timestamp="2024-01-01T00:00:00"
    )

    new_analysis = AnalysisResult(
        score=0.85,
        insights=["洞察1", "洞察2"],
        confidence=0.9
    )

    return {
        "messages": [new_message],
        "analysis": new_analysis,
        "status": "completed"
    }

workflow = StateGraph(TypedState)
workflow.add_node("process", process_typed)
workflow.add_edge(START, "process")
workflow.add_edge("process", END)

app = workflow.compile()
```

## 禁止事项

1. **禁止直接修改状态**: 必须通过返回新状态来更新
2. **禁止混合更新逻辑**: 同一字段只能有一种更新方式
3. **禁止忽略类型注解**: 所有状态字段必须有明确的类型
4. **禁止过度嵌套**: 过深的嵌套会使状态难以管理
5. **禁止在状态中存储大对象**: 状态应该保持精简
6. **禁止缺少默认值处理**: 访问状态时应该处理字段不存在的情况
7. **禁止在 reducer 中产生副作用**: reducer 应该是纯函数

## 检查清单

### 状态设计检查
- [ ] 所有字段有明确的类型注解
- [ ] 定义了清晰的更新逻辑
- [ ] 避免了不必要的嵌套
- [ ] 考虑了状态的序列化
- [ ] 设计了合理的初始值

### 实现检查
- [ ] 节点函数返回完整的状态更新
- [ ] 使用了适当的 reducer
- [ ] 处理了可选字段
- [ ] 添加了状态验证
- [ ] 实现了错误处理

### 持久化检查
- [ ] 选择了合适的 checkpointer
- [ ] 配置了正确的 thread_id
- [ ] 测试了状态恢复
- [ ] 考虑了并发访问
- [ ] 实现了状态清理机制

## 注意事项

### 状态更新语义
- **累加 (Annotated[list, add])**: 列表会累加，不会替换
- **替换**: 默认行为，新值替换旧值
- **自定义 reducer**: 完全控制更新逻辑

### Checkpointer 选择
- **MemorySaver**: 内存存储，适合开发和测试
- **SqliteSaver**: SQLite 持久化，适合单机应用
- **PostgresSaver**: PostgreSQL 持久化，适合生产环境
- **RedisSaver**: Redis 持久化，适合分布式系统

### Thread ID 管理
- thread_id 标识一个对话会话
- 相同的 thread_id 会恢复之前的状态
- 不同的 thread_id 创建新的独立会话
- 可以使用 user_id + session_id 组合

### 性能考虑
- 状态大小会影响性能
- 频繁的持久化会影响速度
- 大列表考虑使用分页
- 不必要的数据不要放入状态

### 最佳实践
1. **保持状态精简**: 只包含必要的信息
2. **使用类型注解**: 提高代码可读性和可维护性
3. **合理使用 reducer**: 避免复杂的更新逻辑
4. **选择合适的持久化**: 根据场景选择 checkpointer
5. **处理边界情况**: 考虑状态不存在或为空的情况
6. **添加验证**: 使用 Pydantic 验证状态数据

## 常见问题

**Q: 状态会被替换还是累加？**
A: 取决于字段的定义。使用 `Annotated[list, add]` 会累加，否则默认替换。

**Q: 如何删除状态中的字段？**
A: 返回一个包含该字段为 None 的更新，或使用专门的删除逻辑。

**Q: 状态可以存储在多个数据库吗？**
A: 可以，通过自定义 checkpointer 实现。

**Q: 如何处理状态并发更新？**
A: 使用事务性 checkpointer（如 Postgres）或添加乐观锁。

**Q: 状态大小有限制吗？**
A: 理论上没有硬限制，但过大的状态会影响性能，建议保持精简。

## 进阶技巧

### 状态快照
定期保存状态快照，支持回滚。

### 状态压缩
对历史状态进行压缩，只保留关键信息。

### 状态分片
将大状态拆分为多个小状态，按需加载。

### 状态验证
使用 Pydantic 验证状态数据的完整性。

## 相关资源

- [状态管理指南](https://langchain-ai.github.io/langgraph/concepts/low_level/#state)
- [Checkpointer 文档](https://langchain-ai.github.io/langgraph/concepts/persistence/)
- [StateReducer 参考](https://langchain-ai.github.io/langgraph/reference/types/#reducer)
