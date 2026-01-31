---
name: langchain-retriever
description: 实现检索器 (RAG)
---

# LangChain 检索器技能

## 使用场景
- 构建知识库问答系统
- 实现 RAG (检索增强生成)
- 文档语义搜索
- 上下文相关查询

## 代码模板

### 基础向量存储检索器
```python
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document

# 准备文档
documents = [
    Document(page_content="LangChain 是一个用于开发 LLM 应用的框架。"),
    Document(page_content="Chroma 是一个向量数据库。"),
    Document(page_content="RAG 结合了检索和生成。")
]

# 创建向量存储
vectorstore = Chroma.from_documents(
    documents=documents,
    embedding=OpenAIEmbeddings()
)

# 创建检索器
retriever = vectorstore.as_retriever(
    search_type="similarity",
    search_kwargs={"k": 3}  # 返回前3个结果
)

# 使用检索器
results = retriever.invoke("什么是 LangChain?")
for doc in results:
    print(doc.page_content)
```

### 完整的 RAG 链
```python
from langchain_anthropic import ChatAnthropic
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

# 创建向量存储和检索器
vectorstore = Chroma.from_documents(
    documents=documents,
    embedding=OpenAIEmbeddings()
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})

# 定义提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的助手。使用以下上下文回答问题。"),
    ("human", """上下文:
{context}

问题: {question

根据上下文回答问题。如果上下文中没有相关信息，就说"我不知道"。""")
])

# 格式化文档
def format_docs(docs):
    return "\n\n".join([d.page_content for d in docs])

# 构建 RAG 链
rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | ChatAnthropic(model="claude-3-5-sonnet-20241022")
    | StrOutputParser()
)

# 查询
answer = rag_chain.invoke("什么是 RAG?")
print(answer)
```

### 多路召回 (MMR)
```python
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

# 使用 MMR 策略
retriever = vectorstore.as_retriever(
    search_type="mmr",
    search_kwargs={
        "k": 5,           # 返回5个文档
        "fetch_k": 20,    # 从20个候选中选择
        "lambda_mult": 0.5  # 多样性权重
    }
)

results = retriever.invoke("查询内容")
```

### 自定义检索器
```python
from langchain_core.retrievers import BaseRetriever
from langchain_core.callbacks import CallbackManagerForRetrieverRun
from typing import List

class CustomRetriever(BaseRetriever):
    """自定义检索器"""

    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: CallbackManagerForRetrieverRun
    ) -> List[Document]:
        # 实现自定义检索逻辑
        docs = self.search(query)
        return docs

    def search(self, query: str) -> List[Document]:
        # 实现搜索逻辑
        # 可以调用外部 API、数据库等
        return [
            Document(page_content=f"关于 {query} 的结果")
        ]

# 使用自定义检索器
retriever = CustomRetriever()
results = retriever.invoke("查询")
```

### 带过滤的检索
```python
from langchain_community.vectorstores import Chroma

# 添加元数据过滤
retriever = vectorstore.as_retriever(
    search_kwargs={
        "k": 3,
        "filter": {"category": "技术"}  # 只返回技术类文档
    }
)

results = retriever.invoke("查询")
```

## 禁止事项 ⭐重要

- ❌ 不要返回不相关的文档 - 必须设置合适的相似度阈值
- ❌ 不要忽略元数据 - 元数据对过滤和排序很重要
- ❌ 不要使用过小的 k 值 - 可能会遗漏重要信息
- ❌ 不要在检索器中做复杂计算 - 保持检索器简单高效
- ❌ 不要硬编码检索参数 - 使用配置文件

## 检查清单 ⭐重要

- [ ] 是否选择了合适的向量存储?
- [ ] 是否设置了合适的 k 值?
- [ ] 是否添加了元数据过滤?
- [ ] 是否处理了无结果的情况?
- [ ] 检索性能是否可接受?
- [ ] 是否添加了缓存?
- [ ] 是否进行了相关性评分?

## 注意事项

### 向量存储选择
- **Chroma**: 轻量级，适合原型开发
- **Pinecone**: 云服务，易扩展
- **Weaviate**: 开源，功能丰富
- **FAISS**: 高性能，本地部署

### 检索策略
1. **相似度搜索** - 返回最相似的文档
2. **MMR** - 平衡相关性和多样性
3. **相似度得分阈值** - 只返回超过阈值的文档

### 性能优化
```python
# 批量添加文档
vectorstore.add_documents(documents)

# 使用持久化存储
vectorstore = Chroma(
    persist_directory="./chroma_db",
    embedding_function=embeddings
)

# 添加缓存
from langchain.cache import InMemoryCache
from langchain.globals import set_cache
set_cache(InMemoryCache())
```

### 检索评估
```python
# 评估检索质量
from langchain.evaluation import load_evaluator
from langchain_community.vectorstores import Chroma

evaluator = load_evaluator("retrieval_quality")

# 评估检索结果
results = retriever.invoke("查询")
evaluation = evaluator.evaluate(
    query="查询",
    context=results
)
```

## 最佳实践

1. **数据预处理** - 清洗和分段文档
2. **合理分段** - 按段落或章节分段，保持语义完整
3. **元数据丰富** - 添加来源、时间、类别等元数据
4. **混合检索** - 结合向量检索和关键词检索
5. **重排序** - 使用重排序模型提高准确性
6. **缓存** - 缓存常见查询的结果
7. **监控** - 记录检索准确率和性能指标
