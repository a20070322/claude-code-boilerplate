# LangChain 链完整示例

## 1. 基础 LCEL 链

```python
# chains/basic_chain.py
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

# 定义组件
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

prompt = ChatPromptTemplate.from_template(
    "讲一个关于{topic}的故事，要求生动有趣。"
)

output_parser = StrOutputParser()

# 使用 LCEL 构建链
chain = prompt | llm | output_parser

# 调用
result = chain.invoke({"topic": "人工智能"})
print(result)
```

## 2. RAG 链（检索增强生成）

```python
# chains/rag_chain.py
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义提示模板
template = """根据以下上下文回答问题：

上下文：
{context}

问题：{question}

答案："""
prompt = ChatPromptTemplate.from_template(template)

# 定义检索器（示例）
def retriever(query: str) -> str:
    """模拟检索器"""
    return f"这是关于 '{query}' 的相关上下文信息。"

# 构建链
rag_chain = (
    {
        "context": lambda x: retriever(x["question"]),
        "question": lambda x: x["question"]
    }
    | prompt
    | llm
    | StrOutputParser()
)

# 调用
result = rag_chain.invoke({"question": "什么是 LangChain？"})
print(result)
```

## 3. 路由链

```python
# chains/router_chain.py
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableBranch

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义不同任务的提示
code_prompt = ChatPromptTemplate.from_template(
    "编写 {language} 代码：{task}"
)

math_prompt = ChatPromptTemplate.from_template(
    "计算：{expression}"
)

general_prompt = ChatPromptTemplate.from_template(
    "回答：{input}"
)

# 定义子链
code_chain = code_prompt | llm | StrOutputParser()
math_chain = math_prompt | llm | StrOutputParser()
general_chain = general_prompt | llm | StrOutputParser()

# 定义路由逻辑
def route_function(input_data):
    task_type = input_data.get("type", "")
    if "code" in task_type or "编程" in task_type:
        return "code"
    elif "math" in task_type or "计算" in task_type:
        return "math"
    else:
        return "general"

# 创建路由链
router = RunnableBranch(
    (lambda x: route_function(x) == "code", code_chain),
    (lambda x: route_function(x) == "math", math_chain),
    general_chain
)

# 调用
result1 = router.invoke({"type": "code", "language": "Python", "task": "Hello World"})
result2 = router.invoke({"type": "math", "expression": "2+2"})
result3 = router.invoke({"type": "general", "input": "你好"})
```

## 4. 带记忆的链

```python
# chains/chain_with_memory.py
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain.memory import ConversationBufferMemory

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义提示
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个友好的助手。"),
    ("placeholder", "{history}"),  # 对话历史
    ("human", "{input}")
])

# 创建记忆
memory = ConversationBufferMemory(return_messages=True)

# 创建链
chain = prompt | llm | StrOutputParser()

# 带记忆的调用
from langchain_core.runnables import RunnableWithMessageHistory

chain_with_history = RunnableWithMessageHistory(
    chain,
    lambda x: memory.get_session_history(x["session_id"])
)

# 调用
result = chain_with_history.invoke(
    {"input": "你好！"},
    config={"configurable": {"session_id": "abc123"}}
)
```
