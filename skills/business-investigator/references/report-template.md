# BUSINESS INVESTIGATION — REPORT TEMPLATE

Version: 1.0
Language: Vietnamese
Format: Markdown + Mermaid

## 1. Hướng dẫn sử dụng template

Template này quy định cấu trúc báo cáo do Business Investigator
Skill tạo ra sau khi hoàn thành investigation workflow.

Đọc và tuân thủ:

- output-requirements.md
- investigation-workflow.md

Các giá trị {{...}} là placeholder, phải được thay thế bằng
thông tin thực tế thu thập được.

Không giữ placeholder trong báo cáo cuối cùng.

### Quy tắc sinh báo cáo

1. Ưu tiên giải thích nghiệp vụ dễ hiểu trước, kỹ thuật sau.
2. Không tạo thông tin giả để điền đủ template.
3. Mỗi kết luận quan trọng phải có evidence.
4. Phân biệt VERIFIED / INFERRED / UNKNOWN.
5. Chỉ giữ những bảng, cột và procedure liên quan.
6. Ghi rõ những phần chưa điều tra hoặc chưa xác minh.
7. Không đưa credential hoặc dữ liệu nhạy cảm vào báo cáo.

### Cấu trúc output

docs/business-investigations/{{feature-name}}/
├── README.md
├── database.md
├── technical-flow.md
└── open-questions.md

README.md luôn là tài liệu chính.

Nếu nghiệp vụ nhỏ, có thể gộp các phần vào README.md.
Khi gộp, phải giữ đầy đủ các nội dung bắt buộc.

Chỉ tạo liên kết tới những file thực sự tồn tại.

---

# TEMPLATE 1 — README.md

# {{Tên nghiệp vụ}}

> {{Một câu mô tả ngắn gọn mục đích nghiệp vụ}}

## Thông tin điều tra

| Thông tin          | Giá trị                        |
| ------------------ | ------------------------------ |
| Project            | {{project-name}}               |
| Entry Point        | {{API / Job / Event / Method}} |
| DB Environment     | {{environment / NOT ACCESSED}} |
| DB Metadata Time   | {{timestamp / N/A}}            |
| Investigation Date | {{date}}                       |
| Status             | {{Complete / Partial}}         |

**Phạm vi:** {{Những thành phần và luồng đã điều tra}}

**Giới hạn:** {{Những phần chưa truy cập hoặc chưa xác minh}}

---

## 1. Tổng quan nghiệp vụ

### 1.1. Nghiệp vụ này làm gì?

{{Giải thích nghiệp vụ bằng ngôn ngữ dễ hiểu.
Người đọc chưa cần biết tên class, method hoặc procedure.}}

### 1.2. Đầu vào và kết quả

| Nội dung            | Mô tả                               |
| ------------------- | ----------------------------------- |
| Tác nhân            | {{Ai hoặc hệ thống nào kích hoạt}}  |
| Đầu vào             | {{Input quan trọng}}                |
| Điều kiện thực hiện | {{Điều kiện tiên quyết}}            |
| Kết quả thành công  | {{Kết quả mong đợi}}                |
| Kết quả thất bại    | {{Những trường hợp thất bại chính}} |

---

## 2. Luồng nghiệp vụ

### 2.1. Sơ đồ xử lý

{{Tạo Mermaid flowchart từ các bước đã xác minh.
Thể hiện các nhánh thành công, thất bại và kết thúc sớm.
Không đưa quá nhiều chi tiết Java/SQL vào sơ đồ.}}

### 2.2. Giải thích từng bước

| Bước | Xử lý nghiệp vụ | Điều kiện/Kết quả        |
| ---- | --------------- | ------------------------ |
| 1    | {{Bước 1}}      | {{Điều kiện và kết quả}} |
| 2    | {{Bước 2}}      | {{Điều kiện và kết quả}} |
| ...  | ...             | ...                      |

### 2.3. Trạng thái nghiệp vụ (nếu có)

| Giá trị DB | Trạng thái | Ý nghĩa     | Điều kiện chuyển |
| ---------- | ---------- | ----------- | ---------------- |
| {{value}}  | {{status}} | {{meaning}} | {{condition}}    |

{{Thêm Mermaid stateDiagram khi hữu ích và có đủ bằng chứng.}}

---

## 3. Tổng quan Database

### 3.1. Những bảng liên quan

| Bảng             | Vai trò trong nghiệp vụ     | Phân loại  | Thao tác       |
| ---------------- | --------------------------- | ---------- | -------------- |
| {{schema.table}} | {{Bảng này dùng để làm gì}} | Core       | SELECT, UPDATE |
| {{schema.table}} | {{Vai trò}}                 | Supporting | SELECT         |
| ...              | ...                         | ...        | ...            |

