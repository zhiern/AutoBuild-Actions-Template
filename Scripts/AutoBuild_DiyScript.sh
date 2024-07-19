#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions-BETA>
# AutoBuild DiyScript

Firmware_Diy_Core() {

	Author=AUTO
	# 作者名称, AUTO: [自动识别]
	Author_URL=AUTO
	# 自定义作者网站或域名, AUTO: [自动识别]
	Default_Flag=AUTO
	# 固件标签 (名称后缀), 适用不同配置文件, AUTO: [自动识别]
	Default_IP="192.168.1.1"
	# 固件 IP 地址
	Default_Title="Powered by AutoBuild-Actions"
	# 固件终端首页显示的额外信息
	
	Short_Fw_Date=true
	# 简短的固件日期, true: [20210601]; false: [202106012359]
	x86_Full_Images=false
	# 额外上传已检测到的 x86 虚拟磁盘镜像, true: [上传]; false: [不上传]
	Fw_MFormat=AUTO
	# 自定义固件格式, AUTO: [自动识别]
	Regex_Skip="packages|buildinfo|sha256sums|manifest|kernel|rootfs|factory|itb|profile|ext4|json"
	# 输出固件时丢弃包含该内容的固件/文件
	AutoBuild_Features=true
	# 添加 AutoBuild 固件特性, true: [开启]; false: [关闭]
	
	AutoBuild_Features_Patch=false
	AutoBuild_Features_Kconfig=false
}

Firmware_Diy() {
	# 移除要替换的包
        rm -rf feeds/packages/net/mosdns
        rm -rf feeds/packages/net/msd_lite
        rm -rf feeds/packages/net/smartdns
        rm -rf feeds/luci/themes/luci-theme-argon
	rm -rf feeds/luci/themes/luci-theme-argon-mod
        rm -rf feeds/luci/themes/luci-theme-netgear
        rm -rf feeds/luci/applications/luci-app-mosdns
        rm -rf feeds/luci/applications/luci-app-netdata
        rm -rf feeds/luci/applications/luci-app-serverchan
        # Git稀疏克隆，只克隆指定目录到本地
        function git_sparse_clone() {
         branch="$1" repourl="$2" && shift 2
         git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
         repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
         cd $repodir && git sparse-checkout set $@
         mv -f $@ ../package
         cd .. && rm -rf $repodir
        }
	# 添加额外插件
        git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
        git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
        git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
        git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
        git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
        git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
        git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-filebrowser luci-app-ssr-mudb-server
        git_sparse_clone openwrt-18.06 https://github.com/immortalwrt/luci applications/luci-app-eqos
        # 科学上网插件
        git clone --depth=1 -b master https://github.com/fw876/helloworld package/luci-app-ssr-plus
        git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
        git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
        git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
        git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
        # Themes
        git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
        git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
        git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
        git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
        git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear
        # SmartDNS
        git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
        git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns
        # msd_lite
        git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
        git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite
	# MosDNS
        git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns
        # Alist
        git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
        # DDNS.to
        git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
        git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto
        # iStore
        git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
        git_sparse_clone main https://github.com/linkease/istore luci
	# 取消主题默认设置
        find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;
        # 更改 Argon 主题背景
        cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
	# x86 型号只显示 CPU 型号
        sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore
	# 修改本地时间格式
        sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm
	# 下载并更新
        ./scripts/feeds update -a
        ./scripts/feeds install -a
	# 请在该函数内定制固件

	# 可用预设变量, 其他可用变量请参考运行日志
	# ${OP_AUTHOR}			OpenWrt 源码作者
	# ${OP_REPO}				OpenWrt 仓库名称
	# ${OP_BRANCH}			OpenWrt 源码分支
	# ${TARGET_PROFILE}		设备名称
	# ${TARGET_BOARD}			设备架构
	# ${TARGET_FLAG}			固件名称后缀

	# ${WORK}				OpenWrt 源码位置
	# ${CONFIG_FILE}			使用的配置文件名称
	# ${FEEDS_CONF}			OpenWrt 源码目录下的 feeds.conf.default 文件
	# ${CustomFiles}			仓库中的 /CustomFiles 绝对路径
	# ${Scripts}				仓库中的 /Scripts 绝对路径
	# ${FEEDS_LUCI}			OpenWrt 源码目录下的 package/feeds/luci 目录
	# ${FEEDS_PKG}			OpenWrt 源码目录下的 package/feeds/packages 目录
	# ${BASE_FILES}			OpenWrt 源码目录下的 package/base-files/files 目录

	:
}
