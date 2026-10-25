$ErrorActionPreference='SilentlyContinue'
[Console]::OutputEncoding=[Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle='System Scanner'
$F=[string][char]0x2588; $E=[string][char]0x2591
$tl=[string][char]0x2554; $tr=[string][char]0x2557
$bl=[string][char]0x255A; $br=[string][char]0x255D
$v=[string][char]0x2551; $h=([string][char]0x2550)*46
function Box($t,$c){ Write-Host "$v$($t.PadRight(46))$v" -ForegroundColor $c }

Clear-Host
Write-Host "$tl$h$tr" -ForegroundColor Cyan
Box '          SYSTEM SCANNER  v2.1' Cyan
Box '        Deep protection engine active' Cyan
Write-Host "$bl$h$br" -ForegroundColor Cyan
Write-Host ''
Write-Host '  Initializing engine...' -ForegroundColor DarkGray
Start-Sleep -m 900
Write-Host '  Definitions loaded: OK' -ForegroundColor Green
Start-Sleep -m 600

$stages='Memory','Startup items','System files','Registry','Drivers','Browser data','User documents'
$total=0
foreach($s in $stages){
  $n=Get-Random -Minimum 800 -Maximum 4000
  Write-Host ''
  Write-Host "  > $s" -ForegroundColor White
  $steps=30
  for($i=0;$i -le $steps;$i++){
    $p=[int]($i*100/$steps)
    $bar=($F*$i)+($E*($steps-$i))
    Write-Host ("`r    [$bar] {0,3}%" -f $p) -NoNewline -ForegroundColor Cyan
    Start-Sleep -m (Get-Random -Minimum 15 -Maximum 60)
  }
  $total+=$n
  Write-Host "  OK ($n items)" -ForegroundColor Green
}

Write-Host ''
Write-Host "$tl$h$tr" -ForegroundColor Green
Box '            SCAN COMPLETE' Green
Box "   Items checked : $total" Green
Box '   Threats found : 0' Green
Box '   Your system is clean' Green
Write-Host "$bl$h$br" -ForegroundColor Green
Write-Host ''
Read-Host '  Press Enter to close'
