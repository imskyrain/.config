# Sublime Text 风格使用指南

本配置已添加 Sublime Text 风格的功能，包括自动 Session 恢复和 Oil.nvim 文件浏览器。

## 🎯 核心功能

### 1. Session 管理 - 类似 Sublime Text 的缓存恢复

#### 自动恢复功能
- **自动保存**: 退出 Neovim 时自动保存当前 session
- **自动恢复**: 启动 Neovim 时自动恢复上次的工作状态
- 保存内容包括:
  - 所有打开的文件/缓冲区
  - 窗口布局
  - 标签页
  - 工作目录
  - 光标位置

#### Session 快捷键

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>qs` | 恢复当前目录 Session | 恢复当前工作目录的 session |
| `<leader>ql` | 恢复上次 Session | 恢复最后一次打开的 session |
| `<leader>qd` | 停止保存 Session | 临时禁用 session 自动保存 |

#### 使用场景

**场景 1: 日常使用**
```bash
# 第一次打开项目
cd ~/my-project
nvim

# 打开多个文件，编辑后退出
:wq

# 第二天再打开，自动恢复昨天的状态
cd ~/my-project
nvim
# 所有文件和窗口布局都恢复了！
```

**场景 2: 多项目切换**
```bash
# 项目 A
cd ~/project-a
nvim
# ... 编辑工作 ...
:wq

# 项目 B
cd ~/project-b
nvim
# ... 编辑工作 ...
:wq

# 回到项目 A，自动恢复项目 A 的状态
cd ~/project-a
nvim
```

**场景 3: 手动恢复**
如果因为某些原因自动恢复失败，可以手动恢复:
- 按 `<leader>qs` 恢复当前目录的 session
- 按 `<leader>ql` 恢复上次的 session

### 2. Oil.nvim 文件浏览器 - 像编辑文本一样编辑文件系统

#### 什么是 Oil.nvim?
Oil 将文件系统显示为可编辑的 buffer，你可以像编辑文本文件一样编辑文件系统:
- 移动、重命名、删除文件就像编辑文本一样
- 支持所有 Vim 操作: `dd` 删除, `yy` 复制, `p` 粘贴等
- 编辑完成后保存 (`:w`) 即可应用更改

#### 打开 Oil 文件浏览器

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>e` | 打开浮动窗口文件浏览器 | 推荐使用，不会打乱布局 |
| `<leader>E` | 在当前窗口打开文件浏览器 | 替换当前 buffer |
| `-` | 打开父目录 | 快速向上导航 |

#### Oil 基本操作

**导航操作**
- `<CR>` (回车) - 打开文件或进入目录
- `-` - 返回上级目录
- `_` - 跳转到工作目录根
- `g.` - 显示/隐藏隐藏文件

**文件操作**
1. **移动/重命名文件**
   ```
   # 光标移到文件名上
   cw          # 修改文件名
   输入新名字
   <Esc>
   :w          # 保存应用修改
   ```

2. **删除文件**
   ```
   dd          # 删除当前行（文件）
   :w          # 保存应用删除
   ```

3. **创建新文件/目录**
   ```
   o           # 在下方新建行
   输入文件名   # 文件名
   输入目录名/  # 目录名（以 / 结尾）
   :w          # 保存创建
   ```

4. **复制文件**
   ```
   yy          # 复制当前文件
   p           # 粘贴
   修改文件名
   :w          # 保存
   ```

**分屏操作**
- `<C-s>` - 在垂直分屏中打开文件
- `<C-h>` - 在水平分屏中打开文件
- `<C-t>` - 在新标签页中打开文件
- `<C-p>` - 预览文件（不打开）

**其他操作**
- `<C-l>` - 刷新文件列表
- `<C-c>` - 关闭 Oil 窗口
- `g?` - 显示帮助信息
- `gs` - 改变排序方式
- `gx` - 用系统默认程序打开文件

#### Oil 使用示例

**示例 1: 打开文件夹并浏览**
```
1. 按 <leader>e 打开 Oil 浮动窗口
2. 使用 j/k 上下移动
3. 按回车打开文件或进入目录
4. 按 - 返回上级目录
```

**示例 2: 批量重命名文件**
```
1. 打开 Oil
2. 使用 visual mode 选择多个文件
3. 使用替换命令: :'<,'>s/old/new/g
4. :w 保存应用更改
```

**示例 3: 快速组织文件**
```
1. 打开 Oil
2. 新建目录: o 然后输入 "new_folder/"
3. dd 剪切文件
4. 进入新目录，按 p 粘贴
5. :w 保存所有更改
```

