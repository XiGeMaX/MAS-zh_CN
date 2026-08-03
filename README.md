# MAS (Microsoft Activation Scripts) 3.12 - 中文汉化版

Massgrave 的 MAS_AIO 激活脚本汉化版本（基于英文原版 v3.12 翻译）。

## 文件说明

- `MAS_AIO.cmd` - 汉化版主脚本（推荐使用）
- `MAS_AIO_EN.cmd` - 英文原版（备份参考）
- `_tmap.json` - 整行翻译对照表
- `_sppmgr_bylines.json` - “检查激活状态”内嵌 PowerShell 块的行级翻译

## 使用方法

1. 右键点击 `MAS_AIO.cmd`，选择“以管理员身份运行”。
2. 按主菜单提示选择对应的激活方式（HWID / Ohook / TSforge / 在线 KMS 等）。

## 说明

- 脚本为 **GBK 编码**，内置 `chcp 936`，请在 **cmd / Windows Terminal** 中运行，中文可正常显示。
- 请勿用 UTF-8 编码保存脚本（cmd 的括号块解析在 UTF-8/65001 下存在缺陷，会导致功能异常）。
- 脚本自带 LF 换行检查，请保持 CRLF 换行。
- 主菜单下方已添加署名：**由痛哥codex翻译**。

## 声明

本项目仅用于学习交流，请于下载后 24 小时内删除。激活工具请支持正版授权。
