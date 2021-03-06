# Command curl examples on OSC

From the version 7.75, curl supports the aws signature v4.

## How to use

**OSC.ReadAccessKeys example:**

```bash
curl -XPOST \
  -H "X-Osc-Date: `TZ=GMT date "+%Y%m%dT%H%M%SZ"`" \
  -H "Authorization: Basic `echo -n "MYLOGIN:MYPASSWORD" | base64`" \
  https://api.eu-west-2.outscale.com/api/v1/ReadAccessKeys
```

**ICU.ReadConsumptionAccount example:**

```bash
curl --aws-sigv4 "aws" \
  -u "MYACCESSKEY:MYSECRETKEY" \
  -H "Content-Type: application/x-amz-json-1.1" \
  -H "x-amz-target:TinaIcuService.ReadConsumptionAccount" \
  -H "x-amz-date: `TZ=GMT date "+%Y%m%dT%H%M%SZ"`" \
  -d "@payload_read_consumption_account.json" \
  https://icu.eu-west-2.outscale.com
```

## Scripts

### Prerequisites

You will need a configuration file `auth.conf` with your Access and Secret keys.

```text
oscKey=MYACCESSKEY
oscSecret=MYSECRETKEY
```

### Curl version < 7.75

#### ICU
```bash
./curl_7.68_osc_icu.sh ReadConsumptionAccount payload_read_consumption_account.json | jq
```

### Curl version >= 7.75

#### FCU

```bash
./curl_7.75_osc_fcu.sh DescribeInstances query_describe_instance.txt | xmllint --format -
```

#### ICU

```bash
./curl_7.75_osc_icu.sh ReadConsumptionAccount payload_read_consumption_account.json | jq
```

