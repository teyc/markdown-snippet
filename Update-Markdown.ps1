Function Update-Markdown {
  <#
  .SYNOPSIS
    Updates an existing markdown file with injected code-snippet
  #>
  [CmdletBinding()]
  param (
      <# Markdown file #>
      [Parameter()]
      [string]
      $Path
  )

  If (-Not (Test-Path $Path)) {
    Write-Error "Not found: $Path"
    Exit 1
  }

  $Markdown = Get-Content $Path
  $pattern = "(Get-MarkdownSnippet .+$)"
  
  try {
    Push-Location (Split-Path (Resolve-Path $Path))

    $IsInsertingSnippet = $false

    foreach ($line in $Markdown) {

      if ($line -match $pattern) {
        Write-Output $Line

        $Result = Invoke-Expression $Matches[1]
        If ($Result) {
          $IsInsertingSnippet = $True
          Write-Output $Result
          If ($Until -eq $null) {
            $Until = "``````" # three backticks
          }  

        }
      }

      If ($Until -ne $null -And $line -eq $Until) {
        $Until = $null
        $IsInsertingSnippet = $False
      }

      if ($IsInsertingSnippet -And $Until -ne $null) {
        continue
      }

      Write-Output $line

    }
  
  } finally {
    Pop-Location
  }
}
