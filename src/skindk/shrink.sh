echo imx_path $imx_path
echo imk_path $imk_path
echo rel_path $rel_path

if [ ! -f $imx_path/imx.txt ]; then
    read -p "没有配置imx ifield文件"
fi
ifield=`cat $imx_path/imx.txt`

iplate=${PWD##*/}

echo skindk: $ifield-$iplate

echo "$ifield">ifield.txt
echo "$iplate">iplate.txt

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
