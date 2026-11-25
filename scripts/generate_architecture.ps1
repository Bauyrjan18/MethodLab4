Add-Type -AssemblyName System.Drawing

$width = 2400
$height = 1350
$bmp = New-Object System.Drawing.Bitmap $width, $height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 252, 255))
$g.FillRectangle($bgBrush, 0, 0, $width, $height)
$bgBrush.Dispose()

$fontTitle = New-Object System.Drawing.Font("Arial", 28, [System.Drawing.FontStyle]::Bold)
$fontSubtitle = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Regular)
$fontHeader = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$fontSubHeader = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Italic)
$fontBody = New-Object System.Drawing.Font("Arial", 13, [System.Drawing.FontStyle]::Regular)

$brushBlack = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 41, 59))
$brushMuted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 116, 139))
$brushRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(190, 18, 60))
$penContainer = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(79, 70, 229), 3)
$penContainer.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$penArrow = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 58, 138), 3)
$penArrow.CustomEndCap = New-Object System.Drawing.Drawing2D.AdjustableArrowCap(6, 6, $true)
$penProbe = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(225, 29, 72), 2)
$penProbe.DashStyle = [System.Drawing.Drawing2D.DashStyle]::DashDot
$penProbe.CustomEndCap = New-Object System.Drawing.Drawing2D.AdjustableArrowCap(5, 5, $true)

$g.DrawString("RAG Pipeline Architecture with Telemetry Instrumentation", $fontTitle, $brushBlack, 50, 40)
$g.DrawString("C4 Container Model with Telemetry Probes (M1 - M5) for Concurrency & Guardrail Tracking", $fontSubtitle, $brushMuted, 52, 90)

function Draw-RoundedRectangle($graphics, $pen, $brush, $x, $y, $w, $h, $radius) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $radius, $radius, 180, 90)
    $path.AddArc($x + $w - $radius, $y, $radius, $radius, 270, 90)
    $path.AddArc($x + $w - $radius, $y + $h - $radius, $radius, $radius, 0, 90)
    $path.AddArc($x, $y + $h - $radius, $radius, $radius, 90, 90)
    $path.CloseFigure()
    if ($brush -ne $null) { $graphics.FillPath($brush, $path) }
    if ($pen -ne $null) { $graphics.DrawPath($pen, $path) }
    $path.Dispose()
}

$userBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 246, 255))
$userPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(59, 130, 246), 2)
Draw-RoundedRectangle $g $userPen $userBrush 60 220 280 200 16
$g.DrawString("User / Client Application", $fontHeader, $brushBlack, 75, 240)
$g.DrawString("[External Actor]", $fontSubHeader, $brushMuted, 75, 275)
$g.DrawString("Generates concurrent query", $fontBody, $brushBlack, 75, 310)
$g.DrawString("workloads (C = 1 .. 100)", $fontBody, $brushBlack, 75, 335)
$g.DrawString("Receives streaming responses", $fontBody, $brushBlack, 75, 360)
$userBrush.Dispose()
$userPen.Dispose()

$ragBgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(248, 250, 252))
Draw-RoundedRectangle $g $penContainer $ragBgBrush 400 160 1940 760 20
$g.DrawString("Retrieval-Augmented Generation Subsystem Boundary", $fontHeader, $brushBlack, 430, 180)
$ragBgBrush.Dispose()

$svcWidth = 340
$svcHeight = 220
$ySvc = 280

$boxBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$boxPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(203, 213, 225), 2)

Draw-RoundedRectangle $g $boxPen $boxBrush 440 $ySvc $svcWidth $svcHeight 12
$g.DrawString("API Gateway", $fontHeader, $brushBlack, 455, $ySvc + 20)
$g.DrawString("FastAPI / Envoy Proxy", $fontSubHeader, $brushMuted, 455, $ySvc + 55)
$g.DrawString("- TLS Termination & Routing", $fontBody, $brushBlack, 455, $ySvc + 90)
$g.DrawString("- Concurrency Throttling", $fontBody, $brushBlack, 455, $ySvc + 115)
$g.DrawString("- Circuit Breaker Guard", $fontBody, $brushBlack, 455, $ySvc + 140)

