# LangChain 记忆组件配置表

## 📋 基本信息

**记忆类型**:
- [ ] ConversationBufferMemory（简单缓冲）
- [ ] ConversationBufferWindowMemory（滑动窗口）
- [ ] ConversationSummaryMemory（摘要记忆）
- [ ] VectorStoreMemory（向量存储）
- [ ] 自定义记忆

**使用场景**: _____

## 💾 存储配置

**是否持久化？**
- [ ] 是（Redis/PostgreSQL/SQLite）
- [ ] 否（仅在内存中）

**存储后端**:
- [ ] Redis（推荐）
- [ ] PostgreSQL
- [ ] SQLite
- [ ] 自定义

## ⚙️ 记忆参数

**最大历史轮数**: _____（window k 值）

**摘要策略**:
- [ ] 滚动摘要
- [ ] 最近摘要
- [ ] 自定义摘要

**会话管理**:
- [ ] 单会话
- [ ] 多会话（需要 session_id）

---
