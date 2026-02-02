# LangChain Agent 完整示例

## 1. 工具调用 Agent（Tool Calling Agent）

### 基础实现

```python
# agents/tool_calling_agent.py
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain.tools import tool
from typing import Literal

# 定义工具
@tool
def get_weather(city: str) -> str:
    """获取指定城市的天气信息

    Args:
        city: 城市名称，如 "北京"、"上海"

    Returns:
        天气信息字符串
    """
    weather_data = {
        "北京": "晴天，气温 25°C",
        "上海": "多云，气温 28°C",
        "深圳": "阴天，气温 30°C",
        "广州": "阵雨，气温 29°C",
    }
    return weather_data.get(city, f"抱歉，没有 {city} 的天气信息")

@tool
def calculator(expression: str) -> str:
    """计算数学表达式

    Args:
        expression: 数学表达式，如 "2 + 2" 或 "10 * 5"

    Returns:
        计算结果
    """
    try:
        result = eval(expression)
        return f"计算结果: {result}"
    except Exception as e:
        return f"计算错误: {str(e)}"

@tool
def search_database(query: str) -> str:
    """在数据库中搜索信息

    Args:
        query: 搜索查询语句

    Returns:
        搜索结果
    """
    # 模拟数据库搜索
    return f"数据库搜索结果: 找到 3 条与 '{query}' 相关的记录"

# 工具列表
tools = [get_weather, calculator, search_database]

# 定义 LLM
llm = ChatAnthropic(
    model="claude-3-5-sonnet-20241022",
    temperature=0  # Agent 使用 0 获得确定性输出
)

# 定义提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个有帮助的 AI 助手。使用可用的工具来回答用户的问题。"),
    ("placeholder", "{chat_history}"),  # 对话历史占位符
    ("human", "{input}"),  # 用户输入
    ("placeholder", "{agent_scratchpad}")  # Agent 思考过程占位符
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建 Agent 执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,  # 开发时开启，生产环境关闭
    handle_parsing_errors=True,  # 处理解析错误
    max_iterations=10,  # 最大迭代次数
    return_intermediate_steps=True  # 返回中间步骤
)

# 运行 Agent
if __name__ == "__main__":
    # 示例 1: 查询天气
    result1 = agent_executor.invoke({
        "input": "北京今天天气怎么样？"
    })
    print("=== 天气查询 ===")
    print(result1["output"])
    print()

    # 示例 2: 计算
    result2 = agent_executor.invoke({
        "input": "帮我计算 123 乘以 456"
    })
    print("=== 数学计算 ===")
    print(result2["output"])
    print()

    # 示例 3: 数据库搜索
    result3 = agent_executor.invoke({
        "input": "在数据库中搜索用户信息"
    })
    print("=== 数据库搜索 ===")
    print(result3["output"])
```

### 带对话记忆的 Agent

```python
# agents/agent_with_memory.py
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain.memory import ConversationBufferMemory
from langchain.tools import tool

# 定义工具
@tool
def get_user_info(user_id: str) -> str:
    """获取用户信息

    Args:
        user_id: 用户 ID

    Returns:
        用户信息
    """
    users = {
        "1001": "张三，邮箱: zhangsan@example.com",
        "1002": "李四，邮箱: lisi@example.com",
    }
    return users.get(user_id, f"用户 {user_id} 不存在")

# 工具列表
tools = [get_user_info]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 创建记忆组件
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True,
    output_key="output"  # 重要：指定输出键
)

# 定义提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个客户服务助手。记住之前的对话内容以提供更好的服务。"),
    ("placeholder", "{chat_history}"),  # 这会被记忆填充
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建带记忆的执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    memory=memory,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=5
)

# 多轮对话
if __name__ == "__main__":
    # 第一轮对话
    print("=== 第一轮对话 ===")
    result1 = agent_executor.invoke({
        "input": "查询用户 1001 的信息"
    })
    print(result1["output"])
    print()

    # 第二轮对话（Agent 记住了上下文）
    print("=== 第二轮对话 ===")
    result2 = agent_executor.invoke({
        "input": "他的邮箱是什么？"  # Agent 知道"他"指的是用户 1001
    })
    print(result2["output"])
```

