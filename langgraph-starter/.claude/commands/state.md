# /state - LangGraph 状态定义命令

## 命令描述

`/state` 命令用于创建和管理 LangGraph 中的状态（State）定义。状态是 LangGraph 中节点间传递数据的核心机制。

## 使用方法

```
/state <状态类型> <配置选项>
```

### 状态类型
- `simple` - 简单状态（基本字段）
- `message` - 消息状态（包含消息列表）
- `complex` - 复杂状态（嵌套结构）
- `reducer` - 带 reducer 的状态
- `pydantic` - Pydantic 模型状态

### 配置选项
- `--fields <字段列表>` - 定义字段
- `--reducer <类型>` - 指定 reducer (add/replace/custom)
- `--optional` - 添加可选字段
- `--nested` - 允许嵌套结构
- `--typed` - 使用 Pydantic 类型

## 执行步骤

### 步骤 1: 选择状态类型
根据需求选择合适的状态类型：
```
1. Simple - 基本字段，简单场景
2. Message - 包含消息列表，对话场景
3. Complex - 嵌套结构，复杂数据
4. Reducer - 需要自定义更新逻辑
5. Pydantic - 需要数据验证
```

### 步骤 2: 定义字段
列出了状态需要的所有字段：
```python
class MyState(TypedDict):
    field1: str
    field2: int
    field3: list
```

### 步骤 3: 配置更新逻辑
为每个字段指定更新方式：
- `replace` - 替换（默认）
- `add` - 累加（用于列表/数字）
- `custom` - 自定义函数

### 步骤 4: 添加类型注解
确保所有字段有正确的类型注解。

### 步骤 5: 生成状态文件
生成完整的状态定义代码。

### 步骤 6: 创建使用示例
生成使用该状态的示例代码。

## 示例执行

### 示例 1: 创建消息状态

```bash
/state message --fields "messages,user_id,session_id"
```

**生成的代码:**
```python
# state/message_state.py
from typing import Annotated, List, TypedDict
from operator import add

class MessageState(TypedDict):
    """消息状态 - 用于对话系统"""
    # 消息列表，使用累加 reducer
    messages: Annotated[List[str], add]
    # 用户 ID，替换
    user_id: str
    # 会话 ID，替换
    session_id: str
    # 可选字段
    metadata: dict | None

# 使用示例
def my_node(state: MessageState):
    """处理消息"""
    user_id = state["user_id"]
    messages = state["messages"]

    new_message = f"为用户 {user_id} 处理消息"

    return {
        "messages": [new_message],  # 会累加到现有列表
        "metadata": {"timestamp": "2024-01-01"}
    }
```

### 示例 2: 创建带 reducer 的状态

```bash
/state reducer --fields "counter,tags,findings" --reducer custom
```

**生成的代码:**
```python
# state/reducer_state.py
from typing import Annotated, List, Dict
from operator import add
from langgraph.graph import StateGraph

# 自定义 reducer
def merge_tags(existing: List[str], new: List[str]) -> List[str]:
    """合并标签，去重"""
    return list(set(existing + new))

def merge_findings(
    existing: List[Dict],
    new: List[Dict]
) -> List[Dict]:
    """合并发现列表，基于 ID 去重或更新"""
    existing_dict = {f["id"]: f for f in existing}
    for item in new:
        existing_dict[item["id"]] = item
    return list(existing_dict.values())

class ReducerState(TypedDict):
    """带 reducer 的状态"""
    # 计数器，累加
    counter: Annotated[int, add]
    # 标签列表，自定义合并
    tags: Annotated[List[str], merge_tags]
    # 发现列表，基于 ID 合并
    findings: Annotated[List[Dict], merge_findings]
    # 状态字符串，替换
    status: str

# 使用示例
def process_node(state: ReducerState):
    """处理节点"""
    return {
        "counter": 1,  # 累加到现有值
        "tags": ["important", "reviewed"],  # 去重合并
        "findings": [{"id": 1, "content": "新发现"}],  # 基于 ID 合并
        "status": "processing"  # 替换
    }
```

### 示例 3: 创建 Pydantic 状态

```bash
/state pydantic --fields "analysis,result,metrics" --typed
```

**生成的代码:**
```python
# state/pydantic_state.py
from typing import Annotated, List
from pydantic import BaseModel, Field
from typing import TypedDict

# Pydantic 模型
class AnalysisModel(BaseModel):
    """分析结果模型"""
    score: float = Field(description="分数", ge=0.0, le=1.0)
    insights: List[str] = Field(description="洞察列表")
    confidence: float = Field(description="置信度", ge=0.0, le=1.0)

class MetricsModel(BaseModel):
    """指标模型"""
    precision: float
    recall: float
    f1_score: float

class TypedState(TypedDict):
    """使用 Pydantic 的状态"""
    analysis: AnalysisModel | None
    result: str
    metrics: MetricsModel | None
    step_count: int

# 使用示例
def analyze_node(state: TypedState):
    """分析节点"""
    # 创建 Pydantic 模型实例
    analysis = AnalysisModel(
        score=0.85,
        insights=["洞察1", "洞察2"],
        confidence=0.9
    )

    return {
        "analysis": analysis,  # 自动验证
        "step_count": state["step_count"] + 1
    }

def metrics_node(state: TypedState):
    """指标节点"""
    metrics = MetricsModel(
        precision=0.92,
        recall=0.88,
        f1_score=0.90
    )

    return {"metrics": metrics}
```

### 示例 4: 创建复杂嵌套状态

```bash
/state complex --nested --fields "context,history,output"
```

