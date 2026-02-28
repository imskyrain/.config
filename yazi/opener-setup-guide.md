# Yazi 打开器配置说明

## 问题解决

### 问题1：文档未翻译成中文 ✓
**状态**：已解决
- `config-comparison.md` 已翻译成中文

### 问题2：按 O 后没有显示 Sublime/Numbers 等选项 ✓
**状态**：已解决
- 已在 `yazi.toml` 中添加自定义应用打开器
- 已更新 `[open]` 规则，将这些应用关联到对应文件类型

---

## 新增的应用打开器

已在 `yazi.toml` 中添加以下 macOS 应用：

```toml
[opener]
sublime = Sublime Text
vscode = Visual Studio Code
numbers = Numbers
excel = Microsoft Excel
preview = Preview
vlc = VLC
```

---

## 文件类型关联

### 文本文件（.txt, .md, .py 等）
按 `O` 后会显示：
1. $EDITOR（默认编辑器）
2. Sublime Text
3. VS Code
4. Reveal（在 Finder 中显示）

### Excel 文件（.xlsx, .xls）
按 `O` 后会显示：
1. Numbers
2. Excel
3. Open（系统默认）
4. Reveal

### 图片文件（.jpg, .png 等）
按 `O` 后会显示：
1. Open（系统默认）
2. Preview
3. Reveal

### 视频文件（.mp4, .mkv 等）
按 `O` 后会显示：
1. Play（mpv）
2. VLC
3. Reveal

### PDF 文件
按 `O` 后会显示：
1. Open（系统默认）
2. Preview
3. Reveal

---

## 如何测试

### 1. 重启 Yazi
配置已更新，需要重启 yazi 使其生效：
```bash
# 在 yazi 中按 q 退出
# 然后重新启动
yazi
```

### 2. 测试文本文件
```bash
# 在 yazi 中：
1. 导航到任意 .txt 或 .md 文件
2. 按 Shift+O（大写 O）
3. 应该看到菜单显示：
   - $EDITOR
   - Sublime Text
   - VS Code
   - Reveal
4. 用 j/k 选择
5. 按 Enter 打开
```

### 3. 测试 Excel 文件
```bash
# 在 yazi 中：
1. 导航到 .xlsx 文件
2. 按 O
3. 应该看到：
   - Numbers
   - Excel
   - Open
   - Reveal
```

### 4. 测试视频文件
```bash
# 在 yazi 中：
1. 导航到 .mp4 或 .mkv 文件
2. 按 O
3. 应该看到：
   - Play (mpv)
   - VLC
   - Reveal
```

---

## 注意事项

### 应用必须已安装
打开器只会显示系统中已安装的应用。如果某个应用未安装：
- Sublime Text: https://www.sublimetext.com/
- VS Code: `brew install --cask visual-studio-code`
- VLC: `brew install --cask vlc`
- Numbers: macOS 自带或从 App Store 安装
- Excel: 需要 Microsoft Office 订阅

### 检查应用是否安装
```bash
# 检查应用是否存在
open -a "Sublime Text" --help 2>/dev/null && echo "已安装" || echo "未安装"
open -a "Visual Studio Code" --help 2>/dev/null && echo "已安装" || echo "未安装"
open -a "VLC" --help 2>/dev/null && echo "已安装" || echo "未安装"
open -a "Numbers" --help 2>/dev/null && echo "已安装" || echo "未安装"
```

### 如果某个应用未安装
Yazi 可能不会显示该选项，或者选择后会报错。这是正常的，只需安装对应应用即可。

---

## 添加更多应用

如需添加其他应用，编辑 `yazi.toml`：

### 1. 添加打开器定义
在 `[opener]` 部分添加：
```toml
应用名 = [
    { run = 'open -a "应用全名" "$@"', orphan = true, desc = "显示名称", for = "macos" },
]
```

### 2. 添加到文件类型规则
在 `[open]` 的 `rules` 中找到对应的文件类型，将应用名添加到 `use` 数组：
```toml
{ mime = "text/*", use = [ "edit", "应用名", "reveal" ] },
```

### 示例：添加 Typora（Markdown 编辑器）
```toml
# 在 [opener] 中添加
typora = [
    { run = 'open -a Typora "$@"', orphan = true, desc = "Typora", for = "macos" },
]

# 在 [open] rules 中修改
{ mime = "text/*", use = [ "edit", "sublime", "vscode", "typora", "reveal" ] },
```

---

## 快捷键提醒

| 按键 | 功能 |
|------|------|
| `O` (大写) | 交互式打开器选择 |
| `o` (小写) | 使用默认应用打开 |
| `<Enter>` | 使用默认应用打开（等同于 `o`） |
| `r` | 在 Finder 中显示 |

---

## 故障排查

### 问题：按 O 后没有显示任何应用
**解决**：
1. 确认已重启 yazi
2. 检查文件的 MIME 类型是否在规则中
3. 使用 `;` 键运行 shell 命令测试：`file --mime-type "$f"`

### 问题：选择应用后报错
**解决**：
1. 确认应用已安装
2. 检查应用名称是否正确（区分大小写）
3. 在终端测试：`open -a "应用名" 文件路径`

### 问题：想要添加命令行参数
**示例**：用 Sublime Text 打开大文件（禁用语法高亮）
```toml
sublime-plain = [
    { run = 'subl --syntax Plain "$@"', orphan = true, desc = "Sublime (Plain)", for = "macos" },
]
```

---

## 总结

✅ 已完成：
1. 添加 6 个 macOS 应用打开器（Sublime、VS Code、Numbers、Excel、Preview、VLC）
2. 配置文件类型关联
3. 翻译 config-comparison.md 为中文

📝 下一步：
1. 重启 yazi
2. 测试各种文件类型的打开器
3. 根据需要添加更多应用
4. 参考 `yazi-features-guide.md` 了解完整的 yazi 功能

🎉 现在可以在 yazi 中按 `O` 选择喜欢的应用打开文件了！
