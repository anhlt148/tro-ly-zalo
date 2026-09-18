# ══════════════════════════════════════════════════════════════════════
# CÀI TỪ XA — Windows, một dòng trong PowerShell:
#   irm https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.ps1 | iex
# Bản cụ thể:  $env:TRO_LY_ZALO_VER="v1.1.0"; irm https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.ps1 | iex
# Làm gì: tải zip phiên bản → giải nén vào %USERPROFILE%\tro-ly-zalo (bản cũ đổi tên giữ lại, ho-so\ mang sang) → node cai.mjs
# ══════════════════════════════════════════════════════════════════════
$ErrorActionPreference = "Stop"
$Repo = "anhlt148/tro-ly-zalo"
$Dich = if ($env:TRO_LY_ZALO_DIR) { $env:TRO_LY_ZALO_DIR } else { Join-Path $HOME "tro-ly-zalo" }
$Ver = $env:TRO_LY_ZALO_VER
# mặc định: bản MỚI NHẤT có hỗ trợ Windows (kể cả bản thử nghiệm) — bản chỉ-Mac (v1.0.x) không có cai.mjs
if (-not $Ver) {
  $ds = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases"
  $Ver = ($ds | Where-Object { $_.tag_name -notlike "v1.0.*" } | Select-Object -First 1).tag_name
}
if (-not $Ver) { Write-Host "⛔ không đọc được phiên bản mới nhất"; exit 1 }
$Url = "https://github.com/$Repo/releases/download/$Ver/tro-ly-zalo-$Ver.zip"
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("tro-ly-zalo-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $Tmp | Out-Null
Write-Host "⬇  Tải $Ver …"
Invoke-WebRequest -Uri $Url -OutFile (Join-Path $Tmp "goi.zip")
Expand-Archive -Path (Join-Path $Tmp "goi.zip") -DestinationPath $Tmp -Force
$Moi = Join-Path $Tmp "tro-ly-zalo"
if (-not (Test-Path (Join-Path $Moi "cai.mjs"))) { Write-Host "⛔ gói không đúng cấu trúc"; exit 1 }
if (Test-Path $Dich) {
  $Cu = "$Dich.truoc-" + (Get-Date -Format "yyyyMMdd-HHmmss")
  Move-Item $Dich $Cu; Write-Host "   bản cũ giữ ở $Cu"
  Move-Item $Moi $Dich
  if (Test-Path (Join-Path $Cu "ho-so")) { Copy-Item (Join-Path $Cu "ho-so") (Join-Path $Dich "ho-so") -Recurse; Write-Host "   ✓ mang hồ sơ (ho-so\) sang bản mới" }
} else { Move-Item $Moi $Dich }
Remove-Item $Tmp -Recurse -Force
Write-Host "✅ đã đặt $Ver vào $Dich"
if ($env:TRO_LY_ZALO_KHONG_CAI -eq "1") { Write-Host "   (bỏ qua bước cài theo yêu cầu)"; exit 0 }
Set-Location $Dich
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Write-Host "⛔ chưa có Node.js — cài bản LTS từ https://nodejs.org rồi chạy: cd $Dich; node cai.mjs"; exit 1 }
Write-Host "`n▶ Chạy node cai.mjs (cần trả lời vài câu ở lần đầu)"
node cai.mjs
