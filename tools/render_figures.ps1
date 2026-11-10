# ---------------------------------------------------------------------------
# Rendu des rasters du projet UR06 (Dunkerque) sans ArcGIS.
#
# Décode directement les GeoTIFF float32 (non compressés, tuilés) écrits par
# ArcMap, échantillonne les trois couches sur une grille commune de 25 m,
# reconstruit l'indice de synthèse puis exporte 4 PNG dans -outDir.
#
# Usage :
#   powershell -ExecutionPolicy Bypass -File tools/render_figures.ps1 `
#       -dir "projet/donnée" -outDir "figures"
#
# Prérequis : Windows PowerShell 5.1, .NET Framework (System.Drawing).
# Attention : l'ordre des rasters est déduit du tri alphabétique des noms
# (eau, végétation, bâti) — ne pas renommer les .tif.
# ---------------------------------------------------------------------------
param(
    [string]$dir,
    [string]$outDir,
    [int]$scale = 4
)
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

function Read-GeoTiff([string]$tif) {
    $b = [IO.File]::ReadAllBytes($tif)
    $ifd = [BitConverter]::ToUInt32($b, 4)
    $n = [BitConverter]::ToUInt16($b, $ifd)
    $tags = @{}
    for ($i = 0; $i -lt $n; $i++) {
        $p = $ifd + 2 + $i * 12
        $tags[[int][BitConverter]::ToUInt16($b, $p)] = @{
            type  = [BitConverter]::ToUInt16($b, $p + 2)
            count = [BitConverter]::ToUInt32($b, $p + 4)
            val   = [BitConverter]::ToUInt32($b, $p + 8)
        }
    }
    $w = [int]$tags[256].val; $h = [int]$tags[257].val
    $tw = [int]$tags[322].val; $th = [int]$tags[323].val
    $data = New-Object 'single[,]' $h, $w
    $tilesX = [int][Math]::Ceiling($w / $tw)
    $tilesY = [int][Math]::Ceiling($h / $th)
    for ($t = 0; $t -lt ($tilesX * $tilesY); $t++) {
        $off = [BitConverter]::ToUInt32($b, $tags[324].val + 4 * $t)
        $tx = ($t % $tilesX) * $tw
        $ty = [int][Math]::Floor($t / $tilesX) * $th
        for ($r = 0; $r -lt $th; $r++) {
            $y = $ty + $r
            if ($y -ge $h) { continue }
            for ($c = 0; $c -lt $tw; $c++) {
                $x = $tx + $c
                if ($x -ge $w) { continue }
                $data[$y, $x] = [BitConverter]::ToSingle($b, $off + 4 * ($r * $tw + $c))
            }
        }
    }
    $tfw = [IO.File]::ReadAllLines([IO.Path]::ChangeExtension($tif, ".tfw"))
    return @{
        dx = [double]$tfw[0]; x0 = [double]$tfw[4]
        dy = [double]$tfw[3]; y0 = [double]$tfw[5]
        w  = $w; h = $h; data = $data
    }
}

function Sample($gt, [double]$x, [double]$y) {
    $c = [int][Math]::Floor(($x - $gt.x0) / $gt.dx)
    $r = [int][Math]::Floor(($y - $gt.y0) / $gt.dy)
    if ($c -lt 0 -or $r -lt 0 -or $c -ge $gt.w -or $r -ge $gt.h) { return [single]::NaN }
    return $gt.data[$r, $c]
}

function Ramp($stops, [double]$t) {
    if ($t -lt 0) { $t = 0 }; if ($t -gt 1) { $t = 1 }
    $n = $stops.Count - 1
    $i = [int][Math]::Floor($t * $n)
    if ($i -ge $n) { $i = $n - 1 }
    $f = $t * $n - $i
    $a = $stops[$i]; $b = $stops[$i + 1]
    return [System.Drawing.Color]::FromArgb(
        [int]($a[0] + ($b[0] - $a[0]) * $f),
        [int]($a[1] + ($b[1] - $a[1]) * $f),
        [int]($a[2] + ($b[2] - $a[2]) * $f))
}

