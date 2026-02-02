# uni-app 页面模板完整示例

> 展示各种类型的完整页面实现

## 1. 基础页面模板

### user-profile/index.vue

```vue
<script setup lang="ts">
definePage({
  name: 'user-profile',
  layout: 'default',
  style: {
    navigationBarTitleText: '用户资料',
  },
})

const router = useRouter()
const { toast } = useGlobalToast()

// 用户数据
interface UserInfo {
  id: string
  name: string
  email: string
  avatar: string
}

const userInfo = ref<UserInfo>({
  id: '',
  name: '',
  email: '',
  avatar: '',
})

// 加载用户数据
const loadUserInfo = async () => {
  try {
    // 调用 API 获取用户信息
    const data = await getUserInfoApi()
    userInfo.value = data
  } catch (error) {
    toast.error('加载失败')
  }
}

// 退出登录
const handleLogout = () => {
  router.push({ name: 'login' })
}

onMounted(() => {
  loadUserInfo()
})
</script>

<template>
  <view class="p-4">
    <!-- 用户信息卡片 -->
    <wd-card class="mb-4">
      <view class="flex items-center">
        <image
          :src="userInfo.avatar"
          class="w-16 h-16 rounded-full"
          mode="aspectFill"
        />
        <view class="ml-4 flex-1">
          <view class="text-lg font-bold">{{ userInfo.name }}</view>
          <view class="text-sm text-gray-500">{{ userInfo.email }}</view>
        </view>
      </view>
    </wd-card>

    <!-- 操作按钮 -->
    <view class="space-y-3">
      <wd-button type="primary" block @click="handleLogout">
        退出登录
      </wd-button>
    </view>
  </view>
</template>
```

## 2. TabBar 页面模板

### pages/home/index.vue

```vue
<script setup lang="ts">
definePage({
  name: 'home',
  layout: 'tabbar',
  style: {
    navigationBarTitleText: '首页',
    navigationBarBackgroundColor: '#1989fa',
    navigationBarTextStyle: 'white',
  },
})

const router = useRouter()

// Banner 数据
const banners = ref([
  { id: 1, image: '/static/banner1.jpg' },
  { id: 2, image: '/static/banner2.jpg' },
])

// 推荐列表
const recommendList = ref([])

// 加载推荐数据
const loadRecommend = async () => {
  try {
    const data = await getRecommendApi()
    recommendList.value = data.list
  } catch (error) {
    console.error('加载推荐失败:', error)
  }
}

// 跳转到详情
const goToDetail = (item: any) => {
  router.push({
    name: 'detail',
    query: { id: item.id },
  })
}

onMounted(() => {
  loadRecommend()
})
</script>

<template>
  <view class="min-h-screen bg-gray-100">
    <!-- Banner -->
    <wd-swiper
      v-model:current="0"
      :list="banners"
      autoplay
      indicator-color="white"
      class="h-48"
    >
      <template #default="{ item }">
        <image :src="item.image" class="w-full h-full" mode="aspectFill" />
      </template>
    </wd-swiper>

    <!-- 推荐列表 -->
    <view class="p-4">
      <view class="text-lg font-bold mb-3">推荐</view>
      <view class="grid grid-cols-2 gap-3">
        <view
          v-for="item in recommendList"
          :key="item.id"
          class="bg-white rounded-lg p-3"
          @click="goToDetail(item)"
        >
          <image
            :src="item.image"
            class="w-full h-32 rounded mb-2"
            mode="aspectFill"
          />
          <view class="text-sm font-medium line-clamp-2">
            {{ item.title }}
          </view>
          <view class="text-xs text-red-500 mt-1">
            ¥{{ item.price }}
          </view>
        </view>
      </view>
    </view>
  </view>
</template>
```

## 3. 列表页面模板

### subPages/goods-list/index.vue

