def get-api-key [] {
    vault kv get -format=json /kv/tailscale-api | from json  | get data | get data | get api_key
}


export def list-devices [--api_key: string] {
    let api_key = if $api_key == null { (get-api-key)  } else $api_key
    http get -H ["Authorization", $"Bearer ($api_key)"]  "https://api.tailscale.com/api/v2/tailnet/-/devices" | get devices | select name addresses
}