Phân loại:

- Core: dữ liệu chính hoặc trạng thái nghiệp vụ.
- Supporting: cấu hình, danh mục, dữ liệu tham chiếu.
- Audit/Integration: lịch sử, log hoặc dữ liệu tích hợp.
- Indirect: dependency gián tiếp.

{{Giải thích ngắn gọn những bảng quan trọng nhất và lý do
chúng quan trọng đối với nghiệp vụ.}}

### 3.2. Quan hệ giữa các bảng

{{Tạo Mermaid erDiagram nếu có đủ bằng chứng.
Chỉ hiển thị bảng và các khóa liên kết quan trọng.
Không tự suy đoán cardinality.}}

| Bảng nguồn | Bảng đích | Cột liên kết | Ý nghĩa quan hệ |
| ---------- | --------- | ------------ | --------------- |
| {{table}}  | {{table}} | {{column}}   | {{meaning}}     |

Chi tiết: [Database Analysis](database.md)

---

## 4. Business Rules

| ID     | Điều kiện     | Xử lý/Kết quả | Evidence   | Status   |
| ------ | ------------- | ------------- | ---------- | -------- |
| BR-001 | {{condition}} | {{result}}    | {{source}} | VERIFIED |
| BR-002 | {{condition}} | {{result}}    | {{source}} | INFERRED |

{{Giải thích thêm các rule phức tạp, công thức tính toán
hoặc những trường hợp đặc biệt nếu cần.}}

Không coi ý nghĩa nghiệp vụ của status/type/code là VERIFIED
chỉ vì đã tìm thấy phép so sánh giá trị trong SQL.

---

## 5. Tổng quan luồng kỹ thuật

{{Entry Point}}
-> {{Java Service}}
-> {{Repository/DAO}}
-> {{Stored Procedure / SQL}}
-> {{Database}}
-> {{Response / Event}}

| Bước nghiệp vụ | Thành phần thực hiện         | DB liên quan |
| -------------- | ---------------------------- | ------------ |
| {{step}}       | {{Class.method / Procedure}} | {{table}}    |

Chi tiết: [Technical Flow](technical-flow.md)

---

## 6. Hướng dẫn debug và tra cứu

| Muốn tìm hiểu/kiểm tra   | Nên bắt đầu từ đâu           |
| ------------------------ | ---------------------------- |
| Entry point              | {{API / Class.method}}       |
| Validation               | {{Class.method / Procedure}} |
| Trạng thái nghiệp vụ     | {{Table.Column / Enum}}      |
| Công thức hoặc điều kiện | {{Class.method / Procedure}} |
| Dữ liệu được cập nhật    | {{Procedure + Table}}        |
| Error code               | {{Nơi phát sinh và xử lý}}   |

{{Ghi thêm những lưu ý quan trọng khi debug nếu có.}}

---

## 7. Coverage và điểm chưa xác minh

| Nội dung                | Kết quả                         |
| ----------------------- | ------------------------------- |
| Entry points            | {{Số lượng / phạm vi}}          |
| Procedures/Functions    | {{Đã kiểm tra / chưa kiểm tra}} |
| Tables                  | {{Đã phân tích / chỉ ghi nhận}} |
| Runtime verification    | {{Có / Không}}                  |
| Unresolved dependencies | {{Danh sách hoặc số lượng}}     |

**Các điểm cần lưu ý:**

- {{Điểm chưa xác minh 1}}
- {{Điểm chưa xác minh 2}}

Chi tiết: [Open Questions](open-questions.md)

---

# TEMPLATE 2 — database.md

# Database Analysis — {{Tên nghiệp vụ}}

## 1. Tổng quan

{{Giải thích ngắn gọn dữ liệu của nghiệp vụ nằm ở đâu,
các nhóm bảng chính và cách chúng phối hợp.}}

### Table Inventory

| Table            | Category   | Business Role | Usage          |
| ---------------- | ---------- | ------------- | -------------- |
| {{schema.table}} | Core       | {{role}}      | SELECT, UPDATE |
| {{schema.table}} | Supporting | {{role}}      | SELECT         |
| ...              | ...        | ...           | ...            |

Tất cả các bảng được phát hiện trong phạm vi điều tra
phải có trong Table Inventory.

Những bảng quan trọng được phân tích chi tiết bên dưới.

---

## 2. {{SCHEMA.TABLE_NAME}}

**Category:** {{Core / Supporting / Audit / Indirect}}

**Verification:** {{VERIFIED / INFERRED / UNKNOWN}}

### 2.1. Bảng này dùng để làm gì?

{{Giải thích bảng bằng ngôn ngữ nghiệp vụ.}}

