/**
 * 会话启动钩子 - 显示 LangChain 项目信息
 */
export async function sessionStart(context) {
  const branch = context.env.GIT_BRANCH || "unknown";

  console.log(`
## 🦜 LangChain 项目会话已启动

**时间**: ${new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' })}
**Git 分支**: \`${branch}\`
**工作目录**: ${process.cwd()}

💡 **快捷命令**:
| 命令 | 说明 |
| /chain | 创建 LangChain 链 |
| /agent | 创建 LangChain 智能体 |
| /prompt | 创建提示模板 |
| /retriever | 创建检索器 |
| /check | 检查配置和代码 |

🎯 **核心技能**:
- \`langchain-chain\` - 构建链 (LCEL链、顺序链等)
- \`langchain-agent\` - 开发智能体 (ReAct、工具调用等)
- \`langchain-prompt\` - 管理提示模板
- \`langchain-retriever\` - 实现检索器
- \`langchain-memory\` - 配置记忆组件

🤖 **可用代理**:
- \`@chain-reviewer\` - 审查链的设计和实现

📚 **快速开始**:
1. 使用 /chain 创建第一个链
2. 使用 /agent 创建智能体
3. 参考 .claude/CLAUDE.md 了解详细规范
  `);

  return { proceed: true };
}