**生成的代码:**
```python
# state/complex_state.py
from typing import Annotated, List, Dict, Any, TypedDict

class ContextInfo(TypedDict):
    """上下文信息"""
    user_id: str
    session_id: str
    timestamp: str
    metadata: Dict[str, Any]

class HistoryItem(TypedDict):
    """历史记录项"""
    step: int
    action: str
    result: str
    timestamp: str

class OutputInfo(TypedDict):
    """输出信息"""
    content: str
    format: str
    metadata: Dict[str, Any] | None

class ComplexState(TypedDict):
    """复杂嵌套状态"""
    # 嵌套的上下文
    context: ContextInfo
    # 历史记录列表
    history: Annotated[List[HistoryItem], lambda x, y: x + y]
    # 输出信息
    output: OutputInfo | None
    # 顶层字段
    status: str
    error: str | None

# 使用示例
def initialize(state: ComplexState):
    """初始化状态"""
    context: ContextInfo = {
        "user_id": "user-123",
        "session_id": "session-456",
        "timestamp": "2024-01-01T00:00:00",
        "metadata": {"source": "web"}
    }

    return {"context": context}

def process_action(state: ComplexState):
    """处理动作"""
    history_item: HistoryItem = {
        "step": len(state["history"]) + 1,
        "action": "process",
        "result": "completed",
        "timestamp": "2024-01-01T00:00:01"
    }

    return {"history": [history_item]}
```

## 状态设计原则

### 1. 最小化原则
只包含必要的信息，避免冗余：
```python
# ❌ 不好 - 包含冗余信息
class BadState(TypedDict):
    messages: List[str]
    message_count: int  # 可以从 messages 计算
    last_message: str   # 可以从 messages 获取

# ✅ 好 - 只包含必要信息
class GoodState(TypedDict):
    messages: Annotated[List[str], lambda x, y: x + y]
```

### 2. 类型明确原则
使用明确的类型注解：
```python
# ❌ 不好 - 类型不明确
class BadState(TypedDict):
    data: Any
    items: list

# ✅ 好 - 类型明确
class GoodState(TypedDict):
    data: Dict[str, str]
    items: List[Dict[str, Any]]
```

### 3. 更新逻辑清晰原则
明确每个字段的更新方式：
```python
class ClearState(TypedDict):
    # 明确使用累加
    messages: Annotated[List[str], add]
    # 明确使用替换（默认）
    current_status: str
    # 自定义更新
    tags: Annotated[List[str], custom_merger]
```

### 4. 可选性原则
使用 Optional 标记可能不存在的字段：
```python
class OptionalState(TypedDict):
    required_field: str
    optional_field: str | None  # 可能不存在
    another_optional: Dict[str, Any] | None
```

## Reducer 最佳实践

### 内置 Reducer
```python
from operator import add

# 数字累加
count: Annotated[int, add]

# 列表累加
items: Annotated[List[str], add]
```

### 自定义 Reducer
```python
def append_unique(existing: List[str], new: List[str]) -> List[str]:
    """追加唯一值"""
    return existing + [x for x in new if x not in existing]

def update_dict(
    existing: Dict[str, Any],
    new: Dict[str, Any]
) -> Dict[str, Any]:
    """更新字典"""
    return {**existing, **new}
```

## 注意事项

### 状态序列化
确保状态可以序列化（用于持久化）：
```python
# ✅ 可序列化
class SerializableState(TypedDict):
    text: str
    number: int
    items: List[str]

# ❌ 不可序列化
class NonSerializableState(TypedDict):
    callback: Callable  # 函数不能序列化
    file_handle: FileIO  # 文件句柄不能序列化
```

### 状态大小
保持状态精简：
- 避免存储大对象
- 限制列表大小
- 考虑分页或摘要

### 并发更新
注意并发更新的冲突：
```python
# 使用事务性 checkpointer
from langgraph.checkpoint.postgres import PostgresSaver

checkpointer = PostgresSaver.from_conn_string(conn_string)
app = workflow.compile(checkpointer=checkpointer)
```

## 故障排除

### 问题 1: 状态更新不生效
**原因:** 字段名称拼写错误
**解决:** 检查返回的字典中的字段名

### 问题 2: 类型错误
**原因:** 类型注解不匹配
**解决:** 确保返回值的类型与状态定义一致

### 问题 3: 列表无限增长
**原因:** 使用累加但没有限制
**解决:** 添加列表大小限制或清理逻辑

### 问题 4: 持久化失败
**原因:** 状态包含不可序列化的对象
**解决:** 移除不可序列化的字段

## 高级用法

### 状态验证
使用 Pydantic 进行验证：
```python
from pydantic import BaseModel, validator

class ValidatedModel(BaseModel):
    value: int

    @validator('value')
    def check_range(cls, v):
        if not 0 <= v <= 100:
            raise ValueError('value must be 0-100')
        return v
```

### 状态压缩
定期压缩历史状态：
```python
def compress_history(history: List[HistoryItem]) -> List[HistoryItem]:
    """只保留最近 10 条"""
    return history[-10:]
```

### 状态分片
拆分大状态：
```python
class MainState(TypedDict):
    summary: str
    detailed_state_ref: str  # 引用其他存储

# 详细状态存储在数据库
```

## 相关命令

- `/graph` - 创建使用该状态的图
- `/agent` - 创建使用该状态的智能体
- `/check-graph` - 验证状态定义

## 相关资源

- [状态管理指南](https://langchain-ai.github.io/langgraph/concepts/low_level/#state)
- [Reducer 参考](https://langchain-ai.github.io/langgraph/reference/types/#reducer)
- [状态持久化](https://langchain-ai.github.io/langgraph/concepts/persistence/)
