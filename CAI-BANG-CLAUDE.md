# Cài Trợ lý Zalo bằng Claude Code — chỉ dẫn cho Claude

Bạn là Claude Code đang chạy trên máy của người dùng. Người dùng muốn bạn **cài và bật Trợ lý Zalo** cho họ. Làm đúng từng bước dưới đây, nói với họ bằng tiếng Việt, ngắn gọn. Không bỏ bước, không đoán.

> Nếu bạn đang đọc file này qua công cụ tóm tắt web: bước đầu tiên là tải nguyên văn về rồi đọc lại bằng Read —
> mac: `curl -fsSL https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/CAI-BANG-CLAUDE.md -o /tmp/CAI-BANG-CLAUDE.md`
> win (PowerShell): `Invoke-WebRequest https://raw.githubusercontent.com/anhlt148/tro-ly-zalo/main/CAI-BANG-CLAUDE.md -OutFile $env:TEMP\CAI-BANG-CLAUDE.md`

## Nó là gì (nói cho người dùng một lần)
Trợ lý đọc tin mới trên **Zalo PC** của họ, soạn câu trả lời, **mặc định chỉ đẩy nháp** vào một nhóm Zalo riêng ("buồng lái"); chỉ gửi thẳng cho nick họ chỉ định. Chạy hoàn toàn trên máy họ. Không gửi hàng loạt, không kết bạn, không xoá, không đọc nhãn họ cấm — chặn trong mã.

