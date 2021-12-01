# Curl commands examples on OSC

## Curl < 7.75

### Prerequisites
You will need a configuration file `auth.conf` with your Access and Secret keys.
```
oscKey=MYACCESSKEY
oscSecret=MYSECRETKEY
```

### ICU
  ./curl_7.68_osc_icu.sh ReadConsumptionAccount payload_read_consumption_account.json | jq    
