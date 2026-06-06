#!/system/bin/sh
#ksud-tui
#https://github.com/zlkypx/ksud-tui

KSUD_PATH="/data/adb/ksu/bin/ksud"

if [ ! -f "$KSUD_PATH" ]; then
    echo "找不到 ksud: /data/adb/ksu/bin/ksud"
    exit 1
fi

# 内核特性 (ksud feature)
feature_menu() {
    while true; do
        echo ""
        echo "[内核特性]"
        echo "1) 获取特性值"
        echo "2) 设置特性值"
        echo "3) 列出所有特性"
        echo "4) 检查特性状态"
        echo "5) 从默认位置加载配置"
        echo "6) 保存配置到默认位置"
        echo "0) 返回"
        echo -n "请选择: "
        read feat_choice

        case $feat_choice in
        1)
            echo -n "特性名称: "
            read fname
            $KSUD_PATH feature get "$fname"
            ;;
        2)
            echo -n "特性名称: "
            read fname
            echo -n "设置的值: "
            read fvalue
            $KSUD_PATH feature set "$fname" "$fvalue"
            ;;
        3) $KSUD_PATH feature list ;;
        4)
            echo -n "特性名称: "
            read fname
            $KSUD_PATH feature check "$fname"
            ;;
        5)
            echo "正在从默认位置加载配置..."
            $KSUD_PATH feature load
            ;;
        6)
            echo "正在保存配置到默认位置..."
            $KSUD_PATH feature save
            ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# 应用配置文件 (ksud profile)
profile_menu() {
    while true; do
        echo ""
        echo "[应用配置文件]"
        echo "1) 获取指定包名的 SELinux 策略"
        echo "2) 设置指定包名的 SELinux 策略"
        echo "3) 获取模板"
        echo "4) 设置模板"
        echo "5) 删除模板"
        echo "6) 列出所有模板"
        echo "0) 返回"
        echo -n "请选择: "
        read prof_choice

        case $prof_choice in
        1)
            echo -n "包名: "
            read pkg
            $KSUD_PATH profile get-sepolicy "$pkg"
            ;;
        2)
            echo -n "包名: "
            read pkg
            echo -n "SELinux 策略: "
            read prof
            $KSUD_PATH profile set-sepolicy "$pkg" "$prof"
            ;;
        3)
            echo -n "模板 ID: "
            read tid
            $KSUD_PATH profile get-template "$tid"
            ;;
        4)
            echo -n "模板 ID: "
            read tid
            echo -n "模板内容: "
            read tstr
            $KSUD_PATH profile set-template "$tid" "$tstr"
            ;;
        5)
            echo -n "模板 ID: "
            read tid
            $KSUD_PATH profile delete-template "$tid"
            ;;
        6) $KSUD_PATH profile list-templates ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# SELinux 策略修补 (ksud sepolicy)
sepolicy_menu() {
    while true; do
        echo ""
        echo "[SELinux 策略修补]"
        echo "1) 修补 sepolicy"
        echo "2) 从文件应用 sepolicy"
        echo "3) 检查 sepolicy 语句是否有效"
        echo "4) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read sep_choice

        case $sep_choice in
        1)
            echo -n "sepolicy 文件路径 [默认: /sys/fs/selinux/policy]: "
            read sefile
            [ -z "$sefile" ] && sefile="/sys/fs/selinux/policy"
            if [ -f "$sefile" ]; then
                $KSUD_PATH sepolicy patch "$sefile"
            else
                echo "文件不存在: $sefile"
            fi
            ;;
        2)
            echo -n "sepolicy 文件路径 [默认: /sys/fs/selinux/policy]: "
            read sefile
            [ -z "$sefile" ] && sefile="/sys/fs/selinux/policy"
            if [ -f "$sefile" ]; then
                $KSUD_PATH sepolicy apply "$sefile"
            else
                echo "文件不存在: $sefile"
            fi
            ;;
        3)
            echo -n "sepolicy 语句: "
            read statement
            if [ -n "$statement" ]; then
                $KSUD_PATH sepolicy check "$statement"
            else
                echo "请输入语句"
            fi
            ;;
        4) $KSUD_PATH sepolicy help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# kernel umount 子菜单 (ksud kernel umount)
kernel_umount_menu() {
    while true; do
        echo ""
        echo "[kernel umount 列表管理]"
        echo "1) 添加挂载点 (add)"
        echo "2) 删除挂载点 (del)"
        echo "3) 清空所有 (wipe)"
        echo "4) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read ku_choice

        case $ku_choice in
        1)
            echo -n "挂载点路径: "
            read mountpoint
            $KSUD_PATH kernel umount add "$mountpoint"
            ;;
        2)
            echo -n "挂载点路径: "
            read mountpoint
            $KSUD_PATH kernel umount del "$mountpoint"
            ;;
        3)
            echo "警告：会清空所有 umount 列表条目"
            echo -n "确认？(y/N): "
            read confirm
            case $confirm in y|Y|yes) $KSUD_PATH kernel umount wipe ;; *) echo "取消" ;; esac
            ;;
        4) $KSUD_PATH kernel umount help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# 内核接口 (ksud kernel)
kernel_menu() {
    while true; do
        echo ""
        echo "[内核接口]"
        echo "1) 清除 ext4 sysfs"
        echo "2) 管理 kernel umount 列表"
        echo "3) 通知模块已挂载"
        echo "4) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read ker_choice

        case $ker_choice in
        1) $KSUD_PATH kernel nuke-ext4-sysfs ;;
        2) kernel_umount_menu ;;
        3) $KSUD_PATH kernel notify-module-mounted ;;
        4) $KSUD_PATH kernel help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# debug mark 子菜单 (ksud debug mark)
