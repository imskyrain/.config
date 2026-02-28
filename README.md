# .config

个人配置文件集合，包含常用工具的配置。

## 包含的配置

- **tmux** - 终端复用器配置
- **nvim** - Neovim 编辑器配置
- **yazi** - 文件管理器配置
- **alacritty** - 终端模拟器配置

## 安装

### 方式 1: 直接克隆到 ~/.config

```bash
# 备份现有配置（如果有）
mv ~/.config ~/.config.backup

# 克隆仓库
git clone git@github.com:imskyrain/.config.git ~/.config
```

### 方式 2: 克隆到自定义位置并创建软链接

```bash
# 克隆到指定位置
git clone git@github.com:imskyrain/.config.git ~/Tools/git_core/github/.config

# 创建软链接到 ~/.config
ln -s ~/Tools/git_core/github/.config/nvim ~/.config/nvim
ln -s ~/Tools/git_core/github/.config/yazi ~/.config/yazi
ln -s ~/Tools/git_core/github/.config/alacritty ~/.config/alacritty
ln -s ~/Tools/git_core/github/.config/tmux/.tmux.conf ~/.config/.tmux.conf

# tmux 配置需要额外软链接到家目录
ln -s ~/Tools/git_core/github/.config/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/Tools/git_core/github/.config/tmux/.tmux.conf.local ~/.tmux.conf.local
```

### 当前使用的软链接配置

```bash
# ~/.config 目录下
~/.config/nvim -> ~/Tools/git_core/github/.config/nvim
~/.config/yazi -> ~/Tools/git_core/github/.config/yazi
~/.config/alacritty -> ~/Tools/git_core/github/.config/alacritty
~/.config/.tmux.conf -> ~/Tools/git_core/github/.config/tmux/.tmux.conf

# 家目录下（tmux 配置）
~/.tmux.conf -> ~/Tools/git_core/github/.config/tmux/.tmux.conf
~/.tmux.conf.local -> ~/Tools/git_core/github/.config/tmux/.tmux.conf.local
```

## 原仓库地址

这些配置文件原先是独立的 git 仓库，现已整合：

- tmux: `git@github.com:imskyrain/.tmux.git`
- nvim: `git@github.com:imskyrain/nvim.git`
- yazi: `git@github.com:imskyrain/yazi.git`
- alacritty: `git@github.com:imskyrain/alacritty.git`
