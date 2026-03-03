# Neovim 优化配置说明

## 🚀 已完成的优化

### 1. 禁用 DAP 调试插件（解决启动卡顿问题）

**问题**: DAP 插件（特别是 `vscode-js-debug`）需要 npm 构建，导致启动时卡住并出现构建错误。

**解决方案**: 已将 DAP 插件移动到禁用目录

```
lua/plugins/dap.disabled/
├── nvim-dap.lua          # 核心调试适配器
├── nvim-dap-ui.lua       # 调试UI
├── dap-go.lua            # Go调试
├── dap-js.lua            # JavaScript/TypeScript调试
├── dap-python.lua        # Python调试
```

**状态**: ✅ 已禁用，不会加载

### 2. 禁用 AI 插件（避免不必要的依赖）

**原因**: `avante.nvim` 需要 API key 配置，且有复杂的构建过程。

**状态**: ✅ 已在插件配置中设置 `enabled = false` 且不导入

---

## 📋 当前配置状态

### 已启用的插件分类

```lua
-- lua/core/lazy.lua
spec = {
  { import = "plugins" },           -- 主题和基础插件
  { import = "plugins.editor" },    -- 编辑器增强（包含Oil.nvim）
  { import = "plugins.git" },       -- Git集成
  { import = "plugins.lsp" },       -- LSP和代码补全
  { import = "plugins.navigation" },-- 导航插件
  { import = "plugins.ui" },        -- UI美化
  { import = "plugins.utils" },     -- 工具类（包含Session恢复）
  -- { import = "plugins.dap" },    -- ❌ 已禁用
  -- { import = "plugins.ai" },     -- ❌ 已禁用
}
```

### 核心功能保留

✅ **Session 自动恢复** - 类似 Sublime Text 的缓存
✅ **Oil.nvim 文件浏览器** - 可编辑的文件系统
✅ **LSP 支持** - 代码补全、跳转、诊断
✅ **Treesitter** - 语法高亮
✅ **Telescope** - 模糊查找
✅ **Git 集成** - Gitsigns + Lazygit
✅ **UI 美化** - Lualine, Bufferline, 通知系统

---

## 🔧 如何重新启用 DAP 调试功能

如果你确实需要调试功能，按以下步骤操作：

### 方法一: 启用所有 DAP 插件（不推荐）

```bash
# 1. 恢复 DAP 插件文件
cd ~/.config/nvim
mv lua/plugins/dap.disabled lua/plugins/dap

# 2. 编辑 lua/core/lazy.lua，取消注释
# 将这行:
-- { import = "plugins.dap" },
# 改为:
{ import = "plugins.dap" },

# 3. 安装依赖（vscode-js-debug需要很长时间）
nvim
:Lazy sync
```

**注意**: `vscode-js-debug` 构建可能需要 5-10 分钟，且可能失败。

### 方法二: 只启用特定语言的调试（推荐）

如果你只需要某个语言的调试，可以选择性启用：

#### 启用 Python 调试

```bash
# 1. 复制配置到正确位置
mkdir -p ~/.config/nvim/lua/plugins/dap
cp ~/.config/nvim/lua/plugins/dap.disabled/nvim-dap.lua ~/.config/nvim/lua/plugins/dap/
cp ~/.config/nvim/lua/plugins/dap.disabled/nvim-dap-ui.lua ~/.config/nvim/lua/plugins/dap/
cp ~/.config/nvim/lua/plugins/dap.disabled/dap-python.lua ~/.config/nvim/lua/plugins/dap/

# 2. 取消注释 lua/core/lazy.lua 中的 dap 导入
# 3. 安装 debugpy
nvim
:Mason
# 搜索 debugpy 并安装
```

#### 启用 Go 调试

```bash
# 1. 复制配置
mkdir -p ~/.config/nvim/lua/plugins/dap
cp ~/.config/nvim/lua/plugins/dap.disabled/{nvim-dap.lua,nvim-dap-ui.lua,dap-go.lua} ~/.config/nvim/lua/plugins/dap/

# 2. 安装 delve
go install github.com/go-delve/delve/cmd/dlv@latest

# 3. 取消注释 lua/core/lazy.lua 中的 dap 导入
```

### 方法三: 使用替代的轻量级调试方案

如果 DAP 太重，可以考虑：

1. **使用 print 调试** - 简单直接
2. **使用 IDE 调试** - VSCode 等专业工具
3. **使用终端调试器** - `pdb` (Python), `dlv` (Go) 等

---

## 💡 优化建议

### 1. 启动速度优化

```lua
-- 当前配置已经优化：
-- ✅ 使用 lazy loading (event, keys, ft)
-- ✅ 禁用了重度插件 (DAP, AI)
-- ✅ 使用 VeryLazy 延迟加载
```

