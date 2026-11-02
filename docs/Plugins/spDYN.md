title: Securepoint spDYN

# How To Use the spDYN DNS Plugin

This plugin works against the [spDYN]([https://spdyn.de/) DNS provider. It is assumed that you have already setup an account and one or more domains you will be working against.

## Setup

You will need to generate an ACME-Challenge-Token if you haven't already done so. Follow the guide provided by Securepoint [here (DE)](https://wiki.securepoint.de/index.php?title=SPDyn/Updatetoken&uselang=de) or [here (EN)](https://wiki.securepoint.de/index.php?title=SPDyn/Updatetoken&uselang=en).

## Using the Plugin

You will need to provide the Secret ACME-Challenge-Token to `spDYNToken`.

```powershell
$pArgs = @{
  spDYNToken = (Read-Host 'ACME Challenge Token' -AsSecureString)
}

	
New-PACertificate example.com -Plugin spDYN -PluginArgs $pArgs
```
