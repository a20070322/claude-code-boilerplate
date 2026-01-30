# 代码规范技能

## 触发条件
- 关键词: 代码规范、代码风格、最佳实践、代码检查
- 场景: 编写任何代码时都应该遵循的通用规范

## 核心规范

### 1. 命名规范

#### 类名
- 使用 PascalCase (大驼峰)
- 名词形式
- 见名知意

#### 方法名/函数名
- 使用 camelCase (小驼峰)
- 动词开头
- 见名知意

#### 变量名
- 使用 camelCase
- 布尔类型使用 is/has/can 前缀

#### 常量名
- 全大写,下划线分隔

### 2. 代码组织

#### 导入顺序
```
// 1. 标准库
// 2. 第三方库
// 3. 项目内部
```

#### 类成员顺序
```
// 1. 常量
// 2. 静态变量
// 3. 实例变量
// 4. 构造方法
// 5. 公共方法
// 6. 私有方法
// 7. getter/setter
```

### 3. 注释规范

#### 类/文件注释
```javascript
/**
 * 模块/类的简短描述
 *
 * @author Your Name
 * @date 2024-01-01
 */
```

#### 方法/函数注释
```javascript
/**
 * 方法/函数的简短描述
 *
 * @param param1 参数1说明
 * @param param2 参数2说明
 * @returns 返回值说明
 */
```

#### 复杂逻辑注释
```javascript
// TODO: 需要优化性能
// FIXME: 修复问题
// NOTE: 重要说明
```

### 4. 异常处理

#### 不要吞掉异常
```javascript
// ❌ 错误
try {
  doSomething();
} catch (e) {
  // 什么都不做
}

// ✅ 正确
try {
  doSomething();
} catch (e) {
  console.error('操作失败', e);
  throw new Error('操作失败');
}
```

### 5. 空值检查

```javascript
// ❌ 错误
if (str != null && str !== '') {}
if (arr != null && arr.length > 0) {}

// ✅ 正确
if (str) {}
if (arr && arr.length) {}
// 或使用工具函数
if (isNotEmpty(str)) {}
if (isNotEmpty(arr)) {}
```

### 6. 字符串处理

#### 字符串比较
```javascript
// ❌ 错误
if (str === 'test') {}

// ✅ 正确
if ('test' === str) {}
```

#### 字符串拼接
```javascript
// ❌ 错误 (在循环中)
let str = '';
for (let i = 0; i < 100; i++) {
  str += i;
}

// ✅ 正确
const parts = [];
for (let i = 0; i < 100; i++) {
  parts.push(i);
}
const str = parts.join('');
```

### 7. 日志规范

#### 使用占位符
```javascript
// ❌ 错误
console.log('用户ID: ' + userId + ', 用户名: ' + userName);

// ✅ 正确
console.log('用户ID: %d, 用户名: %s', userId, userName);
```

#### 选择合适的日志级别
```javascript
console.error('错误信息', exception);  // 错误
console.warn('警告信息');              // 警告
console.info('关键信息');              // 信息
console.debug('调试信息');             // 调试
```

## 禁止事项
- ❌ 使用魔法数字 (未定义的常量)
- ❌ 过度使用嵌套 if-else (超过3层)
- ❌ 在循环中进行 I/O 操作
- ❌ 在 finally 中使用 return
- ❌ 使用 + 拼接大量字符串
- ❌ 忽略异常
- ❌ 使用过时的 API

## 检查清单
- [ ] 命名是否符合规范?
- [ ] 常量是否全大写?
- [ ] 是否有必要的注释?
- [ ] 是否有吞掉异常的情况?
- [ ] 是否正确处理空值?
- [ ] 日志是否使用占位符?
- [ ] 是否过度使用嵌套 if-else?
- [ ] 是否在循环中进行 I/O 操作?
