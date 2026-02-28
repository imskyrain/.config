#!/bin/bash
# Markdown 查看器快速安装脚本

echo "================================================"
echo "  Markdown 查看器安装向导"
echo "================================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${RED}✗ Homebrew 未安装${NC}"
    echo "请先安装 Homebrew: https://brew.sh/"
    exit 1
fi

echo -e "${GREEN}✓ Homebrew 已安装${NC}"
echo ""

# 推荐安装 glow（免费）
echo "【推荐】安装 Glow - 终端 Markdown 查看器（免费）"
echo "特点：轻量、快速、终端中直接渲染 Markdown"
echo ""
read -p "是否安装 glow? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "正在安装 glow..."
    brew install glow
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ glow 安装成功${NC}"
    else
        echo -e "${RED}✗ glow 安装失败${NC}"
    fi
else
    echo "跳过 glow 安装"
fi
echo ""

# 可选：MacDown（免费）
echo "【可选】安装 MacDown - 免费图形化 Markdown 编辑器"
echo "特点：免费、开源、实时预览"
echo ""
read -p "是否安装 MacDown? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "正在安装 MacDown..."
    brew install --cask macdown
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ MacDown 安装成功${NC}"
    else
        echo -e "${RED}✗ MacDown 安装失败${NC}"
    fi
else
    echo "跳过 MacDown 安装"
fi
echo ""

# 可选：QuickLook 插件（免费）
echo "【可选】安装 QLMarkdown - QuickLook Markdown 插件"
echo "特点：按空格键即可预览 Markdown"
echo ""
read -p "是否安装 QLMarkdown? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "正在安装 QLMarkdown..."
    brew install --cask qlmarkdown
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ QLMarkdown 安装成功${NC}"
        echo -e "${YELLOW}提示：需要重启 Finder 或重新登录才能生效${NC}"
        read -p "是否现在重启 Finder? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            killall Finder
            echo -e "${GREEN}✓ Finder 已重启${NC}"
        fi
    else
        echo -e "${RED}✗ QLMarkdown 安装失败${NC}"
    fi
else
    echo "跳过 QLMarkdown 安装"
fi
echo ""

# 付费选项
echo "【付费选项】以下工具需要购买授权："
echo "  - Typora: 专业 Markdown 编辑器 (~$15)"
echo "  - Marked 2: 专业 Markdown 预览器 (~$14)"
echo ""
echo "如需安装，请手动运行："
echo "  brew install --cask typora"
echo "  brew install --cask marked"
echo ""

# 总结
echo "================================================"
echo "  安装完成！"
echo "================================================"
echo ""
echo "下一步："
echo "1. 重启 yazi (在 yazi 中按 q 退出，然后重新启动)"
echo "2. 导航到任意 .md 文件"
echo "3. 按 O (大写字母) 打开选择菜单"
echo "4. 选择以下选项之一："
echo "   - edit          → nvim 编辑"
echo "   - Glow          → 终端渲染预览"
echo "   - MacDown       → 图形化编辑（如已安装）"
echo "   - QuickLook     → 系统快速预览（如已安装）"
echo ""
echo "查看详细文档："
echo "  cat markdown-viewer-setup.md"
echo ""
echo "享受更好的 Markdown 体验！ 🎉"
