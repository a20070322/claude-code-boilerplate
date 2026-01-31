# LangChain 项目配置

## 项目概述

本项目是一个 LangChain 开发模板，提供了开箱即用的 LangChain 应用开发配置和最佳实践。

LangChain 是一个用于开发由大型语言模型(LLM)驱动的应用程序的框架，提供了链、智能体、提示、记忆等核心组件。

## 技术栈说明

### 核心技术
- **LangChain**: LLM 应用开发框架 (>=0.2.0)
- **LangChain Core**: LangChain 核心接口 (>=0.3.0)
- **LangChain Anthropic**: Anthropic Claude 模型集成 (>=0.2.0)
- **Python 3.9+**: 主要开发语言
- **Anthropic Claude**: 推荐使用的 LLM 模型

### 可选依赖
```python
# 向量存储
chromadb>=0.4.0              # 本地向量数据库
pinecone-client>=2.0.0       # 云向量数据库
weaviate-client>=3.0.0       # 开源向量数据库

# 嵌入模型
langchain-openai>=0.1.0      # OpenAI 嵌入
sentence-transformers>=2.0   # 本地嵌入模型

# 记忆存储
redis>=4.0.0                 # Redis 记忆存储
psycopg2-binary>=2.9.0       # PostgreSQL 记忆存储

# 其他工具
langchain-community>=0.2.0   # 社区集成工具
```

## 核心规范

### 代码风格
- 遵循 PEP 8 规范
- 使用类型注解 (Type Hints)
- 所有函数必须有文档字符串
- 使用有意义的变量名

### LCEL 规范 ⭐核心
1. **必须使用 LCEL 语法** - 使用 `|` 操作符组合组件
2. **使用 ChatPromptTemplate** - 不要用 PromptTemplate
3. **使用 invoke()** - 不要用已弃用的 run()
4. **类型明确** - 链的输入输出类型要清晰

### 智能体规范
1. **使用新版 API** - 使用 `create_tool_calling_agent`
2. **工具函数必须有类型注解** - 参数和返回值
3. **工具描述要清晰** - 详细说明工具功能
4. **设置 max_iterations** - 防止无限循环
5. **启用错误处理** - `handle_parsing_errors=True`

### 提示模板规范
1. **使用 ChatPromptTemplate** - 支持多种消息类型
2. **变量命名清晰** - 使用有意义的变量名
3. **指定输出格式** - 明确告诉模型期望的输出
4. **控制长度** - 注意 token 限制

### 检索器规范
1. **设置合理的 k 值** - 通常 3-5 个文档
2. **添加元数据** - 丰富文档的元数据
3. **考虑多样性** - 使用 MMR 策略
4. **性能优化** - 使用缓存和持久化

### 记忆组件规范
1. **限制长度** - 防止超出 token 限制
2. **持久化存储** - 使用数据库存储历史
3. **会话隔离** - 不同用户使用独立记忆
4. **定期清理** - 删除过期历史

## 快捷命令

### /chain - 创建 LangChain 链
```bash
/chain <链类型> [配置选项]
```

**链类型:**
- `basic` - 基础 LCEL 链
- `rag` - RAG 检索链
- `router` - 带路由的链
- `sequential` - 顺序执行链

**示例:**
```bash
/chain basic --model claude-3-5-sonnet-20241022
/chain rag --vector-store chroma
```

### /agent - 创建 LangChain 智能体
```bash
/agent <智能体类型> [配置选项]
```

**智能体类型:**
- `tool-calling` - 工具调用智能体 (推荐)
- `react` - ReAct 模式智能体
- `planning` - 规划执行智能体

**示例:**
```bash
/agent tool-calling --tools search,calculator
/agent react --memory conversation --max-steps 10
```

### /prompt - 创建提示模板
```bash
/prompt <模板类型> [配置选项]
```

**模板类型:**
- `chat` - ChatPromptTemplate 对话模板
- `fewshot` - 少样本学习模板
- `partial` - 部分填充模板

**示例:**
```bash
/prompt chat --role "翻译专家"
/prompt fewshot --examples 3
```

### /retriever - 创建检索器
```bash
/retriever <检索器类型> [配置选项]
```

**检索器类型:**
- `basic` - 基础向量检索
- `mmr` - MMR 多样性检索
- `similarity` - 相似度检索

**示例:**
```bash
/retriever basic --vector-store chroma --k 5
/retriever mmr --k 3 --diversity 0.5
```

