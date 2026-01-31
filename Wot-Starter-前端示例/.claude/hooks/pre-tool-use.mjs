/**
 * Pre Tool Use Hook
 * 拦截危险命令，防止误操作
 */

export async function preToolUse(context) {
  const { toolName, toolInput } = context;

  // 危险命令列表
  const dangerousPatterns = [
    { pattern: /rm\s+-rf\s+\//, message: '⚠️ 警告：正在删除根目录！' },
    { pattern: /rm\s+-rf\s+\.+/, message: '⚠️ 警告：正在删除大量文件！' },
    { pattern: /git\s+reset\s+--hard/, message: '⚠️ 警告：这将丢弃所有未提交的更改！' },
    { pattern: /git\s+clean\s+-fd/, message: '⚠️ 警告：这将删除所有未跟踪的文件！' },
    { pattern: /npm\s+uninstall\s+wot-design-uni/, message: '⚠️ 警告：不能移除核心依赖 wot-design-uni！' },
    { pattern: /pnpm\s+remove\s+wot-design-uni/, message: '⚠️ 警告：不能移除核心依赖 wot-design-uni！' },
  ];

  // 检查 Bash 命令
  if (toolName === 'Bash' && toolInput.command) {
    for (const { pattern, message } of dangerousPatterns) {
      if (pattern.test(toolInput.command)) {
        return {
          proceed: false,
          message: `${message}\n\n如果确定要执行，请使用更具体的路径。`
        };
      }
    }
  }

  return { proceed: true };
}
