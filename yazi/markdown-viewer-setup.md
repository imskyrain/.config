# Markdown 文件查看器配置指南

## 问题描述
- **编辑 Markdown**：nvim 很好用 ✓
- **查看 Markdown**：纯文本显示，没有渲染效果 ✗

## 解决方案
为 Markdown 文件配置专用的查看器，按 `O` 键时可以选择不同的查看/编辑方式。

---

## 已添加的 Markdown 查看器选项

现在按 `O` 打开 .md 文件时，会显示以下选项：

| 选项 | 类型 | 说明 | 需要安装 |
|------|------|------|----------|
| **edit** | 编辑器 | $EDITOR (nvim) | ✓ 已有 |
| **glow** | 终端查看器 | 终端中渲染 Markdown | 需要安装 |
| **typora** | 图形化编辑器 | 所见即所得编辑器（付费） | 需要安装 |
| **marked** | 查看器 | 专业 Markdown 预览（付费） | 需要安装 |
| **macdown** | 编辑器 | 免费开源 MD 编辑器 | 需要安装 |
| **quicklook** | 系统预览 | macOS 快速预览 | 需要插件 |
| **sublime** | 编辑器 | Sublime Text | 可选 |
| **vscode** | 编辑器 | VS Code | 可选 |
| **reveal** | Finder | 在 Finder 中显示 | ✓ 已有 |

---

## 推荐方案

### 方案 1：Glow（免费，终端，推荐）

**优点**：
- 🆓 完全免费
- ⚡ 启动速度快
- 🎨 终端中渲染 Markdown
- 📦 轻量级，无需 GUI
- 🔥 支持代码高亮、表格、列表等

**安装**：
```bash
brew install glow
```

**使用**：
在 yazi 中导航到 .md 文件，按 `O`，选择 "Glow (终端预览)"

**效果**：
- 在终端中直接显示渲染后的 Markdown
- 支持滚动、代码高亮
- 按 `q` 退出预览

**测试**：
```bash
# 手动测试
glow README.md
glow -p README.md  # 分页模式
```

---

### 方案 2：Typora（付费，图形化，强大）

**优点**：
- 🎨 所见即所得（WYSIWYG）
- 📝 编辑体验极佳
- 🖼️ 支持图片、表格、数学公式
- 📊 支持图表（mermaid、flowchart）
- 🎯 专业级 Markdown 编辑器

**缺点**：
- 💰 需要付费（约 $15）

**安装**：
```bash
brew install --cask typora
```

**使用**：
在 yazi 中按 `O`，选择 "Typora"

**官网**：https://typora.io/

---

### 方案 3：MacDown（免费，图形化）

**优点**：
- 🆓 完全免费
- 💻 macOS 原生应用
- 👁️ 实时预览（分屏）
- 🚀 轻量级

**缺点**：
- 功能相对简单
- 更新较慢

**安装**：
```bash
brew install --cask macdown
```

**使用**：
在 yazi 中按 `O`，选择 "MacDown"

**官网**：https://macdown.uranusjr.com/

---

### 方案 4：Marked 2（付费，专业预览）

**优点**：
- 🎯 专业级 Markdown 预览工具
- 📊 支持多种样式主题
- 📤 导出 PDF、HTML
- 🔍 文档分析、字数统计

**缺点**：
- 💰 需要付费（约 $14）
- 只能预览，不能编辑

**安装**：
```bash
brew install --cask marked
```

**使用**：
在 yazi 中按 `O`，选择 "Marked 2"

**官网**：https://marked2app.com/

---

### 方案 5：QuickLook（系统内置，需要插件）

**优点**：
- 🆓 免费
- ⚡ 超快（按空格键即可预览）
- 🍎 macOS 系统集成

**需要安装插件**：
```bash
# 安装 QLMarkdown 插件
brew install --cask qlmarkdown

# 或者使用 syntax-highlight （更好的代码高亮）
brew install --cask syntax-highlight
```

**使用**：
1. 在 Finder 或 yazi 中选中 .md 文件
2. 按空格键即可预览
3. 或在 yazi 中按 `O`，选择 "QuickLook 预览"

**注意**：安装插件后需要重启 Finder 或重新登录

---

## 我的推荐组合

### 极简方案（免费）
```bash
brew install glow
```
**使用场景**：
- 快速查看 Markdown 内容
- 终端中工作不想离开命令行
- 轻量级需求

### 平衡方案（免费）
```bash
brew install glow
brew install --cask macdown
brew install --cask qlmarkdown
```
**使用场景**：
- glow：快速终端预览
- MacDown：需要编辑或查看复杂文档
- QuickLook：Finder 中快速预览

### 专业方案（付费）
```bash
brew install glow
brew install --cask typora
brew install --cask marked
```
**使用场景**：
- glow：快速终端预览
- Typora：专业编辑
- Marked 2：专业预览和导出

---

## 安装步骤

### 推荐：先安装 Glow（免费）

```bash
# 1. 安装 glow
brew install glow

# 2. 重启 yazi
# 在 yazi 中按 q 退出，然后重新启动
yazi

# 3. 测试
# 导航到任意 .md 文件
# 按 O (大写)
# 应该看到 "Glow (终端预览)" 选项
# 选择后会在终端中渲染显示
```

### 可选：安装图形化工具

```bash
# 免费选项
brew install --cask macdown
brew install --cask qlmarkdown

# 付费选项（如果预算允许）
brew install --cask typora
brew install --cask marked
```

---

## 使用示例

### 场景 1：快速查看 README.md
```
1. 在 yazi 中导航到 README.md
2. 按 O
3. 选择 "Glow (终端预览)"
4. 查看渲染后的内容
5. 按 q 退出
```

