# /chain - 创建 LangChain 链

## 描述
使用 LCEL (LangChain Expression Language) 创建一个 LangChain 链。支持各种类型的链：基础链、RAG链、路由链等。

## 使用方法
```
/chain <链类型> [配置选项]
```

**链类型:**
- `basic` - 基础 LCEL 链
- `rag` - RAG 检索链
- `router` - 带路由的链
- `sequential` - 顺序执行链

**示例:**
```
/chain basic --model claude-3-5-sonnet-20241022
/chain rag --vector-store chroma
/chain router --routes summary,translation
```

## 执行步骤

### 步骤 1: 分析需求
- [ ] 确定链的类型
- [ ] 确定使用的模型
- [ ] 确定输入输出格式

### 步骤 2: 设计链结构
- [ ] 列出需要的组件 (提示、模型、解析器)
- [ ] 确定组件间的连接方式
- [ ] 设计数据流

### 步骤 3: 实现代码
使用 langchain-chain 技能创建代码:
- [ ] 导入必要的模块
- [ ] 定义提示模板
- [ ] 配置模型
- [ ] 构建链 (使用 LCEL)
- [ ] 添加类型注解

### 步骤 4: 测试验证
- [ ] 编写测试用例
- [ ] 测试基本功能
- [ ] 测试边界情况
- [ ] 验证输出格式

### 步骤 5: 优化完善
- [ ] 添加错误处理
- [ ] 添加日志记录
- [ ] 优化性能
- [ ] 补充文档

## 示例执行

### 示例 1: 基础链
```python
# 输入: /chain basic

# 输出代码:
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_anthropic import ChatAnthropic

prompt = ChatPromptTemplate.from_template("讲一个关于{topic}的故事")
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")
output_parser = StrOutputParser()

chain = prompt | llm | output_parser

result = chain.invoke({"topic": "勇气"})
```

### 示例 2: RAG 链
```python
# 输入: /chain rag

# 输出代码:
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_anthropic import ChatAnthropic
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

# 设置检索器
vectorstore = Chroma(embedding_function=OpenAIEmbeddings())
retriever = vectorstore.as_retriever()

# 构建链
prompt = ChatPromptTemplate.from_template("""
上下文: {context}

问题: {question}
""")

def format_docs(docs):
    return "\n\n".join([d.page_content for d in docs])

rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | ChatAnthropic(model="claude-3-5-sonnet-20241022")
    | StrOutputParser()
)
```

## 注意事项

1. **必须使用 LCEL** - 不要使用旧的 Chain 类
2. **类型安全** - 添加类型注解
3. **错误处理** - 添加 try-catch
4. **测试驱动** - 先写测试
5. **文档完整** - 包含使用示例

## 相关技能
- langchain-chain - 核心链构建技能
- langchain-prompt - 提示模板设计
- langchain-retriever - 检索器配置
