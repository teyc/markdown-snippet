Function Set-Indentation {
  [CmdletBinding()]
  param(
    [parameter(Mandatory=$True,Position=0)][int] $Indent,
    [parameter(ValueFromPipeline=$True)] $Line
  )

  begin {
    Write-Verbose "Indented to $Indent"
  }

  process {
    " " * $Indent + $line
  }
}

Function Update-MarkdownSnippet {
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
  $pattern = "^(\s*).*(Get-MarkdownSnippet .+$)"

  try {
    Push-Location (Split-Path (Resolve-Path $Path))

    $IsInsertingSnippet = $false

    foreach ($line in $Markdown) {

      if ($line -match $pattern) {
        Write-Output $Line

        $Indent = $Matches[1].Length
        Write-Verbose "`[$($Matches[1])`][$($Matches[2])]"
        $Result = Invoke-Expression $Matches[2]
                If ($Result) {
          $IsInsertingSnippet = $True
          $Result | Set-Indentation -Indent $Indent | Write-Output
          If ($null -eq $Until) {
            $Until = "``````" # three backticks
          }

        }
      }

      If ($null -ne $Unil -And $line -Match "^\s*$Until\s*$") {
        $Until = $null
        $IsInsertingSnippet = $False
      }

      if ($IsInsertingSnippet -And $null -ne $Until) {
        continue
      }

      Write-Output $line

    }

  } finally {
    Pop-Location
  }

  If ($IsInsertingSnippet) {
    Write-Error "Did not find marker $Until"
  }
}
