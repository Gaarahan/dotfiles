# 项目架构与 Agent 指南 (AGENTS.md)

本文件旨在为开发者和 AI Agent 提供关于 `dotfiles` 项目的架构概览、代码风格及开发规范，以便于理解和维护。

## 1. 项目概览 (Project Overview)
本项目是作者的个人开发环境配置集（Dotfiles），主要针对 Linux (i3-wm) 和 macOS 环境。
核心组件包括：
- **Neovim**: 基于 Lua 的现代化配置，使用 `lazy.nvim` 管理插件。
- **Window Manager**: i3-gaps 配合 polybar 状态栏。
- **Shell**: zsh 配置，包含常用的 alias 和环境设置。
- **Terminal Utils**: tmux, lazygit, ripgrep 等工具的深度配置。

### 核心目录结构
- `/nvim`: Neovim 配置文件，采用模块化设计。
- `/bin`: 包含安装脚本和实用工具。
- `/zsh`, `/tmux`, `/i3`, `/polybar`: 各工具的特定配置文件。

## 2. 构建与常用命令 (Build & Commands)
### 安装与部署
- `sh ./bin/doInstall`

### 编辑器常用快捷键 (Neovim)
- `<leader>ff`: 查找文件名。
- `<leader>fg`: 实时搜索字符串 (Live Grep)。
- `<leader>fd`: 调用 `Guard fmt` 格式化当前文档。
- `<F3>`: 切换文件树 (NvimTree)。

## 3. 代码风格与规范 (Code Style)
### Lua (Neovim 配置)
- **模块化**: 配置位于 `nvim/lua/usermod/` 下，按功能拆分（如 `keymap.lua`, `appearance.lua`）。
- **格式化**: 使用 `guard.nvim` 集成 `prettier` 进行自动格式化。
- **命名**: 遵循 Lua 的小驼峰或下划线命名习惯。
- **语言倾向**：尽可能的使用英文来书写项目内容，如命令提示符，快捷键描述等。

### Shell 脚本
- 脚本位于 `bin/scripts/`，通常包含环境检查和用户交互。
- 习惯使用 `bot`, `info`, `ok` 等辅助函数进行日志输出 (参考 `utils.sh`)。

## 4. 安全性 (Security)
- **备份机制**: `linkConfigFile.sh` 在覆盖旧配置前会自动创建 `.bak` 备份。

## 5. 配置管理 (Configuration)
- **插件管理**: Neovim 使用 `lazy.nvim`，插件定义位于 `nvim/lua/usermod/plugins/`。
- **路径引用**: 倾向于使用软链接 (`ln -s`) 而非直接复制，以保持仓库与系统配置同步。
- **环境适配**: 部分配置会检查操作系统类型（如 macOS 偏好设置脚本）。
