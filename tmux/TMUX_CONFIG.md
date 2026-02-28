# Tmux 配置文档

## 概述

本配置基于 **Oh My Tmux!** 框架，结合了多个实用插件和自定义设置，提供了一个功能强大且用户友好的终端多路复用环境。

## 核心配置

### 基础设置

| 配置项 | 值 | 说明 |
|--------|----|----- |
| `default-terminal` | `screen-256color` | 支持256色显示 |
| `history-limit` | `50000` | 历史记录行数 |
| `base-index` | `1` | 窗口编号从1开始 |
| `pane-base-index` | `1` | 面板编号从1开始 |
| `mouse` | `on` | 启用鼠标支持 |
| `prefix` | `C-b` | 主前缀键 |
| `prefix2` | `C-a` | 备用前缀键 |
| `mode-keys` | `vi` | Vi模式键位 |
| `escape-time` | `10` | 加快命令响应 |

### 窗口管理

| 设置 | 值 | 说明 |
|------|----|----- |
| `automatic-rename` | `on` | 自动重命名窗口 |
| `renumber-windows` | `on` | 重新编号窗口 |
| `set-titles` | `on` | 设置终端标题 |
| `set-titles-string` | `#h ❐ #S ● #I #W` | 标题格式 |

## 主题配置

### Powerline Block Blue 主题

使用 `tmux-themepack` 的 `powerline/block/blue` 主题，具有以下特点：

#### 状态栏左侧
```
#S #[fg=white]» #[fg=yellow]#I #[fg=cyan]#P
```
- 会话名称
- 窗口索引
- 面板索引

#### 状态栏右侧
```
#{prefix_highlight} %H:%M:%S #[fg=white]« #[fg=yellow]CPU:#{cpu_percentage} BAT:#{battery_percentage}#{battery_status} #[fg=green]#H
```
- 前缀键高亮指示器
- 当前时间
- CPU使用率
- 电池状态
- 主机名

#### 窗口状态格式
- **当前窗口**: ` #I:#W#F ` (红底黑字，加粗)
- **普通窗口**: ` #I:#W#F ` (默认样式)
- **活动窗口**: 黄色前景

## 插件配置

### 已安装插件

| 插件 | 功能 | 配置 |
|------|------|------|
| `tmux-sensible` | 合理的默认设置 | 默认 |
| `tmux-themepack` | 主题包 | `powerline/block/blue` |
| `tmux-cpu` | CPU监控 | 状态栏显示CPU百分比 |
| `tmux-battery` | 电池状态 | 状态栏显示电池信息 |
| `tmux-resurrect` | 会话保存/恢复 | 捕获面板内容 |
| `tmux-continuum` | 自动会话恢复 | 启用自动恢复 |
| `tmux-yank` | 系统剪贴板集成 | 选择剪贴板模式 |
| `tmux-prefix-highlight` | 前缀键指示器 | 状态栏高亮显示 |
| `vim-tmux-navigator` | Vim与tmux导航 | Ctrl-hjkl无缝切换 |
| `tmux-fzf` | 模糊查找 | 集成fzf功能 |
| `tmux-sidebar` | 文件树侧边栏 | 左侧40列宽度 |
| `tmux-thumbs` | 快速复制 | 空格键激活 |

### 插件详细配置

#### tmux-sidebar
```bash
@sidebar-tree-command "tree -C -I \"node_modules|.git|target|dist\""
@sidebar-tree-position left
@sidebar-tree-width 40
```

#### tmux-thumbs
```bash
@thumbs-key Space
@thumbs-command "echo -n {} | pbcopy"
@thumbs-regexp-1 "[a-z][a-z0-9-]{30,}"
```

#### tmux-resurrect/continuum
```bash
@continuum-restore on
@resurrect-capture-pane-contents on
```

## 快捷键绑定

### 会话管理
| 快捷键 | 功能 |
|--------|------|
| `C-c` | 创建新会话 |
| `C-f` | 查找会话 |
| `BTab` | 切换到上一个会话 |

