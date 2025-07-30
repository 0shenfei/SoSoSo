# 社交媒体日历后端配置指南

## 步骤1: 创建Supabase项目

1. 访问 [supabase.com](https://supabase.com)
2. 注册账号并创建新项目
3. 获取项目URL和API密钥

## 步骤2: 数据库设计

### 表结构设计

```sql
-- 用户表
CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 发布内容表
CREATE TABLE posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  date DATE NOT NULL,
  caption TEXT,
  platforms TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 媒体文件表
CREATE TABLE media_files (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_type TEXT NOT NULL,
  file_url TEXT NOT NULL,
  thumbnail_url TEXT,
  file_size INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 步骤3: 前端集成

### 安装依赖
```bash
npm install @supabase/supabase-js
```

### 配置连接
```javascript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'YOUR_SUPABASE_URL'
const supabaseKey = 'YOUR_SUPABASE_ANON_KEY'
const supabase = createClient(supabaseUrl, supabaseKey)
```

### API调用示例
```javascript
// 保存发布内容
const savePost = async (postData) => {
  const { data, error } = await supabase
    .from('posts')
    .insert([postData])
  
  if (error) console.error('Error:', error)
  return data
}

// 上传文件
const uploadFile = async (file) => {
  const { data, error } = await supabase.storage
    .from('media')
    .upload(`${Date.now()}_${file.name}`, file)
  
  if (error) console.error('Error:', error)
  return data
}

// 获取所有发布内容
const getPosts = async () => {
  const { data, error } = await supabase
    .from('posts')
    .select(`
      *,
      media_files (*)
    `)
    .order('date', { ascending: true })
  
  return data
}
```

## 步骤4: 认证系统

```javascript
// 用户注册
const signUp = async (email, password) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  })
  return { data, error }
}

// 用户登录
const signIn = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })
  return { data, error }
}

// 检查登录状态
const getUser = async () => {
  const { data: { user } } = await supabase.auth.getUser()
  return user
}
```

## 步骤5: 实时同步

```javascript
// 监听数据变化
const setupRealtimeListener = () => {
  const channel = supabase
    .channel('posts')
    .on('postgres_changes', 
      { event: '*', schema: 'public', table: 'posts' },
      (payload) => {
        console.log('Change received!', payload)
        // 更新本地状态
        refreshPosts()
      }
    )
    .subscribe()
    
  return channel
}
```

## 步骤6: 部署和域名

1. **前端部署**: 继续使用GitHub Pages或迁移到Vercel
2. **自定义域名**: 配置您的域名指向部署服务
3. **HTTPS配置**: 确保安全连接

## 高级功能扩展

### 自动发布集成
```javascript
// 定时发布到Instagram (需要Meta Business API)
const schedulePost = async (postData, scheduledTime) => {
  // 使用Supabase Edge Functions
  const { data, error } = await supabase.functions.invoke('schedule-post', {
    body: { postData, scheduledTime }
  })
  return data
}
```

### 团队协作
```javascript
// 团队成员管理
const addTeamMember = async (teamId, memberEmail) => {
  const { data, error } = await supabase
    .from('team_members')
    .insert([{ team_id: teamId, email: memberEmail }])
  return data
}
```

## 成本估算

### Supabase免费额度
- 数据库: 500MB
- 文件存储: 1GB
- 实时连接: 200个并发
- Edge Functions: 500,000次调用/月

### 付费计划 (约$25/月)
- 数据库: 8GB
- 文件存储: 100GB
- 无限实时连接
- 高级功能支持

## 迁移策略

### 从localStorage迁移到Supabase
```javascript
const migrateLocalData = async () => {
  const localData = localStorage.getItem('socialMediaCalendar')
  if (localData) {
    const posts = JSON.parse(localData)
    
    for (const [date, dayPosts] of Object.entries(posts)) {
      for (const post of dayPosts) {
        await savePost({
          date,
          caption: post.caption,
          platforms: post.platforms,
          // 处理媒体文件...
        })
      }
    }
  }
}
```