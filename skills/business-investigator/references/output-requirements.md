# ĐẶC TẢ YÊU CẦU ĐẦU RA

# BUSINESS INVESTIGATION REPORT

Version: 1.0
Status: Draft
Target: AI Agent / Codex
Output format: Markdown + Mermaid
Report language: Tiếng Việt

---

## 1. MỤC TIÊU

Xây dựng tài liệu điều tra nghiệp vụ dựa trên source code,
database và các tài liệu liên quan của một project.

Tài liệu được viết cho developer mới, chưa có kiến thức
về nghiệp vụ, cấu trúc database hoặc luồng xử lý hệ thống.

Sau khi đọc báo cáo, người đọc phải có thể:

1. Hiểu nghiệp vụ đang giải quyết vấn đề gì.
2. Hiểu luồng xử lý từ lúc bắt đầu đến khi kết thúc.
3. Biết các bảng DB liên quan và vai trò của từng bảng.
4. Hiểu các cột quan trọng, ý nghĩa và cách sử dụng.
5. Hiểu quan hệ giữa các bảng trong ngữ cảnh nghiệp vụ.
6. Biết Java gọi procedure nào và procedure xử lý gì.
7. Biết dữ liệu được đọc, tạo hoặc cập nhật ở bước nào.
8. Hiểu các business rule, trạng thái và trường hợp lỗi.
9. Biết bắt đầu kiểm tra ở đâu khi cần debug hoặc sửa code.
10. Phân biệt thông tin đã xác minh và thông tin chưa chắc chắn.

Báo cáo phải ưu tiên giải thích bản chất nghiệp vụ, không
chỉ liệt kê class, method, procedure và câu lệnh SQL.

---

## 2. NGUYÊN TẮC CHUNG

### 2.1. Lấy người mới làm trung tâm

Giả định người đọc chưa biết hệ thống.

Khi xuất hiện thuật ngữ nghiệp vụ, bảng DB, trạng thái hoặc
procedure quan trọng, phải giải thích ý nghĩa và vai trò.

Không yêu cầu người đọc phải tự mở source code để hiểu
những nội dung cốt lõi của báo cáo.

### 2.2. Trình bày từ tổng quan đến chi tiết

Thứ tự ưu tiên:

Business Overview
-> Business Flow
-> Database Overview
-> Data Dictionary
-> Business Rules
-> Technical Flow
-> Evidence

Không bắt đầu báo cáo bằng danh sách procedure hoặc toàn bộ
DDL của database.

### 2.3. Phân biệt sự thật và suy luận

Không được suy đoán nghiệp vụ chỉ dựa trên tên bảng, tên cột
hoặc tên procedure.

Mỗi kết luận quan trọng phải có nguồn chứng minh hoặc
được đánh dấu là chưa xác minh.

Sử dụng ba trạng thái:

- VERIFIED: Có bằng chứng trực tiếp từ source code, SQL,
  metadata DB, cấu hình hoặc tài liệu đáng tin cậy.

- INFERRED: Có căn cứ để suy luận nhưng chưa đủ bằng chứng
  để xác nhận đầy đủ ý nghĩa nghiệp vụ.

- UNKNOWN: Chưa có đủ thông tin để kết luận.

VERIFIED đối với logic kỹ thuật không đồng nghĩa với việc
ý nghĩa nghiệp vụ của logic đó đã được xác minh.

Không sử dụng tên hàm, comment hoặc mô tả cũ làm bằng chứng
duy nhất nếu hành vi thực tế của code có thể khác.

### 2.4. Giới hạn phạm vi

Chỉ tập trung vào các thành phần liên quan đến nghiệp vụ
đang điều tra.

Không cần mô tả toàn bộ hệ thống hoặc toàn bộ database.

Các dependency gián tiếp vẫn phải được ghi nhận, kể cả khi
không cần phân tích chi tiết.

### 2.5. Không che giấu thông tin thiếu

Nếu không thể truy cập DB, không lấy được định nghĩa
procedure, gặp dynamic SQL hoặc thiếu source code, phải
ghi rõ giới hạn của cuộc điều tra.

Không tự hoàn thiện các phần bị thiếu bằng giả định.

### 2.6. Ngôn ngữ