$rampHeat  = @(@(255, 244, 228), @(253, 210, 150), @(250, 150, 90), @(225, 70, 40), @(160, 20, 25), @(85, 0, 12))
$rampGreen = @(@(226, 240, 222), @(180, 218, 160), @(120, 190, 110), @(55, 150, 80), @(15, 105, 60), @(5, 55, 32))
$rampBlue  = @(@(226, 238, 248), @(170, 205, 235), @(110, 170, 215), @(55, 120, 190), @(20, 70, 145), @(8, 32, 78))
$rampSynth = @(@(255, 255, 229), @(255, 232, 150), @(253, 175, 88), @(240, 100, 55), @(190, 40, 40), @(110, 10, 25))
$bg = [System.Drawing.Color]::FromArgb(240, 238, 232)
$sea = [System.Drawing.Color]::FromArgb(225, 235, 242)

function Read-ShpPolygons([string]$shp) {
    $b = [IO.File]::ReadAllBytes($shp)
    $rings = New-Object System.Collections.ArrayList
    $pos = 100
    while ($pos -lt $b.Length - 4) {
        $len = [BitConverter]::ToInt32($b, $pos + 4) * 2
        $st = [BitConverter]::ToInt32($b, $pos + 8)
        if ($st -eq 5 -or $st -eq 15 -or $st -eq 25) {
            $numParts = [BitConverter]::ToInt32($b, $pos + 44)
            $numPoints = [BitConverter]::ToInt32($b, $pos + 48)
            $parts = @()
            for ($i = 0; $i -lt $numParts; $i++) { $parts += [BitConverter]::ToInt32($b, $pos + 52 + 4 * $i) }
            $ptsBase = $pos + 52 + 4 * $numParts
            for ($p = 0; $p -lt $numParts; $p++) {
                $s0 = $parts[$p]
                $s1 = if ($p -lt $numParts - 1) { $parts[$p + 1] } else { $numPoints }
                $ring = New-Object System.Collections.ArrayList
                for ($k = $s0; $k -lt $s1; $k++) {
                    $x = [BitConverter]::ToDouble($b, $ptsBase + 16 * $k)
                    $y = [BitConverter]::ToDouble($b, $ptsBase + 16 * $k + 8)
                    [void]$ring.Add([System.Drawing.PointF]::new([single]$x, [single]$y))
                }
                [void]$rings.Add($ring)
            }
        }
        $pos += 8 + $len
    }
    return $rings
}

function RenderGrid($vals, [int]$w, [int]$h, $ramp, [string]$path, $rings, [double]$x0, [double]$y0, [double]$dx, [double]$dy) {
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    for ($r = 0; $r -lt $h; $r++) {
        for ($c = 0; $c -lt $w; $c++) {
            $v = $vals[$r, $c]
            if ([single]::IsNaN([single]$v)) { $bmp.SetPixel([int]$c, [int]$r, [System.Drawing.Color]$bg); continue }
            $bmp.SetPixel([int]$c, [int]$r, [System.Drawing.Color](Ramp $ramp ([Math]::Pow([Math]::Max([double]$v, 0), 0.5))))
        }
    }
    $big = New-Object System.Drawing.Bitmap($bmp, [int]($w * $scale), [int]($h * $scale))
    $bmp.Dispose()
    $g = [System.Drawing.Graphics]::FromImage($big)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(60, 40, 30)), 2.0
    foreach ($ring in $rings) {
        $arr = @()
        foreach ($pt in $ring) {
            $px = [single](($pt.X - $x0) / $dx * $scale)
            $py = [single](($pt.Y - $y0) / $dy * $scale)
            $arr += [System.Drawing.PointF]::new($px, $py)
        }
        if ($arr.Count -gt 2) { $g.DrawPolygon($pen, $arr) }
    }
    $g.Dispose(); $pen.Dispose()
    $big.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $big.Dispose()
}

# ---------- main ----------
$tifs = Get-ChildItem $dir -Filter *.tif | Sort-Object Name
$rasters = @()
foreach ($t in $tifs) {
    $gt = Read-GeoTiff $t.FullName
    $rasters += @{ name = $t.Name; gt = $gt }
}
# ordre attendu : eau, vegetation, bati (tri alphabetique)
$eauGt = $rasters[0].gt; $vegeGt = $rasters[1].gt; $batiGt = $rasters[2].gt

