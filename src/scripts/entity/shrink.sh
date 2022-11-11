echo imx_path $imx_path
echo imk_path $imk_path
echo rel_path $rel_path

if [ ! -f $imx_path/imx.txt ]; then
    read -p "没有配置imx ifield文件" key
    exit
fi
ifield=`cat $imx_path/imx.txt`

# 提取项目信息
tmp_path=$rel_path
entity=${tmp_path##*/}
tmp_path=${tmp_path%/*}
iassem=${tmp_path##*/}
tmp_path=${tmp_path%/*}
imodel=${tmp_path##*/}

tmp_path=${tmp_path%/entity/*}
iplate=${tmp_path##*/}

echo ifield $ifield iplate $iplate imodel $imodel iassem $iassem iclass $iclass iorder $iorder entity $entity

entity_scripts_path=$imk_path/src/scripts/entity

# 更加anima.txt文件拷贝到entity的工作目录
while read file
do
    if [ -f $file ]; then
        rm $file
    fi
done < $entity_scripts_path/anima.txt

if [ -f entity.jconfig ]; then
    rm entity.jconfig
fi
if [ -f entity.sconfig ]; then
    rm entity.sconfig
fi

if [ -f Icoupig ]; then
    rm Icoupig
fi
if [ -f Iconfig_master ]; then
    rm Iconfig_master
fi
if [ -f Iconfig_assist ]; then
    rm Iconfig_assist
fi
