# BUSINESS INVESTIGATION WORKFLOW

Version: 1.0
Target: Codex / Business Investigator Skill
Language: Vietnamese
Output specification: output-requirements.md

---

## 1. Mục tiêu

Điều tra một nghiệp vụ từ entry point đến các thành phần
Java, stored procedure và database liên quan.

Kết quả phải giúp developer mới hiểu:

- Nghiệp vụ hoạt động như thế nào.
- Mỗi bảng DB liên quan có tác dụng gì.
- Các cột quan trọng và quan hệ giữa các bảng.
- Java và procedure phối hợp xử lý ra sao.
- Dữ liệu được đọc/ghi ở đâu và theo điều kiện nào.
- Những gì đã xác minh và những gì còn chưa biết.

Thực hiện điều tra theo trình tự:

SCOPE
-> JAVA TRACE
-> DATABASE TRACE
-> BUSINESS ANALYSIS
-> VERIFICATION
-> REPORT GENERATION

Không bắt đầu viết kết luận nghiệp vụ khi chưa thu thập
đủ bằng chứng cho kết luận đó.

---

## 2. Nguyên tắc điều tra

1. Chỉ điều tra trong phạm vi nghiệp vụ được yêu cầu.
2. Ưu tiên hành vi thực tế của code/SQL hơn suy luận từ tên.
3. Không dừng ở procedure đầu tiên được Java gọi.
4. Truy vết nested procedure, function và dependency liên quan.
5. Mỗi bảng phải được ghi nhận vai trò, kể cả khi chỉ gián tiếp.
6. Ưu tiên các cột ảnh hưởng trực tiếp đến nghiệp vụ.
7. Không coi thao tác ghi là đã commit nếu chưa xác minh.
8. Mọi kết luận quan trọng phải có evidence.
9. Không tự đoán ý nghĩa của status, type hoặc error code.
10. Nếu thiếu thông tin, ghi UNKNOWN và tiếp tục phần có thể làm.

Hoạt động DB mặc định là metadata-only/read-only.
Không thực thi business procedure hoặc thay đổi dữ liệu.

---

## 3. STEP 1 — Xác định phạm vi (Scope Discovery)

### Input

Yêu cầu điều tra có thể là:

- Tên nghiệp vụ.
- API endpoint.
- Java class/method.
- Stored procedure.
- Job hoặc event handler.

### Thực hiện

1. Đọc hướng dẫn và cấu hình riêng của project nếu có.
2. Xác định repository, branch và commit hiện tại.
3. Xác định môi trường DB được phép điều tra.
4. Tìm entry point phù hợp với yêu cầu.
5. Xác định input, output và các thành phần liên quan.
6. Ghi nhận phạm vi, giả định và những phần không điều tra.

Nếu tìm thấy nhiều entry point, xác định các entry point
thuộc cùng nghiệp vụ và quan hệ giữa chúng.

Nếu yêu cầu chưa đủ rõ, sử dụng bằng chứng để chọn phạm vi
hợp lý và ghi lại giả định. Không tự gộp các nghiệp vụ
khác nhau chỉ vì có tên tương tự.

### Kết quả trung gian

- Investigation scope.
- Danh sách entry point.
- Git commit.
- DB environment.
- Những giới hạn ban đầu.

---

## 4. STEP 2 — Truy vết Java (Java Trace)

### Thực hiện

Bắt đầu từ entry point và truy vết theo luồng thực thi:

Controller / Listener / Job
-> Service
-> Repository / DAO / Mapper
-> SQL / Stored Procedure

Với mỗi thành phần liên quan, xác định:

- Vai trò trong nghiệp vụ.
- Input/output và dữ liệu được truyền.
- Validation và authorization.
- Điều kiện IF/ELSE, switch và các nhánh xử lý.
- Mapping DTO/entity/parameter.
- External service và configuration liên quan.
- Exception handling.
- Transaction boundary.
- Các lời gọi SQL, procedure hoặc function.

### Lưu ý khi trace

- Truy vết lời gọi thực tế, không chỉ tìm theo tên method.
- Kiểm tra cả SQL được gọi trực tiếp từ Java.
- Xác định procedure/schema thông qua cấu hình và mapping.
- Không mặc định mọi method đều chạy trong cùng transaction.
- Ghi nhận các nhánh lỗi và trường hợp kết thúc sớm.

### Kết quả trung gian

Java Call Chain:

| Component | Method | Vai trò | Calls | Evidence |
| --------- | ------ | ------- | ----- | -------- |

Danh sách procedure/SQL cần điều tra tiếp.

---

## 5. STEP 3 — Điều tra Database (Database Trace)

### 5.1. Truy vết procedure và function

Với mỗi procedure/function được phát hiện:

