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

echo imodel $imodel iassem $iassem entity $entity
echo skindk: $ifield-$iplate

if [ -f imodel.txt ]; then
    rm imodel.txt
fi
if [ -f iassem.txt ]; then
    rm iassem.txt
fi
if [ -f entity.txt ]; then
    rm entity.txt
fi

entity_scripts_path=$imk_path/src/scripts/entity

# 更新ignore文件
find $entity_scripts_path/anima/ -type f | cut -d / -f 10 | sed -e 's/^/\//g' > .gitignore
# 更新anima.txt列表文件
find $entity_scripts_path/anima/ -type f | cut -d / -f 10 > $entity_scripts_path/anima.txt
# 更加anima.txt文件拷贝到entity的工作目录
while read file
do
    if [ -f $file ]; then
        rm $file
    fi
done < $entity_scripts_path/anima.txt

# 执行skindk一级的扩散
# pushd ../../../../ > /dev/null
# if [ -f annexe_shrink.sh ]; then
#     source annexe_shrink.sh
# fi
# popd > /dev/null
