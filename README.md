ksud-tui
一个基于 Shell 的ksud交互式管理工具，为 ksud 命令行提供友好的菜单界面。


项目简介
--------
ksud-tui 是一个交互式菜单脚本，无需记忆复杂命令参数，通过菜单即可管理内核特性、SELinux 策略、应用配置等功能。
为了优化代码质量，本项目使用了ai进行辅助

核心功能
--------
- 内核特性管理：获取、设置、列出内核特性，加载/保存配置
- 应用配置文件：管理应用 SELinux 策略和配置模板
- SELinux 策略修补：修补、应用和验证 sepolicy 策略
- 内核接口：ext4 sysfs 清理、kernel umount 列表管理
- 开发者调试：Root Shell、进程标记、APK 签名获取
- Umount 路径管理：管理需要卸载的挂载点
- 启动信息查询：KMI 版本、分区信息、A/B 槽位


快速开始
--------
系统要求：
- Android 设备已安装 KernelSU
- Root 权限
- ksud 命令位于 /data/adb/ksu/bin/ksud

安装步骤：
1. git clone https://github.com/zlkypx/ksud-tui.git
2. cd ksud-tui
3. bash ksud-tui.sh

版本历史
--------
v1.0.0 (2026-01-20) : 初始版本


问题反馈
--------
https://github.com/zlkypx/ksud-tui/issues


许可证
--------
Copyright 2026 zlkypx

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
如果觉得项目不错，请给一个 Star
Made by zlkypx
