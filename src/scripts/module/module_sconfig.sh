#!/usr/bin/env bash
#
# 对指定的path更新sconig
#

function module_group_sconfig()
{
    group=$1
    if [ -d $group ]; then
        # 目录存在，遍历本目录族
        echo "" > Sconfig
        echo "menu \"$group\"" >> Sconfig
        mkdir -p $group/config
        for module in $group
        do
            if [ -d module ] && [ $module/module.json ]; then
                # 是一个module目录
                touch config/$moudle
                echo "menuconfig COUPER
    bool \"couper\"
    default y
    help
        couper
if COUPER
    rsource \"config/couper\"
endif" >> Sconfig
            fi
        done
        echo "endmenu" >> Sconfig
    fi
}

imk_path=
ims_path=
group_path=

for group_path_mono in group_path
do
    # imk
   module_group_sconfig $imk_path/$group_path_mono
    # ims
   module_group_sconfig $ims_path/$group_path_mono
done