```vue
<script setup lang="ts">
definePage({
  name: 'goods-list',
  layout: 'default',
  style: {
    navigationBarTitleText: '商品列表',
    enablePullDownRefresh: true,
  },
})

const router = useRouter()
const { toast } = useGlobalToast()

// 列表数据
interface Goods {
  id: string
  title: string
  price: number
  image: string
}

const list = ref<Goods[]>([])
const loading = ref(false)
const finished = ref(false)
const page = ref(1)

// 加载数据
const loadData = async () => {
  if (loading.value || finished.value) return

  loading.value = true
  try {
    const data = await getGoodsListApi({
      page: page.value,
      pageSize: 10,
    })

    if (data.list.length > 0) {
      list.value.push(...data.list)
      page.value++
    } else {
      finished.value = true
    }
  } catch (error) {
    toast.error('加载失败')
  } finally {
    loading.value = false
  }
}

// 下拉刷新
const onRefresh = async () => {
  list.value = []
  page.value = 1
  finished.value = false
  await loadData()
  uni.stopPullDownRefresh()
}

// 上拉加载
const onLoadMore = () => {
  loadData()
}

// 跳转详情
const goToDetail = (item: Goods) => {
  router.push({
    name: 'goods-detail',
    query: { id: item.id },
  })
}

onMounted(() => {
  loadData()
})

// 监听上拉加载
onReachBottom(() => {
  onLoadMore()
})
</script>

<template>
  <view class="min-h-screen bg-gray-100">
    <!-- 列表 -->
    <view class="p-4 space-y-3">
      <view
        v-for="item in list"
        :key="item.id"
        class="bg-white rounded-lg p-3 flex"
        @click="goToDetail(item)"
      >
        <image
          :src="item.image"
          class="w-24 h-24 rounded flex-shrink-0"
          mode="aspectFill"
        />
        <view class="ml-3 flex-1 flex flex-col justify-between">
          <view class="text-sm font-medium line-clamp-2">
            {{ item.title }}
          </view>
          <view class="flex items-center justify-between">
            <view class="text-red-500 font-bold">
              ¥{{ item.price }}
            </view>
            <wd-button size="small" type="primary">
              购买
            </wd-button>
          </view>
        </view>
      </view>
    </view>

    <!-- 加载状态 -->
    <view v-if="loading" class="text-center py-4 text-gray-500">
      加载中...
    </view>
    <view v-if="finished" class="text-center py-4 text-gray-500">
      没有更多了
    </view>
  </view>
</template>
```

## 4. 表单页面模板

### subPages/feedback/index.vue

```vue
<script setup lang="ts">
definePage({
  name: 'feedback',
  layout: 'default',
  style: {
    navigationBarTitleText: '意见反馈',
  },
})

const router = useRouter()
const { toast } = useGlobalToast()
const { loading } = useGlobalLoading()

// 表单数据
const formData = ref({
  type: '1', // 反馈类型
  content: '', // 反馈内容
  contact: '', // 联系方式
  images: [] as string[], // 图片
})

// 反馈类型选项
const typeOptions = [
  { label: '功能建议', value: '1' },
  { label: 'Bug 反馈', value: '2' },
  { label: '其他', value: '3' },
]

// 提交表单
const handleSubmit = async () => {
  // 验证
  if (!formData.value.content.trim()) {
    toast.error('请输入反馈内容')
    return
  }

  try {
    loading.show()

    await submitFeedbackApi({
      type: formData.value.type,
      content: formData.value.content,
      contact: formData.value.contact,
      images: formData.value.images,
    })

    toast.success('提交成功')
    router.back()
  } catch (error) {
    toast.error('提交失败')
  } finally {
    loading.hide()
  }
}

// 选择图片
const chooseImage = () => {
  uni.chooseImage({
    count: 3 - formData.value.images.length,
    success: (res) => {
      formData.value.images.push(...res.tempFilePaths)
    },
  })
}

// 删除图片
const removeImage = (index: number) => {
  formData.value.images.splice(index, 1)
}
</script>

<template>
  <view class="p-4">
    <wd-cell-group border>
      <!-- 反馈类型 -->
      <wd-picker
        v-model="formData.type"
        :columns="typeOptions"
        label="反馈类型"
        placeholder="请选择"
        required
      />

      <!-- 反馈内容 -->
      <wd-textarea
        v-model="formData.content"
        label="反馈内容"
        placeholder="请详细描述您的问题或建议"
        :maxlength="500"
        show-word-limit
        required
      />

      <!-- 联系方式 -->
      <wd-input
        v-model="formData.contact"
        label="联系方式"
        placeholder="手机号或邮箱（可选）"
      />

      <!-- 图片上传 -->
      <view class="px-4 py-3">
        <view class="text-sm mb-2">图片（选填）</view>
        <view class="flex flex-wrap gap-2">
          <view
            v-for="(img, index) in formData.images"
            :key="index"
            class="relative"
          >
            <image
              :src="img"
              class="w-20 h-20 rounded"
              mode="aspectFill"
            />
            <view
              class="absolute -top-1 -right-1 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs"
              @click="removeImage(index)"
            >
              ×
            </view>
          </view>
          <view
            v-if="formData.images.length < 3"
            class="w-20 h-20 border-2 border-dashed border-gray-300 rounded flex items-center justify-center"
            @click="chooseImage"
          >
            <text class="text-gray-400 text-2xl">+</text>
          </view>
        </view>
      </view>
    </wd-cell-group>

    <!-- 提交按钮 -->
    <view class="mt-6">
      <wd-button type="primary" block @click="handleSubmit">
        提交
      </wd-button>
    </view>
  </view>
</template>
```

## 5. 详情页面模板

### subPages/goods-detail/index.vue

