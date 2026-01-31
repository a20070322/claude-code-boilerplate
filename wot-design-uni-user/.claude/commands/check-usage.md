# /check-usage - 检查使用规范

## 描述
全面检查项目中 Wot Design Uni 组件的使用规范，包括组件引入、代码质量、性能优化、平台兼容性等方面。

## 使用方法
```
/check-usage [检查范围]
```

**示例：**
```
/check-usage              # 检查整个项目
/check-usage pages/index  # 检查指定文件/目录
/check-usage component     # 检查组件使用规范
```

## 执行步骤

### 步骤 1: 配置检查
- [ ] 检查 easycom 配置是否正确
- [ ] 检查 sass 版本兼容性
- [ ] 检查主题配置文件
- [ ] 检查依赖包版本

### 步骤 2: 组件引入检查
- [ ] 检查组件名称是否规范（wd-前缀）
- [ ] 检查是否存在未使用的组件
- [ ] 检查组件 Props 使用是否正确
- [ ] 检查事件绑定是否正确

### 步骤 3: 代码规范检查
- [ ] 检查命名规范
- [ ] 检查代码格式
- [ ] 检查 TypeScript 类型定义
- [ ] 检查注释完整性

### 步骤 4: 性能检查
- [ ] 检查是否存在不必要的渲染
- [ ] 检查列表是否使用了 key
- [ ] 检查大组件是否需要拆分
- [ ] 检查是否有内存泄漏

### 步骤 5: 平台兼容性检查
- [ ] 检查平台特定代码
- [ ] 检查条件编译使用
- [ ] 检查 API 兼容性
- [ ] 检查样式兼容性

### 步骤 6: 生成报告
- [ ] 汇总检查结果
- [ ] 标记问题级别（错误/警告/提示）
- [ ] 提供修复建议
- [ ] 生成优化建议

## 检查项目

### 1. 配置检查

```json
✅ pages.json easycom 配置
{
  "easycom": {
    "autoscan": true,
    "custom": {
      "^wd-(.*)": "wot-design-uni/components/wd-$1/wd-$1.vue"
    }
  }
}

❌ 常见错误
- easycom 配置格式错误
- 组件路径不正确
- 缺少 easycom 配置
```

### 2. 组件使用检查

```vue
✅ 正确示例
<wd-button type="primary" @click="handleClick">按钮</wd-button>

❌ 错误示例
<wd-button type="primary" @click="handleClick">按钮</wd-button>

❌ 常见问题
- 组件名称没有 wd- 前缀
- Props 使用驼峰命名（应该用 kebab-case）
- 事件名称缺少 @ 前缀
- 组件标签没有闭合
```

### 3. 表单验证检查

```vue
✅ 正确示例
<wd-form ref="formRef" :model="formData" :rules="rules">
  <wd-input
    v-model="formData.name"
    label="姓名"
    prop="name"
    required
  />
</wd-form>

❌ 常见问题
- form-item 缺少 prop 属性
- 验证规则格式错误
- v-model 绑定错误
```

### 4. 类型定义检查

```typescript
✅ 正确示例
import type { FormInstance } from 'wot-design-uni/components/wd-form/types'
import type { UploadFile } from 'wot-design-uni/components/wd-upload/types'

const formRef = ref<FormInstance>()
const fileList = ref<UploadFile[]>([])

❌ 常见问题
- 没有导入类型定义
- 类型定义路径错误
- 类型推断错误
```

### 5. 样式检查

```vue
✅ 正确示例
<wd-button custom-style="border-radius: 8px">按钮</wd-button>

<style>
.custom-button {
  --wd-button-bg-color: #3b82f6;
}
</style>

❌ 常见问题
- 直接修改组件内部样式（应该用 CSS 变量）
- !important 优先级使用不当
- 样式作用域污染
```

### 6. 性能检查

```vue
✅ 正确示例
<wd-checkbox-group v-model="checkedList">
  <wd-checkbox
    v-for="item in list"
    :key="item.id"
    :value="item.id"
  >
    {{ item.label }}
  </wd-checkbox>
</wd-checkbox-group>

❌ 常见问题
- 列表渲染缺少 key
- v-for 和 v-if 混用
- 大数据量未做分页/虚拟滚动
- 未使用的组件未按需引入（虽然 easycom 自动处理）
```

### 7. 平台兼容性

```vue
✅ 正确示例
<!-- #ifdef MP-WEIXIN -->
<wd-button>微信小程序专用</wd-button>
<!-- #endif -->

<!-- #ifdef H5 -->
<wd-button>H5 专用</wd-button>
<!-- #endif -->

❌ 常见问题
- 平台特有 API 未做条件编译
- 样式在某些平台不兼容
- 未测试目标平台
```

## 检查报告格式

