echo imx_path $imx_path
echo imk_path $imk_path
echo rel_path $rel_path

# 提取项目信息
tmp_path=$rel_path
entity=${tmp_path##*/}
tmp_path=${tmp_path%/*}
imodel=${tmp_path##*/}
tmp_path=${tmp_path%/*}
ispace=${tmp_path##*/}
tmp_path=${tmp_path%/entity/*}

skindk=${tmp_path##*/}

echo ispace $ispace imodel $imodel entity $entity
echo skindk $skindk

ISPACE=`echo $ispace | tr '[a-z]' '[A-Z]'`
IMODEL=`echo $imodel | tr '[a-z]' '[A-Z]'`
ENTITY=`echo $entity | tr '[a-z]' '[A-Z]'`

echo $ispace > ispace.txt
echo $imodel > imodel.txt
echo $entity > entity.txt

entity_scripts_path=$imk_path/src/scripts/entity

# 更新ignore文件
find $entity_scripts_path/anima/ -type f | cut -d / -f 10 | sed -e 's/^/\//g' > .gitignore
# 更新anima.txt列表文件
find $entity_scripts_path/anima/ -type f | cut -d / -f 10 > $entity_scripts_path/anima.txt
# 更加anima.txt文件拷贝到entity的工作目录
while read file
do
    cp $entity_scripts_path/anima/$file ./
done < $entity_scripts_path/anima.txt

if [ -f ispace.h ]; then
    sed -i s/demo/$ispace/g ispace.h
    sed -i s/DEMO/$ISPACE/g ispace.h
fi
if [ -f imodel.h ]; then
    sed -i s/demo/$imodel/g imodel.h
    sed -i s/DEMO/$IMODEL/g imodel.h
fi
if [ -f entity.h ]; then
    sed -i s/demo/$entity/g entity.h
    sed -i s/DEMO/$ENTITY/g entity.h
fi

# 执行skindk一级的扩散
pushd ../../../../ > /dev/null
if [ -f annexe_spread.sh ]; then
    source annexe_spread.sh
fi
popd > /dev/null
