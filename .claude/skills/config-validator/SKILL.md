# 配置验证技能

## 触发条件
- 关键词: 配置、settings、验证、检查
- 场景: 创建或修改 .claude 配置文件时

## 验证清单

### settings.json 验证
- [ ] JSON 格式正确
- [ ] hooks 节点完整
- [ ] 每个 hook 有 matcher 和 command
- [ ] permissions 配置正确

### CLAUDE.md 验证
- [ ] 项目概述清晰
- [ ] 核心规范明确
- [ ] 快捷命令列表完整
- [ ] 技能列表准确
- [ ] 代理列表准确

### Hooks 验证
- [ ] JavaScript 语法正确
- [ ] 文件有执行权限 (chmod +x)
- [ ] 错误处理完善
- [ ] 不会阻塞正常使用

### Skills 验证
- [ ] 每个 skill 有 SKILL.md
- [ ] 触发条件明确
- [ ] 规范内容完整
- [ ] 有检查清单

### Commands 验证
- [ ] 命令文件是 .md 格式
- [ ] 有描述和使用方法
- [ ] 有执行步骤
- [ ] 有注意事项

### Agents 验证
- [ ] 每个 agent 有 AGENT.md
- [ ] 触发方式明确
- [ ] 职责范围清晰
- [ ] 有使用示例

## 常见问题

### JSON 格式错误
**检查:** 使用 JSON 验证工具

### Hook 不触发
**检查:**
1. settings.json 中路径是否正确
2. 文件是否有执行权限
3. Node.js 是否已安装

### 技能不激活
**检查:**
1. skill-forced-eval.js 中是否包含该技能
2. SKILL.md 是否在正确的目录
3. 触发条件是否明确
