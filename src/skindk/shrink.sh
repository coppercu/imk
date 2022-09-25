echo imx_path $imx_path
echo imk_path $imk_path
echo rel_path $rel_path

if [ ! -f $imx_path/ifield.txt ]; then
    read -p "没有配置imx ifield文件"
fi
ifield=`cat $imx_path/ifield.txt`

tmp_skindk=${PWD##*/}
iscene=${tmp_skindk%%-*}
tmp_skindk=${tmp_skindk#*-}
#echo ${tmp_skindk}
igrade=${tmp_skindk%%-*}
tmp_skindk=${tmp_skindk#*-}
#echo ${tmp_skindk}
iplate=${tmp_skindk%%-*}
tmp_skindk=${tmp_skindk#*-}
#echo ${tmp_skindk}
iassem=${tmp_skindk%%-*}
tmp_skindk=${tmp_skindk#*-}
#echo ${tmp_skindk}

echo skindk: ${ifield}-${iscene}-${igrade}-${iplate}-${iassem}

if [ -f ifield.txt ]; then
    rm ifield.txt
fi
if [ -f iscene.txt ]; then
    rm iscene.txt
fi
if [ -f igrade.txt ]; then
    rm igrade.txt
fi
if [ -f iplate.txt ]; then
    rm iplate.txt
fi
if [ -f iassem.txt ]; then
    rm iassem.txt
fi

if [ -f $imk_path/src/scripts/ibuild/anima.txt ]; then
    while read file
    do
        if [ -f $file ]; then
            rm $file
        fi
    done < $imk_path/src/scripts/ibuild/anima.txt
fi

if [ -f $imk_path/src/scripts/itrace/anima.txt ]; then
    while read file
    do
        if [ -f $file ]; then
            rm $file
        fi
    done < $imk_path/src/scripts/itrace/anima.txt
fi

if [ -f $imk_path/src/scripts/iwatch/anima.txt ]; then
    while read file
    do
        if [ -f $file ]; then
            rm $file
        fi
    done < $imk_path/src/scripts/iwatch/anima.txt
fi
