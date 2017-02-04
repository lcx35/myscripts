#!/bin/sh

#备份文件前缀
hostname=7mtt
#备份存放目录
savedir=/data/webbak/
#网站文件目录
bakdir=/data/www

#全量备份目录
base=base
#增量备份目录
augmenter=augmenter

#获得日期
day=$(date +%e)
site=`ls ${bakdir}`
time=`date '+%F-%H-%M'`


#1号全量备份
if [ $day == "01" ]
then
	savename=${savedir}${base}/${hostname}-${time}
	mkdir -p ${savename}
	cd ${bakdir}

	for i in ${site}
	do
	tar -cJf ${savename}/${i}.tar.xz ${i}
	done
	
	#rm -rf ${savedir}${augmenter}
	#清理过期文件
	find ${savedir} -type d -mtime +62|xargs rm -rf

else
	#其余日期增量备份
	savename=${savedir}${augmenter}/${hostname}-${time}
	mkdir -p ${savename}
	cd ${bakdir}

	for i in ${site}
	do
	tar --newer-mtime=$(date '+%Y-%m')-01 -cJf ${savename}/${i}.tar.xz ${i}
	done

	#清理/tmp目录
	find /tmp -type f -mtime +2 -exec rm -f {} \;
fi

exit 0