- Nội dung giải thích: tiếng Việt.
- Tên class, method, bảng, cột, procedure: giữ nguyên.
- Thuật ngữ tiếng Anh quan trọng: có thể giữ kèm giải thích.
- Ưu tiên câu ngắn, rõ ràng, tránh mô tả kỹ thuật không cần thiết.

---

## 3. CẤU TRÚC FILE ĐẦU RA

Mỗi nghiệp vụ được xuất thành một thư mục riêng.

Ví dụ:

docs/business-investigations/
└── payment-approval/
├── README.md
├── database.md
├── technical-flow.md
└── open-questions.md

### 3.1. README.md

Tài liệu chính, dành cho người đọc lần đầu.

Chứa:

- Tổng quan nghiệp vụ.
- Luồng xử lý.
- Vòng đời trạng thái.
- Danh sách bảng DB và vai trò.
- Quan hệ dữ liệu tổng quan.
- Business rules.
- Liên kết đến phân tích kỹ thuật.
- Hướng dẫn debug và những điểm chưa xác minh.

### 3.2. database.md

Tài liệu giải thích database theo ngữ cảnh nghiệp vụ.

Chứa:

- Danh sách bảng liên quan.
- Vai trò từng bảng.
- Các cột quan trọng.
- Ý nghĩa trạng thái, mã loại, mã cấu hình.
- Quan hệ giữa các bảng.
- Hành vi đọc/ghi.
- Procedure sử dụng các bảng.
- Bằng chứng tương ứng.

### 3.3. technical-flow.md

Tài liệu phân tích kỹ thuật chi tiết.

Chứa:

- Java call chain.
- Procedure/function call graph.
- Input/output mapping.
- Validation và error handling.
- Transaction và rollback.
- Database side effects.
- Các tích hợp hoặc dependency liên quan.

### 3.4. open-questions.md

Danh sách thông tin chưa xác minh được.

Chứa:

- Câu hỏi nghiệp vụ cần BA xác nhận.
- Câu hỏi kỹ thuật cần developer/DBA xác nhận.
- Những object không truy cập được.
- Những mâu thuẫn giữa các nguồn bằng chứng.
- Những phạm vi chưa được điều tra.

### 3.5. Quy tắc chia file

Với nghiệp vụ nhỏ, có thể gộp nội dung vào README.md
nhưng vẫn phải giữ đầy đủ các section bắt buộc.

Với nghiệp vụ lớn, có thể chia database.md thành nhiều
file theo nhóm bảng, miễn là README.md liên kết đến được.

Không tách file chỉ để tách file.

README.md phải luôn đóng vai trò là điểm bắt đầu đọc tài liệu.

---

## 4. YÊU CẦU CHI TIẾT: README.md

### 4.1. Thông tin báo cáo

Phải có:

- Tên nghiệp vụ.
- Mục đích điều tra.
- Project/repository.
- Entry point được điều tra.
- Phạm vi điều tra.
- Git commit hoặc phiên bản source.
- Môi trường DB và thời điểm lấy metadata, nếu có.
- Ngày tạo hoặc cập nhật báo cáo.
- Tình trạng điều tra: Complete / Partial.
- Các giới hạn quan trọng.

Không đưa credential hoặc thông tin nhạy cảm vào báo cáo.

### 4.2. Executive Summary

Giải thích ngắn gọn:

- Nghiệp vụ là gì?
- Ai hoặc hệ thống nào kích hoạt?
- Tại sao nghiệp vụ cần thực hiện?
- Input chính là gì?
- Kết quả mong đợi là gì?
- Dữ liệu chính được lưu ở đâu?

Ưu tiên diễn giải bằng ngôn ngữ nghiệp vụ.

Không trình bày chi tiết Java hoặc SQL tại phần này.

Nếu chưa xác định được mục đích nghiệp vụ, nêu rõ những
hành vi thực tế đã quan sát và đánh dấu phần chưa xác minh.

### 4.3. Business Flow

Mô tả từng bước theo trình tự thực thi.

Mỗi bước nên trả lời:

- Điều gì xảy ra?
- Điều kiện để thực hiện bước này?
- Dữ liệu nào được sử dụng?
- Kết quả của bước?
- Có nhánh xử lý khác hoặc lỗi không?

Bắt buộc có một sơ đồ Mermaid flowchart khi có thể
xác định được luồng.