### /check - 检查配置和代码
```bash
/check [检查范围]
```

**检查范围:**
- `all` - 全面检查 (默认)
- `config` - 仅检查配置
- `code` - 仅检查代码

**示例:**
```bash
/check              # 全面检查
/check code         # 检查代码质量
```

## 技能列表

### langchain-chain
**技能描述:** 使用 LCEL 构建 LangChain 链

**使用场景:**
- 构建数据处理链
- 创建 RAG 流程
- 实现多步骤 LLM 应用

**调用方式:**
```
使用 langchain-chain 技能创建一个 RAG 链
```

### langchain-agent
**技能描述:** 开发 LangChain 智能体

**使用场景:**
- 构建对话式 AI 助手
- 实现工具调用 Agent
- 创建自主决策系统

**调用方式:**
```
使用 langchain-agent 技能创建一个工具调用 Agent
```

### langchain-prompt
**技能描述:** 创建和管理提示模板

**使用场景:**
- 创建对话提示模板
- 管理系统提示词
- 实现少样本学习

**调用方式:**
```
使用 langchain-prompt 技能创建提示模板
```

### langchain-retriever
**技能描述:** 实现检索器 (RAG)

**使用场景:**
- 构建知识库问答系统
- 实现 RAG 应用
- 文档语义搜索

**调用方式:**
```
使用 langchain-retriever 技能创建检索器
```

### langchain-memory
**技能描述:** 配置记忆组件

**使用场景:**
- 构建多轮对话系统
- 保持会话上下文
- 管理对话历史

**调用方式:**
```
使用 langchain-memory 技能配置记忆
```

## 代理

### @chain-reviewer
**代理描述:** 审查链的设计和实现

**触发方式:** `@chain-reviewer`

**职责:**
- 代码规范检查
- 架构设计审查
- 性能问题分析
- 安全漏洞检测

**调用方式:**
```
@chain-reviewer 审查这个链
@chain-reviewer 检查 chains/my_chain.py
```

## 开发流程

### 1. 创建新项目

```bash
# 使用 /chain 命令创建链
/chain basic --model claude-3-5-sonnet-20241022

# 使用 /agent 命令创建智能体
/agent tool-calling --tools search,calculator

# 使用 /prompt 命令创建提示模板
/prompt chat --role "翻译专家"
```

### 2. 开发链

```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_anthropic import ChatAnthropic

# 定义组件
prompt = ChatPromptTemplate.from_template("讲一个关于{topic}的故事")
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")
output_parser = StrOutputParser()

# 使用 LCEL 构建链
chain = prompt | llm | output_parser

# 调用链
result = chain.invoke({"topic": "AI"})
```

### 3. 开发智能体

```python
from langchain.tools import tool
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_anthropic import ChatAnthropic

# 定义工具
@tool
def search(query: str) -> str:
    """搜索互联网信息"""
    return f"搜索结果"

# 创建智能体
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)
agent = create_tool_calling_agent(llm, [search], prompt)
agent_executor = AgentExecutor(agent=agent, tools=[search])

# 运行
result = agent_executor.invoke({"input": "搜索最新新闻"})
```

### 4. 验证配置

```bash
# 验证链配置
/check code

# 审查链设计
@chain-reviewer 审查这个链
```

### 5. 测试

```python
# 测试链
def test_chain():
    result = chain.invoke({"topic": "测试"})
    assert result is not None
    assert len(result) > 0

# 测试智能体
def test_agent():
    result = agent_executor.invoke({"input": "测试输入"})
    assert "output" in result
```

### 6. 部署

```bash
# 最终验证
/check all

# 部署前检查清单
- [ ] 所有类型注解完整
- [ ] 错误处理已添加
- [ ] 日志记录已配置
- [ ] 性能已优化
- [ ] 安全已检查
- [ ] 测试已通过
```

## 代码检查清单

### 链构建
- [ ] 使用了 LCEL 语法
- [ ] 使用了 ChatPromptTemplate
- [ ] 类型注解完整
- [ ] 有文档字符串
- [ ] 有错误处理
- [ ] 有测试用例

### 智能体开发
- [ ] 使用了新版 Agent API
- [ ] 工具函数有类型注解
- [ ] 工具描述清晰
- [ ] 设置了 max_iterations
- [ ] 启用了错误处理
- [ ] 有权限检查

