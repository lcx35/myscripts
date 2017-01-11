#!/bin/sh

#备份文件前缀
hostname=7mtt
savedir=/data/webbak/
bakdir=/data/www

#全量备份存放目录
base=base
#增量备份存放目录
augmenter=augmenter


site=`ls ${bakdir}`
time=`date '+%F-%H-%M'`

#每月1日全量备份
if [ $1 == "01" ]
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
    #其余时间增量备份
	savename=${savedir}${augmenter}/${hostname}-${time}
	mkdir -p ${savename}
	cd ${bakdir}

	for i in ${site}
	do
	tar --newer-mtime=$(date '+%Y-%m')-01 -cJf ${savename}/${i}.tar.xz ${i}
	done
fi

exit 0
