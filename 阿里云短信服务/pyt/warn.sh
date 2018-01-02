#!/bin/bash

key="sz000833"
url="https://gupiao.baidu.com/stock/$key.html?from=aladingpc"
cap="_close"

stock="gtgf"
date=$(date +%Y%m%d)
recfile="/tmp/pyt/$key.rec"
threshold=8

price=""

msg=$(date +%Y%m%d%H%M%S)

for i in `seq 20`
do
price=$(curl -s $url | grep $cap)
    
    if [ -n "$price" ];then
    #echo "---get info at loop:$i---"
    msg="$msg (threshold is $threshold) --- get info at loop:$i, "
    break 2
    fi

done

#echo -e "---price(before) is\n $price"
price=${price#*>}
price=${price%<*}
#echo -e "---price(after)  is:$price---"

if [ `expr $threshold \> $price` -eq 0 ];then
#echo `date +%Y%m%d%H%M%S`"---"`grep -o $date $recfile |wc -l`" sent by today!" >> /tmp/pyt/send.log
msg="$msg"`grep -o $date $recfile |wc -l`" sent by today! "
    if [ `grep -o $date $recfile |wc -l` -lt 3 ];then
    python /tmp/pyt/dysms_python/api_demo/alicom-python-sdk-dysmsapi/sms.py $stock $price
    msg="$msg""new msg's sent with price as $price"
    else
    msg="$msg""no msg would be sent by today"
    fi
echo $msg >> $recfile
fi
