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

couple=""
master=""
assist=""
if [ -f ../master.txt ]; then
    # assist节点会在master.txt中保存对应的master值，其他所有的信息，都从指向的master获得
    master=`cat ../master.txt`
    assist=$iplate
    couple="1"
else
    # master节点，指向自己
    master=$iplate
    if [ -f ../../imodel.json ]; then
        assist=`cat ../../imodel.json | jq .assist | sed -e "s/\"//g"`
        if [ -n $assist ]; then
            couple="1"
            if [ -d ../../../../../$assist ]; then
                echo assist $assist
                mkdir -p ../../../../../$assist/entity/$imodel/$iassem/$entity
                echo $master > ../../../../../$assist/entity/$imodel/$iassem/master.txt
                cp .gitignore ../../../../../$assist/entity/$imodel/$iassem/$entity/
                cp bundle.json ../../../../../$assist/entity/$imodel/$iassem/$entity/
                cp annexe_spread.sh ../../../../../$assist/entity/$imodel/$iassem/$entity/
                cp annexe_shrink.sh ../../../../../$assist/entity/$imodel/$iassem/$entity/
                # 即使master.txt文件存在也更新，这样vc工具可以判断配置是否有异常
            else
                read -p "assist $assist 没有创建" key
                exit
            fi
        else
            assist=$iplate
        fi
    else
        read -p "没有imodel文件" key
        exit
    fi
fi
if [ -z $master -o -z $assist ]; then
    read -p "没有判断出master的指向" key
    exit
fi

if [ -f $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json ]; then
   iclass=`cat $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json | jq .iclass`
   iorder=`cat $imx_path/src/skindk/$master/entity/$imodel/$iassem/$entity/entity.json | jq .iorder`
fi
if [ -z $iclass -o -z $iorder ]; then
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

echo "ifield.txt" >> .gitignore
echo "iplate.txt" >> .gitignore
echo "imodel.txt" >> .gitignore
echo "iassem.txt" >> .gitignore
echo "iclass.txt" >> .gitignore
echo "iorder.txt" >> .gitignore
echo "entity.txt" >> .gitignore

echo "
select $IFIELD
select $IPLATE
select $IMODEL
select $IASSEM
select $ICLASS
select $IORDER
select $ENTITY
" > Icoupig

if [ -n $couple ]; then
    echo "
config COUPLE
    bool \"COUPLE\"
" >> Icoupig
else
    echo "
config SINGLE
    bool \"SINGLE\"
" >> Icoupig
fi

echo "
config MASTER
    bool \"MASTER\"
config ASSIST
    bool \"ASSIST\"
" >> Icoupig

echo "rsource Sconfig" >> Icoupig

if [ -n $couple ]; then

    # master
    echo "
select $IFIELD
select $IPLATE
select $IMODEL
select $IASSEM
select $ICLASS
select $IORDER
select $ENTITY
" > Iconfig_master

    if [ -n $couple ]; then
        echo "
config COUPLE
    bool \"COUPLE\"
" >> Iconfig_master
    else
        echo "
config SINGLE
    bool \"SINGLE\"
" >> Iconfig_master
    fi

    echo "
config MASTER
    bool \"MASTER\"
" >> Iconfig_master

    echo "rsource Sconfig" >> Iconfig_assist

    # assist
    echo "
select $IFIELD
select $IPLATE
select $IMODEL
select $IASSEM
select $ICLASS
select $IORDER
select $ENTITY
" > Iconfig_assist

    if [ -n $couple ]; then
        echo "
config COUPLE
    bool \"COUPLE\"
" >> Iconfig_assist
    else
        echo "
config SINGLE
    bool \"SINGLE\"
" >> Iconfig_assist
    fi

    echo "
config ASSIST
    bool \"ASSIST\"
" >> Iconfig_assist

    echo "rsource Sconfig" >> Iconfig_assist

fi

echo "Icoupig" >> .gitignore
echo "Iconfig_master" >> .gitignore
echo "Iconfig_assist" >> .gitignore
