#!/bin/bash

#获得domain_id可以用curl
#`curl -X POST https://dnsapi.cn/Domain.List -d "login_token=11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&format=json"`
#获得record_id类似
#`curl -X POST https://dnsapi.cn/Record.List -d "login_token=11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&format=json&domain_id=xxx"`

#获取记录信息
#curl -X POST https://dnsapi.cn/Record.Info -d 'login_token=11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&format=json&domain_id=10569577&record_id=178245860'

#更新动态dns记录
#curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=LOGIN_TOKEN&format=json&domain_id=2317346&record_id=16894439&record_line_id=10%3D3&sub_domain=www'

token_id=11111
token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
domain_id=00000000
record_id=000000000
sub_domain1=ddns

myip=$(curl http://ip.taobao.com/service/getIpInfo2.php?ip=myip --silent)
ip=`echo $myip |sed 's/.*"ip":"\(.*\)"}}/\1/g'`

record_info=`curl -X POST https://dnsapi.cn/Record.Info -d "login_token=$token_id,$token&format=json&domain_id=$domain_id&record_id=$record_id" --silent`
record_ip=`echo $record_info | sed 's/.*"value":"\([0-9\.]*\)".*/\1/g'`

echo $ip
echo $record_ip
if [ $ip != $record_ip ];then
curl -X POST https://dnsapi.cn/Record.Ddns -d "login_token=$token_id,$token&format=json&domain_id=$domain_id&record_id=$record_id&record_line_id=0&sub_domain=ddns" --silent
fi


