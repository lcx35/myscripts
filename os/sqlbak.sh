#!/bin/bash

dbhost=10.10.162.200
dbuser=root
dbpassword=XIAOzi2308842
domain=7mtt
bakdir=/data/sqlbak
time=`date '+%F-%H-%M'`
savesqldir=${bakdir}/${domain}-sql-${time}

#获得所有数据库名
dbname=`mysql -e "show databases;" -h${dbhost} -u${dbuser} -p${dbpassword}| grep -Ev "Database|information_schema|mysql|test|performance_schema"`

if [ $? -ne 0 ]
then
echo 'error:get database name error!'
exit 1
fi

#创建备份目录
[ ! -d $bakdir ] && mkdir -p $bakdir

cd ${bakdir}

mkdir -p ${savesqldir}

#备份数据库
for db in $dbname
do
    mysqldump -h${dbhost} -u${dbuser} -p${dbpassword} -R -E --databases $db > ${savesqldir}/${domain}-${db}-${time}.sql
done

#打包压缩
tar Jcf ${savesqldir}.tar.xz ${domain}-sql-${time}/

#清理过期文件
find ${bakdir}  -type d -name "${domain}-*" -o -mtime +30 |xargs rm -rf 

exit 0
