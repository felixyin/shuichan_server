#!/usr/bin/env sh

# mvn 自动部署插件，各种不好用，所以直接脚本搞定，效率更高
cd /Volumes/data/workspace/shui_chan/codes/shuichan_server/ || exit
mvn package -o -Dmaven.test.skip=true -P prod
scp /Volumes/data/workspace/shui_chan/codes/shuichan_server/target/bak.war root@cds:/root/tomcat8_qdbak/webapps
mvn compile -o -Dmaven.test.skip=true -P dev
ti1=$(date +%s)    #获取时间戳
ti2=$(date +%s)
i=$(($ti2 - $ti1 ))

while [[ "$i" -ne "10" ]]
do
	ti2=`date +%s`
	i=$(($ti2 - $ti1 ))
done
open http://gongchang.qdbak.com

exit
exit
exit
