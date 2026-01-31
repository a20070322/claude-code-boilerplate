# /check - 检查配置和代码

## 描述
检查 LangChain 项目的配置和代码质量，确保遵循最佳实践。

## 使用方法
```
/check [检查范围]
```

**检查范围:**
- `all` - 全面检查 (默认)
- `config` - 仅检查配置
- `code` - 仅检查代码
- `dependencies` - 检查依赖

**示例:**
```
/check              # 全面检查
/check config       # 检查配置文件
/check code         # 检查代码质量
```

## 执行步骤

### 步骤 1: 环境检查
- [ ] Python 版本 >= 3.9
- [ ] 依赖包版本兼容
- [ ] 环境变量配置
- [ ] API 密钥有效

### 步骤 2: 配置检查
- [ ] settings.json 格式正确
- [ ] Hook 文件可执行
- [ ] 技能定义完整
- [ ] 命令配置有效

### 步骤 3: 代码规范检查
- [ ] 使用 LCEL 语法
- [ ] 类型注解完整
- [ ] 文档字符串存在
- [ ] 错误处理完善

### 步骤 4: 安全检查
- [ ] API 密钥未硬编码
- [ ] 输入验证存在
- [ ] 没有注入漏洞
- [ ] 敏感数据已加密

### 步骤 5: 性能检查
- [ ] 无内存泄漏
- [ ] 无阻塞调用
- [ ] 使用了缓存
- [ ] 设置了超时

### 步骤 6: 生成报告
- [ ] 汇总检查结果
- [ ] 列出问题清单
- [ ] 提供修复建议
- [ ] 生成评分

## 检查项目清单

### LangChain 最佳实践
- [ ] 使用 ChatPromptTemplate 而不是 PromptTemplate
- [ ] 使用 LCEL (`|` 操作符) 构建链
- [ ] 使用 `invoke()` 而不是 `run()`
- [ ] 使用新版 Agent API (create_tool_calling_agent)
- [ ] 工具函数有类型注解和文档字符串
- [ ] 提示模板有明确的输出格式说明
- [ ] 检索器设置了合理的 k 值
- [ ] 记忆组件配置了持久化
- [ ] Agent 设置了 max_iterations
- [ ] 启用了错误处理 (handle_parsing_errors)

### 代码质量
- [ ] 遵循 PEP 8 规范
- [ ] 函数有类型注解
- [ ] 有完整的文档字符串
- [ ] 有单元测试
- [ ] 错误处理完善
- [ ] 日志记录充分

### 安全性
- [ ] API 密钥使用环境变量
- [ ] 用户输入已验证
- [ ] 没有硬编码的敏感信息
- [ ] 工具函数有权限检查

### 性能
- [ ] 使用了批量处理
- [ ] 实现了结果缓存
- [ ] 设置了合理的超时
- [ ] 避免了阻塞操作

## 示例输出

```
## LangChain 项目检查报告

### ✅ 环境检查 (通过)
- Python: 3.11.0 ✓
- langchain: 0.2.0 ✓
- langchain-anthropic: 0.2.0 ✓

### ✅ 配置检查 (通过)
- settings.json: 有效 ✓
- hooks: 3个钩子已配置 ✓
- skills: 5个技能已定义 ✓

### ⚠️ 代码检查 (发现问题)

**chain.py:12**
- 问题: 使用了已弃用的 LLMChain
- 建议: 使用 LCEL 语法重构
- 优先级: 高

**agent.py:45**
- 问题: 缺少类型注解
- 建议: 为函数参数和返回值添加类型注解
- 优先级: 中

**retriever.py:20**
- 问题: 未设置 k 值
- 建议: 设置 search_kwargs={"k": 5}
- 优先级: 低

### ✅ 安全检查 (通过)
- API 密钥未硬编码 ✓
- 输入验证已添加 ✓

### 📊 总体评分: 75/100

### 🔧 修复建议
1. 重构 chain.py 使用 LCEL
2. 添加类型注解
3. 配置检索器参数
```

## 注意事项

1. **定期检查** - 每次提交前运行检查
2. **修复优先级** - 优先处理高优先级问题
3. **持续改进** - 根据检查结果优化代码
4. **记录问题** - 跟踪未修复的问题

## 自动化检查

可以将 /check 集成到 CI/CD 流程:

```yaml
# .github/workflows/check.yml
name: LangChain Check

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run check
        run: |
          python -m pytest tests/
          mypy .
          black --check .
```

## 相关技能
- 所有 LangChain 技能
- @chain-reviewer - 代码审查代理
