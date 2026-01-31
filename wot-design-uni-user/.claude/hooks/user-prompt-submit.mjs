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

  // 如果涉及组件使用，自动激活相关技能（不阻止执行）
  if (hasComponentKeyword) {
    // 自动激活技能，不要求用户确认
    // AI 会根据上下文自动选择合适的技能
    console.log('\n💡 检测到组件使用任务，AI 将自动使用相关技能');
  }

  // 其他任务直接放行
  return { proceed: true };
}
