[CmdletBinding()]
param(
    [ValidateNotNull()]
    [Parameter()]
    [hashtable]$ModuleParameters = @{ }
)
Set-StrictMode -Version 2

$decayRate = 0.0231049060186648 # Ln(2) / 30
$referenceDate = [DateTime]::Parse('2019-01-01')
$frecencyDbPath = "$env:LocalAppData\z.ps\frecencyData.csv"
$navigationDbPath = "$env:LocalAppData\z.ps\navigationData.csv"
New-Item $frecencyDbPath -ItemType File -ErrorAction Ignore
New-Item $navigationDbPath -ItemType File -ErrorAction Ignore

$collectNavigationData = $true

function Update-NavigationHistory([string]$Path) {
    $absolutePath = Resolve-Path -LiteralPath $Path
    $currentDateTime = [DateTime]::UtcNow
    $delta = $currentDateTime.Subtract($referenceDate)
    $currentScore = Get-CurrentScore $absolutePath
    $newScore = $currentScore + [Math]::Pow([Math]::E, ($delta.TotalDays * $decayRate))
    if ($collectNavigationData) {
        $timeStamp = $currentDateTime.ToString('o')
        "$absolutePath,$timeStamp" >> $navigationDbPath
    }
}

function Get-CurrentScore([string]$AbsolutePath) {
    1.0
}

function Set-Score([string]$AbsolutePath, [double]$Score) {
    
}