### 异步工具 Agent

```python
# agents/async_agent.py
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain.tools import tool
import asyncio
import aiohttp

# 定义异步工具
@tool
async def async_search_news(topic: str) -> str:
    """异步搜索新闻

    Args:
        topic: 搜索主题

    Returns:
        新闻内容
    """
    # 模拟异步 API 调用
    await asyncio.sleep(1)  # 模拟网络延迟
    return f"关于 '{topic}' 的最新新闻: 这是一条模拟新闻"

@tool
async def async_fetch_data(url: str) -> str:
    """异步获取网页数据

    Args:
        url: 网页 URL

    Returns:
        网页内容
    """
    # 实际应用中可以使用 aiohttp
    await asyncio.sleep(0.5)
    return f"从 {url} 获取的数据内容"

# 工具列表
tools = [async_search_news, async_fetch_data]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义提示
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个研究助手，可以异步搜索信息和获取数据。"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=False,
    handle_parsing_errors=True,
    max_iterations=5
)

# 运行异步 Agent
async def main():
    result = await agent_executor.ainvoke({
        "input": "搜索关于人工智能的新闻"
    })
    print(result["output"])

if __name__ == "__main__":
    asyncio.run(main())
```

## 2. ReAct Agent

```python
# agents/react_agent.py
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_react_agent, AgentExecutor
from langchain import hub
from langchain.tools import Tool
from langchain_community.utilities import SerpAPIWrapper

# 定义工具
search = SerpAPIWrapper()
search_tool = Tool(
    name="Search",
    func=search.run,
    description="用于搜索互联网信息，获取最新的数据和新闻"
)

tools = [search_tool]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 获取 ReAct 提示模板
prompt = hub.pull("hwchase17/react")

# 创建 ReAct Agent
agent = create_react_agent(llm, tools, prompt)

# 创建执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=5
)

# 运行
if __name__ == "__main__":
    result = agent_executor.invoke({
        "input": "最新的人工智能发展趋势是什么？"
    })
    print(result["output"])
```

## 3. 结构化输出 Agent

```python
# agents/structured_output_agent.py
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain.tools import tool
from langchain_core.pydantic_v1 import BaseModel, Field

# 定义输出模型
class WeatherReport(BaseModel):
    """天气报告"""
    city: str = Field(description="城市名称")
    temperature: int = Field(description="温度（摄氏度）")
    condition: str = Field(description="天气状况")
    humidity: int = Field(description="湿度（百分比）")

@tool
def generate_weather_report(city: str) -> WeatherReport:
    """生成天气报告

    Args:
        city: 城市名称

    Returns:
        结构化的天气报告
    """
    # 模拟数据
    report = WeatherReport(
        city=city,
        temperature=25,
        condition="晴天",
        humidity=60
    )
    return report

@tool
def analyze_data(data: str) -> dict:
    """分析数据并返回结构化结果

    Args:
        data: 要分析的数据

    Returns:
        包含分析结果的结构化字典
    """
    return {
        "summary": "数据分析完成",
        "key_insights": ["洞察1", "洞察2"],
        "recommendations": ["建议1", "建议2"]
    }

# 工具列表
tools = [generate_weather_report, analyze_data]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义提示
prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个数据分析助手。使用工具生成结构化的报告。"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=False,
    handle_parsing_errors=True,
    max_iterations=5
)

# 运行
if __name__ == "__main__":
    result = agent_executor.invoke({
        "input": "生成北京的天气报告"
    })
    print(result["output"])
```

## 4. 多工具复杂 Agent

