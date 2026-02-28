# Tmux 深度配置文档

## 目录
1. [会话(Session)管理](#会话session管理)
2. [窗口(Window)操作](#窗口window操作)
3. [面板(Pane)控制](#面板pane控制)
4. [命令行模式详解](#命令行模式详解)
5. [交互模式详解](#交互模式详解)
6. [设计思想与架构](#设计思想与架构)
7. [高级技巧与最佳实践](#高级技巧与最佳实践)

---

## 会话(Session)管理

### 会话概念与作用

会话是tmux的最高级别组织单位，代表一个独立的终端工作环境。每个会话可以包含多个窗口，支持：

- **持久化**: 即使断开连接，会话仍然在后台运行
- **隔离性**: 不同会话之间的进程完全隔离
- **恢复性**: 系统重启后可通过continuum自动恢复

### 会话创建与管理

#### 创建新会话
```bash
# 基础创建
tmux new-session -s session_name

# 在指定目录创建
tmux new-session -s project -c /path/to/project

# 指定窗口名称
tmux new-session -s dev -n editor

# 分离式创建（不立即附加）
tmux new-session -d -s background
```

#### 当前配置快捷键
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `C-c` | 创建新会话 | Oh My Tmux! 默认绑定 |
| `C-f` | 查找会话 | 交互式选择 |
| `BTab` | 切换到上一个会话 | 快速切换 |

#### 会话操作命令
```bash
# 列出所有会话
tmux list-sessions
tmux ls

# 附加到指定会话
tmux attach-session -t session_name
tmux a -t session_name

# 分离当前会话
tmux detach-client
prefix + d

# 重命名会话
tmux rename-session -t old_name new_name
prefix + $  # 交互式重命名

# 删除会话
tmux kill-session -t session_name
```

### 会话保护机制

#### Main会话守护机制
配置中实现了特殊的main会话保护：

```bash
# 在choose-tree模式下的保护
bind-key -T choose-tree X if-shell -F "#{==:#{session_name},main}" \
  "display-message 'main 是守护 session，不能删除'" \
  "kill-session -t \"#{session_name}\""

# 面板保护机制
bind-key x if-shell -F "#{&&:#{==:#{session_name},main},#{==:#{session_windows},1},#{==:#{window_panes},1}}" \
  "display-message '不能关闭 main session 的最后一个 pane'" \
  "confirm-before -p \"kill-pane #P? (y/n)\" kill-pane"
```

**设计理念**: 
- Main会话作为"守护进程"存在
- 防止误操作导致的工作环境丢失
- 确保至少有一个稳定的工作环境

---

## 窗口(Window)操作

### 窗口概念

窗口是会话内的第二级组织单位，每个窗口可以包含多个面板：

```
Session (会话)
├── Window 1 (窗口)
│   ├── Pane 1 (面板)
│   └── Pane 2 (面板)
└── Window 2 (窗口)
    ├── Pane 1 (面板)
    └── Pane 2 (面板)
```

### 窗口管理快捷键

#### 基础操作
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `c` | 创建新窗口 | 在当前目录 |
| `&` | 删除当前窗口 | 保护main会话 |
| `,` | 重命名窗口 | 交互式 |
| `.` | 显示窗口编号 | 快速跳转 |
| `w` | 窗口选择器 | choose-tree模式 |

#### 导航操作
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `C-h` | 上一个窗口 | 循环导航 |
| `C-l` | 下一个窗口 | 循环导航 |
| `Tab` | 最后活跃窗口 | 快速切换 |
| `0-9` | 跳转到窗口 | 数字索引 |
| `C-S-H` | 向左移动窗口 | 交换位置 |
| `C-S-L` | 向右移动窗口 | 交换位置 |

#### 窗口状态与格式
```
# 当前窗口格式
" #I:#W#F "  # 索引:名称#标记

# 标记说明：
#F = #{window_flags}
- * 当前窗口
- - 最后窗口
- ! 有活动通知
- Z 缩放状态
```

### 窗口布局系统

#### 预定义布局
| 布局名 | 模式 | 适用场景 |
|--------|------|----------|
| `even-horizontal` | 均匀水平分布 | 多个终端面板 |
| `even-vertical` | 均匀垂直分布 | 多个代码编辑器 |
| `main-horizontal` | 主面板+水平辅助 | 主要工作区 |
| `main-vertical` | 主面板+垂直辅助 | 主编辑器+终端 |
| `tiled` | 平铺布局 | 监控面板 |

#### 布局切换
```bash
prefix + Space  # 循环切换布局
prefix + M-{1,2,3,4,5}  # 跳转到指定布局
```

---

## 面板(Pane)控制

### 面板概念

面板是tmux的最小工作单元，代表一个独立的终端实例。面板管理是tmux的核心优势：

- **并行执行**: 同时运行多个命令
- **可视化对比**: 并排查看代码输出
- **任务分离**: 不同面板承担不同任务

### 面板创建与分割

#### 分割操作
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `-` | 水平分割 | 上下分割 |
| `_` | 垂直分割 | 左右分割 |
| `!` | 将面板转为新窗口 | 独立面板 |

#### 智能分割特性
```bash
# 保持当前路径
tmux split-window -c "#{pane_current_path}"

# 分割后执行命令
tmux split-window -c "#{pane_current_path}" "npm run dev"
```

### 面板导航系统

#### Vi模式导航
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `h` | 左移面板 | 按方向移动 |
| `j` | 下移面板 | 按方向移动 |
| `k` | 上移面板 | 按方向移动 |
| `l` | 右移面板 | 按方向移动 |
| `q` | 显示面板编号 | 快速选择 |

#### Vim-Tmux-Navigator集成
```bash
# 在tmux和vim之间无缝导航
Ctrl-h  # 左侧
Ctrl-j  # 下方
Ctrl-k  # 上方
Ctrl-l  # 右侧
```

### 面板管理操作

#### 面板调整
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `H/J/K/L` | 调整面板大小 | 大写键调整 |
| `</>` | 交换面板位置 | 上下交换 |
| `+` | 最大化/恢复面板 | 临时全屏 |
| `z` | 缩放面板 | 切换大小 |
| `m` | 标记面板 | 用于交换操作 |

#### 面板生命周期
```bash
# 创建面板
tmux split-window [-h] [-c start-directory] [shell-command]

# 删除面板
tmux kill-pane [-t target-pane]

# 重启面板
tmux respawn-pane [-k] [shell-command]

# 关闭其他面板
tmux kill-pane -a
```

### 面板状态管理

#### 面板同步功能
```bash
# 同步所有面板输入
prefix + : setw synchronize-panes on

# 关闭同步
prefix + : setw synchronize-panes off
```

#### 面板信息显示
```bash
prefix + q  # 显示面板编号（短暂显示）
prefix + i  # 显示面板详细信息
```

---

## 命令行模式详解

### 命令行模式概述

命令行模式是tmux的强大功能，允许执行复杂操作和脚本化任务。

### 进入命令行模式

#### 方式
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `prefix + :` | 进入命令行模式 | 执行tmux命令 |
| `prefix + ?` | 显示键绑定帮助 | 查看所有快捷键 |
| `prefix + !` | 提示符模式 | 自定义提示符 |

### 命令行功能分类

#### 会话管理命令
```bash
# 会话操作
new-session [-AdDEPX] [-s session-name] [-n window-name]
attach-session [-t target-session]
detach-client [-P] [-c target-client]
kill-session [-aC] [-t target-session]
rename-session [-t target-session] new-name
```

#### 窗口管理命令
```bash
# 窗口操作
new-window [-abdkPS] [-n window-name] [-t target-window]
select-window [-lnpT] [-t target-window]
kill-window [-a] [-t target-window]
rename-window [-t target-window] new-name
move-window [-r] [-s src-window] [-t dst-window]
```

#### 面板管理命令
```bash
# 面板操作
split-window [-bdefhIPvZ] [-l size] [-t target-pane]
select-pane [-DdeLlMmRUZ] [-t target-pane]
kill-pane [-a] [-t target-pane]
resize-pane [-DLMRUZ] [-t target-pane] [size]
swap-pane [-dDUZ] [-s src-pane] [-t dst-pane]
```

#### 配置管理命令
```bash
# 选项设置
set-option [-agqsw] [-t target-session|window|pane] option [value]
set-window-option [-agq] [-t target-window] option [value]
show-options [-gqsv] [-t target-session|window|pane]
show-window-options [-gqv] [-t target-window]
```

### 高级命令行技巧

#### 条件执行
```bash
# 条件判断
if-shell "test -f ~/.tmux.local" "source ~/.tmux.local"

# 基于当前状态的条件操作
if-shell "#{==:#{session_name},main}" "display 'Main session'"
```

#### 链式命令
```bash
# 分号分隔多个命令
new-window \; send-keys "vim" C-m \; split-window \; send-keys "npm run dev" C-m

# 管道和重定向
run-shell "tmux list-sessions | grep -v main > /tmp/sessions.txt"
```

#### 命令历史
```bash
# 在命令行中使用
Ctrl-p  # 上一个命令
Ctrl-n  # 下一个命令
Ctrl-r  # 搜索命令历史
```

---

## 交互模式详解

### Choose-Tree模式

#### 功能概述
Choose-tree是tmux的交互式选择界面，提供可视化的会话/窗口/面板管理。

#### 启动方式
| 快捷键 | 功能 | 范围 |
|--------|------|------|
| `prefix + s` | 会话选择树 | 仅会话 |
| `prefix + w` | 窗口选择树 | 仅窗口 |
| `prefix + BTab` | 选择树交互 | 智能选择 |

#### Choose-Tree导航
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `j/k` | 上下移动 | 导航项目 |
| `h/l` | 展开/折叠 | 层级导航 |
| `Enter` | 选择项目 | 附加/切换 |
| `x/X` | 删除项目 | 带保护机制 |
| `q/Escape` | 退出选择 | 取消操作 |

#### 自定义保护机制
```bash
# Main会话保护
bind-key -T choose-tree X if-shell -F "#{==:#{session_name},main}" \
  "display-message 'main 是守护 session，不能删除'" \
  "kill-session -t \"#{session_name}\""
```

### Display-Menu模式

#### 右键上下文菜单
当前配置实现了强大的右键菜单系统：

```bash
# 右键菜单功能
"Horizontal Split" h { split-window -h -c "#{pane_current_path}" }
"Vertical Split" v { split-window -v -c "#{pane_current_path}" }
"Swap Up" u { swap-pane -U }
"Swap Down" d { swap-pane -D }
"Kill" X { kill-pane }
"Zoom/Unzoom" z { resize-pane -Z }
```

#### 菜单导航
- 鼠标移动选择菜单项
- 键盘快捷键快速执行
- 支持条件显示和隐藏

### Copy-Mode (复制模式)

#### Vi模式复制
当前配置使用Vi模式复制：

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Enter` | 进入复制模式 | |
| `v` | 开始选择 | 可视选择 |
| `C-v` | 矩形选择 | 块选择 |
| `y` | 复制到剪贴板 | 系统集成 |
| `Escape` | 退出复制模式 | |
| `H/L` | 跳转行首/行尾 | 快速导航 |

#### 智能复制增强
```bash
# 双击选择单词并复制
bind -T copy-mode-vi DoubleClick1Pane select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel pbcopy

# 三击选择整行并复制
bind -T copy-mode-vi TripleClick1Pane select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel pbcopy

# 拖动结束后不清除选择
unbind -T copy-mode-vi MouseDragEnd1Pane
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-no-clear
```

### 其他交互模式

#### Choose-Buffer模式
```bash
prefix + =      # 可视化选择缓冲区
prefix + P      # 选择并粘贴缓冲区
```

#### Choose-Client模式
```bash
prefix + D      # 选择客户端并附加
```

---

## 设计思想与架构

### 分层架构设计

#### 三层组织模型
```
┌─────────────────────────────────────┐
│           Session Layer            │  ← 持久化层
│  工作环境隔离、持久化、恢复      │
├─────────────────────────────────────┤
│            Window Layer           │  ← 任务组织层  
│  任务分组、上下文切换、布局管理   │
├─────────────────────────────────────┤
│             Pane Layer            │  ← 执行单元层
│  并行执行、实时对比、多任务处理   │
└─────────────────────────────────────┘
```

#### 职责分离原则
- **Session**: 负责持久化和隔离
- **Window**: 负责任务组织和上下文
- **Pane**: 负责具体执行和显示

### 核心设计理念

#### 1. 持久化工作环境
```bash
# 自动保存与恢复
@continuum-restore on
@resurrect-capture-pane-contents on
```

**设计思想**: 工作环境应该是持久化的，不应该因为网络断开或系统重启而丢失。

#### 2. 最小认知负荷
```bash
# 一致的导航键位
h/j/k/l        # 统一的方向导航
C-h/C-l        # 统一的窗口切换
prefix + space  # 统一的模式切换
```

**设计思想**: 降低用户的心智模型负担，提供一致的交互体验。

#### 3. 渐进式增强
```bash
# 基础功能开箱即用
mouse on        # 鼠标支持
history-limit 50000  # 足够的历史记录

# 高级功能按需配置
tmux-thumbs     # 快速复制
tmux-sidebar    # 文件管理
vim-tmux-navigator # 无缝导航
```

**设计思想**: 新用户可以立即使用，高级用户可以逐步探索更多功能。

#### 4. 防御性编程
```bash
# 保护机制
if-shell "#{==:#{session_name},main}" \
  "display-message 'main 是守护 session，不能删除'"
```

**设计思想**: 防止用户误操作导致的不可逆损失。

### 插件化架构

#### TPM (Tmux Plugin Manager)
```bash
# 声明式配置
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'tmux-plugins/tmux-battery'
```

**设计优势**:
- **模块化**: 功能按需加载
- **可维护性**: 插件独立更新
- **可扩展性**: 社区贡献新功能

#### 插件分类设计
1. **核心增强**: `tmux-sensible`, `tmux-yank`
2. **视觉美化**: `tmux-themepack`, `tmux-prefix-highlight`
3. **信息展示**: `tmux-cpu`, `tmux-battery`
4. **工具集成**: `tmux-sidebar`, `tmux-fzf`, `tmux-thumbs`
5. **工作流优化**: `tmux-resurrect`, `vim-tmux-navigator`

### 状态管理设计

#### 分散式状态模型
```bash
# 状态分散在不同组件
@battery_charge 1.00                    # 电池状态
@cpu_percentage "15.7%"                # CPU状态
@continuum-restore on                   # 恢复状态
@resurrect-capture-pane-contents on     # 捕获状态
```

#### 统一状态展示
```bash
# 状态栏统一展示所有信息
status-right "#{prefix_highlight} %H:%M:%S #[fg=white]« #[fg=yellow]CPU:#{cpu_percentage} BAT:#{battery_percentage}#{battery_status} #[fg=green]#H"
```

**设计哲学**: 状态管理应该无感知但信息充分。

---

## 高级技巧与最佳实践

### 会话管理最佳实践

#### 命名约定
```bash
# 按项目命名
tmux new -s myproject-web
tmux new -s myproject-api
tmux new -s myproject-docs

# 按环境命名
tmux new -s dev-env
tmux new -s staging-env
tmux new -s prod-monitor
```

#### 会话启动脚本
```bash
#!/bin/bash
# ~/.tmux/start-project.sh

PROJECT_NAME=$1
PROJECT_PATH=$2

tmux new-session -d -s $PROJECT_NAME -c $PROJECT_PATH
tmux send-keys "nvim" C-m
tmux split-window -h -c $PROJECT_PATH
tmux send-keys "npm run dev" C-m
tmux split-window -v -c $PROJECT_PATH
tmux send-keys "git status" C-m
tmux attach-session -t $PROJECT_NAME
```

### 窗口布局最佳实践

#### 开发环境标准布局
```bash
# 布局预设
prefix + : setw main-horizontal
# 主面板: 代码编辑器 (左侧)
# 辅助面板: 终端 (右侧下方)
# 监控面板: 日志 (右侧上方)
```

#### 布局脚本化
```bash
#!/bin/bash
# 创建标准开发布局
tmux split-window -h
tmux split-window -v
tmux select-pane -t 0
tmux split-window -v
tmux select-layout main-horizontal
```

### 面板工作流优化

#### 并行任务管理
```bash
# 同步执行命令
setw synchronize-panes on
# 在所有面板同时执行命令
npm install

# 关闭同步
setw synchronize-panes off
```

#### 面板标记系统
```bash
# 标记重要面板
prefix + m  # 标记当前面板
prefix + }  # 下一个标记面板
prefix + {  # 上一个标记面板
```

### 性能优化技巧

#### 资源管理
```bash
# 限制历史记录
set -g history-limit 10000  # 根据需要调整

# 控制状态更新频率
set -g status-interval 5    # 降低更新频率

# 优化鼠标事件
set -g mouse on             # 开启鼠标但避免过度使用
```

#### 内存优化
```bash
# 清理未使用的会话
tmux kill-server  # 重置所有会话

# 定期清理缓冲区
prefix + #      # 列出缓冲区
prefix + &      # 删除缓冲区
```

### 自动化工作流

#### Git集成
```bash
# Git状态面板
tmux display-popup -E "git status --short && echo '' && git log --oneline -5"

# 快速Git操作
bind g new-window -n git 'git status'
bind G new-window -n git-log 'git log --oneline -10'
```

#### 项目管理集成
```bash
# Docker集成
bind D new-window -n docker 'docker ps'
bind d display-popup -E "docker-compose ps"

# 监控集成
bind M new-window -n monitor 'htop'
bind N new-window -n network 'nethogs'
```

### 故障排除与调试

#### 配置验证
```bash
# 检查配置语法
tmux source-file ~/.tmux.conf

# 查看生效配置
tmux show-options -g
tmux show-window-options -g

# 调试信息
tmux info
```

#### 常见问题解决
```bash
# 修复鼠标不工作
set -g mouse on

# 修复配色问题
set -g default-terminal "screen-256color"

# 修复复制问题
set -g set-clipboard on
```

---

## 总结

本配置体系体现了现代终端工作环境的设计理念：

### 核心价值
1. **持久性**: 工作环境永不丢失
2. **效率性**: 最小化操作成本
3. **可扩展性**: 按需定制功能
4. **安全性**: 防止误操作损失

### 技术特色
- **分层架构**: Session→Window→Pane清晰分离
- **插件生态**: 模块化功能扩展
- **智能保护**: 防御性编程实践
- **无缝集成**: 跨工具协同工作

### 使用理念
> "让工具适应人，而不是人适应工具"

通过合理的配置和优化，tmux不仅仅是一个终端复用器，而是一个完整的开发环境管理平台。

---

*文档版本: v2.0*  
*更新时间: 2026-02-07*  
*基于配置: Oh My Tmux! + 自定义优化*