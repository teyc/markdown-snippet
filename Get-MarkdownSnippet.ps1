
Function Get-MarkdownSnippet {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$True)]
      [string]
      $Path,

      [Parameter(Mandatory=$True)]
      [string]
      $Name,

      [Parameter(Mandatory=$False)]
      [string]
      $Until = $null
    )

    $FullName = Resolve-Path $Path

    If (-Not (Test-Path $FullName)) {
      Write-Error "Not found: $FullName"
      Exit 1
    }

    $lines = Get-Content $FullName
    $patternStart = "snip:$Name"
    $patternEnd = "end:$Name"
    $snipStart = $false
    $snipEnd = $false

    $indentSize = 1000
    $result = @()

    foreach ($line in $lines) {

      if ($line -match $patternStart) {
        $snipStart = $true
        continue
      }

      if ($line -match $patternEnd) {
        $snipEnd = $true
        break
      }

      If (-Not $snipStart) {
        continue
      }

      $result += $line

      # Remove any indentation
      If ($line -notmatch "^(\s+)") {
        $indentSize = 0
      } ElseIf ($matches[0].Length -lt $indentSize) {
        $indentSize = $matches[0].Length
      }

    }

    If ($snipStart -and $snipEnd) {
      foreach ($line in $result) {
        Write-Output $line.Substring($indentSize)
      }
    } ElseIf (-Not $snipStart) {
      Write-Warning "not found '$patternStart' in '$FullName'"
    } ElseIf (-Not $snipEnd) {
      Write-Warning "not found '$patternEnd' in '$FullName'"
    }

    Set-Variable "Until" $Until -scope 1
}