### 3. Sublime Text 风格快捷键

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-n>` | 新建文件 | 创建新的空白 buffer |
| `<C-s>` | 保存文件 | 保存当前文件 |
| `<C-w>` | 关闭文件 | 关闭当前 buffer |
| `<C-Tab>` | 下一个文件 | 切换到下一个 buffer |
| `<C-S-Tab>` | 上一个文件 | 切换到上一个 buffer |
| `<C-a>` | 全选 | 选择所有内容 |

### 4. 编辑器增强设置

已添加以下 Sublime Text 风格的设置:

```lua
-- 缓冲区管理
hidden = true           -- 允许在未保存的 buffer 间切换
confirm = true          -- 退出时提示保存
autoread = true         -- 自动重载外部修改的文件

-- 文件管理
swapfile = false        -- 禁用交换文件（更接近 Sublime）
backup = false          -- 禁用备份文件
writebackup = false     -- 禁用写入前备份

-- 界面
mouse = "a"             -- 启用鼠标支持
smoothscroll = true     -- 平滑滚动
updatetime = 300        -- 更快的事件触发
```

## 📋 完整工作流示例

### 典型的工作流程

```bash
# 1. 打开项目
cd ~/my-project
nvim
# → 自动恢复上次的工作状态

# 2. 浏览和打开文件
按 <leader>e
# → 打开 Oil 文件浏览器
浏览到文件，按回车打开

# 3. 编辑多个文件
<C-n>              # 新建文件
<C-s>              # 保存
<C-Tab>            # 切换到下一个文件
<C-w>              # 关闭不需要的文件

# 4. 文件管理
<leader>e          # 打开 Oil
dd                 # 删除不需要的文件
o                  # 创建新文件
:w                 # 应用文件系统更改

# 5. 退出
:wqa               # 保存所有并退出
# → Session 自动保存

# 6. 第二天继续
nvim
# → 自动恢复昨天的工作状态
```

## 🔧 配置位置

- **Session 管理**: `lua/plugins/utils/persistence.lua`
- **Oil 配置**: `lua/plugins/editor/oil.lua`
- **基础设置**: `lua/core/basic.lua`
- **快捷键**: `lua/core/keymap.lua`

## 💡 提示和技巧

### Session 技巧

1. **禁用特定目录的自动恢复**
   ```bash
   # 使用参数打开文件，不会自动恢复 session
   nvim file.txt
   ```

2. **清理 Session**
   ```bash
   # Session 保存在:
   rm -rf ~/.local/state/nvim/sessions/
   ```

3. **临时禁用 Session**
   ```vim
   " 在 Neovim 中执行
   :lua require("persistence").stop()
   ```

### Oil 技巧

1. **批量操作**
   - 使用 visual mode 选择多行
   - 使用 Vim 的替换命令批量修改

2. **撤销操作**
   - 在保存 (`:w`) 之前，所有修改都可以用 `u` 撤销
   - 保存后的文件操作可以用 Git 恢复

3. **配合 Git**
   - Oil 支持 Git 集成（需要配置）
   - 删除的文件会进入回收站（`delete_to_trash = true`）

4. **快速跳转**
   - `/` 搜索文件名
   - `_` 跳转到项目根目录
   - `` ` `` 快速切换目录

## 🎨 与其他插件的配合

### 配合 Neo-tree
- Neo-tree: 传统树状文件浏览器 (`:Neotree`)
- Oil: 可编辑的文件浏览器 (`<leader>e`)
- 两者可以共存，各有优势

### 配合 Telescope
- Telescope: 快速查找文件 (`<leader>ff`)
- Oil: 浏览和管理文件 (`<leader>e`)
- Session: 恢复工作状态 (`<leader>qs`)

### 配合 Bufferline
- Bufferline 显示所有打开的 buffer
- `<C-Tab>` / `<C-S-Tab>` 快速切换
- Session 会保存所有 buffer

## 🚀 立即开始

1. **安装插件**
   ```vim
   :Lazy sync
   ```

2. **试用 Session**
   ```bash
   # 打开项目
   cd ~/test-project
   nvim

   # 打开几个文件
   :e file1.txt
   :e file2.txt

   # 退出
   :wqa

   # 重新打开
   nvim
   # 看！文件都回来了！
   ```

3. **试用 Oil**
   ```vim
   " 在 Neovim 中
   <leader>e
   " 使用 j/k 移动，回车打开文件
   " g? 查看帮助
   ```

## ❓ 常见问题

**Q: Session 没有自动恢复？**
A: 确保以下条件:
- 在项目目录中启动 Neovim (不是打开特定文件)
- 上次退出时至少有一个 buffer

**Q: Oil 的修改如何撤销？**
A: 保存前可以用 `u` 撤销，保存后:
- 文件删除可以从回收站恢复
- 文件修改可以用 Git 恢复

**Q: 如何禁用自动恢复？**
A: 在 `lua/plugins/utils/persistence.lua` 中注释掉 `init` 部分

**Q: Oil 和 Neo-tree 冲突吗？**
A: 不冲突，可以同时使用:
- Neo-tree: 侧边栏树状浏览
- Oil: 全屏可编辑文件管理

---

享受 Sublime Text 般丝滑的 Neovim 体验！ 🎉
