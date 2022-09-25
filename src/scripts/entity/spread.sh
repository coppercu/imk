# 提取项目信息
entity_path=${1}
entity=${entity_path##*/}
entity_path=${entity_path%/*}
imodel=${entity_path##*/}
entity_path=${entity_path%/*}
ispace=${entity_path##*/}

echo ispace ${ispace} imodel ${imodel} entity ${entity}

ISPACE=`echo $ispace | tr '[a-z]' '[A-Z]'`
IMODEL=`echo $imodel | tr '[a-z]' '[A-Z]'`
ENTITY=`echo $entity | tr '[a-z]' '[A-Z]'`

echo $ispace > ispace.txt
echo $imodel > imodel.txt
echo $entity > entity.txt

entity_scripts_path=../../../../../../../imk/src/scripts/entity

# 更新anima.txt列表文件
find ${entity_scripts_path}/anima/ -type f | cut -d / -f 13 > ${entity_scripts_path}/anima.txt
# 更加anima.txt文件拷贝到entity的工作目录
while read file
do
    cp ${entity_scripts_path}/anima/$file ./
done < ${entity_scripts_path}/anima.txt

if [ -f ispace.h ]; then
    sed -i /s/demo/$ispace/g
    sed -i /s/DEMO/$ISPACE/g
fi

if [ -f imodel.h ]; then
    sed -i /s/demo/$imodel/g
    sed -i /s/DEMO/$IMODEL/g
fi

if [ -f entity.h ]; then
    sed -i /s/demo/$entity/g
    sed -i /s/DEMO/$ENTITY/g
fi

# 执行skindk一级的扩散
pushd ../../../../
source annexe_skrink.sh
source annexe_spread.sh
popd