Sơ đồ ưu tiên thể hiện nghiệp vụ, không dùng toàn bộ
tên method kỹ thuật làm nội dung các node.

Các nhánh thành công, thất bại và kết thúc sớm quan trọng
phải được thể hiện.

Không biến một luồng có nhiều nhánh thành một chuỗi
tuyến tính gây hiểu nhầm.

### 4.4. Business State / Lifecycle

Nếu nghiệp vụ liên quan đến trạng thái dữ liệu, cần có:

- Danh sách trạng thái.
- Giá trị được lưu trong DB.
- Ý nghĩa nghiệp vụ của từng trạng thái.
- Điều kiện chuyển trạng thái.
- Thành phần thực hiện chuyển trạng thái.
- Các chuyển trạng thái không hợp lệ.

Sử dụng Mermaid stateDiagram-v2 khi phù hợp.

Nếu chưa xác minh được ý nghĩa của một mã trạng thái,
giữ nguyên giá trị kỹ thuật và đánh dấu UNKNOWN.

Không tự đặt tên nghiệp vụ cho mã trạng thái.

### 4.5. Database Overview

Phải liệt kê các bảng DB được phát hiện trong phạm vi
nghiệp vụ.

Mỗi bảng có tối thiểu:

| Thông tin | Mô tả                                |
| --------- | ------------------------------------ |
| Table     | Tên đầy đủ schema.table              |
| Role      | Vai trò trong nghiệp vụ              |
| Category  | Core / Supporting / Audit / Indirect |
| Usage     | SELECT / INSERT / UPDATE / DELETE    |
| Used by   | Procedure hoặc thành phần sử dụng    |
| Detail    | Liên kết tới database.md             |

Phải giải thích bằng ngôn ngữ dễ hiểu bảng đó dùng để làm gì.

Không chỉ ghi "bảng thông tin" hoặc "bảng dữ liệu".

Nếu chưa xác định được vai trò của bảng, phải ghi UNKNOWN.

### 4.6. Data Relationship Overview

Phải có sơ đồ thể hiện quan hệ giữa các bảng chính
nếu đủ thông tin để xác định quan hệ.

Sử dụng Mermaid erDiagram hoặc sơ đồ tương đương.

Chỉ hiển thị các bảng và khóa quan trọng để giữ dễ đọc.

Phân biệt:

- Quan hệ được DB constraint xác nhận.
- Quan hệ logic từ JOIN hoặc source code.
- Quan hệ chưa đủ căn cứ xác định.

Chỉ ghi cardinality 1:1, 1:N, N:N khi có bằng chứng.

Với quan hệ phức tạp hoặc chưa xác minh, sử dụng bảng
mô tả quan hệ thay vì vẽ sơ đồ gây hiểu nhầm.

### 4.7. Business Rules

Tạo danh sách rule có định danh ổn định:

BR-001, BR-002, BR-003...

Mỗi rule phải có:

- Rule ID.
- Tên rule.
- Ý nghĩa nghiệp vụ.
- Điều kiện áp dụng.
- Dữ liệu đầu vào hoặc trường liên quan.
- Hành động/kết quả.
- Trường hợp lỗi nếu có.
- Evidence.
- Verification status.

Các nhóm rule cần xem xét:

- Điều kiện hợp lệ.
- Kiểm tra quyền.
- Kiểm tra trạng thái.
- Công thức tính toán.
- Hạn mức/ngưỡng.
- Điều kiện chuyển trạng thái.
- Quy tắc cập nhật dữ liệu.
- Quy tắc idempotency hoặc xử lý trùng.
- Quy tắc xử lý lỗi.

Chỉ ghi những rule liên quan đến nghiệp vụ được điều tra.

### 4.8. Technical Overview & Debug Guide

Tóm tắt luồng:

Entry Point
-> Controller / Listener / Job
-> Service
-> Repository / DAO / Mapper
-> Procedure / SQL
-> Database
-> Response / Event

Không cần mô tả tất cả method trong README.md.

Bắt buộc có bảng hướng dẫn tra cứu:

| Muốn tìm hiểu     | Nên kiểm tra               |
| ----------------- | -------------------------- |
| Điều kiện đầu vào | Class/method               |
| Quy tắc xử lý     | Class/procedure            |
| Trạng thái        | Enum/table/column          |
| Cập nhật dữ liệu  | Procedure + table          |
| Lỗi cụ thể        | Error code + nơi phát sinh |

Các đường dẫn phải liên kết được tới technical-flow.md
hoặc evidence tương ứng.

---

## 5. YÊU CẦU CHI TIẾT: database.md

Đây là một trong hai đầu ra được ưu tiên cao nhất,
cùng với README.md.

### 5.1. Table Inventory

Trước khi phân tích từng bảng, phải có bảng tổng hợp
toàn bộ các bảng DB được tìm thấy trong phạm vi điều tra.

Phân loại:

CORE:
Bảng lưu thực thể chính, trạng thái hoặc kết quả nghiệp vụ.

SUPPORTING:
Bảng cấu hình, danh mục, tham chiếu hoặc dữ liệu bổ trợ.

AUDIT / INTEGRATION:
Bảng log, lịch sử, sự kiện hoặc dữ liệu tích hợp.

INDIRECT:
Bảng xuất hiện qua dependency nhưng ảnh hưởng trực tiếp
đến nghiệp vụ chưa rõ hoặc không đáng kể.

Phân loại theo vai trò trong nghiệp vụ hiện tại, không
cố định vai trò của bảng cho mọi nghiệp vụ.

### 5.2. Mẫu phân tích cho từng bảng

Mỗi bảng được phân tích chi tiết phải có cấu trúc:

#### A. Thông tin cơ bản

- Table name.
- Database/schema.
- Category.
- Verification status.

#### B. Vai trò nghiệp vụ

Trả lời:

- Bảng này lưu loại dữ liệu gì?
- Một bản ghi đại diện cho đối tượng/sự kiện nào?
- Vì sao nghiệp vụ cần dữ liệu trong bảng này?
- Dữ liệu trong bảng được tạo hoặc thay đổi khi nào?
- Bảng này là dữ liệu chính, dữ liệu tham chiếu hay lịch sử?

Ưu tiên giải thích bằng 1-2 đoạn ngắn.

#### C. Các cột quan trọng

Mỗi cột được chọn phải có:

| Field            | Nội dung                                 |
| ---------------- | ---------------------------------------- |
| Column           | Tên cột                                  |
| Data Type        | Kiểu dữ liệu, nếu lấy được               |
| Business Meaning | Ý nghĩa trong nghiệp vụ                  |
| Usage            | JOIN / FILTER / CALCULATE / READ / WRITE |
| Value Mapping    | Mapping code, nếu có                     |
| Evidence         | Nguồn chứng minh                         |

Ưu tiên các cột:

1. Primary key hoặc business identifier.
2. Foreign key hoặc khóa liên kết logic.
3. Status, type, category, error code.
4. Các cột tham gia IF/CASE/WHERE quan trọng.
5. Các cột tham gia công thức tính toán.
6. Các cột được INSERT hoặc UPDATE.
7. Ngày giờ và thông tin audit cần để hiểu luồng.

Có thể lược các cột không liên quan.

Ưu tiên khoảng 5-10 cột mỗi bảng để dễ đọc, nhưng
không được bỏ các cột quyết định hành vi nghiệp vụ.

Nếu bảng có nhiều cột quan trọng, chia chúng theo nhóm.

#### D. Value Mapping

Với các cột chứa mã trạng thái, mã loại hoặc giá trị
điều khiển nghiệp vụ, mô tả:

- Giá trị lưu trong DB.
- Ý nghĩa nghiệp vụ.
- Giá trị được định nghĩa ở đâu.
- Hành vi tương ứng.
- Evidence.

Nếu mapping nằm trong bảng danh mục hoặc cấu hình,
cần ghi rõ bảng và khóa tra cứu.

Không được tự suy luận mapping từ số thứ tự.

#### E. Quan hệ với các bảng khác

Mỗi quan hệ cần có:

- Bảng nguồn.
- Bảng đích.
- Cột liên kết.
- Kiểu quan hệ, nếu xác minh được.
- Ý nghĩa nghiệp vụ của quan hệ.
- Nguồn bằng chứng.
- Có hay không có FK constraint thực tế.

#### F. Data Read/Write

Phải mô tả bảng được sử dụng như thế nào:

- SELECT: đọc để phục vụ điều kiện hoặc tính toán gì?
- INSERT: khi nào phát sinh bản ghi mới?
- UPDATE: cột nào bị thay đổi và trong điều kiện nào?
- DELETE: điều kiện xóa và tác động, nếu có?

Chỉ ra procedure, SQL hoặc Java method thực hiện.

Phân biệt thao tác ghi được code dự định thực hiện với
thao tác chắc chắn được commit.

Nếu không xác định được kết quả transaction, phải ghi rõ.

#### G. Dependencies

Liệt kê:

- Java class/method sử dụng bảng trực tiếp.
- Stored procedure/function sử dụng bảng.
- Trigger liên quan, nếu có.
- Các bảng khác phụ thuộc vào dữ liệu này.

#### H. Evidence và lưu ý

Đưa liên kết nguồn, các điểm chưa xác minh và lưu ý
cần thiết khi đọc hoặc kiểm tra dữ liệu.

### 5.3. Giới hạn độ chi tiết

Không bắt buộc phân tích toàn bộ cột của mọi bảng.

CORE: phân tích kỹ các cột và logic liên quan.

SUPPORTING: tập trung vào khóa, giá trị cấu hình và
những trường ảnh hưởng trực tiếp đến nghiệp vụ.

AUDIT / INTEGRATION: giải thích dữ liệu được ghi nhận,
thời điểm ghi và mối liên kết với bản ghi chính.

INDIRECT: tối thiểu ghi tên, vai trò đã xác minh,
đường dẫn dependency và lý do chưa phân tích sâu.

Không được âm thầm bỏ một bảng đã phát hiện.

---

## 6. YÊU CẦU CHI TIẾT: technical-flow.md

### 6.1. Entry Point

Xác định:

- API endpoint, event listener, job hoặc entry point khác.
- HTTP method/path nếu là API.
- Request/response quan trọng.
- Điều kiện validation và authorization.
- Thành phần gọi tiếp theo.

### 6.2. Java Call Chain

Truy vết đường đi thực tế qua các lớp Java.

Ghi rõ:

- Class và method.
- Mục đích của method trong luồng.
- Input/output quan trọng.
- Điều kiện rẽ nhánh.
- Transaction annotation hoặc boundary.
- Exception handling.
- Các lời gọi DB và external service.

### 6.3. Procedure Call Graph

Phải ghi nhận các procedure/function được gọi từ Java
và các lời gọi lồng nhau liên quan.

Mỗi procedure quan trọng cần có:

- Tên đầy đủ schema.object.
- Mục đích trong luồng.
- Input/output parameter quan trọng.
- Procedure/function được gọi tiếp.
- Các bảng được đọc hoặc ghi.
- Điều kiện và business rule chính.
- Error handling và transaction.
- Evidence.

Không kết luận dependency graph đã đầy đủ nếu còn
dynamic SQL hoặc object không truy cập được.

### 6.4. End-to-End Mapping

Tạo bảng liên kết:

Business Step
-> Java Method
-> Procedure / SQL
-> Table
-> Data Operation
-> Business Result

Mục tiêu là giúp người đọc tra ngược từ nghiệp vụ
đến code và database.

### 6.5. Error Handling

Với các lỗi quan trọng, ghi:

- Điều kiện phát sinh.
- Nơi phát sinh.
- Error code/message.
- Java xử lý thế nào.
- Procedure xử lý thế nào.
- Response/event cuối cùng, nếu xác minh được.
- DB có bị rollback hay không.

### 6.6. Transaction

Cần phân tích khi có thao tác ghi:

- Transaction bắt đầu ở đâu?
- Có nested procedure hoặc transaction không?
- Commit/rollback nằm ở đâu?
- Hành vi khi exception xảy ra?
- Những bảng nào có thể bị thay đổi cùng một transaction?

Không tự khẳng định tính atomic chỉ vì nhiều câu SQL
nằm trong cùng một procedure.

Nếu không có đủ bằng chứng, ghi rõ UNKNOWN.

---

## 7. YÊU CẦU CHI TIẾT: open-questions.md

Mỗi câu hỏi phải có:

