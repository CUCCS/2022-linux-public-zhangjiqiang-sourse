#!/usr/bin/env bash

function help {
    echo "-h 帮助手册"
    echo "-a 统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-b 统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-c 统计最频繁被访问的URL TOP 100"
    echo "-d 统计不同响应状态码的出现次数和对应百分比"
    echo "-e 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-f 给定URL输出TOP 100访问来源主机"
}
#统计访问来源主机TOP 100和分别对应出现的总次数
function host_time {
    awk -F "\t" '
    BEGIN {}
    $1!="host" {
        num[$1]++;
    }
    END {
        printf "%s %s\n","host","count"
        for( i in num) { printf "%s %d\n",i,num[i] }
    }' web_log.tsv | sort -r -k 2 | head -100
}
#统计访问来源主机TOP 100 IP和分别对应出现的总次数
function IP_time {
    awk -F "\t" '
    BEGIN {}
    $1!="host" {
        if(
        match($1,/^((2(5[0-5]|[0-4][0-9]))
        |[0-1]?[0-9]{1,2})(\.((2(5[0-5]|[0-4][0-9]))
        |[0-1]?[0-9]{1,2})){3}$/))
        num[$1]++;
    }
    END {
        printf "%s %s\n","IP","count"
        for( i in num) {printf "%s %d\n",i,num[i]}
    }' web_log.tsv | sort -r -k 2 | head -100
}
#统计最频繁被访问的URL TOP 100
function busy_url {
    awk -F "\t" '
    BEGIN {}
    $5!="url" {num[$5]++;}
    END {
        printf "%s %s\n","url","count"
        for( i in num) {printf "%s %d\n",i,num[i]}
    }' web_log.tsv | sort -g -r -k 2 | head -100
}
#统计不同响应状态码的出现次数和对应百分比
function response_status {
    awk -F "\t" '
    BEGIN {sum=0}
    $6!="referer" {
        num[$6]++;
        sum++;}
    END {
        printf "%s %s %s\n","referer","count","percentage"
        for( i in num) {printf "%d %d %.5f\%\n",i,num[i],num[i]*100/sum}
    }' web_log.tsv
}
#分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function 4xx_url {
printf "%s %s %s\n" "referer" "url" "count"
awk -F "\t" '
BEGIN {}
   $6!="referer" {
    if($6=="403") {num1[$5]++;}
    }
END {
    for( i in num1) {printf "%d %s %d\n","403",i,num1[i]}
}' web_log.tsv | sort -g -r -k 3 | head -10

awk -F "\t" '
BEGIN {}
   $6!="referer" {
    if($6=="404") {num2[$5]++;}
    }
END {
    for( i in num2) {printf "%d %s %d\n","404",i,num2[i]}
}' web_log.tsv | sort -g -r -k 3 | head -10
}
#给定URL输出TOP 100访问来源主机
function url_visit {
    url=$1;
    printf "%s %s\n" "host" "count";
    awk -F "\t" '
    BEGIN{}
    $5!="url"{
    if($5=="'"${url}"'") {num[$1]++;}}
    END{
        for (i in num){printf "%s %d\n",i,num[i];}
    }' web_log.tsv | sort -g -r -k 2 | head -100
}

while [ "$1"!="" ];do
case "$1" in
        "-h")
        help
        exit 0
        ;;

        "-a")
        host_time
        exit 0
        ;;

        "-b")
        IP_time
        exit 0
        ;;

        "-c")
        busy_url
        exit 0
        ;;

        "-d")
        response_status
        exit 0
        ;;

        "-e")
        4xx_url
        exit 0
        ;;

        "-f")
        url_visit "$2"
        exit 0
        ;;
esac
done