# Command curl examples on OSC

## Prerequisites

You will need a configuration file `auth.conf` with your Access and Secret keys.

```text
oscKey=MYACCESSKEY
oscSecret=MYSECRETKEY
```

## ICU

### Curl version < 7.75

```bash
./curl_7.68_osc_icu.sh ReadConsumptionAccount payload_read_consumption_account.json | jq
```