```markdown
## Wot Design Uni 使用检查报告

### 📊 检查概览
- 检查文件数: 25
- 问题总数: 12
  - ❌ 错误: 3
  - ⚠️ 警告: 7
  - 💡 提示: 2

### ❌ 错误项（必须修复）

1. **组件名称错误** - pages/login/index.vue:15
   - 使用了 `button` 应该使用 `wd-button`
   - 修复: 替换为正确的组件名称

2. **表单验证缺少 prop** - pages/form/index.vue:23
   - `wd-input` 缺少 prop 属性
   - 修复: 添加 prop="username"

3. **事件绑定错误** - components/UserInfo.vue:8
   - 使用了 `onconfirm` 应该使用 `@confirm`
   - 修复: 添加 @ 前缀

### ⚠️ 警告项（建议修复）

1. **缺少类型定义** - pages/api/index.vue:12
   - 建议导入 FormInstance 类型
   - 影响: 失去类型提示

2. **列表渲染缺少 key** - pages/list/index.vue:34
   - v-for 循环缺少 key 属性
   - 影响: 性能和渲染问题

3. **未使用的组件** - pages/test/index.vue:5
   - 引入了但未使用的 wd-toast
   - 影响: 增加包体积

4. **样式覆盖不当** - pages/custom/index.vue:18
   - 直接修改组件内部样式
   - 建议: 使用 CSS 变量

5. **平台兼容性** - pages/payment/index.vue:45
   - 使用了平台特有 API 未做条件编译
   - 建议: 添加 #ifdef 条件编译

6. **内存泄漏风险** - components/Chart.vue:10
   - 定时器未在 onUnmounted 清理
   - 影响: 可能导致内存泄漏

7. **大组件建议拆分** - pages/dashboard/index.vue
   - 组件代码超过 500 行
   - 建议: 拆分为多个子组件

### 💡 优化建议

1. **性能优化**
   - 建议对长列表使用虚拟滚动
   - 考虑使用 wd-virtual-list 组件

2. **代码规范**
   - 建议统一使用 TypeScript
   - 建议添加 ESLint 检查

3. **主题定制**
   - 建议创建统一的 theme.css 文件
   - 使用 CSS 变量统一管理主题

### 📈 评分
- 配置规范性: ⭐⭐⭐⭐⭐ (100%)
- 组件使用: ⭐⭐⭐⭐ (85%)
- 代码质量: ⭐⭐⭐⭐ (80%)
- 性能优化: ⭐⭐⭐ (65%)
- 平台兼容: ⭐⭐⭐⭐ (75%)

**综合评分: ⭐⭐⭐⭐ (81/100)**

### 🎯 优先修复
1. 所有错误项（必须）
2. 表单验证问题（重要）
3. 内存泄漏风险（重要）
4. 平台兼容性问题（重要）
```

## 自动修复

部分问题可以自动修复：

```javascript
// 自动修复示例
const fixes = {
  // 组件名称自动添加 wd- 前缀
  'button' => 'wd-button',
  'input' => 'wd-input',

  // 事件名称自动添加 @ 前缀
  'click=' => '@click=',
  'change=' => '@change=',

  // Props 自动转为 kebab-case
  'maxLength' => 'max-length',
  'placeholderText' => 'placeholder-text'
}
```

## 最佳实践建议

### 1. 组件使用
- ✅ 始终使用 `wd-` 前缀
- ✅ Props 使用 kebab-case
- ✅ 事件使用 `@` 前缀
- ✅ 查阅官方文档确认用法

### 2. 表单处理
- ✅ 每个 form-item 设置 prop
- ✅ 定义完整的验证规则
- ✅ 正确处理异步验证
- ✅ 提供友好的错误提示

### 3. 性能优化
- ✅ 列表渲染始终添加 key
- ✅ 避免不必要的重渲染
- ✅ 大数据量使用分页或虚拟滚动
- ✅ 及时清理定时器和事件监听

### 4. 类型安全
- ✅ 使用 TypeScript
- ✅ 导入正确的类型定义
- ✅ 避免 any 类型
- ✅ 使用枚举代替魔法值

### 5. 平台兼容
- ✅ 使用条件编译处理平台差异
- ✅ 测试所有目标平台
- ✅ 查阅官方平台差异文档
- ✅ 避免使用平台特有 API

## 注意事项

1. **检查范围**: 默认检查整个项目，可以指定文件或目录
2. **性能影响**: 大型项目检查可能需要一些时间
3. **修复建议**: 报告中会提供具体的修复建议和示例
4. **版本兼容**: 检查规则会随组件库版本更新

## 相关命令

- `/use-component` - 查看组件正确用法
- `/theme-config` - 检查主题配置
- `@component-helper` - 获取组件使用帮助