# bbox des cellules valides (sur le bati)
$c0 = 1e9; $c1 = -1; $r0 = 1e9; $r1 = -1
for ($r = 0; $r -lt $batiGt.h; $r++) {
    for ($c = 0; $c -lt $batiGt.w; $c++) {
        $v = $batiGt.data[$r, $c]
        if ([single]::IsNaN($v) -or $v -lt -1e30) { continue }
        if ($c -lt $c0) { $c0 = $c }; if ($c -gt $c1) { $c1 = $c }
        if ($r -lt $r0) { $r0 = $r }; if ($r -gt $r1) { $r1 = $r }
    }
}
$xmin = $batiGt.x0 + $c0 * $batiGt.dx
$xmax = $batiGt.x0 + ($c1 + 1) * $batiGt.dx
$ymax = $batiGt.y0 + $r0 * $batiGt.dy
$ymin = $batiGt.y0 + ($r1 + 1) * $batiGt.dy
Write-Output ("bbox valid: {0},{1} -> {2},{3}" -f $xmin, $ymin, $xmax, $ymax)

$cell = 25.0
$w = [int][Math]::Round(($xmax - $xmin) / $cell)
$h = [int][Math]::Round(($ymax - $ymin) / $cell)
Write-Output ("grid {0}x{1}" -f $w, $h)

$shp = Get-ChildItem $dir -Filter "Dunkerque.shp" | Select-Object -First 1
$ringsAll = Read-ShpPolygons $shp.FullName

# masque commune par balayage de lignes
$inside = New-Object 'bool[,]' $h, $w
for ($r = 0; $r -lt $h; $r++) {
    $y = $ymax - ($r + 0.5) * $cell
    $xs = New-Object System.Collections.ArrayList
    foreach ($ring in $ringsAll) {
        $npts = $ring.Count
        for ($i = 0; $i -lt $npts; $i++) {
            $p1 = $ring[$i]; $p2 = $ring[($i + 1) % $npts]
            if (($p1.Y -le $y -and $p2.Y -gt $y) -or ($p2.Y -le $y -and $p1.Y -gt $y)) {
                $t = ($y - $p1.Y) / ($p2.Y - $p1.Y)
                [void]$xs.Add($p1.X + $t * ($p2.X - $p1.X))
            }
        }
    }
    if ($xs.Count -lt 2) { continue }
    $sorted = $xs | Sort-Object
    for ($k = 0; $k -lt $sorted.Count - 1; $k += 2) {
        $xa = $sorted[$k]; $xb = $sorted[$k + 1]
        $ca = [int][Math]::Ceiling(($xa - $xmin) / $cell - 0.5)
        $cb = [int][Math]::Floor(($xb - $xmin) / $cell - 0.5)
        if ($ca -lt 0) { $ca = 0 }; if ($cb -ge $w) { $cb = $w - 1 }
        for ($c = $ca; $c -le $cb; $c++) { $inside[$r, $c] = $true }
    }
}

