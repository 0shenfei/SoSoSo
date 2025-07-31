#!/bin/bash

# 社交媒体日历 - 自动部署脚本
# 使用方法: ./deploy.sh "提交信息"

set -e  # 遇到错误时退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 社交媒体日历 - 自动部署脚本${NC}"
echo "======================================"

# 检查是否提供了提交信息
if [ -z "$1" ]; then
    echo -e "${YELLOW}⚠️  请提供提交信息${NC}"
    echo "使用方法: ./deploy.sh \"你的提交信息\""
    echo "示例: ./deploy.sh \"修复了日历显示bug\""
    exit 1
fi

COMMIT_MESSAGE="$1"

echo -e "${BLUE}📝 提交信息: ${COMMIT_MESSAGE}${NC}"
echo ""

# 检查Git状态
echo -e "${BLUE}🔍 检查Git状态...${NC}"
if ! git status --porcelain | grep -q .; then
    echo -e "${YELLOW}ℹ️  没有检测到文件更改${NC}"
    exit 0
fi

# 显示将要提交的文件
echo -e "${BLUE}📋 将要提交的文件:${NC}"
git status --short
echo ""

# 添加所有更改
echo -e "${BLUE}➕ 添加所有更改...${NC}"
git add .

# 提交更改
echo -e "${BLUE}💾 提交更改...${NC}"
git commit -m "$COMMIT_MESSAGE"

# 推送到远程仓库
echo -e "${BLUE}🚀 推送到GitHub...${NC}"
git push origin main

echo ""
echo -e "${GREEN}✅ 部署完成！${NC}"
echo -e "${GREEN}🌐 GitHub Actions 将自动部署到 GitHub Pages${NC}"
echo -e "${BLUE}📱 查看部署状态: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:\/]\([^\/]*\/[^\/]*\).*/\1/' | sed 's/\.git$//')/actions${NC}"
echo ""
echo -e "${YELLOW}💡 提示: 部署通常需要1-3分钟完成${NC}"