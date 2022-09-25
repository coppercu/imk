if [ -z ${1} ]; then
    read -p "没有项目路径参数, 请输入任意建退出" none
    exit
fi

imk_path=
imx_path=
rer_path=

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

# 更新ignore文件
find ${entity_scripts_path}/anima/ -type f | cut -d / -f 13 | sed -e 's/^/\//g' > .gitignore
# 更新anima.txt列表文件
find ${entity_scripts_path}/anima/ -type f | cut -d / -f 13 > ${entity_scripts_path}/anima.txt
# 更加anima.txt文件拷贝到entity的工作目录
while read file
do
    cp ${entity_scripts_path}/anima/$file ./
done < ${entity_scripts_path}/anima.txt

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
source annexe_skrink.sh
source annexe_spread.sh
popd > /dev/null

iframe=${PWD##*/}
ifield=${iframe%%-*}
iframe=${iframe#*-}
#echo ${iframe}
iscene=${iframe%%-*}
iframe=${iframe#*-}
#echo ${iframe}
igrade=${iframe%%-*}
iframe=${iframe#*-}
#echo ${iframe}
iplate=${iframe%%-*}
iframe=${iframe#*-}
#echo ${iframe}
iassem=${iframe%%-*}
iframe=${iframe#*-}
#echo ${iframe}

#echo ${ifield}-${iscene}-${igrade}-${iplate}-${iassem}

echo "${ifield}">ifield.txt
echo "${iscene}">iscene.txt
echo "${igrade}">igrade.txt
echo "${iplate}">iplate.txt
echo "${iassem}">iassem.txt

if [ -f ../../scripts/buildi/build_inward_file.txt ]
then
	while read line
	do
		if [ "${line}" != "." ]
		then
			cp ../../scripts/buildi/${line} ./
		fi
	done < ../../scripts/buildi/build_inward_file.txt
	rm -f build_inward_file.*
fi

if [ -f ../../scripts/buildo/build_openup_file.txt ]
then
	while read line
	do
		if [ "${line}" != "." ]
		then
			cp ../../scripts/buildo/${line} ./
		fi
	done < ../../scripts/buildo/build_openup_file.txt
	rm -f build_openup_file.*
fi

if [ -f ../../scripts/loadon/loadon_file.txt ]
then
	while read line
	do
		if [ "${line}" != "." ]
		then
			cp ../../scripts/loadon/${line} ./
		fi
	done < ../../scripts/loadon/loadon_file.txt
	rm -f loadon_file.*
fi

if [ ../../scripts/codsim/codsim_file.txt ]
then
	while read line
	do
		if [ "${line}" != "." ]
		then
			cp ../../scripts/codsim/${line} ./
		fi
	done < ../../scripts/codsim/codsim_file.txt
	rm -f codsim_file.*
fi