1. Xác định database, schema và tên object chính xác.
2. Lấy định nghĩa từ nguồn được phép truy cập.
3. Xác định input/output parameter quan trọng.
4. Phân tích các điều kiện IF/CASE, loop và dynamic SQL.
5. Tìm procedure/function được gọi tiếp.
6. Xác định các bảng được SELECT/INSERT/UPDATE/DELETE.
7. Phân tích error handling và transaction.
8. Kiểm tra trigger và side effect liên quan khi cần.

Tiếp tục truy vết nested procedure/function trong phạm vi
nghiệp vụ cho đến khi không còn dependency liên quan
chưa được xử lý.

Sử dụng danh sách object đã truy cập để tránh vòng lặp
hoặc phân tích trùng.

Nếu gặp dynamic SQL, synonym, DB link hoặc object không
truy cập được, ghi rõ phần dependency chưa xác minh.

Không kết luận call graph đã đầy đủ khi vẫn còn lời gọi
không thể phân giải.

### 5.2. Thu thập thông tin bảng

Với mỗi bảng được phát hiện:

- Lấy schema và metadata nếu có quyền.
- Xác định primary key, foreign key và unique constraint.
- Tìm các cột được sử dụng trong nghiệp vụ.
- Xác định bảng được đọc hay ghi ở bước nào.
- Xác định các procedure/method sử dụng bảng.
- Tìm quan hệ với những bảng khác.

Phân loại sơ bộ:

CORE:
Lưu dữ liệu chính, trạng thái hoặc kết quả nghiệp vụ.

SUPPORTING:
Cấu hình, danh mục hoặc dữ liệu tham chiếu.

AUDIT / INTEGRATION:
Log, lịch sử hoặc dữ liệu tích hợp.

INDIRECT:
Dependency gián tiếp, chưa rõ tác động hoặc không cần
phân tích sâu trong phạm vi hiện tại.

Không tự xác định ý nghĩa nghiệp vụ chỉ từ tên bảng/cột.

### 5.3. Thu thập cột quan trọng

Ưu tiên:

- Primary key và business identifier.
- Foreign key và khóa liên kết logic.
- Status, type, category và error code.
- Cột tham gia điều kiện hoặc công thức.
- Cột được INSERT/UPDATE.
- Cột audit có ý nghĩa với nghiệp vụ.

Không cần phân tích toàn bộ cột nếu bảng có nhiều trường.

Tuy nhiên, không được lược bỏ cột ảnh hưởng trực tiếp
đến điều kiện, kết quả hoặc thay đổi dữ liệu.

### Kết quả trung gian

- Procedure Call Graph.
- Table Inventory.
- Danh sách cột quan trọng.
- Table Relationships.
- Data Read/Write Map.
- Những dependency chưa xác minh.

---

## 6. STEP 4 — Tái dựng nghiệp vụ (Business Analysis)

Sử dụng kết quả Java Trace và Database Trace để giải thích
nghiệp vụ bằng ngôn ngữ dễ hiểu.

### 6.1. Business Flow

Tái dựng các bước theo thứ tự thực thi:

- Điều kiện bắt đầu.
- Các bước kiểm tra.
- Các phép tính hoặc xử lý dữ liệu.
- Các nhánh thành công/thất bại.
- Các thay đổi trạng thái.
- Kết quả cuối cùng.

Ưu tiên mô tả "nghiệp vụ làm gì" thay vì chỉ liệt kê
"method hoặc procedure nào được gọi".

### 6.2. Business Rules

Với mỗi rule, xác định:

- Điều kiện áp dụng.
- Dữ liệu đầu vào.
- Xử lý hoặc phép tính.
- Kết quả.
- Error code nếu có.
- Nơi thực hiện.
- Evidence.

Gán mã BR-001, BR-002... nhất quán trong báo cáo.

### 6.3. Giải thích vai trò từng bảng

Với mỗi bảng, cố gắng trả lời:

1. Một bản ghi đại diện cho đối tượng hoặc sự kiện nào?
2. Bảng dùng để làm gì trong nghiệp vụ?
3. Bảng được đọc/ghi khi nào?
4. Những cột nào ảnh hưởng đến nghiệp vụ?
5. Bảng liên kết với những bảng nào?
6. Method/procedure nào sử dụng bảng?

Mô tả chi tiết Core Tables.

Với Supporting/Audit/Indirect Tables, chỉ phân tích sâu
những phần thực sự ảnh hưởng đến nghiệp vụ.

Nếu vai trò chưa xác minh được, chỉ mô tả hành vi đã quan
sát và ghi UNKNOWN cho ý nghĩa chưa rõ.

### 6.4. State & Value Mapping

Tìm ý nghĩa của status/type/code trong:

- Enum/constants.
- Bảng danh mục và cấu hình.
- Java/SQL mapping.
- Test và tài liệu nghiệp vụ.

Không tự suy luận rằng STATUS = 1 nghĩa là APPROVED nếu
không có bằng chứng.

### Kết quả trung gian

- Business Summary.
- Business Flow.
- Business Rules.
- Business State/Lifecycle.
- Business Data Dictionary.

---

