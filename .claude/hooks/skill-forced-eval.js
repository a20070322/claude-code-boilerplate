#!/usr/bin/env node

/**
 * 强制技能评估钩子
 * 触发时机: UserPromptSubmit (用户每次提交问题时)
 * 作用: 强制 AI 评估并激活相关技能,激活率从 25% → 90%+
 */

const fs = require('fs');
const path = require('path');

// 读取用户输入
const prompt = process.argv.slice(2).join(' ');

// 检测是否为斜杠命令,如果是则跳过评估
const isSlashCommand = /^\/[^\/\s]+$/.test(prompt.split(/\s/)[0]);
if (isSlashCommand) {
  process.exit(0);
}

// 定义可用技能列表 (根据项目需要自定义)
const skills = [
  'doc-development',
  'template-dev',
  'config-validator',
  'project-explorer'
];

// 检查是否有自定义技能配置
const skillsDir = path.join(process.cwd(), '.claude/skills');
if (fs.existsSync(skillsDir)) {
  const skillFolders = fs.readdirSync(skillsDir, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);

  // 合并自定义技能
  skillFolders.forEach(skill => {
    if (!skills.includes(skill)) {
      skills.push(skill);
    }
  });
}

// 生成技能评估指令
const instructions = `## 指令:强制技能激活流程(必须执行)

### 步骤 1 - 评估
针对以下每个技能,陈述: [技能名] - 是/否 - [理由]

可用技能列表:
${skills.map(s => `- ${s}`).join('\n')}

### 步骤 2 - 激活
如果任何技能为"是" → 立即使用 Skill() 工具激活
如果所有技能为"否" → 说明"不需要技能"并继续

### 步骤 3 - 实现
只有在步骤 2 完成后,才能开始实现。
`;

// 输出指令
console.log(instructions);
