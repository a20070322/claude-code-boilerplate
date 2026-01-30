# /push - Git 提交和推送命令

## 描述
自动完成 Git 提交和推送的全流程，包括代码审查、状态检查和提交信息生成。

## 使用方法
```
/push                           # 自动提交并推送所有变更
/push <提交信息>                # 使用自定义提交信息
/push --amend                  # 修正最后一次提交
```

## 执行步骤

### 1. 前置检查
- [ ] 检查工作树状态
- [ ] 检查是否有未提交的变更
- [ ] 确认当前分支

### 2. 变更分析
- [ ] 运行 `git status` 查看变更
- [ ] 运行 `git diff` 查看具体修改
- [ ] 运行 `git log --oneline -5` 查看最近提交

### 3. 代码审查 (可选)
- [ ] 如果有 @code-reviewer 代理，触发代码审查
- [ ] 根据审查结果修复问题
- [ ] 确认代码质量

### 4. 生成提交信息
- [ ] 分析变更类型 (feat/fix/refactor/docs/chore/test/style)
- [ ] 生成简短的提交标题
- [ ] 生成详细的提交描述
- [ ] 添加 Co-Authored-By 标记

### 5. 执行提交
- [ ] 添加相关文件到暂存区
- [ ] 创建提交 (不使用 --amend 除非明确指定)
- [ ] 运行 `git status` 验证提交成功

### 6. 推送到远程
- [ ] 执行 `git push`
- [ ] 验证推送成功
- [ ] 显示最终状态
- [ ] 如果遇到网络错误，自动配置代理重试

## 提交信息规范

### 类型标签
- **feat**: 新功能
- **fix**: Bug 修复
- **refactor**: 代码重构
- **docs**: 文档更新
- **chore**: 构建/工具变更
- **test**: 测试相关
- **style**: 代码格式

### 提交信息格式
```
<type>: <简短描述>

<详细描述>

<影响范围>

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## 示例

### 示例 1: 自动提交
```
用户: /push

AI 分析变更:
- 新增了 .gitignore 文件
- 移除了 settings.local.json

AI 生成提交信息:
chore: protect local config files with .gitignore

- Add .gitignore to root directory
- Remove settings.local.json from version control
- Keep local config files to prevent accidental commits
```

### 示例 2: 自定义提交信息
```
用户: /push 添加用户认证功能

AI 使用自定义信息:
feat: 添加用户认证功能

- Implement JWT authentication
- Add login/logout endpoints
- Update user schema

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## 安全检查

### 提交前验证
- [ ] 确认不会提交敏感信息
- [ ] 确认 .gitignore 配置正确
- [ ] 确认没有临时文件被包含

### 危险操作保护
- **禁止** 使用 `git push --force` 到 main/master 分支
- **禁止** 使用 `git commit --amend` 除非用户明确指定
- **禁止** 提交包含密码/密钥的文件

## 输出格式

```
## 📊 Git 状态分析

### 当前分支
main

### 变更文件
- M  modified-file.txt
- A  new-file.txt
- D  deleted-file.txt

### 提交信息
feat: add new feature

- Implement feature X
- Add component Y
- Update documentation Z

---

## ✅ 提交成功

Commit: abc1234
Branch: main -> main

## 🚀 推送成功

To https://github.com/user/repo.git
   abc1234..def5678  main -> main
```

## 网络问题处理

### 检测网络错误
当 `git push` 遇到以下错误时：
```
fatal: unable to access 'https://github.com/...':
Failed to connect to github.com port 443 after xxx ms: Couldn't connect to server
```

### 自动配置代理
1. **设置代理环境变量**
   ```bash
   export https_proxy=http://127.0.0.1:7890 \
          http_proxy=http://127.0.0.1:7890 \
          all_proxy=socks5://127.0.0.1:7890
   ```

2. **重试推送**
   ```bash
   git push
   ```

3. **清除代理 (推送完成后)**
   ```bash
   unset https_proxy http_proxy all_proxy
   ```

### 代理端口配置
常见代理端口：
- **7890**: Clash 默认端口
- **1080**: 常见 SOCKS5 端口
- **7891**: Clash 混合端口
- **8080**: 常见 HTTP 代理端口

### 手动配置 Git 代理
如果环境变量不生效，可以为 Git 单独配置：
```bash
# HTTP 代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# SOCKS5 代理
git config --global http.proxy socks5://127.0.0.1:7890
git config --global https.proxy socks5://127.0.0.1:7890

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

### SSH 仓库代理配置
如果使用 SSH 协议 (git@github.com)，编辑 `~/.ssh/config`：
```
Host github.com
    ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
```

## 注意事项

1. **永远不要** 在未征得用户同意的情况下执行强制推送
2. **永远不要** 提交包含敏感信息的文件
3. **始终** 在提交前运行 `git status` 确认变更
4. **建议** 在提交前使用 @code-reviewer 进行代码审查
5. **避免** 在提交信息中使用表情符号 (除非用户明确要求)
6. **网络问题** 遇到推送失败时，自动配置代理重试一次