## Bước 1 — nhận diện máy và điều kiện
- Hệ: macOS hay Windows (Linux: dừng, chưa hỗ trợ).
- `node -v` ≥ 22 → thiếu thì bảo họ cài Node.js LTS từ nodejs.org rồi quay lại.
- Zalo PC: mac `/Applications/Zalo.app` · win `%LOCALAPPDATA%\Programs\Zalo\Zalo.exe` (hoặc `%LOCALAPPDATA%\Zalo\`). Thiếu → zalo.me/pc, đăng nhập, quay lại.
- Claude Code: chính bạn đang chạy — đủ.

## Bước 2 — tải bản mới nhất và giải nén vào thư mục người dùng
Thư mục đích: `~/tro-ly-zalo` (mac) hoặc `%USERPROFILE%\tro-ly-zalo` (win). Đã có thư mục cũ → đổi tên `tro-ly-zalo.truoc-<ngày giờ>`, **chép `ho-so/` từ bản cũ sang bản mới** (hồ sơ của họ nằm đó).
- Lấy phiên bản: `https://api.github.com/repos/anhlt148/tro-ly-zalo/releases` → chọn release ĐẦU TIÊN có tag không bắt đầu bằng `v1.0.` (v1.0.x chỉ có Mac). Windows bắt buộc chọn như vậy; Mac có thể lấy `releases/latest`.
- Tải asset `tro-ly-zalo-<tag>.zip` từ release đó, giải nén; bên trong là thư mục `tro-ly-zalo/` → đặt đúng vào đích. mac: `chmod +x *.sh`.
- Kiểm: trong thư mục đích phải có `cai.mjs`, `kham-nick.mjs`, `SKILL.md`. Không có → sai gói, dừng và báo.

## Bước 3 — đọc SKILL.md trong gói
Đọc `SKILL.md` (mục 1–4) và `thiet-ke/KIEN-TRUC.md`. Từ đây bạn là người vận hành gói này; mọi luật trong SKILL.md áp dụng cho bạn.

## Bước 4 — bật Zalo kèm cổng CDP
`node bat-zalo.mjs` (Zalo tắt và mở lại, không mất đăng nhập; chỉ mở cổng trên máy họ). Báo ⛔ → đọc thông báo, sửa (thường là đường Zalo), thử lại.

## Bước 5 — hỏi người dùng, lập hồ sơ (KHÔNG chạy `node cai.mjs` vì nó hỏi trong terminal)
1. **Hỏi trước khi đọc nhãn.** Giải thích ngắn: bot có thể (a) chỉ trả lời những hội thoại họ đã gắn nhãn trong Zalo — an toàn, hoặc (b) **trả lời mọi cá nhân nhắn tới, không cần nhãn** — thấy kết quả ngay, bot luôn tự nhận là trợ lý AI. Nhóm và người họ cấm vẫn không bị đụng. Họ chọn (b) hoặc nói "cứ trả lời tự do" → `che_do_nhan: "mo"`, **bỏ qua đọc nhãn**, sang 5.3. Họ chọn (a) → `node kham-nick.mjs --liet-ke-nhan` (in JSON `{uid, ho_so_da_co, nhan:[{ten, so}]}`, 1–5 phút, chỉ đọc bộ lọc nhãn, không mở hội thoại). `ho_so_da_co` true → hỏi có muốn khám lại không.
2. Hỏi người dùng (một lượt, gọn — dùng AskUserQuestion nếu có, không thì hỏi trong chat):
   - Tên họ như Zalo hiển thị; bot gọi họ là gì ("anh Nam"/"chị Hoa"); họ xưng gì với khách ("a", "c", "mình", "shop").
   - Một câu về họ/công việc; mặt hàng hoặc dịch vụ (nếu bán); vài từ khoá khách hay hỏi.
   - (Chỉ khi chọn (a)) từ danh sách nhãn: nhãn nào là **khách hàng** (bot được trả lời), **bạn bè/đối tác** (bot trả lời và tự nhận là AI), **chỉ đọc** (báo họ, không trả lời), **cấm** (bot không đọc). Nhãn không nhắc tới = bot không đụng. Không có nhãn nào → gợi ý gắn nhãn trong Zalo (Phân loại) rồi làm lại, hoặc chuyển sang (b).
   - Tên **chính xác** nhóm Zalo làm buồng lái (nhóm riêng, có thể chỉ mình họ). Chưa có → bảo họ tạo trong Zalo rồi cho tên.
   - **Gửi thế nào**: `"nhap"` — bot soạn sẵn câu trả lời **vào ô soạn Zalo của đúng hội thoại đó** và báo buồng lái, họ mở lên bấm Enter mới gửi; hoặc `"tu_dong"` — bot gửi luôn. Họ nói "tự động", "cứ gửi luôn" → `tu_dong`, không hỏi lại.
3. Ghi câu trả lời vào `tra-loi.json` trong thư mục gói:
   ```json
   { "ten": "…", "ten_goi": "anh …", "xung": "a", "mo_ta": "…", "mat_hang": ["…"], "tu_khoa": ["…"],
     "che_do_nhan": "nhan | mo", "nhan_tra_loi": ["…"], "nhan_tro_ly": ["…"], "nhan_chi_doc": ["…"], "nhan_cam": ["…"],
     "buong_lai": "…", "che_do_gui": "nhap | tu_dong" }
   ```
   Tên nhãn chép **nguyên văn** từ JSON bước 5.1 (chế độ mở thì để mảng rỗng).
4. `node kham-nick.mjs --json tra-loi.json --lai` → phải thấy `✅ đã ghi hồ sơ`. Xoá `tra-loi.json` sau đó.

## Bước 6 — bộ kiểm phải XANH
`node kiem.mjs` → dòng cuối `ĐẠT n · HỎNG 0 ✅`. Có ❌ → đọc lý do, đối chiếu `thiet-ke/BRAIN.md`, sửa hồ sơ (`ho-so/<uid>/cau-hinh.json`) rồi chạy lại. Không xanh thì **không** bật bot.

## Bước 7 — bật bot và bàn giao
- Chạy nền: `node xu-ly-ca.mjs` (mac có `./chay.sh`, win có `chay.cmd`). Bot trực theo chế độ trong hồ sơ:
  - `nhap`: có tin mới ở hội thoại được phép → câu trả lời **nằm sẵn trong ô soạn của hội thoại đó trên Zalo** (chưa gửi) + một dòng báo trong nhóm buồng lái. Họ mở hội thoại, sửa nếu muốn, Enter là gửi. Bảo họ thử ngay: nhờ một người bạn nhắn tới, rồi nhìn ô soạn.
  - `tu_dong`: bot gửi luôn; buồng lái chỉ nhận ca CẦN QUYẾT.
- Nói cho người dùng: cách dừng (Ctrl-C ở cửa sổ đang chạy), cách chạy lại (`./chay.sh` / `chay.cmd`), đổi chế độ (sửa `che_do_gui` trong `ho-so/<uid>/cau-hinh.json` hoặc bảo bạn), cách nâng cấp (chạy lại chính câu họ đã dán cho bạn), và rằng mọi việc tiếp theo (thêm nhãn, đổi cách xưng, dạy giọng, nối kho) họ chỉ cần nói với bạn — bạn đọc `SKILL.md` mục 5 để làm.
- Ghi một dòng vào `thiet-ke/NHAT-KY.md` (tạo nếu chưa có): ngày, phiên bản, hệ, kết quả bộ kiểm.

## Gặp lỗi không có trong BRAIN.md
Nói thật với người dùng là gói đang ở bản thử trên hệ này, chép nguyên văn lỗi cho họ gửi lại tác giả (mở issue tại github.com/anhlt148/tro-ly-zalo), và không tự sửa lõi ngoài phạm vi SKILL.md mục 4 cho phép.