### 提示模板
- [ ] 使用了 ChatPromptTemplate
- [ ] 变量命名清晰
- [ ] 指定了输出格式
- [ ] 控制了长度
- [ ] 提供了示例

### 检索器
- [ ] 设置了合理的 k 值
- [ ] 添加了元数据
- [ ] 有过滤条件
- [ ] 使用了缓存
- [ ] 持久化了存储

### 记忆组件
- [ ] 限制了长度
- [ ] 配置了持久化
- [ ] 会话隔离
- [ ] 定期清理

## 项目结构

```
langchain-starter/
├── .claude/
│   ├── settings.json          # 核心配置
│   ├── CLAUDE.md              # 项目规范 (本文件)
│   ├── hooks/                 # 生命周期钩子
│   │   ├── session-start.mjs
│   │   ├── user-prompt-submit.mjs
│   │   └── stop.mjs
│   ├── skills/                # 专业技能
│   │   ├── langchain-chain/
│   │   ├── langchain-agent/
│   │   ├── langchain-prompt/
│   │   ├── langchain-retriever/
│   │   └── langchain-memory/
│   ├── commands/              # 斜杠命令
│   │   ├── chain.md
│   │   ├── agent.md
│   │   ├── prompt.md
│   │   ├── retriever.md
│   │   └── check.md
│   ├── agents/                # 代理
│   │   └── chain-reviewer/
│   └── docs/                  # 项目文档
├── chains/                    # 链定义
│   ├── __init__.py
│   ├── basic_chain.py
│   └── rag_chain.py
├── agents/                    # 智能体节点
│   ├── __init__.py
│   └── tools.py
├── prompts/                   # 提示模板
│   ├── __init__.py
│   └── templates.py
├── retrievers/                # 检索器
│   ├── __init__.py
│   └── vector_store.py
├── tests/                     # 测试文件
│   ├── __init__.py
│   └── test_chains.py
├── requirements.txt           # 依赖列表
├── .env.example               # 环境变量示例
└── README.md                  # 项目说明
```

## 配置文件

### requirements.txt
```
langchain>=0.2.0
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

# Vector Store (可选)
CHROMA_PERSIST_DIR=./chroma_db

# Memory (可选)
REDIS_URL=redis://localhost:6379
```

## 开发建议

### 1. 从简单开始
先创建简单的链，理解基本概念后再逐步增加复杂度。

### 2. 充分测试
LangChain 的行为可能难以预测，需要充分测试各种场景。

### 3. 使用 LCEL
LCEL 是 LangChain 的推荐方式，代码更简洁，性能更好。

### 4. 添加日志
详细的日志有助于调试和理解链的执行过程。

### 5. 限制资源
设置超时、步数限制等，防止无限循环或资源耗尽。

### 6. 监控性能
使用 LangSmith 或其他工具监控链的性能。

## 常见问题

### Q: 如何选择合适的链类型?
A:
- 简单流程 → Basic Chain
- 需要检索 → RAG Chain
- 需要决策 → Router Chain
- 对话系统 → Chain + Memory

### Q: 应该使用哪种 Agent?
A:
- 工具调用 → tool-calling Agent (推荐)
- 推理+行动 → ReAct Agent
- 复杂任务 → Planning Agent

### Q: 如何优化检索质量?
A:
1. 优化文档分段
2. 调整 k 值
3. 使用 MMR 策略
4. 添加重排序
5. 混合检索

### Q: 如何防止 Agent 无限循环?
A:
1. 设置 max_iterations
2. 添加超时
3. 使用时间限制
4. 监控执行步数

### Q: 如何调试链的执行?
A:
1. 使用 LangSmith
2. 添加 print 语句
3. 使用 verbose=True
4. 单独测试每个组件

## 相关资源

- [LangChain 官方文档](https://python.langchain.com/)
- [LangChain 教程](https://python.langchain.com/docs/get_started/introduction)
- [Anthropic Claude API](https://docs.anthropic.com/)
- [LCEL 文档](https://python.langchain.com/docs/expression_language/)
- [示例项目](https://github.com/langchain-ai/langchain/tree/main/cookbook)

## 获取帮助

如遇问题，可以：
1. 查阅技能文档（`.claude/skills/` 目录）
2. 使用命令文档（`.claude/commands/` 目录）
3. 查看 [LangChain 官方文档](https://python.langchain.com/)
4. 在项目中提问

## 版本历史

- v1.0.0 - 初始版本
  - 基础技能和命令
  - 项目模板
  - 最佳实践指南
