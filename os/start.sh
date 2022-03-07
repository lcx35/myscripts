#!/bin/bash

case "$1" in
    all)
		cd ug-server-xstarter
		sh service.sh dev start
		sh service.sh dev start
		cd ..

		cd ug-manager-xstarter
		sh service.sh dev start
		sh service.sh dev start
		cd ..

		cd ug-quartz-xstarter
		sh service.sh dev start
		sh service.sh dev start
		cd ..

		exit 0
		;;
	server)
		cd ug-server-xstarter
		sh service.sh dev start
		sh service.sh dev start
		cd ..
		exit 0
		;;
	manager)
		cd ug-manager-xstarter
		sh service.sh dev start
		sh service.sh dev start
		cd ..
		exit 0
		;;
    quartz)
		cd ug-quartz-xstarter
		sh service.sh dev start
		sh service.sh dev start
		cd ..
		exit 0
		;;
	*)
		echo 'Usage: cmd name all|server|manager|quartz'
		echo 'start.sh all'
		exit 0
		;;
esac