- Một bản ghi đại diện cho: {{object/event}}.
- Dữ liệu được tạo khi: {{condition}}.
- Dữ liệu được sử dụng khi: {{business step}}.
- Vai trò trong nghiệp vụ: {{business role}}.

Nếu chưa xác định được ý nghĩa nghiệp vụ, mô tả những
hành vi thực tế đã quan sát và đánh dấu UNKNOWN.

### 2.2. Các cột quan trọng

| Column     | Data Type | Ý nghĩa nghiệp vụ | Cách sử dụng    |
| ---------- | --------- | ----------------- | --------------- |
| {{id}}     | {{type}}  | {{meaning}}       | PK / JOIN       |
| {{status}} | {{type}}  | {{meaning}}       | FILTER / UPDATE |
| {{amount}} | {{type}}  | {{meaning}}       | CALCULATE       |
| ...        | ...       | ...               | ...             |

Chỉ liệt kê những cột liên quan đến nghiệp vụ.

Ưu tiên khóa, status, điều kiện, công thức và cột được ghi.
Không lược bỏ cột ảnh hưởng đến hành vi nghiệp vụ.

### 2.3. Value Mapping (nếu có)

| Column     | Value     | Ý nghĩa     | Evidence   |
| ---------- | --------- | ----------- | ---------- |
| {{column}} | {{value}} | {{meaning}} | {{source}} |

Không tự suy đoán mapping chưa được xác minh.

### 2.4. Quan hệ với bảng khác

| Bảng liên quan | Cột liên kết | Ý nghĩa     | Bằng chứng             |
| -------------- | ------------ | ----------- | ---------------------- |
| {{table}}      | {{key}}      | {{meaning}} | {{FK / JOIN / Source}} |

Phân biệt FK constraint thực tế và quan hệ logic suy ra
từ Java/SQL.

### 2.5. Bảng được đọc/ghi như thế nào?

| Operation | Thành phần thực hiện | Cột liên quan | Mục đích/Điều kiện |
| --------- | -------------------- | ------------- | ------------------ |
| SELECT    | {{procedure}}        | {{columns}}   | {{purpose}}        |
| INSERT    | {{procedure}}        | {{columns}}   | {{purpose}}        |
| UPDATE    | {{procedure}}        | {{columns}}   | {{purpose}}        |
| DELETE    | {{procedure}}        | {{columns}}   | {{purpose}}        |

Chỉ giữ các operation thực sự được phát hiện.

Không khẳng định thao tác ghi đã commit nếu chưa
xác minh được transaction.

### 2.6. Evidence và lưu ý

- Java: {{path / class / method / lines}}
- DB: {{database / schema / procedure / SQL section}}
- Config/Test: {{source nếu có}}

**Chưa xác minh:** {{unknowns / Không có}}

---

{{Lặp lại mục 2 cho những bảng cần phân tích chi tiết.

Core Tables cần được phân tích đầy đủ.

Supporting/Audit/Indirect Tables chỉ cần mức độ chi tiết
tương ứng với tác động thực tế trong nghiệp vụ.

Không tạo nội dung giả để điền đủ các section.}}

---

# TEMPLATE 3 — technical-flow.md

# Technical Flow — {{Tên nghiệp vụ}}

## 1. Entry Point

| Thông tin   | Giá trị                       |
| ----------- | ----------------------------- |
| Type        | {{API / Job / Event / Other}} |
| Entry Point | {{endpoint / class.method}}   |
| Input       | {{Important parameters}}      |
| Output      | {{Response / Event / Result}} |

{{Giải thích entry point và vai trò trong nghiệp vụ.}}

---

## 2. Java Call Chain

{{Tạo call graph hoặc sequenceDiagram nếu hữu ích.}}

| Order | Class.Method | Vai trò     | Calls    |
| ----- | ------------ | ----------- | -------- |
| 1     | {{method}}   | {{purpose}} | {{next}} |
| 2     | {{method}}   | {{purpose}} | {{next}} |

### Validation và xử lý đặc biệt

- {{Validation / Authorization}}
- {{Exception handling}}
- {{Configuration / External calls}}
- {{Transaction boundary}}

Ghi evidence cho những hành vi quan trọng.

---

## 3. Procedure Call Graph

{{Tạo Mermaid flowchart cho các procedure/function
và lời gọi lồng nhau liên quan.}}

### {{SCHEMA.PROCEDURE_NAME}}

**Vai trò:** {{Procedure thực hiện việc gì}}

**Input:** {{Important input parameters}}

**Output:** {{Important output parameters / return code}}

**Called by:** {{Java method / parent procedure}}

**Calls:** {{Nested procedures/functions}}

| Table     | Operation | Purpose     |
| --------- | --------- | ----------- |
| {{table}} | SELECT    | {{purpose}} |
| {{table}} | UPDATE    | {{purpose}} |

