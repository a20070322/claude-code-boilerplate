# /graph - LangGraph 构建命令

## 命令描述

`/graph` 命令用于快速创建和配置 LangGraph 工作流图结构。该命令会引导你完成图的定义、节点配置、边连接等步骤。

## 使用方法

```
/graph <图类型> <配置选项>
```

### 图类型选项
- `react` - 创建 React Agent 图
- `multi-agent` - 创建多智能体协作图
- `sequential` - 创建顺序执行图
- `conditional` - 创建条件分支图
- `parallel` - 创建并行执行图
- `custom` - 自定义图结构

### 配置选项
- `--state <类型>` - 指定状态类型
- `--memory` - 启用记忆功能
- `--persistence <类型>` - 指定持久化类型 (memory/sqlite/postgres)
- `--tools` - 添加工具节点
- `--checkpointer` - 添加检查点

## 执行步骤

### 步骤 1: 分析需求
命令首先会分析当前项目结构，确定：
- 项目类型（Python/JavaScript）
- 已有的依赖包
- 现有的图定义
- 配置文件位置

### 步骤 2: 选择图类型
根据你的选择，提供对应的模板：
```
请选择图的类型:
1. React Agent (推荐用于对话系统)
2. Multi-Agent (用于多智能体协作)
3. Sequential (用于顺序流程)
4. Conditional (用于条件分支)
5. Parallel (用于并行执行)
```

### 步骤 3: 定义状态
创建状态类型定义：
```python
from typing import Annotated, TypedDict

class GraphState(TypedDict):
    messages: Annotated[list, lambda x, y: x + y]
    # 添加更多字段...
```

### 步骤 4: 添加节点
定义节点函数：
```python
def my_node(state: GraphState):
    # 处理逻辑
    return {"messages": ["新消息"]}
```

### 步骤 5: 配置边
配置节点之间的连接：
```python
workflow.add_edge(START, "node_a")
workflow.add_conditional_edges("node_a", should_continue)
```

### 步骤 6: 编译和测试
编译图并运行测试。

## 示例执行

### 示例 1: 创建基础 React Agent

```bash
/graph react --tools --memory
```

**执行过程:**
1. 分析项目结构
2. 检查依赖（langgraph, langchain-anthropic）
3. 创建 `graphs/react_agent.py`
4. 生成状态定义
5. 添加 Agent 节点和 ToolNode
6. 配置条件边
7. 添加 MemorySaver checkpointer
8. 生成测试代码

**生成的文件:**
```
graphs/
├── react_agent.py
├── state.py
└── tools.py
tests/
└── test_react_agent.py
```

### 示例 2: 创建多智能体系统

```bash
/graph multi-agent --persistence sqlite
```

**执行过程:**
1. 确认多智能体架构
2. 定义共享状态
3. 创建各个智能体节点
4. 配置智能体间的协作流程
5. 设置 SQLite 持久化
6. 生成协调逻辑

**生成的文件:**
```
graphs/
├── multi_agent_team.py
├── agents/
│   ├── researcher.py
│   ├── critic.py
│   └── synthesizer.py
└── state.py
data/
└── agent_memory.db
```

### 示例 3: 创建条件分支图

```bash
/graph conditional --state custom
```

**执行过程:**
1. 定义状态结构
2. 创建分支节点
3. 实现条件判断函数
4. 配置多分支路径
5. 添加汇聚节点

**生成的代码:**
```python
def route_function(state: GraphState) -> Literal["path_a", "path_b", END]:
    if state["condition"] == "A":
        return "path_a"
    elif state["condition"] == "B":
        return "path_b"
    return END

workflow.add_conditional_edges(
    "decision_node",
    route_function
)
```

## 注意事项

### 依赖检查
命令会自动检查以下依赖：
- `langgraph` >= 0.2.0
- `langchain-core` >= 0.3.0
- `langchain-anthropic` (如使用 Claude)

如果缺失，会提示安装：
```bash
pip install langgraph langchain-core langchain-anthropic
```

### 文件冲突
如果目标文件已存在，命令会：
1. 显示现有文件内容
2. 询问是否覆盖
3. 提供 `--force` 选项强制覆盖

### 配置验证
命令会验证：
- 状态定义的完整性
- 节点函数的类型注解
- 边的连接有效性
- 条件函数的返回值

### 最佳实践
1. **先设计再实现**: 使用 `/graph` 前，先在文档中规划图结构
2. **增量开发**: 从简单图开始，逐步添加复杂度
3. **测试驱动**: 生成的代码包含测试模板
4. **文档注释**: 生成的节点函数包含文档字符串

## 故障排除

### 问题 1: 导入错误
```
ImportError: No module named 'langgraph'
```
**解决:** 安装依赖 `pip install langgraph`

### 问题 2: 类型检查失败
```
TypeError: Node function missing type annotations
```
**解决:** 确保节点函数有完整的类型注解

### 问题 3: 状态更新错误
```
State update error: key 'messages' not found
```
**解决:** 检查状态定义，确保所有字段在 TypedDict 中声明

### 问题 4: Checkpointer 错误
```
Checkpointer initialization failed
```
**解决:** 检查数据库连接字符串，确保有写入权限

## 高级用法

### 自定义模板
创建 `.claude/templates/graph/` 目录，添加自定义模板：
```python
# custom_template.py
def create_custom_graph(config):
    # 自定义图创建逻辑
    pass
```

### 批量创建
```bash
# 一次性创建多个图
/graph react sequential parallel --batch
```

### 配置预设
在 `.claude/config.json` 中定义预设：
```json
{
  "graph": {
    "default_model": "claude-3-5-sonnet-20241022",
    "default_checkpointer": "memory",
    "default_tools": ["search", "calculator"]
  }
}
```

## 相关命令

- `/agent` - 创建智能体节点
- `/state` - 定义状态结构
- `/check-graph` - 验证图配置

## 相关资源

- [LangGraph 图构建指南](https://langchain-ai.github.io/langgraph/concepts/low_level/)
- [图类型参考](https://langchain-ai.github.io/langgraph/concepts/)