```python
# agents/complex_agent.py
from langchain_anthropic import ChatAnthropic
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate
from langchain.tools import tool
from typing import List, Dict
import json

# 定义多个工具
@tool
def read_file(file_path: str) -> str:
    """读取文件内容

    Args:
        file_path: 文件路径

    Returns:
        文件内容
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        return f"读取文件错误: {str(e)}"

@tool
def write_file(file_path: str, content: str) -> str:
    """写入文件

    Args:
        file_path: 文件路径
        content: 文件内容

    Returns:
        操作结果
    """
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return f"成功写入文件: {file_path}"
    except Exception as e:
        return f"写入文件错误: {str(e)}"

@tool
def list_files(directory: str) -> str:
    """列出目录中的文件

    Args:
        directory: 目录路径

    Returns:
        文件列表
    """
    import os
    try:
        files = os.listdir(directory)
        return json.dumps(files, ensure_ascii=False, indent=2)
    except Exception as e:
        return f"列出文件错误: {str(e)}"

@tool
def execute_python(code: str) -> str:
    """执行 Python 代码（仅用于简单计算）

    Args:
        code: Python 代码

    Returns:
        执行结果
    """
    try:
        # 注意：生产环境要非常谨慎执行代码
        result = eval(code)
        return f"执行结果: {result}"
    except Exception as e:
        return f"执行错误: {str(e)}"

@tool
def web_search(query: str) -> str:
    """网络搜索

    Args:
        query: 搜索查询

    Returns:
        搜索结果
    """
    # 模拟搜索结果
    return f"搜索 '{query}' 的结果: 这是一条模拟搜索结果"

# 工具列表
tools = [read_file, write_file, list_files, execute_python, web_search]

# 定义 LLM
llm = ChatAnthropic(model="claude-3-5-sonnet-20241022", temperature=0)

# 定义系统提示
system_prompt = """你是一个功能强大的 AI 助手，可以使用多种工具来完成复杂任务。

使用指南：
1. 读取文件前先列出目录
2. 执行代码前先确认代码安全
3. 写入文件前先确认路径正确
4. 搜索信息时提供详细的关键词

遵循以下原则：
- 逐步完成任务，不要急躁
- 每一步都确认结果
- 遇到错误时尝试恢复
- 必要时向用户请求澄清
"""

# 定义提示
prompt = ChatPromptTemplate.from_messages([
    ("system", system_prompt),
    ("placeholder", "{chat_history}"),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}")
])

# 创建 Agent
agent = create_tool_calling_agent(llm, tools, prompt)

# 创建执行器
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=15,  # 复杂任务可能需要更多迭代
    early_stopping_method="generate"  # 早停策略
)

# 运行示例
if __name__ == "__main__":
    # 示例：文件操作
    result = agent_executor.invoke({
        "input": "帮我列出当前目录的文件，然后读取 README.md 文件的内容"
    })
    print(result["output"])
```

## 快速参考

### 工具定义模板
```python
from langchain.tools import tool

@tool
def my_tool(param1: str, param2: int) -> str:
    """工具描述（Agent 会根据描述选择工具）

    Args:
        param1: 参数1说明
        param2: 参数2说明

    Returns:
        返回值说明
    """
    # 实现逻辑
    return "结果"
```

### Agent 创建步骤
1. 定义工具（使用 @tool 装饰器）
2. 创建 LLM 实例
3. 创建提示模板
4. 调用 create_tool_calling_agent()
5. 创建 AgentExecutor
6. 调用 invoke()

### 重要配置
```python
AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,                    # 开发时开启
    handle_parsing_errors=True,      # 启用错误处理
    max_iterations=10,               # 限制迭代次数
    return_intermediate_steps=True,  # 返回中间步骤
    early_stopping_method="generate" # 早停策略
)
```

### 性能优化
- 使用异步工具提高并发性能
- 设置合理的 max_iterations
- 生产环境关闭 verbose
- 添加结果缓存
- 批量处理请求