Draw-RoundedRectangle $g $boxPen $boxBrush 820 $ySvc $svcWidth $svcHeight 12
$g.DrawString("Embedding Service", $fontHeader, $brushBlack, 835, $ySvc + 20)
$g.DrawString("ONNX Runtime / Bi-Encoder", $fontSubHeader, $brushMuted, 835, $ySvc + 55)
$g.DrawString("- Query text normalization", $fontBody, $brushBlack, 835, $ySvc + 90)
$g.DrawString("- Dense projection (d=768)", $fontBody, $brushBlack, 835, $ySvc + 115)
$g.DrawString("- Unit L2 hypersphere map", $fontBody, $brushBlack, 835, $ySvc + 140)

$vdbBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(254, 242, 242))
$vdbPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(239, 68, 68), 3)
Draw-RoundedRectangle $g $vdbPen $vdbBrush 1200 $ySvc 370 $svcHeight 12
$g.DrawString("Vector DB Engine", $fontHeader, $brushBlack, 1215, $ySvc + 20)
$g.DrawString("Evaluated Index Core", $fontSubHeader, $brushRed, 1215, $ySvc + 55)
$g.DrawString("- Baseline: Exact Flat (L2)", $fontBody, $brushBlack, 1215, $ySvc + 90)
$g.DrawString("- Proposed: HNSW-SQ8 Graph", $fontBody, $brushBlack, 1215, $ySvc + 115)
$g.DrawString("- Candidate queue: efSearch=64", $fontBody, $brushBlack, 1215, $ySvc + 140)
$g.DrawString("- Top-k retrieval: k=10", $fontBody, $brushBlack, 1215, $ySvc + 165)
$vdbBrush.Dispose()
$vdbPen.Dispose()

Draw-RoundedRectangle $g $boxPen $boxBrush 1610 $ySvc 330 $svcHeight 12
$g.DrawString("Neural Reranker", $fontHeader, $brushBlack, 1625, $ySvc + 20)
$g.DrawString("Cross-Encoder (MiniLM)", $fontSubHeader, $brushMuted, 1625, $ySvc + 55)
$g.DrawString("- Candidate pair scoring", $fontBody, $brushBlack, 1625, $ySvc + 90)
$g.DrawString("- Context relevance sort", $fontBody, $brushBlack, 1625, $ySvc + 115)
$g.DrawString("- Top-k context windowing", $fontBody, $brushBlack, 1625, $ySvc + 140)

Draw-RoundedRectangle $g $boxPen $boxBrush 1980 $ySvc 330 $svcHeight 12
$g.DrawString("LLM Engine", $fontHeader, $brushBlack, 1995, $ySvc + 20)
$g.DrawString("vLLM / TensorRT-LLM", $fontSubHeader, $brushMuted, 1995, $ySvc + 55)
$g.DrawString("- Context augmentation", $fontBody, $brushBlack, 1995, $ySvc + 90)
$g.DrawString("- Autoregressive decoding", $fontBody, $brushBlack, 1995, $ySvc + 115)
$g.DrawString("- SSE streaming generator", $fontBody, $brushBlack, 1995, $ySvc + 140)

$boxBrush.Dispose()
$boxPen.Dispose()

$g.DrawLine($penArrow, 340, 320, 440, 320)
$g.DrawLine($penArrow, 780, 390, 820, 390)
$g.DrawLine($penArrow, 1160, 390, 1200, 390)
$g.DrawLine($penArrow, 1570, 390, 1610, 390)
$g.DrawLine($penArrow, 1940, 390, 1980, 390)

$telemBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(241, 245, 249))
$telemPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 116, 139), 2)
Draw-RoundedRectangle $g $telemPen $telemBrush 440 980 1870 300 16
$g.DrawString("Telemetry Collector & Guardrail Aggregator (OpenTelemetry / Prometheus)", $fontHeader, $brushBlack, 470, 1005)
$g.DrawString("Sub-millisecond resolution metric aggregation, non-parametric bootstrap estimation, and SLA monitoring", $fontSubHeader, $brushMuted, 472, 1040)
$telemBrush.Dispose()
$telemPen.Dispose()

function Draw-ProbeCard($graphics, $id, $name, $desc, $unit, $x, $y) {
    $cBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $cPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(244, 63, 94), 2)
    Draw-RoundedRectangle $graphics $cPen $cBrush $x $y 340 180 10
    
    $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(225, 29, 72))
    $badgeFont = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $graphics.FillRectangle($badgeBrush, $x + 12, $y + 12, 110, 26)
    $wBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $graphics.DrawString($id, $badgeFont, $wBrush, $x + 18, $y + 16)
    
    $tFont = New-Object System.Drawing.Font("Arial", 13, [System.Drawing.FontStyle]::Bold)
    $bBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 23, 42))
    $graphics.DrawString($name, $tFont, $bBrush, $x + 130, $y + 16)
    
    $dFont = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Regular)
    $mBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(71, 85, 105))
    $graphics.DrawString($desc, $dFont, $mBrush, $x + 14, $y + 52)
    
    $uFont = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Italic)
    $graphics.DrawString("Metric: " + $unit, $uFont, $bBrush, $x + 14, $y + 140)
    
    $badgeBrush.Dispose()
    $badgeFont.Dispose()
    $wBrush.Dispose()
    $tFont.Dispose()
    $bBrush.Dispose()
    $dFont.Dispose()
    $mBrush.Dispose()
    $uFont.Dispose()
    $cBrush.Dispose()
    $cPen.Dispose()
}

Draw-ProbeCard $g "PROBE M1" "API Gateway" "End-to-End Latency (ms),`nHTTP status, error rate E_rate,`nand SLA breach (>200 ms)" "tau_E2E (ms), E_rate (%)" 470 1080
Draw-ProbeCard $g "PROBE M2" "Embedding" "Dense inference duration,`nencoder batch queue depth,`nand GPU memory occupancy" "tau_embed (ms)" 850 1080
Draw-ProbeCard $g "PROBE M3" "Vector DB" "Core index search latency,`ntop-k candidate distance,`nand retrieval Recall@10" "tau_search (ms), Recall@10" 1220 1080
Draw-ProbeCard $g "PROBE M4" "Reranker" "Cross-encoder scoring time,`nsequence length overhead,`nand candidate rerank delay" "tau_rerank (ms)" 1600 1080
Draw-ProbeCard $g "PROBE M5" "LLM Engine" "Time-to-First-Token (TTFT),`nautoregressive decode rate,`nand token generation speed" "TTFT (ms), Tokens/sec" 1955 1080

$g.DrawLine($penProbe, 610, 500, 610, 980)
$g.DrawLine($penProbe, 990, 500, 990, 980)
$g.DrawLine($penProbe, 1385, 500, 1385, 980)
$g.DrawLine($penProbe, 1775, 500, 1775, 980)
$g.DrawLine($penProbe, 2145, 500, 2145, 980)

$fontTitle.Dispose()
$fontSubtitle.Dispose()
$fontHeader.Dispose()
$fontSubHeader.Dispose()
$fontBody.Dispose()
$brushBlack.Dispose()
$brushMuted.Dispose()
$brushRed.Dispose()
$penContainer.Dispose()
$penArrow.Dispose()
$penProbe.Dispose()
$g.Dispose()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$destDir = Join-Path (Split-Path -Parent $scriptDir) "figures"
if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
$destPath = Join-Path $destDir "fig3_c4_architecture.png"
$bmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
