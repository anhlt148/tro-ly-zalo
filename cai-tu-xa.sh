#!/bin/bash
# ══════════════════════════════════════════════════════════════════════
# CÀI TỪ XA — một dòng cho người nhận (macOS):
#   curl -fsSL https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.sh | bash
# Bản cụ thể:  TRO_LY_ZALO_VER=v1.0.0 bash -c "$(curl -fsSL https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.sh)"
# Làm gì: tải zip phiên bản (mới nhất nếu không chỉ định) → giải nén vào ~/tro-ly-zalo (bản cũ đổi tên giữ lại,
# hồ sơ ho-so/ được mang sang) → chạy ./cai.sh (hỏi vài câu ở lần đầu; nâng cấp thì chỉ chạy bộ kiểm).
# ══════════════════════════════════════════════════════════════════════
set -euo pipefail
REPO="anhlt148/tro-ly-zalo"
DICH="${TRO_LY_ZALO_DIR:-$HOME/tro-ly-zalo}"
VER="${TRO_LY_ZALO_VER:-}"

[[ "$(uname)" == "Darwin" ]] || { echo "⛔ Bản này chỉ hỗ trợ macOS (Windows chưa kiểm)."; exit 1; }
command -v curl >/dev/null || { echo "⛔ thiếu curl"; exit 1; }

if [[ -z "$VER" ]]; then
  VER=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
  [[ -n "$VER" ]] || { echo "⛔ không đọc được phiên bản mới nhất từ GitHub"; exit 1; }
fi
URL="https://github.com/$REPO/releases/download/$VER/tro-ly-zalo-$VER.zip"
TMP=$(mktemp -d)
echo "⬇  Tải $VER …"
curl -fsSL -o "$TMP/goi.zip" "$URL" || { echo "⛔ không tải được $URL — phiên bản có tồn tại không? Xem https://github.com/$REPO/releases"; exit 1; }
unzip -q "$TMP/goi.zip" -d "$TMP"
[[ -f "$TMP/tro-ly-zalo/cai.sh" ]] || { echo "⛔ gói không đúng cấu trúc"; exit 1; }

if [[ -d "$DICH" ]]; then
  CU="$DICH.truoc-$(date +%Y%m%d-%H%M%S)"
  mv "$DICH" "$CU"; echo "   bản cũ giữ ở $CU"
  mv "$TMP/tro-ly-zalo" "$DICH"
  [[ -d "$CU/ho-so" ]] && { cp -R "$CU/ho-so" "$DICH/ho-so"; echo "   ✓ mang hồ sơ (ho-so/) sang bản mới"; }
else
  mv "$TMP/tro-ly-zalo" "$DICH"
fi
rm -rf "$TMP"
chmod +x "$DICH"/*.sh
echo "✅ đã đặt $VER vào $DICH"

if [[ "${TRO_LY_ZALO_KHONG_CAI:-}" == "1" ]]; then echo "   (bỏ qua bước cài theo yêu cầu)"; exit 0; fi
cd "$DICH"
if [[ -r /dev/tty ]]; then
  echo; echo "▶ Chạy ./cai.sh (cần trả lời vài câu ở lần đầu)"; ./cai.sh < /dev/tty
else
  echo "▶ Mở Terminal và chạy:  cd \"$DICH\" && ./cai.sh"
fi
