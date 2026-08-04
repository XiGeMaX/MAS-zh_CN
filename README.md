<div align="center">

# 🪟 MAS-zh_CN

**Microsoft Activation Scripts (MAS) 3.12 简体中文本地化版本**

> 基于 [massgrave.dev](https://massgrave.dev) 官方 [Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts) 翻译，集成 HWID、Ohook、TSforge、在线 KMS 等激活方式。

![MAS 3.12](https://img.shields.io/badge/MAS-3.12-blue)
![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-green)
![Windows](https://img.shields.io/badge/OS-Windows%20Vista%2F7%2F8%2F10%2F11-orange)
![Language](https://img.shields.io/badge/lang-zh--CN-red)

</div>

---

## 📖 项目简介

MAS-zh_CN 是微软激活脚本（Microsoft Activation Scripts, MAS）的社区**简体中文本地化**版本，目前对应官方 **MAS 3.12**。所有菜单、提示与帮助信息均已翻译为简体中文，功能与官方版本保持一致，开箱即用。

> ⚠️ 本项目为**非官方**翻译，仅用于社区学习与交流。

## ✨ 功能特性

- **HWID 数字许可证** — 永久激活 Windows
- **Ohook** — 永久激活 Office
- **TSforge** — 激活 Windows / Office / ESU
- **在线 KMS** — 激活 Windows / Office
- **激活状态检查** — 查看许可证状态、剩余期限与 KMS 信息
- **版本切换** — 在脚本内直接更改 Windows / Office 版本
- **疑难解答** — 自动检测并修复常见激活问题
- **无人值守** — 支持命令行参数，便于批量部署与 OEM 预激活

## 🚀 快速开始

> ⚠️ 脚本需要**管理员权限**，运行前请先备份重要数据。

### 方式一：在线运行（推荐）

在 Windows PowerShell 中执行以下命令，脚本将自动下载并运行：

```powershell
irm https://mas-zh-cn.pages.dev/get | iex
```

### 方式二：本地运行

1. 下载 [`MAS_AIO.cmd`](MAS_AIO.cmd)
2. 右键点击 → **以管理员身份运行**
3. 根据菜单选择需要的激活方式

### 无人值守（命令行参数）

```bat
MAS_AIO.cmd /HWID               :: HWID 激活 Windows
MAS_AIO.cmd /Ohook              :: Ohook 激活 Office
MAS_AIO.cmd /Z-                 :: TSforge 激活 Windows / Office / ESU
MAS_AIO.cmd /K-                 :: 在线 KMS 激活 Windows / Office
```

## 📋 主菜单

| 选项 | 功能 |
| :--: | --- |
| `1` | HWID — Windows 数字许可证激活 |
| `2` | Ohook — Office 永久激活 |
| `3` | TSforge — Windows / Office / ESU 激活 |
| `4` | 在线 KMS — Windows / Office 激活 |
| `5` | 检查激活状态 |
| `6` | 更改 Windows 版本 |
| `7` | 更改 Office 版本 |
| `8` | 疑难解答 |
| `0` | 退出 |

## 🧩 本地化说明

- 本仓库基于官方 MAS 3.12 生成，功能与官方脚本保持一致。
- 翻译映射文件：[`_tmap.json`](_tmap.json) 与 [`_sppmgr_bylines.json`](_sppmgr_bylines.json)，可用于重新生成或校对翻译。
- 脚本使用 **GBK (936)** 编码，请使用支持 GBK 的编辑器查看源码。
- 上游发布新版本后，可对照翻译映射重新生成对应版本的中文脚本。

## ⚠️ 免责声明

- 本项目与微软公司无关，仅供社区学习与交流使用。
- 请仅在拥有合法授权的设备上使用，并遵守当地法律法规。
- 因使用本脚本而产生的一切后果由使用者自行承担。

## 📄 许可证

本项目基于 [GPL-3.0](LICENSE) 协议开源，原始脚本版权归 [Massgrave](https://github.com/massgravel) 团队所有。

## 🙏 致谢

- 感谢 [Massgrave](https://github.com/massgravel) 团队开发并开源 [Microsoft Activation Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)。
- 感谢 [痛哥](https://github.com/XiGeMaX) 完成本次中文翻译工作。
