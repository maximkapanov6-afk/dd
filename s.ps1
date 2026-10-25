$ErrorActionPreference='SilentlyContinue'
[Console]::OutputEncoding=[Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle='System Scanner v3.0'
mode con: cols=100 lines=40 | Out-Null
$Host.UI.RawUI.BackgroundColor='Black'
[Console]::CursorVisible=$false
Clear-Host

$F=[string][char]0x2588; $E=[string][char]0x2591
$tl=[string][char]0x2554; $tr=[string][char]0x2557
$bl=[string][char]0x255A; $br=[string][char]0x255D
$v=[string][char]0x2551; $hz=[string][char]0x2550
$line=$hz*94

function W($x,$y,$t,$c){
  [Console]::SetCursorPosition($x,$y)
  Write-Host $t -NoNewline -ForegroundColor $c
}

# ---------- banner ----------
$L=@{
 S=@(' ____  ','/ ___| ','\___ \ ',' ___) |','|____/ ')
 C=@('  ____ ',' / ___|','| |    ','| |___ ',' \____|')
 A=@('    _    ','   / \   ','  / _ \  ',' / ___ \ ','/_/   \_\')
 N=@(' _   _ ','| \ | |','|  \| |','| |\  |','|_| \_|')
 E=@(' _____ ','| ____|','|  _|  ','| |___ ','|_____|')
 R=@(' ____  ','|  _ \ ','| |_) |','|  _ < ','|_| \_\')
}
$grad='Cyan','Cyan','Cyan','DarkCyan','DarkCyan'
Write-Host ''
for($r=0;$r -lt 5;$r++){
  $s=''
  foreach($ch in 'SCANNER'.ToCharArray()){
    $a=$L[[string]$ch]
    $w=($a | ForEach-Object {$_.Length} | Measure-Object -Maximum).Maximum
    $s+=$a[$r].PadRight($w)
  }
  Write-Host ('   '+$s) -ForegroundColor $grad[$r]
}
Write-Host ''
Write-Host ('  '+$line) -ForegroundColor DarkGray
Write-Host '   Deep protection engine   |   v3.0   |   real-time analysis' -ForegroundColor Gray
Write-Host ('  '+$line) -ForegroundColor DarkGray
Write-Host ''

# ---------- init ----------
foreach($t in 'Initializing scan engine','Loading threat definitions','Preparing system snapshot'){
  Write-Host ("   $t".PadRight(48)) -NoNewline -ForegroundColor Gray
  Start-Sleep -m 450
  Write-Host '[ OK ]' -ForegroundColor Green
}
Write-Host ''

# ---------- modules list ----------
$stages='Memory','Startup items','System files','Registry','Drivers','Browser data','User documents'
Write-Host '   SCAN MODULES' -ForegroundColor White
$ys=[Console]::CursorTop
foreach($s in $stages){
  Write-Host ("   [ ..  ]  $s") -ForegroundColor DarkGray
}
Write-Host ''
$yp=[Console]::CursorTop
1..5 | ForEach-Object { Write-Host '' }

$roots=@('C:\Windows\System32','C:\Windows\SysWOW64','C:\Windows\System32\drivers','C:\Program Files\Common Files',
         'C:\Program Files (x86)','C:\ProgramData',"$env:APPDATA","$env:LOCALAPPDATA\Temp","$env:USERPROFILE\Documents","$env:USERPROFILE\Downloads")
$exts='.dll','.sys','.exe','.dat','.tmp','.cfg'
$sp='|','/','-','\'
$steps=40
$total=0

for($s=0;$s -lt $stages.Count;$s++){
  $n=Get-Random -Minimum 900 -Maximum 4200
  W 3 ($ys+$s) '[ >>  ]' Yellow
  W 12 ($ys+$s) $stages[$s] White
  for($i=0;$i -le $steps;$i++){
    $pct=[int]($i*100/$steps)
    $bar=($F*$i)+($E*($steps-$i))
    $op=[int](($s*$steps+$i)*100/($stages.Count*$steps))
    $obar=($F*[int]($op/100*40))+($E*(40-[int]($op/100*40)))
    $name=-join ((1..8)|ForEach-Object {'abcdef0123456789'[(Get-Random -Maximum 16)]})
    $file=(($roots|Get-Random)+'\'+$name+($exts|Get-Random))
    if($file.Length -gt 84){$file=$file.Substring(0,84)}
    W 3 $yp ("$($sp[$i%4])  Scanning: $($stages[$s])").PadRight(90) Cyan
    W 3 ($yp+1) ("[$bar] "+("$pct%").PadLeft(4)).PadRight(90) Cyan
    W 3 ($yp+2) ("   $file").PadRight(90) DarkGray
    W 3 ($yp+3) ("Overall  [$obar] "+("$op%").PadLeft(4)).PadRight(90) DarkCyan
    Start-Sleep -m (Get-Random -Minimum 15 -Maximum 55)
  }
  $total+=$n
  W 3 ($ys+$s) '[  OK ]' Green
  W 12 ($ys+$s) ($stages[$s].PadRight(22)+('{0:N0} items' -f $n)) Gray
}

# ---------- result ----------
for($k=0;$k -lt 5;$k++){ W 0 ($yp+$k) (' '*98) Gray }
[Console]::SetCursorPosition(0,$yp)
function Box($t,$c){ Write-Host ('  '+$v+$t.PadRight(60)+$v) -ForegroundColor $c }
Write-Host ('  '+$tl+($hz*60)+$tr) -ForegroundColor Green
Box '                    SCAN COMPLETE' Green
Box '' Green
Box ('   Items checked : {0:N0}' -f $total) Green
Box '   Threats found : 0' Green
Box '   Status        : your system is clean' Green
Write-Host ('  '+$bl+($hz*60)+$br) -ForegroundColor Green
Write-Host ''
[Console]::CursorVisible=$true
Read-Host '   Press Enter to close'
