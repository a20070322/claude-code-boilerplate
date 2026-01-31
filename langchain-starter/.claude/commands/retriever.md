# /retriever - 创建检索器

## 描述
创建 LangChain 检索器，用于实现 RAG (检索增强生成) 和文档问答系统。

## 使用方法
```
/retriever <检索器类型> [配置选项]
```

**检索器类型:**
- `basic` - 基础向量检索
- `mmr` - MMR 多样性检索
- `similarity` - 相似度检索
- `custom` - 自定义检索器

**配置选项:**
- `--vector-store <类型>` - 向量存储 (chroma/pinecone/weaviate)
- `--k <数量>` - 返回文档数
- `--filter <字段>` - 元数据过滤

**示例:**
```
/retriever basic --vector-store chroma --k 5
/retriever mmr --k 3 --diversity 0.5
/retriever custom --type hybrid
```

## 执行步骤

### 步骤 1: 准备文档
- [ ] 收集源文档
- [ ] 清洗文档内容
- [ ] 分段处理
- [ ] 添加元数据

### 步骤 2: 选择向量存储
- [ ] 评估存储需求
- [ ] 选择向量数据库
- [ ] 配置连接参数
- [ ] 创建向量存储

### 步骤 3: 创建检索器
使用 langchain-retriever 技能:
- [ ] 配置检索策略
- [ ] 设置返回数量
- [ ] 配置过滤条件
- [ ] 测试检索效果

### 步骤 4: 构建 RAG 链
- [ ] 设计提示模板
- [ ] 格式化检索结果
- [ ] 组合完整链
- [ ] 测试端到端

### 步骤 5: 优化性能
- [ ] 添加缓存
- [ ] 优化索引
- [ ] 调整参数
- [ ] 持久化存储

### 步骤 6: 评估监控
- [ ] 评估检索质量
- [ ] 监控性能
- [ ] 收集反馈
- [ ] 迭代优化

## 示例执行

### 示例 1: 基础向量检索
```python
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_core.documents import Document

# 准备文档
documents = [
    Document(page_content="LangChain 是一个 LLM 应用框架。", metadata={"source": "doc1"}),
    Document(page_content="Chroma 是一个向量数据库。", metadata={"source": "doc1"}),
]

# 创建向量存储
vectorstore = Chroma.from_documents(
    documents=documents,
    embedding=OpenAIEmbeddings()
)

# 创建检索器
retriever = vectorstore.as_retriever(
    search_type="similarity",
    search_kwargs={"k": 3}
)

# 使用
results = retriever.invoke("什么是 LangChain?")
for doc in results:
    print(f"{doc.page_content} (来源: {doc.metadata['source']})")
```

### 示例 2: 完整 RAG 链
```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_anthropic import ChatAnthropic

# 创建检索器
vectorstore = Chroma.from_documents(
    documents=documents,
    embedding=OpenAIEmbeddings()
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})

# 构建链
prompt = ChatPromptTemplate.from_template("""
上下文:
{context}

问题: {question}

根据上下文回答问题。如果上下文中没有相关信息，就说"我不知道"。
""")

def format_docs(docs):
    return "\n\n".join([d.page_content for d in docs])

rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | ChatAnthropic(model="claude-3-5-sonnet-20241022")
    | StrOutputParser()
)

# 查询
answer = rag_chain.invoke("什么是 LangChain?")
```

### 示例 3: 带过滤的检索
```python
# 创建带过滤的检索器
retriever = vectorstore.as_retriever(
    search_kwargs={
        "k": 5,
        "filter": {"category": "技术"}  # 只返回技术类文档
    }
)

results = retriever.invoke("查询")
```

## 注意事项

### 文档处理
- **分段长度** - 建议 500-1000 字符
- **重叠部分** - 建议 10-20% 重叠
- **元数据丰富** - 添加来源、类别、时间等
- **清洗数据** - 去除无用字符和格式

### 向量存储选择
- **Chroma** - 轻量级，适合开发
- **Pinecone** - 云服务，易扩展
- **Weaviate** - 开源，功能丰富
- **FAISS** - 高性能，本地部署

### 检索策略
- **相似度** - 返回最相似的文档
- **MMR** - 平衡相关性和多样性
- **阈值过滤** - 只返回高相关度文档

### 性能优化
- 批量添加文档
- 使用持久化存储
- 添加结果缓存
- 异步检索

## 评估指标

- **准确率** - 检索结果的相关性
- **召回率** - 是否检索到所有相关文档
- **延迟** - 检索响应时间
- **吞吐量** - 每秒处理的查询数

## 最佳实践

1. **数据预处理** - 充分清洗和分段
2. **元数据管理** - 丰富的元数据提升效果
3. **混合检索** - 结合向量和关键词
4. **重排序** - 使用重排序模型
5. **缓存策略** - 缓存常见查询
6. **监控告警** - 监控检索质量和性能
7. **A/B 测试** - 对比不同策略

## 相关技能
- langchain-retriever - 检索器核心技能
- langchain-chain - RAG 链构建
- langchain-prompt - 提示模板设计
