<#
.SYNOPSIS
  使用 _tmap.json / _sppmgr_bylines.json 将新版英文 MAS_AIO.cmd 汉化
.DESCRIPTION
  1) 子串替换 _tmap.json 自动翻译 2) 对 :sppmgr: 块应用 _sppmgr_bylines.json
  3) 自动补编码(GBK/chcp 936/GetEncoding) 4) 主菜单加署名 5) 报告剩余英文行
.PARAMETER NewEnFile
  新版英文 MAS_AIO.cmd 的路径
.PARAMETER OutFile
  输出文件路径（默认: 输入同目录 MAS_AIO_<版本>_zh.cmd）
.PARAMETER Download
  从官方仓库自动下载最新英文版（无需 -NewEnFile）
.EXAMPLE
  .\update_translator.ps1 -NewEnFile C:\temp\MAS_AIO.cmd
  .\update_translator.ps1 -Download -OutFile D:\out\MAS_AIO.cmd
#>
param(
  [string]$NewEnFile = '',
  [string]$OutFile = '',
  [switch]$Download
)
$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ---- 1. 获取新版英文脚本 ----
$tmp = ''
if ($Download) {
  $url = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd'
  Write-Host '正在从官方仓库下载最新 MAS_AIO.cmd ...' -ForegroundColor Cyan
  $tmp = Join-Path $env:TEMP ('MAS_AIO_latest_' + [guid]::NewGuid().ToString('N') + '.cmd')
  Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
  $NewEnFile = $tmp
}
if (-not $NewEnFile) { throw '请指定 -NewEnFile 或使用 -Download' }
if (-not (Test-Path -LiteralPath $NewEnFile)) { throw ('NewEnFile 不存在: ' + $NewEnFile) }

# ---- 2. 读取（自动识别编码）并统一为行数组 ----
$cr = [char]13; $lf = [char]10
$crlf = $cr.ToString() + $lf.ToString()
$lfStr = $lf.ToString()
$raw = [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $NewEnFile))
$enc = $null
try {
  $u8 = New-Object System.Text.UTF8Encoding($false, $true)
  [void]$u8.GetString($raw)
  $enc = $u8
} catch {
  $enc = [System.Text.Encoding]::GetEncoding(936)
}
$text = $enc.GetString($raw)
$text = $text -replace $crlf, $lfStr
if (-not $text.EndsWith($lfStr)) { $text += $lfStr }
$lines = [System.Collections.Generic.List[string]]::new()
foreach ($l in ($text -split $lfStr)) { $lines.Add([string]$l) }

# ---- 3. 整行/片段翻译映射（子串替换，长键优先） ----
$tmap = New-Object 'System.Collections.Generic.Dictionary[string,string]'
$tmapArr = Get-Content -LiteralPath (Join-Path $dir '_tmap.json') -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($pair in $tmapArr) {
  $k = [string]$pair[0]
  if (-not $tmap.ContainsKey($k)) { $tmap[$k] = [string]$pair[1] }
}
$tmapKeys = @($tmap.Keys | Sort-Object { $_.Length } -Descending)
$tmapApplied = 0
foreach ($k in $tmapKeys) {
  if ($k.Length -eq 0) { continue }
  $v = [string]$tmap[$k]
  if ($k -ceq $v) { continue }
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*(rem\b|::)') { continue }
    if ($lines[$i].Contains($k)) {
      $lines[$i] = $lines[$i].Replace($k, $v)
      $tmapApplied++
    }
  }
}

# ---- 4. :sppmgr: 块内行级翻译（子串替换） ----
$byApplied = 0
$byArr = Get-Content -LiteralPath (Join-Path $dir '_sppmgr_bylines.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$bymap = New-Object 'System.Collections.Generic.Dictionary[string,string]'
foreach ($pair in $byArr) {
  $k = [string]$pair[0]
  if (-not $bymap.ContainsKey($k)) { $bymap[$k] = [string]$pair[1] }
}
$start = -1; $end = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match '^:sppmgr:' -or $lines[$i] -eq ':sppmgr:') {
    if ($start -lt 0) { $start = $i } elseif ($end -lt 0) { $end = $i; break }
  }
}
if ($start -ge 0 -and $end -gt $start) {
  $byKeys = @($bymap.Keys | Sort-Object { $_.Length } -Descending)
  foreach ($k in $byKeys) {
    if ($k.Length -eq 0) { continue }
    $v = [string]$bymap[$k]
    if ($k -ceq $v) { continue }
    for ($i = $start + 1; $i -lt $end; $i++) {
      if ($lines[$i] -match '^\s*(rem\b|::)') { continue }
      if ($lines[$i].Contains($k)) {
        $lines[$i] = $lines[$i].Replace($k, $v)
        $byApplied++
      }
    }
  }
}

