# Updates a DuckDNS record from Windows Task Scheduler.
# Requires $env:DUCKDNS_DOMAIN and $env:DUCKDNS_TOKEN.
$ErrorActionPreference = 'Stop'
if (-not $env:DUCKDNS_DOMAIN -or -not $env:DUCKDNS_TOKEN) {
    throw 'Set DUCKDNS_DOMAIN and DUCKDNS_TOKEN first.'
}
$ip = (Invoke-RestMethod -Uri 'https://api.ipify.org' -TimeoutSec 15).Trim()
if ($ip -notmatch '^\d{1,3}(\.\d{1,3}){3}$') { throw "Unexpected public IP: $ip" }
$uri = 'https://www.duckdns.org/update?domains={0}&token={1}&ip={2}' -f $env:DUCKDNS_DOMAIN, $env:DUCKDNS_TOKEN, $ip
$answer = (Invoke-WebRequest -Uri $uri -TimeoutSec 20 -UseBasicParsing).Content.Trim()
Write-Output ("duckdns: {0} for {1} -> {2}" -f $answer, $env:DUCKDNS_DOMAIN, $ip)
if ($answer -ne 'OK') { exit 1 }
