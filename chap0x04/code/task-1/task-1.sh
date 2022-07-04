#!/usr/bin/env bash

function help {
echo  "-h    打开帮助文档"
echo  "-w c  对图片批量添加内容为c的文本水印"
echo  "-j    将png/svg图片统一转换为jpg格式图片"
echo  "-z q  对jpeg格式图片进行质量因子为q的质量压缩"
echo  "-p r  对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩r对应的分辨率"
echo  "-m_bef n 批量对文件名添加名为n的前缀"
echo  "-m_aft n 批量对文件名添加名为n的后缀"
}

function add_word {
    c=$1;
    for i in *.jpeg *.jpg *.png *.svg
    do
    convert ${i} -gravity center -fill red  -pointsize 30 -draw "text 5,5'$1'" c-${i};
    done
}

function translate_jpg {
    for i in *.png *.svg
    do
    convert ${i} ${i%.*}.jpg;
    done

}

function quality_zip {
    q=$1;
    for i in *.jpeg
    do
    convert -quality $1 ${i} q-${i};
    done
}

function ratio_zip {
    r=$1;
    for i in *.jpeg *.png *.svg
    do
    convert -resize $1 ${i} r-${i};
    done
}

function add_before {
    n=$1;
    for i in *.jpeg *.jpg *.png *.svg
    do
    mv ${i} $1${i};
    done
}

function add_after {
    n=$1;
    for i in *.jpeg *.jpg *.png *.svg
    do
    mv ${i} ${i%.*}$1.${i##*.};
    done
}

while [ "$1"!="" ];do
case "$1" in
        "-h")
        help
        exit 0
        ;;

        "-w")
        add_word "$2"
        exit 0
        ;;

        "-j")
        translate_jpg
        exit 0
        ;;

        "-z")
        quality_zip "$2"
        exit 0
        ;;

        "-p")
        ratio_zip "$2"
        exit 0
        ;;

        "-m_bef")
        add_before "$2"
        exit 0
        ;;

        "-m_aft")
        add_after "$2"
        exit 0
        ;;
esac
done