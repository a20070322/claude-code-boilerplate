---
name: langchain-chain
description: 使用 LCEL 构建 LangChain 链
---

# LangChain 链构建技能

## 使用场景
- 构建数据处理链
- 创建 RAG (检索增强生成) 流程
- 实现多步骤 LLM 应用
- 组合多个组件

## 代码模板

### 基础 LCEL 链
```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_anthropic import ChatAnthropic

# 定义模型
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")

# 定义提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个专业的{role}。"),
    ("user", "{input}")
])

# 定义输出解析器
output_parser = StrOutputParser()

# 使用 LCEL 构建链
chain = prompt | llm | output_parser

# 调用链
result = chain.invoke({
    "role": "翻译专家",
    "input": "Hello, world!"
})
print(result)
```

### 复杂链 (带路由)
```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_anthropic import ChatAnthropic
from langchain_core.runnables import RunnableLambda

# 定义不同的处理链
summary_chain = ChatPromptTemplate.from_template("总结以下内容:\n\n{content}") | ChatAnthropic() | StrOutputParser()
translation_chain = ChatPromptTemplate.from_template("翻译成中文:\n\n{content}") | ChatAnthropic() | StrOutputParser()

# 路由函数
def route_function(x):
    if "summary" in x["task_type"]:
        return summary_chain
    else:
        return translation_chain

# 构建带路由的链
full_chain = {
    "content": lambda x: x["input"],
    "task_type": lambda x: x["task_type"]
} | RunnableLambda(route_function)

# 调用
result = full_chain.invoke({
    "input": "Long text here...",
    "task_type": "summary"
})
```

### RAG 链
```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_anthropic import ChatAnthropic

# 定义提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。使用以下上下文回答问题。"),
    ("human", "上下文: {context}\n\n问题: {question}")
])

# 定义 RAG 链
rag_chain = (
    {"context": retriever | (lambda docs: "\n\n".join([d.page_content for d in docs])),
     "question": RunnablePassthrough()}
    | prompt
    | ChatAnthropic(model="claude-3-5-sonnet-20241022")
    | StrOutputParser()
)

# 调用
answer = rag_chain.invoke("什么是 LangChain?")
```

## 禁止事项 ⭐重要

- ❌ 不要使用旧版 Chain (LLMChain, SequentialChain 等) - 必须使用 LCEL
- ❌ 不要在链中硬编码参数 - 使用 RunnablePassthrough 或 itemgetter
- ❌ 不要忽略类型注解 - 链的输入输出应该有明确类型
- ❌ 不要在链中进行大量计算 - 将复杂逻辑提取为独立函数
- ❌ 不要使用 `chain.run()` - 已弃用，使用 `chain.invoke()`

## 检查清单 ⭐重要

- [ ] 是否使用了 LCEL 语法 (`|` 操作符)?
- [ ] 是否使用了 ChatPromptTemplate 而不是 PromptTemplate?
- [ ] 是否正确配置了输出解析器?
- [ ] 链的输入输出类型是否明确?
- [ ] 是否处理了异常情况?
- [ ] 是否添加了日志记录?
- [ ] 是否进行了类型注解?

## 注意事项

### LCEL 优势
- 声明式构建，代码更简洁
- 自动优化执行顺序
- 内置流式输出支持
- 易于调试和可视化

### 链的可组合性
- 每个组件都是 Runnable
- 可以随意组合和嵌套
- 支持并行执行

### 性能优化
- 使用 `batch()` 批量处理
- 使用 `stream()` 流式输出
- 合理使用缓存

### 调试技巧
```python
# 使用 RunnableParallel 查看中间结果
from langchain_core.runnables import RunnableParallel

chain = RunnableParallel(
    prompt=prompt,
    llm_output=llm,
    parsed=output_parser
)

# 使用 debug 模式
from langchain.globals import set_debug
set_debug(True)
```

## 最佳实践

1. **模块化设计** - 将复杂链拆分为小的可复用组件
2. **类型安全** - 使用 Pydantic 模型定义输入输出
3. **错误处理** - 添加 try-catch 和回退逻辑
4. **测试** - 单独测试每个组件
5. **监控** - 添加追踪和日志