**预期启动时间**: 100-300ms（取决于机器性能）

### 2. 减少插件数量

如果启动仍然慢，可以考虑禁用以下可选插件：

```lua
-- lua/plugins/ui/noice.lua
enabled = false,  -- 禁用 fancy 通知

-- lua/plugins/utils/render-markdown.lua
enabled = false,  -- 如果不常编辑 markdown

-- lua/plugins/utils/typst-preview.lua
enabled = false,  -- 如果不用 typst
```

### 3. LSP 优化

如果 LSP 响应慢，可以调整：

```lua
-- lua/core/basic.lua
vim.opt.updatetime = 300  -- 调整为 500 或 1000
```

---

## 🎯 正确使用 Neovim 的方式

### 推荐的工作流程

```bash
# 1. 进入项目目录
cd ~/my-project

# 2. 直接启动（不带参数，自动恢复session）
nvim

# 3. 如果是新项目，使用 Oil 浏览文件
# 按 <leader>e 打开 Oil
# 浏览并打开文件

# 4. 编辑多个文件
# <C-Tab> 切换文件
# <C-s> 保存
# <C-n> 新建文件

# 5. 退出（自动保存session）
:wqa
```

### 避免的使用方式

```bash
# ❌ 不推荐：打开单个文件（会跳过session恢复）
nvim file.txt

# ❌ 不推荐：在随机目录启动
cd /tmp
nvim

# ✅ 推荐：在项目根目录启动
cd ~/my-project
nvim
```

---

## 📊 插件统计

### 当前已安装插件

```
总计: ~45 个插件
├── UI美化: 8 个
├── 编辑增强: 10 个
├── LSP相关: 6 个
├── Git: 2 个
├── 导航: 4 个
├── 工具类: 10 个
└── 主题: 15+ 个
```

### 已禁用插件

```
DAP调试: 5 个（nvim-dap及语言支持）
AI助手: 1 个（avante.nvim）
```

---

## 🔍 故障排查

### 问题 1: 启动时卡住

**症状**: 打开 nvim 后长时间无响应

**原因**:
- 插件正在后台安装/构建
- 某个插件配置错误
- LSP 服务器启动慢

**解决**:
```bash
# 查看 lazy.nvim 状态
nvim
:Lazy

# 查看哪些插件正在安装
# 等待所有插件安装完成

# 如果某个插件一直失败，禁用它
# 在对应的 .lua 文件中添加:
enabled = false,
```

### 问题 2: 下载完插件后不知道如何进入

**原因**: 首次安装时 lazy.nvim 会打开安装界面

**解决**:
```
1. 等待所有插件安装完成（看到 "Done" 或全部绿色勾）
2. 按 q 退出 lazy.nvim 界面
3. 你就进入了 Neovim 正常界面

如果卡在 lazy.nvim 界面：
- 按 q 退出
- 按 :q<CR> 强制退出
- 如果都不行，Ctrl+C 然后重新打开 nvim
```

### 问题 3: 插件更新失败

**症状**: `:Lazy sync` 报错

**解决**:
```vim
" 1. 清理并重新安装
:Lazy clean
:Lazy sync

" 2. 如果还是失败，删除插件缓存
:!rm -rf ~/.local/share/nvim/lazy/*
" 然后重启 nvim
```

### 问题 4: Session 恢复了不想要的文件

**解决**:
```vim
" 临时禁用 session 保存
<leader>qd

" 清理所有 session
:!rm -rf ~/.local/state/nvim/sessions/*
```

---

## 📚 相关文档

- **快速入门**: `SUBLIME_QUICKSTART.md` - 5分钟上手
- **完整指南**: `SUBLIME_MODE.md` - Session 和 Oil 详细使用
- **新插件**: `NEW_PLUGINS.md` - 所有新增插件列表
- **本文档**: `OPTIMIZATION.md` - 优化和问题排查

---

## ✅ 检查清单

启动前确认：

- [x] DAP 插件已禁用
- [x] AI 插件已禁用
- [x] 在项目目录中启动 nvim
- [x] 等待插件首次安装完成
- [x] Session 自动恢复功能正常
- [x] Oil.nvim 可以正常打开（`<leader>e`）

---

## 🎉 现在可以使用了！

```bash
# 进入项目
cd ~/your-project

# 启动 nvim（应该很快，1-3秒内）
nvim

# 试用 Oil 文件浏览器
# 在 nvim 中按 <leader>e

# 试用 Session 恢复
# 打开几个文件，退出，再次启动 nvim
```

**享受快速、流畅的 Neovim 体验！** 🚀

如有问题，按 `<leader>` 然后等待，查看所有可用的快捷键。
