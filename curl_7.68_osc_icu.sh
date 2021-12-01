# Source from http://arthurguru.users.sourceforge.net/blog/aws_api_bash.html

# OSC AK/SK
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
dateValue1=`TZ=GMT date "+%Y%m%d"`
dateValue2=`TZ=GMT date "+%Y%m%dT%H%M%SZ"`

#------------------------------------
# Step 1 - Create canonical request.
#------------------------------------
request_payload_sha256=$( printf "${request_payload}" | openssl dgst -binary -sha256 | xxd -p -c 256 )
canonical_request=$( printf "GET
/

content-type:application/x-amz-json-1.1
host:icu.eu-west-2.outscale.com
x-amz-date:${dateValue2}

content-type;host;x-amz-date
${request_payload_sha256}" )
# echo "DEBUG: canonical request: ${canonical_request}"

#------------------------------------
# Step 2 - Create string to sign.
#------------------------------------
canonical_request_sha256=$( printf "${canonical_request}" | openssl dgst -binary -sha256 | xxd -p -c 256 )
stringToSign=$( printf "AWS4-HMAC-SHA256
${dateValue2}
${dateValue1}/${region}/icu/aws4_request
${canonical_request_sha256}" )
# echo "DEBUG: stringToSign: ${stringToSign}"

#------------------------------------
# Step 3 - Calculate signature.
#------------------------------------
kSecret=$(   printf "AWS4${oscSecret}" | xxd -p -c 256 )
kDate=$(     printf "${dateValue1}"    | openssl dgst -binary -sha256 -mac HMAC -macopt hexkey:${kSecret}       | xxd -p -c 256 )
kRegion=$(   printf "${region}"        | openssl dgst -binary -sha256 -mac HMAC -macopt hexkey:${kDate}         | xxd -p -c 256 )
kService=$(  printf "${service}"       | openssl dgst -binary -sha256 -mac HMAC -macopt hexkey:${kRegion}       | xxd -p -c 256 )
kSigning=$(  printf "aws4_request"     | openssl dgst -binary -sha256 -mac HMAC -macopt hexkey:${kService}      | xxd -p -c 256 )
signature=$( printf "${stringToSign}"  | openssl dgst -binary -hex -sha256 -mac HMAC -macopt hexkey:${kSigning} | sed 's/^.* //' )
# echo "DEBUG: signature: ${signature}"

#------------------------------------
# Step 4 - Add signature to request.
#------------------------------------
curl --request GET \
     -H "Authorization: AWS4-HMAC-SHA256 Credential=${oscKey}/${dateValue1}/${region}/icu/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=${signature}" \
     -H "Content-type: application/x-amz-json-1.1" \
     -H "Host: icu.eu-west-2.outscale.com" \
     -H "x-amz-target: TinaIcuService.${action}" \
     -H "X-Amz-Date: ${dateValue2}" \
     --data "${request_payload}" \
     "https://icu.eu-west-2.outscale.com" 
