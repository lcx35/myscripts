#!/bin/sh

filename=aaaa
savedir=/data/webbak
bakdir=/data/www

site=`ls ${bakdir}`
time=`date '+%F-%H-%M'`
savename=${savedir}/${filename}-${time}

mkdir -p ${savename}
cd ${bakdir}

for i in ${site}
do
tar -cJf ${savename}/${i}.tar.xz ${i}
done

#删除十天前的文件
find ${savedir} -type d -mtime +10|xargs rm -rf

exit 0
