# LangChain 链配置表

> 请填写以下信息，创建 LangChain LCEL 链

## 📋 基本信息

**链类型**:
- [ ] 基础链（简单顺序链）
- [ ] RAG 链（检索增强生成）
- [ ] 路由链（条件分支）
- [ ] 顺序链（多步骤链）

**链的用途**: _____

## 🔧 组件定义

### 1. Prompt 模板
- **模板内容**: _____
- **输入变量**: _____
- **系统提示**: _____

### 2. LLM
- **模型**: _____（claude-3-5-sonnet-20241022 推荐）
- **Temperature**: _____（0-1）

### 3. Output Parser
- [ ] StrOutputParser（字符串）
- [ ] PydanticOutputParser（结构化）
- [ ] JsonOutputParser（JSON）
- [ ] Custom Parser（自定义）

### 4. 可选组件
- [ ] Retriever（检索器）
- [ ] Memory（记忆）
- [ ] Tools（工具）

## ⚙️ 链配置

**是否需要错误处理？**
- [ ] 是（使用 with_fallbacks()）
- [ ] 否

**是否需要批处理？**
- [ ] 是（使用 RunnableParallel）
- [ ] 否（顺序执行）

**是否需要路由？**
- [ ] 是（使用 RunnableBranch）
- [ ] 否

## 📝 生成内容确认

- [ ] 链定义文件
- [ ] 提示模板
- [ ] 输出解析器
- [ ] 使用示例

---