debug_mark_menu() {
    while true; do
        echo ""
        echo "[进程标记管理]"
        echo "1) 获取进程标记状态 (get)"
        echo "2) 标记进程 (mark)"
        echo "3) 取消标记进程 (unmark)"
        echo "4) 刷新所有进程标记 (refresh)"
        echo "5) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read dm_choice

        case $dm_choice in
        1)
            echo -n "进程 PID（留空则查看所有）: "
            read pid
            $KSUD_PATH debug mark get $pid
            ;;
        2)
            echo -n "进程 PID: "
            read pid
            if [ -n "$pid" ]; then
                $KSUD_PATH debug mark mark $pid
            else
                echo "需要提供 PID"
            fi
            ;;
        3)
            echo -n "进程 PID: "
            read pid
            if [ -n "$pid" ]; then
                $KSUD_PATH debug mark unmark $pid
            else
                echo "需要提供 PID"
            fi
            ;;
        4) $KSUD_PATH debug mark refresh ;;
        5) $KSUD_PATH debug mark help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# 开发者调试 (ksud debug)
debug_menu() {
    while true; do
        echo ""
        echo "[开发者调试]"
        echo "1) 设置管理器应用"
        echo "2) 获取 APK 大小和哈希"
        echo "3) Root Shell"
        echo "4) 获取内核版本"
        echo "5) 测试"
        echo "6) 进程标记管理"
        echo "7) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read dbg_choice

        case $dbg_choice in
        1)
            echo -n "管理器应用包名: "
            read pkg
            $KSUD_PATH debug set-manager "$pkg"
            ;;
        2)
            echo -n "APK 文件路径: "
            read apkpath
            $KSUD_PATH debug get-sign "$apkpath"
            ;;
        3)
            echo "进入 Root Shell，输入 exit 退出"
            $KSUD_PATH debug su
            ;;
        4) $KSUD_PATH debug version ;;
        5) $KSUD_PATH debug test ;;
        6) debug_mark_menu ;;
        7) $KSUD_PATH debug help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# umount 路径管理 (ksud umount)
umount_menu() {
    while true; do
        echo ""
        echo "[ksud umount 路径管理]"
        echo "1) 添加挂载点到卸载列表 (add)"
        echo "2) 从卸载列表移除挂载点 (remove)"
        echo "3) 列出所有挂载点 (list)"
        echo "4) 保存到文件 (save)"
        echo "5) 从文件加载并应用 (apply)"
        echo "6) 清除所有自定义路径 (clear-custom)"
        echo "7) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read umt_choice

        case $umt_choice in
        1)
            echo -n "挂载点路径: "
            read mountpoint
            $KSUD_PATH umount add "$mountpoint"
            ;;
        2)
            echo -n "挂载点路径: "
            read mountpoint
            $KSUD_PATH umount remove "$mountpoint"
            ;;
        3) $KSUD_PATH umount list ;;
        4)
            echo -n "保存文件路径: "
            read filepath
            $KSUD_PATH umount save "$filepath"
            ;;
        5)
            echo -n "配置文件路径: "
            read filepath
            $KSUD_PATH umount apply "$filepath"
            ;;
        6)
            echo "警告：会清空所有自定义卸载路径"
            echo -n "确认？(y/N): "
            read confirm
            case $confirm in y|Y|yes) $KSUD_PATH umount clear-custom ;; *) echo "取消" ;; esac
            ;;
        7) $KSUD_PATH umount help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# 启动信息 (ksud boot-info)
boot_info_menu() {
    while true; do
        echo ""
        echo "[启动信息]"
        echo "1) 当前 KMI 版本"
        echo "2) 支持的 KMI 版本"
        echo "3) 是否支持 A/B 分区"
        echo "4) 默认启动分区"
        echo "5) 可用分区列表"
        echo "6) 槽位后缀"
        echo "7) 帮助"
        echo "0) 返回"
        echo -n "请选择: "
        read boot_choice

        case $boot_choice in
        1) $KSUD_PATH boot-info current-kmi ;;
        2) $KSUD_PATH boot-info supported-kmis ;;
        3) $KSUD_PATH boot-info is-ab-device ;;
        4) $KSUD_PATH boot-info default-partition ;;
        5) $KSUD_PATH boot-info available-partitions ;;
        6) $KSUD_PATH boot-info slot-suffix ;;
        7) $KSUD_PATH boot-info help ;;
        0) break ;;
        *) echo "无效选项" ;;
        esac
        echo ""
        echo -n "按回车继续..."
        read dummy
    done
}

# 主菜单
while true; do
    echo ""
    echo "========== KernelSU 菜单 =========="
    echo "1) 内核特性"
    echo "2) 应用配置文件"
    echo "3) SELinux 策略修补"
    echo "4) 内核接口"
    echo "5) 开发者调试"
    echo "6) ksud umount 路径管理"
    echo "7) 启动信息"
    echo "8) 转储 sulog 日志"
    echo "9) 帮助"
    echo "10) 版本"
    echo "0) 退出"
    echo "=================================="
    echo -n "请选择: "
    read choice

    case $choice in
    1) feature_menu ;;
    2) profile_menu ;;
    3) sepolicy_menu ;;
    4) kernel_menu ;;
    5) debug_menu ;;
    6) umount_menu ;;
    7) boot_info_menu ;;
    8) $KSUD_PATH sulog-dump ;;
    9) $KSUD_PATH help ;;
    10) $KSUD_PATH --version ;;
    0) echo "退出"; break ;;
    *) echo "无效选项" ;;
    esac
    echo ""
    echo -n "按回车继续..."
    read dummy
done