- ID: Q-001, Q-002...
- Chủ đề.
- Câu hỏi cần làm rõ.
- Lý do cần xác minh.
- Bằng chứng hiện có.
- Thành phần có thể xác nhận: BA / Developer / DBA.
- Trạng thái: OPEN / RESOLVED.
- Kết luận và nguồn xác nhận khi đã giải quyết.

Phân nhóm:

1. Business Questions.
2. Database Questions.
3. Technical Questions.
4. Missing Evidence / Unreachable Dependencies.

Ví dụ:

Q-001:
STATUS = 2 có ý nghĩa nghiệp vụ gì?

Current evidence:
Procedure kiểm tra STATUS = 2 nhưng chưa tìm thấy mapping.

Verification:
UNKNOWN.

Suggested owner:
BA / Developer.

Không đưa một giả định vào phần kết luận chính khi câu hỏi
liên quan vẫn chưa được giải quyết.

---

## 8. QUY TẮC EVIDENCE

### 8.1. Các nguồn được chấp nhận

- Java source code.
- SQL và định nghĩa stored procedure/function.
- Database metadata/schema/constraints.
- Enum và configuration.
- Unit/integration tests.
- Tài liệu nghiệp vụ được cung cấp.
- Kết quả runtime, nếu thực sự được kiểm chứng.

Không sử dụng tên object làm bằng chứng duy nhất cho
một kết luận về mục đích nghiệp vụ.

### 8.2. Định dạng evidence

Mỗi evidence phải đủ thông tin để người đọc tìm lại nguồn.

Ví dụ Java:

src/main/java/.../PaymentService.java
Method: approvePayment()
Lines: 120-145
Commit: <commit-sha>

Ví dụ Database:

Database: PAYMENT_DB
Schema: dbo
Object: SP_APPROVE_PAYMENT
Section: UPDATE PAYMENT_REQUEST
Retrieved at: <timestamp>
Environment: <environment-name>

Nếu có snapshot SQL được phép lưu trong repository,
có thể liên kết trực tiếp tới snapshot.

Không bắt buộc gán số dòng cho SQL nếu không có
nguồn ổn định để xác định số dòng.

### 8.3. Không bịa bằng chứng

Không tạo đường dẫn file hoặc số dòng giả.

Không ghi VERIFIED khi chỉ có suy luận từ tên object.

Không ghi đã kiểm thử runtime nếu mới chỉ đọc code.

Khi Java và DB cho thấy hành vi khác nhau, phải ghi rõ
mâu thuẫn và nguồn của từng nhận định.

---

## 9. QUY TẮC TRÌNH BÀY

### 9.1. Markdown

Sử dụng heading rõ ràng, bảng và liên kết nội bộ.

Không tạo đoạn văn quá dài.

Ưu tiên giải thích ngắn trước, chi tiết kỹ thuật sau.

### 9.2. Mermaid

Sử dụng khi phù hợp:

- flowchart: luồng nghiệp vụ.
- stateDiagram-v2: vòng đời trạng thái.
- erDiagram: quan hệ dữ liệu.
- sequenceDiagram: tương tác giữa thành phần.
- flowchart: procedure call graph.

Không vẽ sơ đồ quá lớn khiến người đọc không theo dõi được.

Nếu sơ đồ phức tạp, chia thành sơ đồ tổng quan và chi tiết.

Không vẽ quan hệ hoặc nhánh xử lý chưa được xác minh
như thể chúng đã được xác nhận.

### 9.3. Liên kết nội bộ

README.md phải có mục lục và liên kết tới:

- Các bảng quan trọng trong database.md.
- Các procedure trong technical-flow.md.
- Các business rule liên quan.
- Các câu hỏi trong open-questions.md.

Mã BR-xxx, Q-xxx phải nhất quán giữa các file.

### 9.4. Giữ báo cáo dễ đọc

Không nhúng toàn bộ source Java hoặc SQL vào báo cáo chính.

Chỉ trích những đoạn code cần thiết để giải thích hành vi.

Với bảng/procedure quá dài, ưu tiên mô tả, bảng tóm tắt
và liên kết tới evidence.

---

## 10. COVERAGE & INVESTIGATION STATUS

Báo cáo phải công khai mức độ điều tra.

Ghi rõ:

