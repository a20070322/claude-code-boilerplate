// 任务停止钩子 - 图结构检查
export async function stop(context) {
  const { files } = context;

  // 检查是否修改了 .py 文件
  const pyFiles = files.filter(f => f.path.endsWith('.py'));

  if (pyFiles.length > 0) {
    console.log(`
## 📋 LangGraph 图结构检查清单

### ✅ 状态定义检查
- [ ] 状态类是否继承 TypedDict？
- [ ] 消息字段是否使用 Annotated[Sequence[BaseMessage], operator.add]？
- [ ] 其他字段是否有正确的类型注解？
- [ ] 字段名是否符合命名规范？

### ✅ 节点定义检查
- [ ] 节点函数是否接收 state 作为参数？
- [ ] 节点函数是否返回新的状态字典？
- [ ] 是否没有在函数内部修改 state？
- [ ] 节点职责是否单一明确？

### ✅ 边定义检查
- [ ] 是否设置了入口点（set_entry_point）？
- [ ] 条件边函数是否返回明确的节点名称或 END？
- [ ] 工具节点是否正确连接回 agent？
- [ ] 是否有明确的终止条件？

### ✅ 工具定义检查
- [ ] 工具是否有清晰的文档字符串？
- [ ] 工具参数是否有类型注解？
- [ ] 工具是否有适当的错误处理？
- [ ] 工具是否通过 bind_tools() 绑定？

### ✅ 编译和测试检查
- [ ] 是否调用了 compile()？
- [ ] 是否配置了 checkpointer（如需要）？
- [ ] 是否用简单输入测试过？
- [ ] 是否处理了异常情况？

### 📝 建议操作
1. 使用 /check-graph 验证图结构
2. 添加打印语句观察执行过程
3. 使用 stream() 查看详细执行步骤
4. 编写单元测试验证关键路径
5. 检查是否有循环依赖

### 🔗 快捷链接
- [LangGraph 文档](https://langchain-ai.github.io/langgraph/)
- [调试技巧](https://langchain-ai.github.io/langgraph/tutorials/debugging/)
- [最佳实践](https://langchain-ai.github.io/langgraph/how-tos/)
    `);
  }
}
