#!/usr/bin/python
# -*- coding: utf-8 -*-

import urllib2
import urllib
import time
import uuid
import json
import base64
import hmac
import sys
from hashlib import sha1


AccessKeyId = 'xxxxxxxxxxxxxxxx'
accessKeySecret = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
recordid = 12345678 
rr = "ddns"



#签名
def sign(accessKeySecret, parameters):
    sortedParameters = sorted(parameters.items(), key=lambda parameters: parameters[0])

    canonicalizedQueryString = ''
    for (k,v) in sortedParameters:
        canonicalizedQueryString += '&' + percent_encode(k) + '=' + percent_encode(v)

    stringToSign = 'POST&%2F&' + percent_encode(canonicalizedQueryString[1:])

    h = hmac.new(accessKeySecret + "&", stringToSign, sha1)
    signature = base64.encodestring(h.digest()).strip()
    return signature

#编码
def percent_encode(encodeStr):
    encodeStr = str(encodeStr)
    res = urllib.quote(encodeStr, '')
#    res = urllib.quote(encodeStr.decode(sys.stdin.encoding).encode('utf8'), '')
    res = res.replace('+', '%20')
    res = res.replace('*', '%2A')
    res = res.replace('%7E', '~')
    return res


def localIP():
    url = 'http://ip.taobao.com/service/getIpInfo2.php'
    parameters = { 'ip': 'myip',}
    myip = url_open(url, parameters)
    return myip

#请求
def url_open(url, parameters):
    data = urllib.urlencode(parameters)
    request = urllib2.Request(url, data)
    urldata = urllib2.urlopen(request)
    result = urldata.read()
    jsonobj = json.loads(result)
    return jsonobj


def getResponse(accessKeySecret, part_parameters):
    url = 'http://dns.aliyuncs.com/'
    timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    parameters = { \
        'Format'        : 'json', \
        'Version'   : '2015-01-09', \
        'AccessKeyId'   : AccessKeyId, \
        'SignatureVersion'  : '1.0', \
        'SignatureMethod'   : 'HMAC-SHA1', \
        'SignatureNonce'    : str(uuid.uuid1()), \
        'TimeStamp'         : timestamp, \
    }
    for i in part_parameters.keys():
        parameters[i] = part_parameters[i]
    signature = sign(accessKeySecret, parameters)
    parameters['Signature'] = signature
    jsonobj = url_open(url, parameters)
    return jsonobj

#Describe_parameters = { \
#    'Action'    : 'DescribeDomainRecords', \
#    'DomainName'  : 'huimou.net.cn', \
#    }

Describe_parameters = { \
    'Action'    : 'DescribeDomainRecordInfo', \
    'RecordId'  : recordid, \
    }

myip = localIP()
ip = myip['data']['ip']

Describe = getResponse(accessKeySecret, Describe_parameters)
Domainip = Describe['Value']

if ip != Domainip:
    print time.strftime("%Y-%m-%d %H:%M:%S")
    print Domainip + 'update to' + ip
    Update_parameters = { \
        'Action'    : 'UpdateDomainRecord', \
        'RecordId'  : recordid, \
        'RR'        : rr, \
        'Type'      : 'A', \
        'Value'     : ip, \
        }
    Update = getResponse(accessKeySecret, Update_parameters)