- Phạm vi đã điều tra.
- Các entry point đã kiểm tra.
- Các procedure/function đã kiểm tra.
- Các bảng được phân tích chi tiết.
- Các bảng chỉ ghi nhận ở mức tổng quan.
- Các dependency chưa truy vết được.
- Những điểm chưa xác minh.
- Có hay không có kiểm thử runtime.

Status = Complete chỉ được sử dụng khi đã đáp ứng phạm vi
điều tra xác định và mọi giới hạn còn lại đều được ghi rõ.

Complete không có nghĩa toàn bộ nghiệp vụ đã được kiểm
chứng bằng runtime hoặc mọi suy luận đều đã xác minh.

Status = Partial khi còn thiếu thông tin quan trọng
ảnh hưởng đến khả năng giải thích nghiệp vụ.

Không coi việc phát hiện đủ số lượng bảng/procedure là
bằng chứng rằng luồng nghiệp vụ đã được hiểu đầy đủ.

---

## 11. YÊU CẦU AN TOÀN DỮ LIỆU

Hoạt động điều tra mặc định là read-only.

- Không thực thi business procedure để thử nghiệm.
- Không thực hiện INSERT/UPDATE/DELETE/DDL.
- Không sửa dữ liệu production.
- Không đưa DB credentials vào báo cáo.
- Không xuất thông tin cá nhân hoặc dữ liệu nhạy cảm
  không cần thiết.
- Chỉ sử dụng metadata và dữ liệu được cấp quyền.
- Nếu cần dữ liệu mẫu, ưu tiên dữ liệu giả lập hoặc
  dữ liệu đã được ẩn danh.

Các truy vấn DB phải được giới hạn bằng quyền truy cập
và công cụ được phép, không chỉ dựa vào yêu cầu trong prompt.

---

## 12. TIÊU CHÍ NGHIỆM THU

Báo cáo đạt yêu cầu khi:

[ ] Người mới hiểu nghiệp vụ mà không cần mở source code.

[ ] Có luồng xử lý và các nhánh nghiệp vụ quan trọng.

[ ] Có danh sách bảng DB liên quan và vai trò từng bảng.

[ ] Các bảng chính được giải thích đủ để hiểu nghiệp vụ.

[ ] Các cột quan trọng có ý nghĩa và cách sử dụng rõ ràng.

[ ] Quan hệ bảng được giải thích, không suy đoán cardinality.

[ ] Các business rule có điều kiện, kết quả và evidence.

[ ] Có luồng Java -> Procedure -> Database -> Response.

[ ] Có mô tả các thao tác ghi và transaction quan trọng.

[ ] Có hướng dẫn xác định điểm bắt đầu debug.

[ ] Các điểm chưa biết và giới hạn được công khai.

[ ] Không có kết luận quan trọng thiếu bằng chứng
mà lại được trình bày như sự thật đã xác minh.

[ ] README.md có thể đọc độc lập và liên kết tới chi tiết.

[ ] Báo cáo không tiết lộ thông tin nhạy cảm.

Nếu thiếu bằng chứng khiến một số tiêu chí không thể đạt,
vẫn phải xuất báo cáo Partial, ghi rõ phần đã điều tra
và phần còn thiếu.

---

## 13. ƯU TIÊN TRIỂN KHAI

Phase 1:
Hoàn thiện README.md và database.md.

Phase 2:
Bổ sung technical-flow.md và open-questions.md.

Phase 3:
Chuẩn hóa evidence, coverage, validation và kiểm thử
tự động cấu trúc báo cáo.

Không hy sinh tính chính xác để tạo báo cáo đầy đủ
về mặt hình thức.

---

## 14. ĐỊNH NGHĨA THÀNH CÔNG

Một Business Investigation Report thành công không chỉ
cho biết hệ thống đang gọi method hoặc procedure nào.

Nó phải giúp người mới hiểu được:

- Nghiệp vụ hoạt động ra sao.
- Dữ liệu nghiệp vụ nằm ở đâu.
- Mỗi bảng và cột quan trọng có tác dụng gì.
- Dữ liệu thay đổi theo những quy tắc nào.
- Code và database phối hợp như thế nào.
- Những gì đã được xác minh và những gì còn chưa biết.

Báo cáo phải có thể sử dụng cho onboarding, điều tra lỗi,
phân tích yêu cầu thay đổi và bàn giao kiến thức kỹ thuật.
