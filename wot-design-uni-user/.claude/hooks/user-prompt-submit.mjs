// 用户提示提交钩子 - 强制技能评估
export async function userPromptSubmit(context) {
  const { prompt } = context;

  // 如果是斜杠命令，直接放行
  if (prompt.trim().startsWith('/')) {
    return { proceed: true };
  }

  // 定义组件使用相关的关键词
  const componentKeywords = [
    // 基础组件
    'button', 'icon', 'cell', 'avatar', 'badge', 'tag',
    '按钮', '图标', '单元格', '头像', '徽标', '标签',

    // 表单组件
    'input', 'form', 'checkbox', 'radio', 'switch', 'slider',
    'picker', 'select', 'upload', 'captcha', 'rate',
    '输入', '表单', '选择框', '开关', '滑块', '上传', '评分',

    // 反馈组件
    'dialog', 'toast', 'loading', 'action-sheet', 'popup',
    'notify', 'swipe', 'dropdown', 'popover',
    '弹窗', '提示', '加载', '下拉', '通知',

    // 布局组件
    'layout', 'divider', 'card', 'collapse', 'grid',
    'col', 'row', 'sticky', 'backtop',
    '布局', '分隔', '卡片', '折叠', '网格', '回到顶部',

    // 导航组件
    'tabbar', 'navbar', 'tabs', 'sidebar', 'breadcrumb',
    '导航', '标签页', '标签栏', '侧边栏', '面包屑',

    // 其他功能
    'calendar', 'datetime-picker', 'count-down', 'count-to',
    'scroll-view', 'swiper', 'watermark', 'signature',
    '日历', '时间选择', '倒计时', '滚动', '水印', '签名',

    // 通用关键词
    'wd-', 'wot-design', 'wot ui', '组件', '页面', '界面'
  ];

  // 检查是否涉及组件使用
  const hasComponentKeyword = componentKeywords.some(keyword =>
    prompt.toLowerCase().includes(keyword.toLowerCase())
  );

  // 如果涉及组件使用，强制技能评估
  if (hasComponentKeyword) {
    return {
      proceed: false,
      message: `
## 指令:强制技能激活流程

### 步骤 1 - 技能评估
针对以下技能，请评估是否适用：

**基础组件技能** (usage-basic-component)
- 是否涉及：按钮、图标、头像、徽标、标签等基础组件

**表单组件技能** (usage-form-component)
- 是否涉及：输入框、表单、选择器、上传、评分等表单组件

**反馈组件技能** (usage-feedback-component)
- 是否涉及：弹窗、提示、加载、通知等反馈组件

**布局组件技能** (usage-layout-component)
- 是否涉及：布局容器、分隔线、卡片、折叠等布局组件

**导航组件技能** (usage-navigation-component)
- 是否涉及：标签页、导航栏、侧边栏等导航组件

### 步骤 2 - 技能激活
如果任何技能为"是" → 立即使用 Skill 工具激活对应技能
如果所有技能为"否" → 说明"无需组件技能"并继续

### 步骤 3 - 实施任务
只有在步骤 2 完成后，才能开始实施。
      `
    };
  }

  // 其他任务直接放行
  return { proceed: true };
}
