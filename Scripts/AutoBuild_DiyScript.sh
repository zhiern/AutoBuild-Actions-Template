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
	rm -rf feeds/luci/themes/luci-theme-argon
        rm -rf feeds/luci/themes/luci-theme-argon-mod
        rm -rf feeds/packages/lang/golang
        find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
        find ./ | grep Makefile | grep mosdns | xargs rm -f
        git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
        git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
	git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
        git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/downloads/luci-theme-argon
	git clone -b main https://github.com/oppen321/openclash package/openclash
        git clone -b main https://github.com/linkease/istore-ui package/istoreos-ui
        git clone -b main https://github.com/linkease/istore package/istoreos
	git clone -b main https://github.com/kenzok8/golang feeds/packages/lang/golang 
        git clone -b main https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-package
	git clone -b main https://github.com/xiaorouji/openwrt-passwall package/passwall
        git clone -b main https://github.com/xiaorouji/openwrt-passwall2 package/passwall2
	git clone -b main https://github.com/oppen321/luci-app-adguardhome package/luci-app-adguardhome
        git clone -b main https://github.com/fw876/helloworld package/helloword
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
