#!/usr/bin/env node

/**
 * 会话启动钩子
 * 触发时机: SessionStart (每次启动 Claude Code 会话时)
 * 作用: 显示项目状态、待办事项、快捷命令菜单
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

try {
  // 获取当前时间
  const now = new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });

  // 获取 Git 分支
  let branch = '未初始化';
  let uncommittedChanges = [];

  try {
    branch = execSync('git branch --show-current', { encoding: 'utf-8' }).trim();

    // 获取未提交变更
    const status = execSync('git status --short', { encoding: 'utf-8' }).trim();
    if (status) {
      uncommittedChanges = status.split('\n');
    }
  } catch (e) {
    // Git 不可用
  }

  // 检查是否有待办事项文件
  const todoPath = path.join(process.cwd(), 'TODO.md');
  let todoInfo = '';
  if (fs.existsSync(todoPath)) {
    const content = fs.readFileSync(todoPath, 'utf-8');
    const completed = (content.match(/\[x\]/g) || []).length;
    const total = (content.match(/\[[ x]\]/g) || []).length;
    const pending = total - completed;
    todoInfo = `\n📋 **待办事项**: ${pending} 未完成 / ${completed} 已完成`;
  }

  // 构建输出
  const output = `
## 🚀 Claude Code 会话已启动
**时间**: ${now}
**目录**: ${path.basename(process.cwd())}
**Git 分支**: \`${branch}\`${uncommittedChanges.length > 0 ? `

⚠️ **未提交变更** (${uncommittedChanges.length} 个文件):
${uncommittedChanges.map(f => `  ${f}`).join('\n')}` : ''}${todoInfo}

💡 **快捷命令**:
| /dev  | 开发新功能 (7步流程) |
| /plan | 创建实现计划 |
`;

  console.log(output);
} catch (error) {
  console.error('SessionStart hook error:', error.message);
}
