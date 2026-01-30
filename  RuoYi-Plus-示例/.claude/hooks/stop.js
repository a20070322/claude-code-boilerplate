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
    // 获取当前会话修改的文件 (最近10分钟)
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
    const hasJava = changes.some(f => f.includes('.java'));
    const hasVue = changes.some(f => f.includes('.vue'));
    const hasSql = changes.some(f => f.includes('.sql'));
    const hasTypeScript = changes.some(f => f.includes('.ts') || f.includes('.tsx'));

    if (hasJava) {
      suggestions.push('• 使用 @code-reviewer 审查后端代码');
    }
    if (hasVue || hasTypeScript) {
      suggestions.push('• 前端代码已变更,建议进行功能测试');
    }
    if (hasSql) {
      suggestions.push('• SQL 文件有变更,确保更新所有数据库脚本');
    }

    suggestions.push('• 使用 `git add . && git commit -m "feat: xxx"` 提交代码');
  }

  // 检查是否有临时文件需要清理
  const tempFiles = [];
  try {
    if (fs.existsSync('nul')) {
      tempFiles.push('nul');
    }
  } catch (e) {
    // 忽略
  }

  // 构建输出
  const output = `
---
✅ **任务完成** | ${changeSummary}${changes.length > 0 ? `
${changes.slice(0, 10).map(f => `  ${f}`).join('\n')}${changes.length > 10 ? `\n  ... 还有 ${changes.length - 10} 个文件` : ''}` : ''}${suggestions.length > 0 ? `

**建议操作**:
${suggestions.join('\n')}` : ''}${tempFiles.length > 0 ? `

**清理临时文件**:
${tempFiles.map(f => `• 删除 ${f}`)}` : ''}

**快捷命令**:
• /update-status - 更新项目状态
• /add-todo - 添加待办事项
`;

  console.log(output);
} catch (error) {
  // 静默失败,不影响正常使用
  process.exit(0);
}
