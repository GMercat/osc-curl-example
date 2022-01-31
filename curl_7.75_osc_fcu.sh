# OSC AK/SK
config_file=auth.conf
if [ ! -f "$config_file" ]; then
  echo "ERROR: $config_file is missing"
  exit 1
fi

source auth.conf

if [ -z $1 ]; then
  echo "ERROR: Action is missing"
  exit 1 
fi

request_query=''
if [ $# = 2 ]; then
  request_query=`cat $2 2> /dev/null`
  if [ $? -ne 0 ]; then
    echo "ERROR: $2: No such file or directory"
    exit 1
  fi
fi
#>&2 echo "DEBUG: request_query (${#request_query}) : ${request_query}"

action=$1
region="eu-west-2"
service="fcu"
date_amz=`TZ=GMT date "+%Y%m%dT%H%M%SZ"`

curl --aws-sigv4 "aws" \
     -u "${oscKey}:${oscSecret}" \
     -H "x-amz-date:${date_amz}" \
     "https://${service}.${region}.outscale.com?Version=2016-11-15&Action=${action}${request_query}"
