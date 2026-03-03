# 新添加的插件配置

> **插件管理器**: 本配置使用 **lazy.nvim** (插件管理器)，而不是 LazyVim (配置框架)

> **⚠️ 重要更新**: DAP 调试插件已默认禁用（会导致启动卡顿），详见 `OPTIMIZATION.md`

本次根据 [CookNixvim](https://github.com/Youthdreamer/CookNixvim) 和 [nvim](https://github.com/Youthdreamer/nvim) 两个仓库，为本机配置补全了以下插件：

## 1. DAP 调试工具套件 ⚠️ 已禁用

**状态**: ❌ 默认禁用（位于 `lua/plugins/dap.disabled/`）

**原因**:
- `vscode-js-debug` 需要长时间 npm 构建（5-10分钟）
- 构建可能失败，导致启动卡住
- 对于日常开发不是必需的

**如何启用**: 查看 `OPTIMIZATION.md` 文档

### nvim-dap.lua
- **插件**: `mfussenegger/nvim-dap`
- **功能**: Neovim 的调试适配器协议 (Debug Adapter Protocol) 客户端
- **依赖**:
  - `rcarriga/nvim-dap-ui` - UI 界面
  - `nvim-neotest/nvim-nio` - 异步 IO
  - `theHamsta/nvim-dap-virtual-text` - 虚拟文本显示变量值
- **快捷键**:
  - `<leader>db` - 切换断点
  - `<leader>dc` - 继续执行
  - `<leader>di` - 步入
  - `<leader>do` - 步过
  - `<leader>dO` - 步出
  - `<leader>dr` - 打开 REPL
  - `<leader>dl` - 运行上次调试
  - `<leader>dt` - 终止调试

### nvim-dap-ui.lua
- **插件**: `rcarriga/nvim-dap-ui`
- **功能**: DAP 的图形界面
- **快捷键**:
  - `<leader>du` - 切换 DAP UI
  - `<leader>de` - 求值表达式 (normal/visual 模式)
- **特性**: 自动在调试开始时打开，结束时关闭

### dap-go.lua
- **插件**: `leoluz/nvim-dap-go`
- **功能**: Go 语言调试支持
- **依赖**: 需要安装 `dlv` (Delve debugger)
- **触发**: 打开 Go 文件时自动加载

### dap-js.lua
- **插件**: `mxsdev/nvim-dap-vscode-js`
- **功能**: JavaScript/TypeScript 调试支持
- **依赖**: `microsoft/vscode-js-debug` (自动构建)
- **支持文件类型**: javascript, javascriptreact, typescript, typescriptreact
- **调试模式**:
  - 启动文件
  - 附加到进程
  - Chrome 浏览器调试

### dap-python.lua
- **插件**: `mfussenegger/nvim-dap-python`
- **功能**: Python 调试支持
- **依赖**: 需要通过 Mason 安装 `debugpy`
- **触发**: 打开 Python 文件时自动加载

## 2. 编辑器增强 (lua/plugins/editor/)

### autotag.lua
- **插件**: `windwp/nvim-ts-autotag`
- **功能**: 基于 Treesitter 的 HTML/JSX 标签自动闭合和重命名
- **依赖**: `nvim-treesitter/nvim-treesitter`
- **特性**:
  - 自动闭合标签
  - 同步重命名开闭标签
  - 支持 HTML, JSX, TSX 等

## 3. UI 增强 (lua/plugins/ui/)

### dressing.lua
- **插件**: `stevearc/dressing.nvim`
- **功能**: 美化 Neovim 内置的 `vim.ui.select` 和 `vim.ui.input` 界面
- **特性**:
  - 优先使用 Telescope 作为选择器后端
  - 圆角边框
  - 支持历史记录 (上下键)
  - 与 Telescope 主题集成

## 4. 工具类 (lua/plugins/utils/)

### img-clip.lua
- **插件**: `HakonHarnes/img-clip.nvim`
- **功能**: 从剪贴板粘贴图片到文档
- **快捷键**: `<leader>p` - 粘贴图片
- **特性**:
  - 支持拖拽插入图片
  - 自动生成图片路径
  - 针对不同文件类型使用不同模板:
    - Markdown: `![$CURSOR]($FILE_PATH)`
    - HTML: `<img src="$FILE_PATH" alt="$CURSOR">`
    - LaTeX: `\includegraphics{}`

## 5. AI 工具 (lua/plugins/ai/) - 可选

### avante.lua
- **插件**: `yetone/avante.nvim`
- **功能**: AI 代码助手，支持 Claude, OpenAI 等
- **状态**: 默认禁用 (`enabled = false`)
- **配置需求**: 需要设置 API key
- **快捷键**:
  - `<leader>aa` - 询问 AI
  - `<leader>ae` - 编辑代码
  - `<leader>ar` - 刷新
- **注意**: 需要配置 API key 后将 `enabled` 设为 `true` 才能使用

## 配置更新

已更新 `lua/core/lazy.lua` 添加了新目录的导入：
```lua
{ import = "plugins.dap" },  -- DAP 调试工具
{ import = "plugins.ai" },   -- AI 工具 (可选)
```

## 使用说明

1. **重启 Neovim** 或执行 `:Lazy sync` 安装新插件
2. **DAP 调试工具**需要额外安装调试器:
   - Go: `go install github.com/go-delve/delve/cmd/dlv@latest`
   - Python: 通过 Mason 安装 `debugpy`
   - JavaScript/TypeScript: 插件会自动构建
3. **AI 插件** (avante.nvim) 默认禁用，如需使用:
   - 获取 Claude API key 或其他 AI 服务 key
   - 在配置文件中设置 `enabled = true`
   - 根据需要配置 provider 和 model

## 插件数量统计

新增配置文件:
- DAP 调试: 5 个配置文件
- 编辑器增强: 1 个配置文件
- UI 增强: 1 个配置文件
- 工具类: 1 个配置文件
- AI 工具: 1 个配置文件 (可选)

总计: **9 个新插件配置**

## 参考配置

本次补全参考了以下两个优秀的 Neovim 配置:
- [CookNixvim](https://github.com/Youthdreamer/CookNixvim) - 基于 Nix 的配置
- [Youthdreamer/nvim](https://github.com/Youthdreamer/nvim) - 基于 Lazy.nvim 的配置
