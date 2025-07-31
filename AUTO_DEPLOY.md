# 🚀 自动部署指南

本项目已配置自动部署功能，每次代码更新后会自动推送到GitHub并部署到GitHub Pages。

## 📋 功能特性

- ✅ **自动化部署**：推送到main分支后自动部署
- ✅ **GitHub Pages**：自动发布到GitHub Pages
- ✅ **快速脚本**：一键提交和推送代码
- ✅ **状态监控**：实时查看部署状态

## 🛠️ 使用方法

### 方法一：使用自动部署脚本（推荐）

```bash
# 一键提交并推送代码
./deploy.sh "你的提交信息"

# 示例
./deploy.sh "修复了日历显示bug"
./deploy.sh "添加了新的媒体压缩功能"
./deploy.sh "优化了用户界面"
```

### 方法二：手动Git命令

```bash
# 添加所有更改
git add .

# 提交更改
git commit -m "你的提交信息"

# 推送到GitHub
git push origin main
```

## 🔧 首次设置

### 1. 启用GitHub Pages

1. 进入你的GitHub仓库
2. 点击 **Settings** 标签
3. 滚动到 **Pages** 部分
4. 在 **Source** 下选择 **GitHub Actions**
5. 保存设置

### 2. 验证部署

1. 推送代码后，访问仓库的 **Actions** 标签
2. 查看 "Auto Deploy to GitHub Pages" 工作流
3. 等待部署完成（通常1-3分钟）
4. 访问你的GitHub Pages网址

## 📱 访问网站

部署完成后，你的网站将在以下地址可用：
```
https://你的用户名.github.io/你的仓库名
```

## 🔍 监控部署状态

- **GitHub Actions**: `https://github.com/你的用户名/你的仓库名/actions`
- **部署历史**: 在Actions页面查看所有部署记录
- **错误排查**: 如果部署失败，查看Actions日志

## ⚡ 快速命令参考

```bash
# 查看当前状态
git status

# 查看提交历史
git log --oneline -5

# 强制推送（谨慎使用）
git push origin main --force

# 查看远程仓库信息
git remote -v
```

## 🚨 注意事项

1. **分支要求**：确保推送到 `main` 分支
2. **权限设置**：确保GitHub Actions有足够权限
3. **部署时间**：首次部署可能需要更长时间
4. **缓存问题**：如果更新未显示，尝试清除浏览器缓存

## 🛠️ 故障排除

### 部署失败
- 检查GitHub Actions日志
- 确认文件路径正确
- 验证权限设置

### 网站未更新
- 等待几分钟让部署完成
- 清除浏览器缓存
- 检查GitHub Pages设置

### 脚本权限错误
```bash
# 给脚本添加执行权限
chmod +x deploy.sh
```

## 📞 支持

如果遇到问题，请：
1. 查看GitHub Actions日志
2. 检查本文档的故障排除部分
3. 确认所有设置步骤已正确完成

---

🎉 **恭喜！** 你的项目现在支持自动部署了！