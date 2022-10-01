#!/usr/bin/env bash
#
#
#

pushd ../../../../../../../ > /dev/null

imx_path=`pwd`

if [ -f imk.txt ]; then
    imk_cite=`cat imk.txt`
else
    imk_cite=imk
fi
if [ ! -d $imk_cite ]; then
    read -p "imk路径未找到，请输入任意键退出" key
else
    pushd $imk_cite > /dev/null
    imk_path=`pwd`
    popd > /dev/null
fi

popd > /dev/null

pwd_path=`pwd`
rel_path=${pwd_path##${imx_path}/}

# 产生本实体独有的问题文件

# 配置
menuconfig Icoupig

# 保存配置
