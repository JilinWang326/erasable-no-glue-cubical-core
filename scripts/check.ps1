$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$defaultAgda = "C:\Users\24539\Agda\toolchains\agda-no-glue\agda-no-glue.cmd"

if ($env:AGDA) {
  $agda = $env:AGDA
} elseif (Test-Path -LiteralPath $defaultAgda) {
  $agda = $defaultAgda
} else {
  $agda = "agda"
}

Set-Location $root

Write-Host "no-glue-cubical-core check"
Write-Host "Project: $root"
Write-Host "Agda: $agda"

$scanRoots = @("src", "tests")
$agdaFiles = foreach ($scanRoot in $scanRoots) {
  if (Test-Path -LiteralPath $scanRoot) {
    Get-ChildItem -Path $scanRoot -Recurse -File -Filter *.agda
  }
}

$bannedPatterns = @(
  "\{!",
  "\bpostulate\b",
  "primTrustMe",
  "TERMINATING",
  "NON_TERMINATING",
  "NO_TERMINATION_CHECK",
  "allow-unsolved-metas",
  "allow-incomplete-match",
  "type-in-type",
  "\bTODO\b",
  "\bFIXME\b",
  "placeholder",
  "dummy",
  "scaffold",
  "vibe",
  "anti-cheat",
  "ChatGPT",
  "Codex",
  "\badmit\b"
)

$violations = @()
foreach ($pattern in $bannedPatterns) {
  $matches = $agdaFiles | Select-String -Pattern $pattern
  foreach ($match in $matches) {
    $violations += [PSCustomObject]@{
      Pattern = $pattern
      Path = $match.Path
      Line = $match.LineNumber
      Text = $match.Line.Trim()
    }
  }
}

if ($violations.Count -gt 0) {
  $violations | ForEach-Object {
    Write-Host "$($_.Path):$($_.Line): banned pattern '$($_.Pattern)' in: $($_.Text)" -ForegroundColor Red
  }
  throw "Banned Agda source pattern scan failed."
}

$targets = @(
  "src\NoGlueCubicalCore\MainTheorem.agda",
  "src\NoGlueCubicalCore\Index.agda",
  "tests\Smoke\LoadEverything.agda"
)

foreach ($target in $targets) {
  Write-Host "Checking $target"
  & $agda "-i" "src" "-i" "tests" $target
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

Write-Host "Check passed."