```vue
<script setup lang="ts">
definePage({
  name: 'goods-detail',
  layout: 'default',
  style: {
    navigationBarTitleText: '商品详情',
  },
})

const router = useRouter()
const { toast } = useGlobalToast()

// 获取路由参数
const query = router.currentRoute.value.query
const goodsId = query.id as string

// 商品数据
const goods = ref<any>(null)
const loading = ref(false)

// 加载商品详情
const loadGoodsDetail = async () => {
  loading.value = true
  try {
    const data = await getGoodsDetailApi(goodsId)
    goods.value = data
  } catch (error) {
    toast.error('加载失败')
  } finally {
    loading.value = false
  }
}

// 加入购物车
const handleAddCart = async () => {
  try {
    await addCartApi({
      goodsId: goods.value.id,
      count: 1,
    })
    toast.success('已加入购物车')
  } catch (error) {
    toast.error('操作失败')
  }
}

// 立即购买
const handleBuy = () => {
  router.push({
    name: 'order-confirm',
    query: { goodsId: goods.value.id, count: 1 },
  })
}

onMounted(() => {
  loadGoodsDetail()
})
</script>

<template>
  <view v-if="loading" class="flex items-center justify-center min-h-screen">
    <wd-loading>加载中...</wd-loading>
  </view>

  <view v-else-if="goods" class="min-h-screen bg-gray-100 pb-20">
    <!-- 商品图片 -->
    <wd-swiper
      :list="goods.images"
      :autoplay="false"
      class="h-80"
    >
      <template #default="{ item }">
        <image :src="item" class="w-full h-full" mode="aspectFill" />
      </template>
    </wd-swiper>

    <!-- 商品信息 -->
    <view class="bg-white p-4 mb-2">
      <view class="flex items-baseline mb-2">
        <view class="text-red-500 text-2xl font-bold mr-2">
          ¥{{ goods.price }}
        </view>
        <view class="text-gray-400 text-sm line-through">
          ¥{{ goods.originalPrice }}
        </view>
      </view>
      <view class="text-lg font-medium mb-2">
        {{ goods.title }}
      </view>
      <view class="text-sm text-gray-500">
        {{ goods.description }}
      </view>
    </view>

    <!-- 规格选择 -->
    <view class="bg-white p-4 mb-2">
      <view class="text-sm font-medium mb-3">规格</view>
      <view class="flex flex-wrap gap-2">
        <view
          v-for="(spec, index) in goods.specs"
          :key="index"
          class="px-4 py-2 border rounded"
          :class="{
            'border-primary text-primary': spec.selected,
            'border-gray-200': !spec.selected,
          }"
        >
          {{ spec.name }}
        </view>
      </view>
    </view>

    <!-- 商品详情 -->
    <view class="bg-white p-4">
      <view class="text-sm font-medium mb-3">商品详情</view>
      <rich-text :nodes="goods.detail" />
    </view>

    <!-- 底部操作栏 -->
    <view class="fixed bottom-0 left-0 right-0 bg-white border-t p-3 flex items-center gap-3">
      <wd-button type="warning" size="large" @click="handleAddCart">
        加入购物车
      </wd-button>
      <wd-button type="primary" size="large" block @click="handleBuy">
        立即购买
      </wd-button>
    </view>
  </view>
</template>
```

## 6. 分包配置示例

### vite.config.ts

```typescript
import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'

export default defineConfig({
  plugins: [
    uni({
      // 分包配置
      subPackages: [
        {
          root: 'src/subPages',
          pages: [
            {
              path: 'goods-list/index',
              style: {
                navigationBarTitleText: '商品列表',
                enablePullDownRefresh: true,
              },
            },
            {
              path: 'goods-detail/index',
              style: {
                navigationBarTitleText: '商品详情',
              },
            },
            {
              path: 'feedback/index',
              style: {
                navigationBarTitleText: '意见反馈',
              },
            },
          ],
        },
        {
          root: 'src/subEcharts',
          pages: [
            {
              path: 'chart/index',
              style: {
                navigationBarTitleText: '图表',
              },
            },
          ],
        },
      ],
    }),
  ],
})
```

## 快速参考

### 页面结构
```vue
<script setup lang="ts">
definePage({
  name: 'page-name',
  layout: 'default', // 或 'tabbar'
  style: {
    navigationBarTitleText: '页面标题',
  },
})

const router = useRouter()
// ... 页面逻辑
</script>

<template>
  <view class="p-4">
    <!-- 页面内容 -->
  </view>
</template>
```

### 路由跳转
```typescript
router.push({ name: 'detail' })
router.push({ name: 'detail', query: { id: '123' } })
router.back()
```

### UnoCSS 常用类
```
p-4         # padding: 1rem
m-2         # margin: 0.5rem
flex        # display: flex
items-center # align-items: center
justify-between # justify-content: space-between
text-lg     # font-size: 1.125rem
font-bold   # font-weight: 700
bg-white    # background-color: white
rounded     # border-radius: 0.25rem
```
