echo imx_path $imx_path
echo imk_path $imk_path
echo rel_path $rel_path

if [ ! -f ../../imodel.json ]; then
    read -p "没有imodel.json文件" key
    exit
fi

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

IMODEL=`echo $imodel | tr '[a-z]' '[A-Z]'`
IASSEM=`echo $iassem | tr '[a-z]' '[A-Z]'`
ENTITY=`echo $entity | tr '[a-z]' '[A-Z]'`

echo $imodel > imodel.txt
echo $iassem > iassem.txt
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

if [ -f imodel.h ]; then
    sed -i s/sample/$imodel/g imodel.h
    sed -i s/SAMPLE/$IMODEL/g imodel.h
fi
if [ -f iassem.h ]; then
    sed -i s/sample/$iassem/g iassem.h
    sed -i s/SAMPLE/$IASSEM/g iassem.h
fi
if [ -f entity.h ]; then
    sed -i s/sample/$entity/g entity.h
    sed -i s/SAMPLE/$ENTITY/g entity.h
fi

master=`cat ../../imodel.json | jq .master`
if [ -z $master ]; then
    # 没有master,不是从节点
    assist=`cat ../../imodel.json | jq .assist`
    if [ ! -z $assist ]; then
       # 没有从节点
    fi
else
    # 有master指向，
fi

# 执行skindk一级的扩散
pushd ../../../../ > /dev/null
if [ -f annexe_spread.sh ]; then
    source annexe_spread.sh
fi
popd > /dev/null
