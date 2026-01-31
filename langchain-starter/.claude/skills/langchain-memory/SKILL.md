---
name: langchain-memory
description: 配置记忆组件
---

# LangChain 记忆组件技能

## 使用场景
- 构建多轮对话系统
- 保持会话上下文
- 实现长期记忆
- 管理对话历史

## 代码模板

### ConversationBufferMemory
```python
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationChain
from langchain_anthropic import ChatAnthropic

# 创建记忆组件
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True  # 返回消息对象而不是字符串
)

# 创建对话链
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")
conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=True
)

# 对话
response1 = conversation.predict(input="我叫张三")
response2 = conversation.predict(input="我叫什么名字?")
print(response2)  # 应该记住"张三"

# 查看历史
print(memory.load_memory_variables({}))
```

### ConversationBufferWindowMemory
```python
from langchain.memory import ConversationBufferWindowMemory

# 只保留最近3轮对话
memory = ConversationBufferWindowMemory(
    memory_key="chat_history",
    k=3,  # 保留最近的3轮
    return_messages=True
)

# 创建对话链
conversation = ConversationChain(
    llm=llm,
    memory=memory
)
```

### ConversationSummaryMemory
```python
from langchain.memory import ConversationSummaryMemory

# 自动总结历史对话
memory = ConversationSummaryMemory(
    llm=ChatAnthropic(model="claude-3-5-sonnet-20241022"),
    memory_key="chat_history",
    return_messages=True
)

# 创建对话链
conversation = ConversationChain(
    llm=llm,
    memory=memory
)
```

### 在链中使用记忆
```python
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.runnables import RunnablePassthrough
from langchain_anthropic import ChatAnthropic

# 创建提示模板 (包含历史记录占位符)
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。"),
    MessagesPlaceholder(variable_name="chat_history"),  # 历史记录
    ("human", "{input}")
])

# 创建记忆
from langchain.memory import ConversationBufferMemory
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True
)

# 创建链
chain = prompt | ChatAnthropic(model="claude-3-5-sonnet-20241022")

# 定义带有记忆的可运行对象
def run_with_memory(chain, memory, user_input):
    # 获取历史
    history = memory.chat_memory.messages

    # 调用链
    response = chain.invoke({
        "chat_history": history,
        "input": user_input
    })

    # 更新记忆
    memory.chat_memory.add_user_message(user_input)
    memory.chat_memory.add_ai_message(response.content)

    return response.content

# 使用
result = run_with_memory(chain, memory, "你好")
result = run_with_memory(chain, memory, "我刚才说了什么?")
```

### 持久化记忆 (使用 Redis)
```python
from langchain.memory import RedisChatMessageHistory
from langchain.memory import ConversationBufferMemory

# 为每个会话创建独立的历史记录
history = RedisChatMessageHistory(
    session_id="user-123",
    url="redis://localhost:6379"
)

memory = ConversationBufferMemory(
    chat_memory=history,
    return_messages=True
)

# 记忆会自动保存到 Redis
```

### 自定义记忆组件
```python
from langchain.memory import ChatMessageHistory
from langchain_core.messages import AIMessage, HumanMessage

# 创建自定义历史记录
history = ChatMessageHistory()

# 添加消息
history.add_user_message("你好")
history.add_ai_message("你好！有什么我可以帮助你的吗？")
history.add_user_message("介绍一下自己")

# 获取消息
messages = history.messages
```

## 禁止事项 ⭐重要

- ❌ 不要使用 `ConversationChain` - 已弃用，使用 LCEL 链
- ❌ 不要让记忆无限增长 - 必须设置窗口或使用摘要
- ❌ 不要在不同会话间共享记忆 - 使用 session_id 区分
- ❌ 不要在内存中存储大量历史 - 使用持久化存储
- ❌ 不要忽略记忆的序列化 - 必须支持保存和加载

## 检查清单 ⭐重要

- [ ] 是否选择了合适的记忆类型?
- [ ] 是否设置了合理的窗口大小?
- [ ] 是否配置了持久化存储?
- [ ] 是否处理了 session 管理?
- [ ] 是否考虑了 token 限制?
- [ ] 是否添加了记忆清除机制?
- [ ] 是否测试了记忆的恢复?

## 注意事项

### 记忆类型选择
- **BufferMemory** - 保留全部历史，适合短对话
- **WindowMemory** - 保留最近 k 轮，适合长对话
- **SummaryMemory** - 自动总结，适合长时间对话
- **KGMemory** - 知识图谱记忆，适合复杂关系

### 性能优化
```python
# 使用滑动窗口
memory = ConversationBufferWindowMemory(k=5)

# 使用摘要
memory = ConversationSummaryMemory(
    llm=llm,
    max_token_limit=1000  # 限制摘要长度
)

# 定期清理
if len(memory.chat_memory.messages) > 100:
    memory.clear()
```

### 持久化选项
- **Redis** - 高性能，适合生产环境
- **PostgreSQL** - 关系型数据库，已有基础设施
- **SQLite** - 轻量级，适合本地开发
- **MongoDB** - 文档数据库，灵活存储

### 多用户会话管理
```python
def get_memory(session_id: str):
    """为每个会话创建独立记忆"""
    history = RedisChatMessageHistory(session_id=session_id)
    return ConversationBufferMemory(
        chat_memory=history,
        return_messages=True
    )

# 使用
memory1 = get_memory("user-123")
memory2 = get_memory("user-456")
```

## 最佳实践

1. **合理选择记忆类型** - 根据应用场景选择
2. **限制记忆长度** - 避免超出 token 限制
3. **持久化存储** - 使用数据库存储历史
4. **会话隔离** - 不同用户使用独立记忆
5. **定期清理** - 删除过期或无用的历史
6. **加密敏感信息** - 保护用户隐私
7. **监控使用量** - 追踪存储和 token 消耗
