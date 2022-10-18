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

# 项目配置
if [ -f Icoupig ]; then
    menuconfig Icoupig
    # 将.config更到icoupig.h
    if [ -f .config ]; then
        mv .config icoupig.h
    else
        read -p "未生成icoupig.h文件" key
        exit
    fi
else
    read -p "未找到Icoupig配置文件" key
fi

# 主节点配置
if [ -f Iconfig_master ]; then
    menuconfig Iconfig_master
    if [ -f .config ]; then
        mv .config iconfig.h
    else
        read -p "未产生iconfig.h文件" key
        exit
    fi
else
    # 从coupig镜像一份配置
    cp icoupig.h iconfig.h
    sed -i "s/icoupig/iconfig" iconfig.h
    sed -i "s/ICOUPIG/ICONFIG" iconfig.h
fi

# 从节点配置
if [ -f Iconfig_assist ]; then
    menuconfig Iconfig_assist
    if [ -f .config ] && [ -f ../../imodel.json ]; then
        assist=`cat ../../imodel.json | jq .assist`
        if [ -n $assist ]; then
            if [ -d ../../../../../$assist/entity/$imodel/$iassem/$entity/ ]; then
                cp .config ../../../../../$assist/entity/$imodel/$iassem/$entity/iconfig.h
            fi
        fi
    else
        read -p "未生成iconfig_assist.h文件" key
        exit
    fi
fi

if [ -f $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json ]; then
    iclass=`cat $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json | jq .iclass`
    iorder=`cat $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json | jq .iorder`
fi
if [ -z $iclass or -z $iorder ]; then
    read -p "iclass $iclas iorder $iorder 不达标" key
    exit
fi