### 窗口和面板操作
| 快捷键 | 功能 |
|--------|------|
| `-` | 水平分割面板 |
| `_` | 垂直分割面板 |
| `h/j/k/l` | 面板导航 (Vi模式) |
| `H/J/K/L` | 调整面板大小 |
| `</>` | 交换面板位置 |
| `+` | 最大化当前面板 |
| `Tab` | 切换到上一个窗口 |
| `C-h/C-l` | 上一个/下一个窗口 |
| `C-S-H/C-S-L` | 交换窗口位置 |

### 复制模式 (Vi模式)
| 快捷键 | 功能 |
|--------|------|
| `Enter` | 进入复制模式 |
| `v` | 开始选择 |
| `C-v` | 矩形选择 |
| `y` | 复制到剪贴板 |
| `Escape` | 退出复制模式 |
| `H/L` | 行首/行尾 |
| `DoubleClick1Pane` | 选择单词 |
| `TripleClick1Pane` | 选择整行 |

### 鼠标优化
| 快捷键 | 功能 |
|--------|------|
| `MouseDragEnd1Pane` | 复制选择不清除 |
| `DoubleClick1Pane` | 选择单词并复制 |
| `TripleClick1Pane` | 选择整行并复制 |

### 插件快捷键
| 快捷键 | 功能 |
|--------|------|
| `C-h/j/k/l` | Vim与tmux无缝导航 |
| `Space` | 激活thumbs快速复制 |
| `prefix + I` | 安装TPM插件 |
| `prefix + u` | 更新TPM插件 |
| `prefix + Alt+u` | 卸载TPM插件 |

## 自定义功能

### Main会话保护
```bash
# 在choose-tree中使用X/x安全删除会话
bind-key -T choose-tree X if-shell -F "#{==:#{session_name},main}" \
  "display-message 'main 是守护 session，不能删除'" \
  "kill-session -t \"#{session_name}\""

# 保护main会话的最后一个面板
bind-key x if-shell -F "#{&&:#{==:#{session_name},main},#{==:#{session_windows},1},#{==:#{window_panes},1}}" \
  "display-message '不能关闭 main session 的最后一个 pane'" \
  "confirm-before -p \"kill-pane #P? (y/n)\" kill-pane"
```

### 剪贴板集成
- macOS: `pbcopy`
- Linux: `xsel` / `xclip`
- Wayland: `wl-copy`
- Windows: `clip.exe`

## 状态栏变量

### 可用变量
- `#{battery_percentage}` - 电池百分比
- `#{battery_status}` - 电池状态 (↑充电/↓放电)
- `#{cpu_percentage}` - CPU使用率
- `#{prefix_highlight}` - 前缀键指示器
- `#{uptime_y/d/h/m/s}` - 系统运行时间
- `#{hostname}` - 主机名
- `#{username}` - 用户名

## 配置文件结构

```
~/.tmux/
├── .tmux.conf          # Oh My Tmux! 主配置
├── .tmux.conf.local    # 本地自定义配置
└── plugins/            # TPM插件目录
    ├── tpm/
    ├── tmux-sensible/
    ├── tmux-themepack/
    └── ...
```

## 使用建议

### 日常使用
1. **启动**: `tmux` 或 `tmux attach -t main`
2. **导航**: 优先使用 `Ctrl-hjkl` 在面板间切换
3. **复制**: 使用 `Space` 激活thumbs快速复制
4. **查找**: 使用 `tmux-fzf` 进行模糊搜索

### 开发工作流
1. **会话管理**: 为不同项目创建独立会话
2. **面板布局**: 主编辑器 + 终端 + 文件树
3. **自动恢复**: 利用continuum自动恢复工作状态
4. **快速复制**: thumbs插件快速复制路径/URL/SHA

### 故障排除
1. **重新加载配置**: `prefix + r`
2. **编辑配置**: `prefix + e`
3. **查看插件状态**: 检查 `~/.tmux/plugins/` 目录

## 性能优化

- **历史限制**: 50000行，平衡内存使用和需求
- **状态更新间隔**: 1秒，实时但不频繁
- **鼠标模式**: 启用，提升操作效率
- **Vi模式**: 减少模式切换时间

## 兼容性

- **tmux版本**: 3.0+ (推荐3.2+以支持扩展键位)
- **终端**: 支持256色和UTF-8的现代终端
- **操作系统**: macOS/Linux/Windows(WSL)

---

*最后更新: 2026-02-07*
*配置版本: Oh My Tmux! + 自定义优化*