### 场景 2：编辑文档
```
1. 在 yazi 中导航到 document.md
2. 按 O
3. 选择 "$EDITOR" (nvim) 编辑
   或选择 "Typora" 进行所见即所得编辑
```

### 场景 3：导出 PDF
```
1. 在 yazi 中导航到 report.md
2. 按 O
3. 选择 "Marked 2"
4. 在 Marked 2 中选择 File > Export > PDF
```

---

## 配置详情

已在 `yazi.toml` 中添加的配置：

```toml
[opener]
# Markdown 终端查看器
glow = [
    { run = 'glow -p "$@"', block = true, desc = "Glow (终端预览)", for = "unix" },
]

# Markdown 图形化工具
typora = [
    { run = 'open -a Typora "$@"', orphan = true, desc = "Typora", for = "macos" },
]
marked = [
    { run = 'open -a "Marked 2" "$@"', orphan = true, desc = "Marked 2", for = "macos" },
]
macdown = [
    { run = 'open -a MacDown "$@"', orphan = true, desc = "MacDown", for = "macos" },
]
quicklook = [
    { run = 'qlmanage -p "$@" &>/dev/null', orphan = true, desc = "QuickLook 预览", for = "macos" },
]

[open]
rules = [
    # Markdown 文件专用规则（优先级最高）
    { mime = "text/markdown", use = [ "edit", "glow", "typora", "marked", "macdown", "quicklook", "sublime", "vscode", "reveal" ] },
    { url = "*.md", use = [ "edit", "glow", "typora", "marked", "macdown", "quicklook", "sublime", "vscode", "reveal" ] },
    # ... 其他规则
]
```

**顺序说明**：
1. `edit` - $EDITOR (nvim)：编辑首选
2. `glow` - 终端查看：快速预览
3. `typora`/`marked`/`macdown` - 图形化工具：专业查看/编辑
4. `quicklook` - 系统预览：快速预览
5. `sublime`/`vscode` - 通用编辑器：备选
6. `reveal` - Finder：查找文件位置

---

## 进阶技巧

### 1. 设置 glow 样式
```bash
# 查看可用样式
glow -s dark   # 深色主题
glow -s light  # 浅色主题

# 设置默认样式（添加到 ~/.zshrc）
export GLOW_STYLE=dark

# 或者在 yazi.toml 中指定样式
glow = [
    { run = 'glow -s dark -p "$@"', block = true, desc = "Glow (深色)", for = "unix" },
]
```

### 2. 自定义 nvim Markdown 预览
如果你想在 nvim 中也有更好的预览体验，可以安装插件：

```vim
" 在 nvim 配置中添加
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" 使用 :MarkdownPreview 在浏览器中预览
```

### 3. 配置 QuickLook 插件
```bash
# 查看已安装的 QuickLook 插件
qlmanage -m

# 重新加载 QuickLook
qlmanage -r
qlmanage -r cache

# 清除 QuickLook 缓存
qlmanage -r
qlmanage -r cache
killall Finder
```

---

## 故障排查

### 问题 1：按 O 后没有显示 glow 选项
**解决**：
```bash
# 检查 glow 是否安装
which glow

# 如果未安装
brew install glow

# 重启 yazi
```

### 问题 2：选择 glow 后报错
**可能原因**：glow 未安装或不在 PATH 中
```bash
# 确认安装
brew install glow

# 测试
glow README.md
```

### 问题 3：QuickLook 不显示 Markdown 渲染
**解决**：
```bash
# 安装 QLMarkdown 插件
brew install --cask qlmarkdown

# 重启 Finder
killall Finder

# 或重新登录系统
```

### 问题 4：Typora/Marked 打开失败
**解决**：
```bash
# 检查应用是否安装
open -a Typora --help
open -a "Marked 2" --help

# 如果未安装，先安装
brew install --cask typora
brew install --cask marked
```

---

## 对比表格

| 工具 | 免费 | 类型 | 启动速度 | 功能丰富度 | 推荐度 |
|------|------|------|----------|------------|--------|
| **Glow** | ✓ | 终端 | ⚡⚡⚡ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **nvim** | ✓ | 终端 | ⚡⚡⚡ | ⭐⭐ | ⭐⭐⭐⭐ |
| **MacDown** | ✓ | GUI | ⚡⚡ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **QuickLook** | ✓ | 系统 | ⚡⚡⚡ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Typora** | ✗ | GUI | ⚡⚡ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Marked 2** | ✗ | GUI | ⚡⚡ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **VS Code** | ✓ | GUI | ⚡ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 总结

### ✅ 已完成
- 在 `yazi.toml` 中添加了 6 个 Markdown 查看器选项
- 为 .md 文件配置了专门的打开规则
- Markdown 文件现在优先显示查看/编辑选项

### 📝 下一步
1. **立即可用**：
   ```bash
   brew install glow
   ```
   重启 yazi，按 O 即可使用 glow 查看 Markdown

2. **可选安装**（根据需求）：
   ```bash
   brew install --cask macdown        # 免费图形化编辑器
   brew install --cask qlmarkdown     # QuickLook 插件
   brew install --cask typora         # 付费专业编辑器
   brew install --cask marked         # 付费专业预览器
   ```

### 🎯 推荐流程
1. 先安装 **glow**（免费，轻量，快速）
2. 试用后如果需要图形化工具，再安装 **MacDown**（免费）
3. 如果预算充足且需要专业功能，考虑 **Typora**

现在你可以：
- 📝 **编辑** Markdown → 按 `O` 选择 "edit" (nvim)
- 👁️ **查看** Markdown → 按 `O` 选择 "Glow" (渲染预览)
- 🎨 **专业编辑** → 按 `O` 选择 "Typora" 或 "MacDown"

享受更好的 Markdown 体验！🎉
