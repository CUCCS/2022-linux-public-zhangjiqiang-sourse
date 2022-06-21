#!/usr/bin/env bash

function help {
    echo "-h 打开帮助手册"
    echo "-a 统计不同年龄区间范围的球员数量、百分比"
    echo "-b 统计不同场上位置的球员数量、百分比"
    echo "-c 找出名字最长的球员和名字最短的球员"
    echo "-d 找出年龄最大的球员和年龄最小的球员"
}
# 统计不同年龄区间范围的球员数量、百分比
function age_range {
awk -F"\t" '
BEGIN {
    low_age=0
    mid_age=0
    hig_age=0
    print $6}
    $6!="Age"{
        if($6<20)     {low_age++;}
        else if ($6<=30) {mid_age++;}
        else          {hig_age++;}
    }
END {
    sum=low_age+mid_age+hig_age;
    printf "%-20s%-10s%-10s\n","Range","count","percentage";
    printf "%-20s%-10s%-.1f\%\n","20岁以下",low_age,low_age*100.0/sum;
    printf "%-23s%-10s%-.1f\%\n","[20,30]",mid_age,mid_age*100.0/sum;
    printf "%-20s%-10s%-.1f\%\n","30岁以上",hig_age,hig_age*100.0/sum;
}
    '  worldcupplayerinfo.tsv
}
# 统计不同场上位置的球员数量、百分比
function positon {
awk -F"\t" '
BEGIN {sum=0;}

   $5!="Position"{
    num[$5]++;
    sum++;
   }
END {
    printf "%-20s%-10s%-10s%\n","Positon","count","percentage"
    for( i in num)
    {
    printf "%-20s%-10s%-.1f\%\n",i,num[i],num[i]*100.0/sum;
    }
}
    '  worldcupplayerinfo.tsv
}
# 找出名字最长的球员和名字最短的球员
function name_length {
awk -F"\t" '
BEGIN {
    max_name_size=0
    min_name_size=100
    }
$9!="Player"{
    name_size=length($9)
    name[$9]=name_size
    if(name_size>max_name_size) {max_name_size=name_size}
    if(name_size<min_name_size) {min_name_size=name_size}
}
END {
    for( i in name)
    {
        if(name[i]==max_name_size)
        printf "名字最长的球员有%s,长度是%d\n",i,max_name_size;
        if(name[i]==min_name_size)
        printf "名字最短的球员有%s,长度是%d\n",i,min_name_size;
    }
}

    ' worldcupplayerinfo.tsv;
}
# 找出年龄最大的球员和年龄最小的球员
function age_size {
awk -F"\t" '
BEGIN {
    max_age_size=0
    min_age_size=100
    }
$6!="Age"{
    age_size=$6
    age[$9]=age_size
    if(age_size>max_age_size) {max_age_size=age_size}
    if(age_size<min_age_size) {min_age_size=age_size}
}
END {
    for(i in age)
    {
        if(age[i]==max_age_size)
        printf "年龄最大的球员有%s,年龄是%d岁\n",i,max_age_size;
    }
    for(i in age)
    {
        if(age[i]==min_age_size)
        printf "年龄最小的球员有%s,年龄是%d岁\n",i,min_age_size;
    }
}

    ' worldcupplayerinfo.tsv;
}

while [ "$1"!="" ];do
case "$1" in
        "-h")
        help
        exit 0
        ;;

        "-a")
        age_range
        exit 0
        ;;

        "-b")
        positon
        exit 0
        ;;

        "-c")
        name_length
        exit 0
        ;;

        "-d")
        age_size
        exit 0
        ;;
esac
done