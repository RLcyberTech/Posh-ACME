function Get-CurrentPluginType { 'dns-01' }

function Add-DnsTxt {
    [CmdletBinding(DefaultParameterSetName='Secure')]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$RecordName,
        [Parameter(Mandatory,Position=1)]
        [string]$TxtValue,
        [Parameter(ParameterSetName='Secure',Mandatory,Position=2)]
        [securestring]$spDYNToken,
        [Parameter(ParameterSetName='DeprecatedInsecure',Mandatory,Position=2)]
        [string]$spDYNTokenInsecure,
        [Parameter(ValueFromRemainingArguments)]
        $ExtraParams
    )

    if ('Secure' -eq $PSCmdlet.ParameterSetName) {
        $spDYNTokenInsecure = [pscredential]::new('a',$spDYNToken).GetNetworkCredential().Password
    }

    Write-Verbose "Adding spDYN TXT record via v3 API for $RecordName"

    $uri = "https://spdyn.de/api/3/host/acmeChallenge"
    $headers = @{
        "Authorization" = "Bearer $spDYNTokenInsecure"
    }

    $body = @{
        host           = $RecordName
        challengeToken = $TxtValue
    } | ConvertTo-Json

    try {
        Write-Debug "POST $uri"
        Write-Debug "Headers: @{ Authorization = 'Bearer REDACTED' }"
        Write-Debug "Body: $body"

        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "application/json" @script:UseBasic -Verbose:$false -EA Stop
        Write-Debug "Response: $response"
    } catch {
        throw "Failed to add spDYN TXT record via v3 API.`nError: $_"
    }

    <#
    .SYNOPSIS
        Add a DNS TXT record to spDYN.

    .DESCRIPTION
        Add a DNS TXT record to spDYN using the v3 REST API.

    .PARAMETER RecordName
        The fully qualified name of the TXT record (e.g., _acme-challenge.example.spdns.eu).

    .PARAMETER TxtValue
        The challenge value of the TXT record.

    .PARAMETER spDYNToken
        The ACME Challenge Token generated in the spDYN portal for this host.

    .PARAMETER spDYNTokenInsecure
        (DEPRECATED) The plaintext ACME Challenge Token for spDYN.

    .PARAMETER ExtraParams
        This parameter can be ignored and is only used to prevent errors when splatting with more parameters than this function supports.

    .EXAMPLE
        $token = Read-Host 'Token' -AsSecureString
        Add-DnsTxt '_acme-challenge.example.spdns.eu' 'challenge-value' $token
    #>
}

function Remove-DnsTxt {
    [CmdletBinding(DefaultParameterSetName='Secure')]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$RecordName,
        [Parameter(Mandatory,Position=1)]
        [string]$TxtValue,
        [Parameter(ParameterSetName='Secure',Mandatory,Position=2)]
        [securestring]$spDYNToken,
        [Parameter(ParameterSetName='DeprecatedInsecure',Mandatory,Position=2)]
        [string]$spDYNTokenInsecure,
        [Parameter(ValueFromRemainingArguments)]
        $ExtraParams
    )

    if ('Secure' -eq $PSCmdlet.ParameterSetName) {
        $spDYNTokenInsecure = [pscredential]::new('a',$spDYNToken).GetNetworkCredential().Password
    }

    Write-Verbose "Removing spDYN TXT record via v3 API for $RecordName"

    $uri = "https://spdyn.de/api/3/host/acmeChallenge"
    $headers = @{
        "Authorization" = "Bearer $spDYNTokenInsecure"
    }

    $body = @{
        host           = $RecordName
        challengeToken = $TxtValue
    } | ConvertTo-Json

    try {
        Write-Debug "DELETE $uri"
        Write-Debug "Headers: @{ Authorization = 'Bearer REDACTED' }"
        Write-Debug "Body: $body"

        # Capturing to out-null because spDYN returns HTTP 204 (No Content) which triggers no output object
        Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers -Body $body -ContentType "application/json" @script:UseBasic -Verbose:$false -EA Stop | Out-Null
    } catch {
        throw "Failed to remove spDYN TXT record via v3 API.`nError: $_"
    }

    <#
    .SYNOPSIS
        Remove a DNS TXT record from spDYN.

    .DESCRIPTION
        Remove a DNS TXT record from spDYN using the v3 REST API.

    .PARAMETER RecordName
        The fully qualified name of the TXT record (e.g., _acme-challenge.example.spdns.eu).

    .PARAMETER TxtValue
        The challenge value of the TXT record.

    .PARAMETER spDYNToken
        The ACME Challenge Token generated in the spDYN portal for this host.

    .PARAMETER spDYNTokenInsecure
        (DEPRECATED) The plaintext ACME Challenge Token for spDYN.

    .PARAMETER ExtraParams
        This parameter can be ignored and is only used to prevent errors when splatting with more parameters than this function supports.

    .EXAMPLE
        $token = Read-Host 'Token' -AsSecureString
        Remove-DnsTxt '_acme-challenge.example.spdns.eu' 'challenge-value' $token
    #>
}

function Save-DnsTxt {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        $ExtraParams
    )

    <#
    .SYNOPSIS
        Not required.

    .DESCRIPTION
        This provider does not require calling this function to commit changes to DNS records.

    .PARAMETER ExtraParams
        This parameter can be ignored and is only used to prevent errors when splatting with more parameters than this function supports.
    #>
}
