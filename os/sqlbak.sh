#!/bin/bash

dbhost=10.10.40.214
dbuser=aaaa
dbpassword=abc123
filename=aaaaa
workdir=/data/sqlbak
time=`date '+%F-%H-%M'`
#rmname=`date "+%F" -d'-1 month'`
savesqldir=${workdir}/${filename}-sql-${time}

#获得数据库名
dbname=`mysql -e "show databases;" -h${dbhost} -u${dbuser} -p${dbpassword}| grep -Ev "Database|information_schema|mysql|test|performance_schema"`

if [ $? -ne 0 ]
then
echo 'error:get database name error!'
fi


[ ! -d $workdir ] && mkdir -p $workdir

cd ${workdir}

mkdir -p ${savesqldir}

for db in $dbname
do
    mysqldump -h${dbhost} -u${dbuser} -p${dbpassword} --databases $db > ${savesqldir}/${filename}-${db}-${time}.sql
done

tar Jcf ${savesqldir}.tar.xz ${filename}-sql-${time}/

#删除30天前的备份
find /data/sqlbak  -type d -name "${filename}-*" -o -mtime +30 |xargs rm -rf 

exit 0
