# Supabase 配置说明

## 🚀 快速配置步骤

### 1. 创建Supabase项目
1. 访问 [supabase.com](https://supabase.com)
2. 注册账号（可以用GitHub登录）
3. 点击 "New Project"
4. 选择组织（个人使用选择自己的账号）
5. 输入项目名称，例如：`social-media-calendar`
6. 设置数据库密码（请记住这个密码）
7. 选择区域（推荐：Northeast Asia (Tokyo) 速度较快）
8. 点击 "Create new project"

### 2. 等待项目初始化
- 项目创建大约需要2-3分钟
- 看到绿色的 "Project ready" 状态后即可继续

### 3. 获取项目凭据
1. 在项目控制台，点击左侧菜单的 "Settings" → "API"
2. 复制以下信息：
   - **Project URL** (例如: https://abcdefghijklmnop.supabase.co)
   - **anon public** API key (很长的字符串)

### 4. 创建数据库表
1. 点击左侧菜单的 "SQL Editor"
2. 点击 "New query"
3. 复制并粘贴 `supabase-schema.sql` 文件中的所有SQL代码
4. 点击 "Run" 执行

### 5. 配置前端代码
在 `index.html` 文件中找到这两行：

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL'; // 替换为您的项目URL
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // 替换为您的API Key
```

替换为您的实际值：

```javascript
const SUPABASE_URL = 'https://abcdefghijklmnop.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### 6. 测试配置
1. 保存文件并刷新页面
2. 左上角应该显示 "🟡 本地存储" 和 "登录/注册" 按钮
3. 点击 "登录/注册" 注册一个测试账号
4. 登录成功后应该显示 "🟢 云端同步已开启"

## ✅ 验证清单

- [ ] Supabase项目创建成功
- [ ] 数据库表创建完成
- [ ] 项目URL和API Key已正确配置
- [ ] 页面左上角显示正确的状态
- [ ] 可以成功注册和登录账号
- [ ] 登录后数据可以云端同步

## 🎯 功能说明

### 本地模式 vs 云端模式

| 功能 | 本地模式 | 云端模式 |
|------|----------|----------|
| 数据存储 | 浏览器localStorage | Supabase云数据库 |
| 跨设备访问 | ❌ | ✅ |
| 数据备份 | ❌ | ✅ |
| 多用户支持 | ❌ | ✅ |
| 数据大小限制 | ~5MB | 500MB (免费版) |

### 状态指示

- **⚫ 本地模式**: 未配置Supabase，仅本地存储
- **🟡 本地存储**: 已配置Supabase但未登录
- **🟢 云端同步已开启**: 已登录，数据自动同步

## 🔧 故障排除

### 问题1: 页面显示 "本地模式"
**原因**: Supabase URL或API Key未正确配置
**解决**: 检查index.html中的配置是否正确

### 问题2: 注册时提示邮箱错误
**原因**: Supabase项目的邮箱验证设置
**解决**: 
1. 到Supabase控制台 → Authentication → Settings
2. 关闭 "Enable email confirmations"

### 问题3: 数据没有同步
**原因**: 可能是权限问题
**解决**: 确保SQL脚本完全执行，检查RLS策略

### 问题4: 登录失败
**原因**: 密码长度或邮箱格式问题
**解决**: 确保密码至少6个字符，邮箱格式正确

## 📞 支持

如果遇到问题：
1. 检查浏览器控制台的错误信息
2. 确认Supabase项目状态正常
3. 验证API凭据是否正确
4. 确保数据库表已正确创建

## 🎉 成功后的好处

- **自动备份**: 数据永不丢失
- **跨设备同步**: 手机、电脑都能访问
- **团队协作**: 可以邀请团队成员
- **扩展性**: 未来可以添加更多功能