# ---- 5. 编码处理 ----
$chcpTop = 0; $chcpTask = 0; $readPatch = 0; $writePatch = 0
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match '^@echo off') {
    if (-not (($i + 1) -lt $lines.Count -and $lines[$i + 1] -match '^chcp 936')) {
      $lines.Insert($i + 1, 'chcp 936 >nul'); $chcpTop = 1
    }
    break
  }
}
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match '^:_extracttask:') {
    $j = $i + 1
    while ($j -lt $lines.Count -and $lines[$j] -notmatch '^@echo off') { $j++ }
    if ($j -lt $lines.Count) {
      if (-not (($j + 1) -lt $lines.Count -and $lines[$j + 1] -match '^chcp 936')) {
        $lines.Insert($j + 1, 'chcp 936 >nul'); $chcpTask = 1
      }
    }
    break
  }
}
$pat = "ReadAllText('!_batp!')"
$rep = "ReadAllText('!_batp!',[System.Text.Encoding]::GetEncoding(936))"
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i].Contains($pat)) {
    $lines[$i] = $lines[$i].Replace($pat, $rep); $readPatch++
  }
}
for ($i = 0; $i -lt $lines.Count; $i++) {
  $l = [string]$lines[$i]
  if (($l.Contains('$OEM$') -or $l.Contains('Activation_task.cmd')) -and $l.Contains('[System.Text.Encoding]::ASCII')) {
    $lines[$i] = $l.Replace('[System.Text.Encoding]::ASCII', '[System.Text.Encoding]::GetEncoding(936)'); $writePatch++
  }
}

# ---- 6. 主菜单署名 ----
$attr = 'call :dk_color %Gray% "         由痛哥codex翻译"'
if (-not ($lines -ccontains $attr)) {
  $promptEn = 'call :dk_color2 %_White% "         " %_Green% "Choose a menu option using your keyboard [1,2,3...E,H,0] :"'
  $promptCn = 'call :dk_color2 %_White% "         " %_Green% "请使用键盘选择菜单选项 [1,2,3...E,H,0] :"'
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -ceq $promptEn -or $lines[$i] -ceq $promptCn) { $lines.Insert($i, $attr); break }
  }
}

# ---- 7. 输出 ----
if (-not $OutFile) {
  $ver = ''
  foreach ($l in $lines) { if ($l -match '^@set masver=(.+)$') { $ver = $Matches[1].Trim(); break } }
  if ($Download) { $OutFile = Join-Path $dir ('MAS_AIO_' + $ver + '_zh.cmd') }
  else { $OutFile = Join-Path (Split-Path -Parent $NewEnFile) ('MAS_AIO_' + $ver + '_zh.cmd') }
}
$gbk = [System.Text.Encoding]::GetEncoding(936)
$outText = ($lines -join $crlf)
[System.IO.File]::WriteAllText($OutFile, $outText, $gbk)
if ($tmp) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }

# ---- 8. 报告与自查 ----
Write-Host ''
Write-Host ('输出文件: ' + $OutFile) -ForegroundColor Green
Write-Host ('整行翻译 ' + $tmapApplied + ' 条 | sppmgr 块 ' + $byApplied + ' 条 | chcp顶部 ' + $chcpTop + ' | chcp任务块 ' + $chcpTask + ' | ReadAllText补编码 ' + $readPatch + ' 处 | WriteAllText转936 ' + $writePatch + ' 处')
$outRaw = [System.IO.File]::ReadAllBytes($OutFile)
$lfOnly = 0
for ($k = 0; $k -lt $outRaw.Length - 1; $k++) { if ($outRaw[$k] -eq 10 -and $outRaw[$k - 1] -ne 13) { $lfOnly++ } }
$outText2 = $gbk.GetString($outRaw)
$chcpCount = ([regex]::Matches($outText2, 'chcp 936 >nul')).Count
$attrCount = ([regex]::Matches($outText2, [regex]::Escape($attr))).Count
Write-Host ('自查: chcp936=' + $chcpCount + ' 署名=' + $attrCount + ' 孤立LF=' + $lfOnly)
$leftover = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
  $l = [string]$lines[$i]
  $isDisplay = ($l -match '^echo:?\s+[A-Za-z]') -or ($l -match '^call\s+:dk_color\w*\s+%\w+%\s+"[A-Za-z]')
  if (-not $isDisplay) { continue }
  if ($l -match '[\u4e00-\u9fff]') { continue }
  if ($l -match '^echo\s+(https?://|dism|sfc|rundll32|fltmc|cd\s|call\s|set\s|@|title\s+Microsoft_)') { continue }
  if ($l -match '^echo\s+[A-Za-z]:\\') { continue }
  if ($l -match '^echo:?\s+[!"%]') { continue }
  $leftover += ('{0,5}: {1}' -f ($i + 1), $l)
}
Write-Host ('剩余英文显示行(需人工处理): ' + $leftover.Count)
$leftover | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
