/**
 * 任务完成钩子 - 显示检查清单和建议
 */
export async function stop(context) {
  console.log(`
## 📋 LangChain 开发任务完成总结

### ✅ 检查清单

**代码规范:**
- [ ] 使用了类型注解 (Type Hints)
- [ ] 添加了文档字符串 (Docstrings)
- [ ] 遵循了 PEP 8 规范
- [ ] 错误处理已完善

**LangChain 最佳实践:**
- [ ] 使用了 LCEL (LangChain Expression Language)
- [ ] 链的输入输出类型明确
- [ ] 提示模板使用了 ChatPromptTemplate
- [ ] 记忆组件正确配置
- [ ] 检索器有相关度评分

**测试:**
- [ ] 单元测试已编写
- [ ] 集成测试已通过
- [ ] 边界情况已处理

**文档:**
- [ ] README 已更新
- [ ] API 文档已补充
- [ ] 示例代码已提供

### 📝 建议操作

1. **运行测试**: \`python -m pytest tests/\`
2. **类型检查**: \`mypy .\`
3. **代码格式化**: \`black . && isort .\`
4. **使用 @chain-reviewer 审查代码**

### 🎯 下一步

- 继续开发其他功能
- 优化性能
- 添加监控和日志
- 编写更多测试
  `);

  return { proceed: true };
}