## 7. STEP 5 — Kiểm chứng (Verification)

Đối chiếu thông tin từ Java, SQL, metadata và tài liệu.

Kiểm tra:

- Java truyền đúng parameter cho procedure nào?
- Procedure trả kết quả gì và Java mapping thế nào?
- Các điều kiện nghiệp vụ có nhất quán giữa các lớp?
- Các thao tác ghi nằm trong transaction nào?
- Khi lỗi xảy ra, dữ liệu có thể bị rollback không?
- Các bảng/cột và quan hệ có đủ bằng chứng?
- Có dependency hoặc nhánh xử lý nào chưa truy vết?

### Verification Status

VERIFIED:
Có bằng chứng trực tiếp xác nhận kết luận.

INFERRED:
Có căn cứ suy luận nhưng chưa xác minh đầy đủ.

UNKNOWN:
Chưa đủ thông tin để kết luận.

Phân biệt bằng chứng về hành vi kỹ thuật với bằng chứng
về ý nghĩa nghiệp vụ.

### Evidence

Với Java, ghi file, class/method và dòng code nếu có.

Với DB, ghi database, schema, object và phần SQL liên quan.

Các kết luận quan trọng phải có nguồn có thể tìm lại.

Nếu phát hiện mâu thuẫn giữa các nguồn, không tự chọn
một nguồn là đúng. Ghi rõ mâu thuẫn và phiên bản/môi trường.

### Kết quả trung gian

- Danh sách kết luận đã xác minh.
- Các suy luận cần xác nhận.
- Open Questions.
- Investigation Coverage.

---

## 8. STEP 6 — Sinh báo cáo (Report Generation)

Đọc và tuân thủ output-requirements.md.

Xuất báo cáo tại:

docs/business-investigations/<feature-name>/

Cấu trúc:

README.md
Tổng quan, business flow, trạng thái, bảng DB tổng quan,
business rules và hướng dẫn debug.

database.md
Vai trò từng bảng, cột quan trọng, quan hệ và dữ liệu
được đọc/ghi.

technical-flow.md
Java call chain, procedure call graph, transaction,
error handling và end-to-end mapping.

open-questions.md
Những điểm chưa xác minh, mâu thuẫn và dependency thiếu.

Với nghiệp vụ nhỏ, có thể gộp các phần vào README.md.

### Quy tắc sinh báo cáo

- Viết bằng tiếng Việt, giữ nguyên tên kỹ thuật.
- Giải thích từ tổng quan đến chi tiết.
- Sử dụng Markdown table và Mermaid khi phù hợp.
- Không nhúng toàn bộ Java/SQL vào báo cáo chính.
- Liên kết các business rule với nguồn kỹ thuật liên quan.
- Không trình bày suy luận chưa xác minh như sự thật.
- Không làm mất thông tin quan trọng để rút ngắn báo cáo.

---

## 9. STEP 7 — Kiểm tra kết quả (Quality Check)

Trước khi hoàn thành, kiểm tra:

[ ] README giải thích được nghiệp vụ cho người mới.

[ ] Business flow có các nhánh quan trọng.

[ ] Các bảng liên quan đều được ghi nhận.

[ ] Mỗi bảng chính có giải thích vai trò.

[ ] Các cột quan trọng được mô tả đủ.

[ ] Quan hệ dữ liệu không bị suy đoán.

[ ] Business rules có điều kiện, kết quả và evidence.

[ ] Java và nested procedure liên quan đã được truy vết.

[ ] Data Read/Write và transaction được ghi nhận.

[ ] Có hướng dẫn tìm code/DB để debug.

[ ] Các điểm UNKNOWN/INFERRED được ghi rõ.

[ ] Báo cáo tuân thủ output-requirements.md.

[ ] Không chứa credential hoặc dữ liệu nhạy cảm.

Nếu thiếu bằng chứng, vẫn tạo báo cáo Partial và nêu rõ
những phần chưa thể xác minh.

---

## 10. Điều kiện hoàn thành

Cuộc điều tra có thể kết thúc khi:

1. Các entry point trong phạm vi đã được xử lý.
2. Các lời gọi Java/SQL liên quan đã được truy vết hoặc
   ghi rõ lý do chưa truy vết được.
3. Các bảng liên quan đã được ghi nhận, các bảng chính
   đã được phân tích đủ để hiểu nghiệp vụ.
4. Những business rule quan trọng có evidence hoặc
   được đánh dấu chưa xác minh.
5. Báo cáo đã được tạo và kiểm tra theo đặc tả output.

Không tiếp tục mở rộng sang các nghiệp vụ không liên quan
chỉ vì chúng sử dụng chung một bảng hoặc procedure.

Không đánh dấu Complete nếu còn thiếu thông tin quan trọng
ảnh hưởng đến việc hiểu nghiệp vụ trong phạm vi yêu cầu.

Khi không thể hoàn thành toàn bộ, xuất kết quả Partial
với phần đã xác minh, coverage và open questions.
