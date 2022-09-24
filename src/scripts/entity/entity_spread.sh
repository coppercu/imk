# 提取项目信息
entity_path=${1}
entity=${entity_path##*/}
entity_path=${entity_path%/*}
imodel=${entity_path##*/}
entity_path=${entity_path%/*}
ispace=${entity_path##*/}

echo entity ${entity} imodel ${imodel} ispace ${ispace}

ENTITY=`echo $entity | tr '[a-z]' '[A-Z]'`
IMODEL=`echo $imodel | tr '[a-z]' '[A-Z]'`
ISPACE=`echo $ispace | tr '[a-z]' '[A-Z]'`

echo $entity > entity.txt
echo $imodel > imodel.txt
echo $ispace > ispace.txt

find ../../../../../../../imk/src/scripts/entity/anima/ -type f -exec cp {} ./ \;
find ../../../../../../../imk/src/scripts/entity/anima/ -type f | cut -d / -f 13 | sed -e 's/^/\//g' > .gitignore

# 执行skindk一级的扩散
pushd ../../../../
source annexe_skrink.sh
source annexe_spread.sh
popd

if [ -f entity.h ]; then
    sed -i /s/demo/$entity/g
    sed -i /s/DEMO/$ENTITY/g
fi
