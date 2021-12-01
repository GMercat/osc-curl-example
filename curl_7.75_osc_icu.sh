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

if [ $# = 2 ]; then
  request_payload=`cat $2 2> /dev/null`
  if [ $? -ne 0 ]; then
    echo "ERROR: $2: No such file or directory"
    exit 1
  fi
fi
#echo "DEBUG: request_payload (${#request_payload}) : ${request_payload}"

action=$1
region="eu-west-2"
service="icu"
date_amz=`TZ=GMT date "+%Y%m%dT%H%M%SZ"`

curl --aws-sigv4 "aws" \
     -u "${oscKey}:${oscSecret}" \
     -H "Content-Type: application/x-amz-json-1.1" \
     -H "x-amz-target:TinaIcuService.${action}" \
     -H "x-amz-date:${date_amz}" \
     -d "${request_payload}" \
     "https://${service}.${region}.outscale.com"
