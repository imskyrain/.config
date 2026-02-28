# Yazi 配置对比：参考配置 vs 本地配置

## 概述
对比参考配置（`~/.config/yazi/`）和本地配置（`~/Tools/git_core/github/yazi/`）。

---

## 主要差异

### 1. 插件

**参考配置**（6个插件）：
- `compress.yazi` - 压缩归档文件
- `git.yazi` - Git 状态集成
- `smart-enter.yazi` - 智能打开文件
- `starship.yazi` - Starship 提示符
- `yamb.yazi` - 书签管理器（基于 fzf）
- `yaziline.yazi` - 自定义状态栏

**本地配置**（14个插件）：
- `cdhist.yazi` - 目录历史模糊跳转
- `chmod.yazi` - 交互式权限修改
- `duckdb.yazi` - 表格数据预览（CSV、Parquet 等）
- `exifaudio.yazi` - 音频元数据及封面
- `full-border.yazi` - 圆角边框 UI
- `git.yazi` - Git 状态集成
- `mediainfo.yazi` - 媒体文件预览（音频/视频/图片）
- `mount.yazi` - 分区挂载/卸载管理器
- `office.yazi` - Office 文档预览
- `ouch.yazi` - 压缩文件压缩/解压
- `piper.yazi` - 备用预览器（使用 hexyl）
- `relative-motions.yazi` - Vim 风格数字移动
- `smart-enter.yazi` - 智能打开文件

### 2. 键位映射理念

**参考配置**：
- Colemak 布局（u/e 用于上下移动，而非 k/j）
- 自定义导航：n=左，i=右
- 数字键（1-9）直接切换标签页
- 书签系统：`'a`、`''`、`'r`

**本地配置**：
- 标准 Vim 键位（k/j 上下移动）
- 标准 hjkl 导航
- Ctrl+数字 切换标签页（数字键留给 relative-motions）
- Relative motions 插件（vim 风格的 3j、10gg）
- Alt+h/Alt+l 前进/后退（释放 H/L 给 duckdb 列滚动）

### 3. 文件管理器设置（yazi.toml）

#### 排序与显示

**参考配置**：
```toml
sort_by = "alphabetical"  # 按字母排序
sort_reverse = false      # 不反转
sort_dir_first = true     # 目录优先
linemode = "size"         # 显示文件大小
ratio = [1, 3, 4]         # 面板比例
```

**本地配置**：
```toml
sort_by = "btime"         # 按创建时间排序
sort_reverse = true       # 最新的在前
sort_dir_first = false    # 文件和目录混合
linemode = "none"         # 不显示元数据列
ratio = [1, 4, 3]         # 中间面板更宽
```

**建议**：考虑使用本地的 `btime` + `sort_reverse=true` 来优先显示最新文件。

#### 归档解压

**参考配置**：使用 `ya pub extract`
**本地配置**：使用 `ouch` 工具（`ouch d -y`）

**建议**：安装 `ouch` 以获得更好的归档处理。

#### 任务配置

**参考配置**：
```toml
image_alloc = 536870912  # 512MB
```

**本地配置**：
```toml
image_alloc = 1073741824  # 1GB（用于大型媒体文件）
```

**建议**：如果预览大型视频/图片，使用 1GB。

#### 插件与预览器

**参考配置**：
- 基础预览器（image、video、pdf、font、code、json、archive）
- 使用 `prepend_fetchers` 添加 git

**本地配置**：
- 高级预览器栈：
  - `mediainfo.yazi` 替换内置的 image/video/magick
  - `office.yazi` 用于 Office 文档（.docx、.xlsx）
  - `duckdb.yazi` 用于表格数据（.csv、.parquet、.db）
  - `ouch.yazi` 替换内置的归档预览器
  - `piper` 配合 `hexyl` 作为未知文件的后备方案
- 使用 `fetchers` 数组（新语法）而非 `prepend_fetchers`
- 明确的 MIME 类型处理

