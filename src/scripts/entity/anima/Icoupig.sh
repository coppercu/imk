#!/usr/bin/env bash
#
#
#

pushd ../../../../../../../../ > /dev/null

imx_path=`pwd`

if [ -f imk.txt ]; then
    imk_cite=`cat imk.txt`
else
    imk_cite=imk
fi
if [ ! -d $imk_cite ]; then
    read -p "imk路径未找到，请输入任意键退出" key
    exit
else
    pushd $imk_cite > /dev/null
    imk_path=`pwd`
    popd > /dev/null
fi

popd > /dev/null

pwd_path=`pwd`
rel_path=${pwd_path##${imx_path}/}

# 产生本实体独有的问题文件

# 项目配置
menuconfig Icoupig

# 主节点配置
if [ -f Iconfig_master ]; then
    menuconfig Iconfig_master
fi

# 从节点配置
if [ -f Iconfig_assist ]; then
    menuconfig Iconfig_assist
fi