**Business Rules:** {{BR-xxx liên quan}}

**Error Handling:** {{Hành vi khi lỗi}}

**Transaction:** {{Boundary / Commit / Rollback / UNKNOWN}}

**Evidence:** {{Database.Schema.Object / SQL section}}

---

{{Lặp lại mục 3 cho các procedure/function quan trọng.

Với dependency ít quan trọng, có thể tóm tắt trong
call graph hoặc bảng tổng hợp.

Ghi rõ dynamic SQL và dependency chưa phân giải.}}

---

## 4. End-to-End Mapping

| Business Step | Java       | Procedure/SQL | Table     | DB Impact     |
| ------------- | ---------- | ------------- | --------- | ------------- |
| {{step}}      | {{method}} | {{procedure}} | {{table}} | {{operation}} |

Mục tiêu là tra ngược từ một bước nghiệp vụ tới code
và database tương ứng.

---

## 5. Error Handling & Transaction

### Error Handling

| Điều kiện lỗi | Nơi phát sinh | Error Code | Kết quả    |
| ------------- | ------------- | ---------- | ---------- |
| {{condition}} | {{source}}    | {{code}}   | {{result}} |

### Transaction

- Transaction bắt đầu tại: {{source / UNKNOWN}}
- Các thao tác ghi liên quan: {{operations}}
- Commit/Rollback: {{behavior / UNKNOWN}}
- Side effects: {{effects / Không xác định}}

Không giả định toàn bộ nested procedure thuộc cùng
một transaction nếu chưa có bằng chứng.

---

## 6. Technical Evidence

{{Ghi các nguồn code và SQL quan trọng để người đọc
có thể kiểm tra lại các kết luận.}}

| ID     | Source        | Location         | Supports              |
| ------ | ------------- | ---------------- | --------------------- |
| EV-001 | {{Java file}} | {{Method/Lines}} | {{BR-xxx / behavior}} |
| EV-002 | {{DB object}} | {{SQL section}}  | {{DB operation}}      |

Nếu nguồn SQL không có số dòng ổn định, sử dụng tên object,
phần SQL liên quan và thông tin môi trường/thời điểm lấy.

---

# TEMPLATE 4 — open-questions.md

# Open Questions — {{Tên nghiệp vụ}}

## 1. Business Questions

| ID    | Câu hỏi      | Bằng chứng hiện có | Cần xác nhận bởi |
| ----- | ------------ | ------------------ | ---------------- |
| Q-001 | {{question}} | {{evidence}}       | BA/Developer     |

## 2. Database Questions

| ID    | Câu hỏi      | Bằng chứng hiện có | Cần xác nhận bởi |
| ----- | ------------ | ------------------ | ---------------- |
| Q-002 | {{question}} | {{evidence}}       | DBA/Developer    |

## 3. Technical Questions

| ID    | Câu hỏi      | Bằng chứng hiện có | Cần xác nhận bởi |
| ----- | ------------ | ------------------ | ---------------- |
| Q-003 | {{question}} | {{evidence}}       | Developer        |

## 4. Missing Evidence / Dependencies

| Object / Source | Vấn đề               | Ảnh hưởng đến kết luận |
| --------------- | -------------------- | ---------------------- |
| {{object}}      | {{missing evidence}} | {{impact}}             |

Nếu không còn câu hỏi nào, ghi rõ không phát hiện
vấn đề chưa xác minh trong phạm vi điều tra.

Không khẳng định toàn bộ nghiệp vụ đã được xác minh
chỉ vì danh sách câu hỏi đang trống.

---

# FINAL REPORT CHECKLIST

Trước khi hoàn thành, kiểm tra:

[ ] README giúp người mới hiểu nghiệp vụ.

[ ] Business Flow thể hiện các nhánh quan trọng.

[ ] Mọi bảng liên quan đều có trong Table Inventory.

[ ] Các bảng chính được giải thích vai trò và cột quan trọng.

[ ] Quan hệ bảng và status mapping có bằng chứng.

[ ] Data Read/Write được ghi nhận.

[ ] Java và nested procedure liên quan đã được truy vết
hoặc có ghi nhận phần chưa truy vết được.

[ ] Business Rules có điều kiện, kết quả và evidence.

[ ] Các kết luận chưa xác minh được đánh dấu phù hợp.

[ ] Các liên kết giữa file, BR-xxx và Q-xxx nhất quán.

[ ] Báo cáo không chứa credential hoặc dữ liệu nhạy cảm.

[ ] Báo cáo tuân thủ output-requirements.md.

Nếu không đạt do thiếu bằng chứng, xuất báo cáo Partial
và ghi rõ giới hạn. Không tự tạo nội dung để hoàn thành mẫu.
