#!/usr/bin/env node

/**
 * 预工具使用钩子
 * 触发时机: PreToolUse (AI 执行 Bash 命令或写入文件之前)
 * 作用: 拦截危险命令,警告敏感操作
 */

// 危险命令黑名单
const dangerousPatterns = [
  { pattern: /rm\s+(-rf?|--recursive).*\//, name: 'rm -rf / (递归删除根目录)' },
  { pattern: /drop\s+(database|table)/i, name: 'DROP DATABASE/TABLE (删除数据库或表)' },
  { pattern: /truncate\s+table/i, name: 'TRUNCATE TABLE (清空表)' },
  { pattern: /format\s+[a-z]:/i, name: 'FORMAT (格式化磁盘)' },
  { pattern: />\s*\/dev\/sda/, name: '直接写入磁盘设备' },
  { pattern: /dd\s+if=.*of=\/dev\/sd/, name: 'dd 命令写入磁盘' },
  { pattern: /chmod\s+000\s+\//, name: 'chmod 000 / (锁定系统)' },
  { pattern: /:(){ :|:& };:/, name: 'Fork 炸弹' }
];

// 敏感操作警告
const warningPatterns = [
  { pattern: /rm\s+.*\.(js|ts|py|java|go|rs|vue|jsx|tsx)$/i, name: '删除源代码文件' },
  { pattern: /git\s+reset\s+--hard/, name: 'Git 硬重置' },
  { pattern: /git\s+clean\s+-fd/, name: 'Git 清理未跟踪文件' },
  { pattern: /npm\s+uninstall/, name: '卸载 npm 包' }
];

try {
  // 读取工具调用参数 (从 stdin)
  let inputData = '';
  process.stdin.setEncoding('utf-8');
  process.stdin.on('data', (chunk) => {
    inputData += chunk;
  });

  process.stdin.on('end', () => {
    try {
      const data = JSON.parse(inputData);

      // 只检查 Bash 命令
      if (data.tool !== 'Bash') {
        console.log(JSON.stringify({ decision: 'allow' }));
        process.exit(0);
      }

      const command = data.command || '';

      // 检查危险命令
      for (const { pattern, name } of dangerousPatterns) {
        if (pattern.test(command)) {
          console.log(JSON.stringify({
            decision: 'block',
            reason: `检测到危险命令: ${name}\n命令: ${command}\n\n该操作已被阻止。如果确实需要执行,请手动在终端中执行。`
          }));
          process.exit(0);
        }
      }

      // 检查敏感操作
      for (const { pattern, name } of warningPatterns) {
        if (pattern.test(command)) {
          console.log(JSON.stringify({
            decision: 'warn',
            reason: `⚠️ 警告: ${name}\n命令: ${command}\n\n请确认此操作是否正确。`
          }));
          process.exit(0);
        }
      }

      // 允许执行
      console.log(JSON.stringify({ decision: 'allow' }));
      process.exit(0);
    } catch (e) {
      // 解析失败,允许执行
      console.log(JSON.stringify({ decision: 'allow' }));
      process.exit(0);
    }
  });
} catch (error) {
  console.log(JSON.stringify({ decision: 'allow' }));
  process.exit(0);
}