$B = New-Object 'single[,]' $h, $w
$V = New-Object 'single[,]' $h, $w
$E = New-Object 'single[,]' $h, $w
$S = New-Object 'single[,]' $h, $w
$valid = 0
for ($r = 0; $r -lt $h; $r++) {
    for ($c = 0; $c -lt $w; $c++) {
        if (-not $inside[$r, $c]) { $B[$r, $c] = [single]::NaN; $V[$r, $c] = [single]::NaN; $E[$r, $c] = [single]::NaN; $S[$r, $c] = [single]::NaN; continue }
        $x = $xmin + ($c + 0.5) * $cell
        $y = $ymax - ($r + 0.5) * $cell
        $vb = Sample $batiGt $x $y; if ([single]::IsNaN($vb) -or $vb -lt -1e30) { $vb = 0 }
        $vv = Sample $vegeGt $x $y; if ([single]::IsNaN($vv) -or $vv -lt -1e30) { $vv = 0 }
        $ve = Sample $eauGt $x $y;  if ([single]::IsNaN($ve) -or $ve -lt -1e30) { $ve = 0 }
        $bn = [double]$vb / 0.0619146
        $vn = [double]$vv / 0.0190182
        $en = [double]$ve / 0.00113333
        $B[$r, $c] = [single]$bn
        $V[$r, $c] = [single]$vn
        $E[$r, $c] = [single]$en
        $S[$r, $c] = [single](0.50 * $bn + 0.33 * (1 - $vn) + 0.17 * (1 - $en))
        $valid++
    }
}
Write-Output ("valid cells: {0} / {1}" -f $valid, ($w * $h))
foreach ($pair in @(@("B", $B), @("V", $V), @("E", $E))) {
    $mn = 1e9; $mx = -1e9; $su = 0.0; $cn = 0
    $arr = $pair[1]
    $bins = New-Object 'int[]' 10
    for ($r = 0; $r -lt $h; $r++) { for ($c = 0; $c -lt $w; $c++) { $pix = $arr[$r, $c]; if ([single]::IsNaN([single]$pix)) { continue }; if ($pix -lt $mn) { $mn = $pix }; if ($pix -gt $mx) { $mx = $pix }; $su += $pix; $cn++; $k = [int][Math]::Floor($pix * 10); if ($k -gt 9) { $k = 9 }; $bins[$k]++ } }
    Write-Output ("{0}: min={1:F4} max={2:F4} mean={3:F4} n={4}" -f $pair[0], $mn, $mx, ($su / $cn), $cn)
    Write-Output ("   deciles: " + ($bins -join " "))
}

$shp = Get-ChildItem $dir -Filter "Dunkerque.shp" | Select-Object -First 1
$rings = Read-ShpPolygons $shp.FullName
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# etirement min-max du composite pour l'affichage et le classement
$smin = 1e9; $smax = -1e9
for ($r = 0; $r -lt $h; $r++) { for ($c = 0; $c -lt $w; $c++) { $pix = $S[$r, $c]; if ([single]::IsNaN([single]$pix)) { continue }; if ($pix -lt $smin) { $smin = $pix }; if ($pix -gt $smax) { $smax = $pix } } }
Write-Output ("S raw min={0} max={1}" -f $smin, $smax)
$Sd = New-Object 'single[,]' $h, $w
for ($r = 0; $r -lt $h; $r++) { for ($c = 0; $c -lt $w; $c++) { $pix = $S[$r, $c]; if ([single]::IsNaN([single]$pix)) { $Sd[$r, $c] = [single]::NaN } else { $Sd[$r, $c] = [single](($pix - $smin) / ($smax - $smin)) } } }

RenderGrid $B $w $h $rampHeat  (Join-Path $outDir "fig_1_impact_bati.png") $rings $xmin $ymax $cell (-$cell)
RenderGrid $V $w $h $rampGreen (Join-Path $outDir "fig_2_rafraichissement_vegetation.png") $rings $xmin $ymax $cell (-$cell)
RenderGrid $E $w $h $rampBlue  (Join-Path $outDir "fig_3_rafraichissement_eau.png") $rings $xmin $ymax $cell (-$cell)
RenderGrid $Sd $w $h $rampSynth (Join-Path $outDir "fig_4_indice_synthese.png") $rings $xmin $ymax $cell (-$cell)

# stats du composite reconstruit
$cls = @(0, 0, 0, 0, 0)
$sumS = 0.0
for ($r = 0; $r -lt $h; $r++) {
    for ($c = 0; $c -lt $w; $c++) {
        $pix = $Sd[$r, $c]
        if ([single]::IsNaN([single]$pix)) { continue }
        $sumS += $pix
        $k = [int][Math]::Floor($pix / 0.2)
        if ($k -gt 4) { $k = 4 }
        $cls[$k]++
    }
}
$areaCell = ($cell * $cell) / 10000.0
Write-Output ("mean S = {0}" -f ($sumS / $valid))
for ($i = 0; $i -lt 5; $i++) {
    Write-Output ("class {0}: {1} cells = {2:N0} ha ({3:P1})" -f ($i + 1), $cls[$i], ($cls[$i] * $areaCell), ($cls[$i] / $valid))
}
Write-Output "done"
