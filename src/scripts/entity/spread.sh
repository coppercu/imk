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

master=
if [ -f ../master.txt ]; then
    # assist节点会在master.txt中保存对应的master值，其他所有的信息，都从指向的master获得
    master=`cat ../master.txt`
else
    # master节点，指向自己
    master=$iplate
    if [ -f ../../imodel.json ]; then
        assist=`cat ../../imodel.json | jq .assist`
        if [ -n $assist ]; then
            if [ -d $iplate > ../../../../../$assist ]; then
                mkdir -p ../../../../../$assist/entity/$imodel/$iassem/$entity
                echo $master > ../../../../../$assist/entity/$imodel/$iassem/master.txt
                cp .gitignore > ../../../../../$assist/entity/$imodel/$iassem/$entity/
                cp .bundle.json > ../../../../../$assist/entity/$imodel/$iassem/$entity/
                cp .annexe_spread.sh > ../../../../../$assist/entity/$imodel/$iassem/$entity/
                cp .annexe_shrink.sh > ../../../../../$assist/entity/$imodel/$iassem/$entity/
                # 即使master.txt文件存在也更新，这样vc工具可以判断配置是否有异常
            fi
        fi
    fi
fi
if [ -n $master ]; then
    read -p "没有判断出master的指向" key
    exit
fi

if [ -f $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json ]; then
   iclass=`cat $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json | jq .iclass`
   iorder=`cat $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json | jq .iorder`
fi
if [ -z $iclass or -z $iorder ]; then
    read -p "iclass $iclas iorder $iorder 不达标" key
    exit
fi

echo ifield $ifield iplate $iplate imodel $imodel iassem $iassem iclass $iclass iorder $iorder entity $entity

IFIELD=`echo $ifield | tr '[a-z]' '[A-Z]'`
IPLATE=`echo $iplate | tr '[a-z]' '[A-Z]'`
IMODEL=`echo $imodel | tr '[a-z]' '[A-Z]'`
IASSEM=`echo $iassem | tr '[a-z]' '[A-Z]'`
ICLASS=`echo $iclass | tr '[a-z]' '[A-Z]'`
IORDER=`echo $iorder | tr '[a-z]' '[A-Z]'`
ENTITY=`echo $entity | tr '[a-z]' '[A-Z]'`

echo $ifield > ifield.txt
echo $iplate > iplate.txt
echo $imodel > imodel.txt
echo $iassem > iassem.txt
echo $iclass > iclass.txt
echo $iorder > iorder.txt
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

# echo "#ifndef __ENTITY_H__
# #define __ENTITY_H__

# #define ICOUPIG_
# #define ICONFIG_

# #define ICONFIG_ENTITY      "sample"

# #endif // __ENTITY_H__" > entity.h

# 执行skindk一级的扩散
# pushd ../../../../ > /dev/null
# if [ -f annexe_spread.sh ]; then
#     source annexe_spread.sh
# fi
# popd > /dev/null
