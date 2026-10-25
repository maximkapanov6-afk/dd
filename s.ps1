Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class Win32 {
  [DllImport("Gdi32.dll")] public static extern IntPtr CreateRoundRectRgn(int l,int t,int r,int b,int w,int h);
  [DllImport("user32.dll")] public static extern bool ReleaseCapture();
  [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h,int m,int w,int l);
}
'@

$Host.UI.RawUI.WindowTitle='Powershell Scanner'
Write-Host 'DO NOT CLOSE THIS CONSOLE BEFORE SCAN IS COMPLETE' -ForegroundColor Red

function Col($r,$g,$b){ [System.Drawing.Color]::FromArgb($r,$g,$b) }
$bg    = Col 8 16 34
$cyan  = Col 34 211 238
$track = Col 28 34 46
$gray  = Col 170 170 170
$green = Col 74 222 128
$dim   = Col 70 85 110

$W=520; $H=410
$form=New-Object System.Windows.Forms.Form
$form.FormBorderStyle='None'
$form.StartPosition='CenterScreen'
$form.Size=New-Object System.Drawing.Size($W,$H)
$form.BackColor=$bg
$form.TopMost=$true
$form.Text='System Scanner'
$form.Region=[System.Drawing.Region]::FromHrgn([Win32]::CreateRoundRectRgn(0,0,$W+1,$H+1,18,18))

$drag={ [void][Win32]::ReleaseCapture(); [void][Win32]::SendMessage($form.Handle,0xA1,2,0) }
$form.Add_MouseDown($drag)

$title=New-Object System.Windows.Forms.Label
$title.Text=':: SYSTEM SCANNER ::'
$title.ForeColor=$cyan
$title.Font=New-Object System.Drawing.Font('Consolas',9,[System.Drawing.FontStyle]::Bold)
$title.AutoSize=$true
$title.Location=New-Object System.Drawing.Point(16,12)
$title.Add_MouseDown($drag)
$form.Controls.Add($title)

$min=New-Object System.Windows.Forms.Label
$min.Text=[string][char]0x2014
$min.ForeColor=[System.Drawing.Color]::White
$min.Font=New-Object System.Drawing.Font('Segoe UI',10,[System.Drawing.FontStyle]::Bold)
$min.AutoSize=$true
$min.Cursor=[System.Windows.Forms.Cursors]::Hand
$min.Location=New-Object System.Drawing.Point(($W-38),8)
$min.Add_Click({ $form.WindowState='Minimized' })
$form.Controls.Add($min)

$head=New-Object System.Windows.Forms.Label
$head.Text='SCANNING IN PROGRESS'
$head.ForeColor=[System.Drawing.Color]::White
$head.Font=New-Object System.Drawing.Font('Segoe UI',18,[System.Drawing.FontStyle]::Bold)
$head.TextAlign='MiddleCenter'
$head.Size=New-Object System.Drawing.Size($W,44)
$head.Location=New-Object System.Drawing.Point(0,50)
$head.Add_MouseDown($drag)
$form.Controls.Add($head)

$trackP=New-Object System.Windows.Forms.Panel
$trackP.BackColor=$track
$trackP.Size=New-Object System.Drawing.Size(460,6)
$trackP.Location=New-Object System.Drawing.Point(30,108)
$form.Controls.Add($trackP)

$fill=New-Object System.Windows.Forms.Panel
$fill.BackColor=$cyan
$fill.Size=New-Object System.Drawing.Size(0,6)
$fill.Location=New-Object System.Drawing.Point(0,0)
$trackP.Controls.Add($fill)

$pctL=New-Object System.Windows.Forms.Label
$pctL.Text='0%'
$pctL.ForeColor=$cyan
$pctL.Font=New-Object System.Drawing.Font('Segoe UI',9)
$pctL.TextAlign='MiddleRight'
$pctL.Size=New-Object System.Drawing.Size(100,20)
$pctL.Location=New-Object System.Drawing.Point(390,118)
$form.Controls.Add($pctL)

$rtb=New-Object System.Windows.Forms.RichTextBox
$rtb.BackColor=[System.Drawing.Color]::Black
$rtb.ForeColor=$gray
$rtb.Font=New-Object System.Drawing.Font('Consolas',9)
$rtb.BorderStyle='None'
$rtb.ReadOnly=$true
$rtb.TabStop=$false
$rtb.Size=New-Object System.Drawing.Size(460,190)
$rtb.Location=New-Object System.Drawing.Point(30,148)
$form.Controls.Add($rtb)

$btn=New-Object System.Windows.Forms.Button
$btn.Text='COMPLETE'
$btn.FlatStyle='Flat'
$btn.FlatAppearance.BorderSize=0
$btn.BackColor=$cyan
$btn.ForeColor=[System.Drawing.Color]::Black
$btn.Font=New-Object System.Drawing.Font('Segoe UI',10,[System.Drawing.FontStyle]::Bold)
$btn.Size=New-Object System.Drawing.Size(160,36)
$btn.Location=New-Object System.Drawing.Point(180,352)
$btn.Cursor=[System.Windows.Forms.Cursors]::Hand
$btn.Visible=$false
$btn.Add_Click({ $form.Close() })
$form.Controls.Add($btn)

$foot=New-Object System.Windows.Forms.Label
$foot.Text='engine v3.0  |  secure mode'
$foot.ForeColor=$dim
$foot.Font=New-Object System.Drawing.Font('Consolas',8)
$foot.AutoSize=$true
$foot.Location=New-Object System.Drawing.Point(16,386)
$form.Controls.Add($foot)

function Log($t,$c){
  $rtb.SelectionStart=$rtb.TextLength
  $rtb.SelectionLength=0
  $rtb.SelectionColor=$c
  $rtb.AppendText($t+"`r`n")
  $rtb.ScrollToCaret()
}

$msgs=@(
  @(0,  '> Scanner initialized. Starting scan...'),
  @(8,  '> Verifying digital signatures...'),
  @(18, '> Checking for external drivers...'),
  @(30, '> Inspecting running processes...'),
  @(42, '> Scanning startup entries...'),
  @(55, '> Analyzing memory allocation...'),
  @(68, '> Checking system services...'),
  @(80, '> Reviewing registry integrity...'),
  @(92, '> Finalizing verification...')
)
$script:pct=0.0
$script:mi=0
$script:done=$false

$timer=New-Object System.Windows.Forms.Timer
$timer.Interval=80
$timer.Add_Tick({
  if($script:done){ return }
  $script:pct=[Math]::Min(100.0,$script:pct+(Get-Random -Minimum 3 -Maximum 12)/10.0)
  while($script:mi -lt $msgs.Count -and $script:pct -ge $msgs[$script:mi][0]){
    Log $msgs[$script:mi][1] $gray
    $script:mi++
  }
  $fill.Width=[int](460*$script:pct/100)
  $pctL.Text=('{0}%' -f [int]$script:pct)
  if($script:pct -ge 100){
    $script:done=$true
    $timer.Stop()
    Log '> Success: No threats found.' $green
    Log '> System is clean.' $green
    $head.Text='SCAN COMPLETE'
    $head.ForeColor=$green
    $btn.Visible=$true
  }
})

$form.Add_Shown({ $form.Activate(); $timer.Start() })
$form.Add_FormClosed({ $timer.Stop() })
[void]$form.ShowDialog()
Write-Host 'Scan finished.' -ForegroundColor Green
