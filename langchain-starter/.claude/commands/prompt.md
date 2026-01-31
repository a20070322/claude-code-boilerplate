# /prompt - 创建提示模板

## 描述
创建 LangChain 提示模板，包括对话模板、少样本模板、部分填充模板等。

## 使用方法
```
/prompt <模板类型> [配置选项]
```

**模板类型:**
- `chat` - ChatPromptTemplate 对话模板
- `fewshot` - 少样本学习模板
- `partial` - 部分填充模板
- `custom` - 自定义模板

**示例:**
```
/prompt chat --role "翻译专家"
/prompt fewshot --examples 3
/prompt partial --variables role,domain
```

## 执行步骤

### 步骤 1: 设计模板
- [ ] 确定模板类型
- [ ] 定义变量列表
- [ ] 设计消息结构
- [ ] 编写示例 (如需要)

### 步骤 2: 创建模板
使用 langchain-prompt 技能:
- [ ] 使用 ChatPromptTemplate
- [ ] 配置消息类型
- [ ] 设置变量占位符
- [ ] 添加系统提示

### 步骤 3: 配置输出
- [ ] 选择输出解析器
- [ ] 定义输出格式
- [ ] 设置格式说明

### 步骤 4: 测试验证
- [ ] 测试变量填充
- [ ] 测试边界情况
- [ ] 验证输出格式
- [ ] 检查 token 使用量

### 步骤 5: 优化完善
- [ ] 优化提示内容
- [ ] 调整示例数量
- [ ] 改进格式说明
- [ ] 添加文档

## 示例执行

### 示例 1: 对话模板
```python
from langchain_core.prompts import ChatPromptTemplate

# 创建模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个专业的{role}，专注于{domain}。"),
    ("human", "{user_input}")
])

# 使用
formatted = prompt.format_messages(
    role="技术顾问",
    domain="人工智能",
    user_input="什么是机器学习?"
)
```

### 示例 2: 少样本模板
```python
from langchain_core.prompts import ChatPromptTemplate, FewShotChatMessagePromptTemplate

# 定义示例
examples = [
    {"input": "开心", "output": "joyful"},
    {"input": "悲伤", "output": "sorrowful"},
]

# 创建少样本模板
example_prompt = ChatPromptTemplate.from_messages([
    ("human", "{input}"),
    ("ai", "{output}")
])

few_shot_prompt = FewShotChatMessagePromptTemplate(
    example_prompt=example_prompt,
    examples=examples
)

# 组合完整模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "翻译以下情感词汇"),
    few_shot_prompt,
    ("human", "{input}")
])
```

### 示例 3: 带输出解析器的模板
```python
from langchain_core.output_parsers import PydanticOutputParser
from pydantic import BaseModel, Field

# 定义输出模型
class SentimentAnalysis(BaseModel):
    sentiment: str = Field(description="positive/negative/neutral")
    confidence: float = Field(description="0-1之间的置信度")
    keywords: list[str] = Field(description="关键词列表")

# 创建解析器
parser = PydanticOutputParser(pydantic_object=SentimentAnalysis)

# 创建提示
prompt = ChatPromptTemplate.from_messages([
    ("system", "分析文本情感。\n{format_instructions}"),
    ("human", "{text}")
])

# 使用
chain = prompt | llm | parser
result = chain.invoke({
    "text": "这个产品太棒了!",
    "format_instructions": parser.get_format_instructions()
})
```

## 注意事项

### 提示工程原则
1. **清晰明确** - 指令要清晰无歧义
2. **提供示例** - 使用少样本学习
3. **指定格式** - 明确输出格式
4. **角色设定** - 给模型分配角色
5. **上下文相关** - 只提供相关信息

### Token 管理
- 估计提示长度
- 移除冗余内容
- 压缩示例数量
- 使用部分填充

### 模板复用
- 定义基础模板
- 通过继承扩展
- 模块化设计

### 版本控制
- 记录模板版本
- A/B 测试效果
- 迭代优化

## 最佳实践

1. **使用 ChatPromptTemplate** - 不要用 PromptTemplate
2. **变量命名清晰** - 使用有意义的变量名
3. **示例代表性** - 选择具有代表性的示例
4. **格式说明详细** - 明确输出格式要求
5. **测试充分** - 测试各种输入情况
6. **文档完整** - 记录设计思路

## 相关技能
- langchain-prompt - 提示模板核心技能
- langchain-chain - 链构建
- langchain-agent - 智能体开发
