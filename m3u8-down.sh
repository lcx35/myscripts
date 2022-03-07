#/bin/bash

url=
s1=
s2=
name=

while [ $# != 0 ]
do
case $1 in
http*)
  url=$1
;;
*mkv)
  name=$1
;;
[0-9:]*)
  t=$1
  n=`echo $t | grep -c ':'`
  case $n in
  0)
      t=0:0:$t
  ;;
  1)
      t=0:$t
  ;;
  esac
  
  s=`date -d 1970-01-01T${t}Z +%s`
  if [ x$s1 == x ];then
    s1=$s
  elif [ $t < $s1 ];then
    s2=$s1
    s1=$s
  elif [ $t > $s1 ];then
    s2=$s
  fi
;;
*)
  echo "Useage: $0 url t1 t2 filename"
  echo "Example: $0 http://aa.co/aa.m3u8 20 1:20 aa.mkv"
  echo "Parameters unordered"
  exit 1
;;
esac
shift
done

if [ "x${url}" == x || "x${name}" == x || "x${s1}" == x ]
then
  echo "Useage: $0 url t1 t2 filename"
  exit 1
fi

url_prefix=${url%/*.m3u8}/


wget --no-check-certificate -O aa.m3u8 "$url"

h1=`awk -F"[:,]" '{sum+=$2;if(sum>'$s1') exit}END{ print NR-1}' aa.m3u8`
ts1=`sed -n ${h1}p aa.m3u8`
  h2=`awk '/#EXT-X-ENDLIST/{print NR-1;exit}' aa.m3u8`
if [ "x${s2}" != "x" ];then
  h2=`awk -F"[:,]" '{sum+=$2;if(sum>'$s2') exit}END{ print NR+1}' aa.m3u8`
fi
ts2=`sed -n ${h2}p aa.m3u8`

for i in $( sed -n "/^$ts1$/,/^$ts2$/"p aa.m3u8|grep -v "#" )
do
  echo $url_prefix$i
  wget --no-check-certificate "$url_prefix$i"
  cat $i >>$name.ts
done

ffmpeg -i $name.ts -c copy $name

rm -rf *.ts
