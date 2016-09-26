#!/usr/bin/env python
#-*- coding:utf-8 -*-

"""
#获得domain_id可以用curl
#`curl -X POST https://dnsapi.cn/Domain.List -d "login_token=11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&format=json"`
#获得record_id类似
#`curl -X POST https://dnsapi.cn/Record.List -d "login_token=11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&format=json&domain_id=xxx"`
#获取记录信息
#curl -X POST https://dnsapi.cn/Record.Info -d 'login_token=11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&format=json&domain_id=10569577&record_id=178245860'
#更新动态dns记录
#curl -X POST https://dnsapi.cn/Record.Ddns -d 'login_token=LOGIN_TOKEN&format=json&domain_id=2317346&record_id=16894439&record_line_id=10%3D3&sub_domain=www'
"""

import urllib, urllib2
import time
import json

def url_open(url, parameters):
    body = urllib.urlencode(parameters)
    request = urllib2.Request(url, body)
    urldata = urllib2.urlopen(request)
    result = urldata.read()
    jsonobj = json.loads(result)
    return jsonobj

login_token = "11111,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
domain_id = 11111111
record_id = 111111111


localip_url = 'http://ip.taobao.com/service/getIpInfo2.php'
localip_parameters = {'ip':'myip'}

dnspod_get_url = 'https://dnsapi.cn/Record.Info'
dnspod_parameters = {"login_token": login_token, "format": "json", "domain_id": domain_id, "record_id": record_id}

dnspod_ddns_url = 'https://dnsapi.cn/Record.Ddns'
#sub_domain="www"

if __name__ == '__main__':
    try:
        ip = url_open(localip_url, localip_parameters)
        dnspod_ip = url_open(dnspod_get_url, dnspod_parameters)
        if dnspod_ip['record']['value'] != ip['data']['ip']:
            print time.strftime('%Y-%m-%d %H:%M:%S')
            print dnspod_ip['record']['value']+'\n'+ip['data']['ip']
            dnspod_parameters['sub_domain'] = 'ddns'
            dnspod_parameters['record_line_id'] = '0'
#            dnspod_parameters['value'] = ip  #sub_domain="www"
            update = url_open(dnspod_ddns_url, dnspod_parameters)
#            print update
    except Exception, e:
        print time.strftime('%Y-%m-%d %H:%M:%S')
        print e
        pass
