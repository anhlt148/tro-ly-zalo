# Trợ lý Zalo

Trợ lý trả lời thay bạn trên **Zalo PC** — chạy trên máy bạn, điều khiển qua cổng gỡ lỗi của Zalo (không mất đăng nhập, không thư viện ngoài), do **Claude Code** trên máy bạn soạn lời. Mặc định chỉ **soạn nháp** vào một nhóm Zalo riêng của bạn; bạn chỉ định nick nào nó mới gửi thẳng.

## Cách dễ nhất — để Claude Code cài hộ
Mở Claude Code trên máy bạn, dán câu này:
> Đọc kỹ https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/CAI-BANG-CLAUDE.md rồi làm đúng từng bước để cài Trợ lý Zalo cho tôi.

Claude sẽ kiểm máy, tải bản mới nhất, bật Zalo, hỏi bạn vài câu, chạy bộ kiểm và bật bot. Về sau muốn gì (thêm nhãn, dạy giọng, nối kho) cũng chỉ cần nói với Claude.

## Cài — một dòng (không qua Claude)
**macOS** (Terminal):
```bash
curl -fsSL https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.sh | bash
```
**Windows** (PowerShell):
```powershell
irm https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.ps1 | iex
```
Cần sẵn: Zalo PC đã đăng nhập · Node.js LTS (nodejs.org) · Claude Code đã đăng nhập (`npm install -g @anthropic-ai/claude-code`, rồi gõ `claude`).

Lệnh trên tải **bản mới nhất**, đặt vào `~/tro-ly-zalo`, hỏi bạn vài câu (tên, bạn làm gì, nhãn nào là khách/bạn bè/cấm, nhóm buồng lái) rồi chạy bộ kiểm. Chạy lại đúng lệnh đó là **nâng cấp** — hồ sơ của bạn được mang sang.

Bản cụ thể: `TRO_LY_ZALO_VER=v1.0.0 bash -c "$(curl -fsSL https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/cai-tu-xa.sh)"` — danh sách ở [Releases](https://github.com/anhlt148/tro-ly-zalo/releases). Chỉ phiên bản tác giả đã công khai mới tải được; nhánh này chỉ chứa file cài, mã nguồn nằm trong zip của từng phiên bản.

## Chạy
```bash
cd ~/tro-ly-zalo && ./chay.sh        # macOS
```
```powershell
cd $HOME\tro-ly-zalo; .\chay.cmd     # Windows
```

## Đọc thêm
- [HUONG-DAN.md](HUONG-DAN.md) — cho người dùng: nó làm gì, không bao giờ làm gì, dùng hằng ngày, dạy nó.
- [SKILL.md](SKILL.md) — cho Claude trên máy bạn: kiến trúc, luật bất biến, điểm cắm để phát triển tiếp, quy trình sửa, phiên bản.
- [CHANGELOG.md](CHANGELOG.md) — mỗi phiên bản có gì.
- `thiet-ke/` — bản đồ kiến trúc, 40+ bẫy đã trả giá, 12 điều cấm.

Một mã nguồn cho cả hai hệ: mọi thứ là Node thuần; chỗ duy nhất biết hệ điều hành là `bat-zalo.mjs` (tìm và bật Zalo) và `goc.mjs` (gọi Claude Code). Windows: đã viết, đang chờ kiểm trên máy thật — xem CHANGELOG.
