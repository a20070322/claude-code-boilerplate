---
name: langchain-prompt
description: 创建和管理提示模板
---

# LangChain 提示模板技能

## 使用场景
- 创建对话提示模板
- 管理系统提示词
- 实现少样本学习
- 构建复杂的多轮对话

## 代码模板

### ChatPromptTemplate (推荐)
```python
from langchain_core.prompts import ChatPromptTemplate

# 方式1: 使用消息元组
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个专业的{role}。"),
    ("human", "{input}")
])

# 方式2: 使用消息类
from langchain_core.messages import SystemMessage, HumanMessage

prompt = ChatPromptTemplate.from_messages([
    SystemMessage(content="你是一个有帮助的助手。"),
    HumanMessage(content="你好，{name}!")
])

# 调用
formatted = prompt.format_messages(
    role="翻译专家",
    input="Hello"
)
```

### 带示例的提示模板
```python
from langchain_core.prompts import ChatPromptTemplate, FewShotChatMessagePromptTemplate

# 定义示例
examples = [
    {"input": "开心", "output": "joyful"},
    {"input": "悲伤", "output": "sorrowful"},
]

# 创建少样本提示模板
example_prompt = ChatPromptTemplate.from_messages([
    ("human", "{input}"),
    ("ai", "{output}")
])

few_shot_prompt = FewShotChatMessagePromptTemplate(
    example_prompt=example_prompt,
    examples=examples
)

# 创建最终提示
prompt = ChatPromptTemplate.from_messages([
    ("system", "将给定的中文情感词翻译成英文。"),
    few_shot_prompt,
    ("human", "{input}")
])

# 调用
formatted = prompt.format_messages(input="愤怒")
```

### 部分变量填充
```python
from langchain_core.prompts import ChatPromptTemplate

# 创建提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个{role}，专注于{domain}。"),
    ("human", "{user_input}")
])

# 部分填充
partial_prompt = prompt.partial(
    role="技术顾问",
    domain="人工智能"
)

# 后续只需要填充剩余变量
formatted = partial_prompt.format_messages(
    user_input="什么是机器学习?"
)
```

### 输出解析器集成
```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import (
    StrOutputParser,
    JsonOutputParser,
    PydanticOutputParser
)
from pydantic import BaseModel, Field

# 定义输出模型
class ProductReview(BaseModel):
    sentiment: str = Field(description="情感: positive/negative/neutral")
    summary: str = Field(description="评论摘要")
    rating: int = Field(description="评分: 1-5")

# 创建解析器
parser = PydanticOutputParser(pydantic_object=ProductReview)

# 创建提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "分析产品评论。\n{format_instructions}"),
    ("human", "{review}")
])

# 组合链
chain = prompt | llm | parser

# 调用
result = chain.invoke({
    "review": "这个产品很棒，我非常喜欢!",
    "format_instructions": parser.get_format_instructions()
})
```

## 禁止事项 ⭐重要

- ❌ 不要使用 PromptTemplate - 必须使用 ChatPromptTemplate
- ❌ 不要在提示中硬编码大量文本 - 使用模板变量
- ❌ 不要忽略输出格式说明 - 必须明确告诉模型期望的输出格式
- ❌ 不要使用过长的上下文 - 注意 token 限制
- ❌ 不要在系统提示中放置用户输入 - 系统提示应该是固定的

## 检查清单 ⭐重要

- [ ] 是否使用了 ChatPromptTemplate?
- [ ] 变量命名是否清晰?
- [ ] 系统提示是否完整?
- [ ] 是否配置了输出解析器?
- [ ] 示例是否具有代表性?
- [ ] 提示长度是否合理 (< 4000 tokens)?
- [ ] 是否处理了边界情况?

## 注意事项

### 提示工程最佳实践
1. **清晰的指令** - 明确告诉模型要做什么
2. **提供示例** - 使用少样本学习提高准确性
3. **指定格式** - 明确输出格式要求
4. **角色设定** - 给模型分配合适的角色
5. **上下文管理** - 只提供相关的上下文信息

### 变量命名规范
```python
# ✅ 好的命名
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是{role}，负责{task}。"),
    ("human", "用户输入: {user_input}")
])

# ❌ 不好的命名
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是{a}，负责{b}。"),
    ("human", "{x}")
])
```

### 模板复用
```python
# 定义基础模板
base_prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。")
])

# 扩展特定功能
customer_service_prompt = base_prompt + ChatPromptTemplate.from_messages([
    ("system", "你专注于客户服务。")
])
```

### 多语言支持
```python
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个{language}翻译专家。"),
    ("human", "翻译: {text}")
])
```

## 最佳实践

1. **模块化** - 将常用的提示模板定义为独立模块
2. **版本控制** - 对提示模板进行版本管理
3. **A/B 测试** - 对比不同提示模板的效果
4. **迭代优化** - 根据结果持续改进提示
5. **文档记录** - 记录每个模板的设计思路