**建议**：采用本地的插件栈以获得更好的文件预览支持。

### 4. UI 与对话框

**参考配置**：
- 使用 `[input]` 部分处理提示
- 单独的 trash/delete/overwrite/quit 设置

**本地配置**：
- 同时使用 `[input]` 和 `[confirm]` 部分（v25.12.29+ 语法）
- `overwrite_body` 和 `quit_body` 替换旧的 `content` 键
- 确认对话框居中显示

**建议**：更新到本地的新对话框语法。

### 5. 键位绑定亮点

**参考配置独有绑定**：
- `P` - 打开 spotter
- `['a]` - 添加书签
- `['']` - 跳转书签
- `ca` - 使用 compress 插件归档
- `S` - Shell 提示符
- Colemak 友好绑定

**本地配置独有绑定**：
- `M` - 挂载管理器
- `C` - 使用 ouch 压缩
- `<A-c>` - 通过 cdhist 跳转（目录历史）
- `<C-m>` - chmod 插件
- `H/L` - 在 duckdb 预览中滚动列
- `<F9>` - 切换 mediainfo 元数据
- `z/Z` - fzf/zoxide（与参考配置互换）
- Relative motions（1-9 用于 vim 风格的计数）
- `<C-c>` - 关闭标签页（vs `q`）

### 6. init.lua

**参考配置**：
- yaziline 状态栏，带自定义符号
- Starship 提示符集成
- 状态栏显示用户/组
- yamb 书签设置

**本地配置**：
- full-border 圆角 UI
- git 状态集成
- relative-motions 带 `show_numbers = "relative"`
- duckdb 设置
- smart-enter 带 `open_multi = true`

---

## 本地配置的推荐升级

### 高优先级

1. **添加书签系统** - 参考配置的 yamb 插件非常实用
   - 添加 `yamb.yazi` 插件
   - 添加键位绑定：`['a]`、`['']`、`['r]`

2. **考虑 Colemak 绑定**（如果你使用 Colemak 键盘）
   - 参考配置有完善的 Colemak 映射

3. **添加状态栏自定义**
   - 参考配置的 yaziline + starship 设置看起来很精致
   - 考虑添加用户/组显示

### 中优先级

4. **归档压缩** - 参考配置有 compress.yazi
   - 你有 ouch.yazi，但 compress.yazi 可能提供更多选项
   - 对比两个插件

5. **Spotter 集成**（如果可用）
   - 参考配置有 `P` 键打开 spotter - 检查这是否是 macOS Spotlight 集成

6. **键位绑定优化**
   - `<C-g>` 打开 lazygit（参考配置有，检查本地是否有）

### 低优先级

7. **面板比例** - 尝试参考的 `[1, 3, 4]` vs 本地的 `[1, 4, 3]`
8. **排序默认值** - 测试两种方法
9. **Linemode** - 测试 `size` vs `none`

---

## 从本地配置保留的优点

1. **插件生态系统** - 更丰富（14 vs 6 个插件）
2. **现代语法** - 使用最新的 yazi 配置格式
3. **Relative motions** - Vim 用户会喜欢
4. **高级预览器** - mediainfo、office、duckdb 都很棒
5. **数字移动** - 对 vim 用户非常高效
6. **挂载管理器** - 对外部驱动器很有用
7. **chmod 插件** - 交互式权限编辑
8. **cdhist** - 目录历史非常实用

---

## 行动项

- [ ] 安装 yamb 插件实现书签功能
- [ ] 测试两种排序策略（alphabetical vs btime）
- [ ] 对比 compress.yazi vs ouch.yazi
- [ ] 检查 spotter 是否可用/有用
- [ ] 考虑添加 starship + yaziline 以获得更好的 UI
- [ ] 测试面板比例
- [ ] 审查键位绑定冲突
- [ ] 如需要，添加用户/组状态显示
