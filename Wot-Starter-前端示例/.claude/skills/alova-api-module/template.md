# Alova API 模块配置表

> 请填写以下信息，我将为您创建 Alova API 模块

## 📋 基本信息

**模块名称**（英文，小写）:
**模块描述**:
**基础路径**: `/api/{moduleName}`

## 🔌 接口列表

**需要创建的接口**:

### 1. 查询列表
- [ ] 是（需要）
- 路径: `GET /{moduleName}/list`
- 参数: _____

### 2. 查询详情
- [ ] 是（需要）
- 路径: `GET /{moduleName}/detail`
- 参数: id

### 3. 创建
- [ ] 是（需要）
- 路径: `POST /{moduleName}/create`
- 参数: _____

### 4. 更新
- [ ] 是（需要）
- 路径: `PUT /{moduleName}/update`
- 参数: id + data

### 5. 删除
- [ ] 是（需要）
- 路径: `DELETE /{moduleName}/delete`
- 参数: id

## 📦 数据类型

**响应数据格式**:
```typescript
{
  code: number,
  message: string,
  data: {
    list?: Array<____>,
    total?: number,
    // 其他字段...
  }
}
```

**请列出主要字段**:
- 字段1: _____（类型: _____）
- 字段2: _____（类型: _____）

## 📝 生成内容确认

- [ ] Mock 模块（src/api/mock/modules/）
- [ ] API 实例（src/api/）
- [ ] TypeScript 类型定义
- [ ] 使用示例

---

**请填写以上信息，我将按照标准格式创建 API 模块。**
