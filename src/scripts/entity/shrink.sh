if [ -z ${1} ]; then
    read -p "没有项目路径参数, 请输入任意建退出" none
    exit
fi

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

if [ -f ispace.txt ]; then
    rm ispace.txt
fi
if [ -f imodel.txt ]; then
    rm imodel.txt
fi
if [ -f entity.txt ]; then
    rm entity.txt
fi

entity_scripts_path=../../../../../../../imk/src/scripts/entity

# 更新anima.txt列表文件
find ${entity_scripts_path}/anima/ -type f | cut -d / -f 13 > ${entity_scripts_path}/anima.txt
# 更加anima.txt文件拷贝到entity的工作目录
while read file
do
    if [ -f $file ]; then
        rm $file
    fi
done < ${entity_scripts_path}/anima.txt
