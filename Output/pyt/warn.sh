#!/bin/bash

var=$(curl -s https://gupiao.baidu.com/stock/sz000833.html?from=aladingpc | grep _close)
echo $var
var=${var#*>}
var=${var%<*}
echo $var
