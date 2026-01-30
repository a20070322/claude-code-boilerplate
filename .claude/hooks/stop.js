#!/usr/bin/env node

/**
 * 停止钩子
 * 触发时机: Stop (AI 完成回答后)
 * 作用: 分析代码变更,推荐下一步操作
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

try {
  // 获取 Git 变更统计
  let changes = [];
  let changeSummary = '未检测到文件变更';

  try {
    // 获取当前会话修改的文件
    const status = execSync('git status --short', { encoding: 'utf-8' }).trim();
    if (status) {
      changes = status.split('\n');
      changeSummary = `检测到 ${changes.length} 个文件变更`;
    }
  } catch (e) {
    // Git 不可用
  }

  // 分析变更类型并生成建议
  let suggestions = [];

  if (changes.length > 0) {
    const hasClaudeConfig = changes.some(f => f.includes('.claude/'));
    const hasDocs = changes.some(f => f.match(/\.md$/i));
    const hasHooks = changes.some(f => f.includes('/hooks/'));

    if (hasClaudeConfig) {
      suggestions.push('• 配置文件已变更,建议使用 `check` 验证');
    }
    if (hasDocs) {
      suggestions.push('• 文档已更新,建议检查链接和格式');
    }
    if (hasHooks) {
      suggestions.push('• Hook 脚本已变更,确保有执行权限 (chmod +x)');
    }

    suggestions.push('• 使用 `git add . && git commit -m "xxx"` 提交代码');
  }

  // 构建输出
  const output = `
---
✅ **任务完成** | ${changeSummary}${changes.length > 0 ? `
${changes.slice(0, 10).map(f => `  ${f}`).join('\n')}${changes.length > 10 ? `\n  ... 还有 ${changes.length - 10} 个文件` : ''}` : ''}${suggestions.length > 0 ? `

**建议操作**:
${suggestions.join('\n')}` : ''}
`;

  console.log(output);
} catch (error) {
  // 静默失败,不影响正常使用
  process.exit(0);
}
