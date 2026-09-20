# DB METADATA SERVICE CONTRACT

Version: 1.0
Target: Business Investigator Skill
Implementation: Local Spring Boot REST Service
Database: Oracle Dev
Transport: HTTP / JSON

---

## 1. Mục tiêu

Cung cấp REST API để Codex truy xuất database metadata
phục vụ điều tra nghiệp vụ.

Ứng dụng Java chạy độc lập trên máy developer.

Java Service chịu trách nhiệm:

- Quản lý Oracle JDBC connection pool.
- Đọc định nghĩa procedure, function và package.
- Truy xuất schema bảng, cột, constraint và relationship.
- Truy xuất dependency và metadata của trigger.
- Trả dữ liệu kỹ thuật theo JSON contract thống nhất.

Codex chịu trách nhiệm:

- Truy vết Java và PL/SQL.
- Phân tích business rules.
- Giải thích vai trò nghiệp vụ của bảng/cột.
- Kiểm chứng bằng chứng.
- Sinh Business Investigation Report.

Java Service không tự diễn giải ý nghĩa nghiệp vụ.

---

## 2. Kiến trúc

Codex
|
| HTTP GET
v
Spring Boot Metadata REST API
|
v
MetadataService
|
v
OracleMetadataAdapter
|
v
HikariCP + Oracle JDBC
|
v
Oracle Dev

Ứng dụng Java được developer khởi động trước.

Codex chỉ gọi HTTP API, không khởi động lại service
hoặc tự quản lý connection.

---

## 3. Service Configuration

### 3.1. HTTP Server

Example Base URL:

http://127.0.0.1:8089

Service phải bind vào 127.0.0.1, không mặc định
lắng nghe trên mọi network interface.

Không expose REST API ra Internet.

Nếu môi trường local không được cách ly tin cậy,
cần bổ sung authentication/authorization.

### 3.2. Connection Profiles

Service quản lý danh sách connection profile được phép.

Ví dụ:

oracle-dev:
databaseType: ORACLE
environment: DEV
allowedSchemas: - PAYMENT - CUSTOMER

Connection profile chỉ là định danh logic.

JDBC URL, username, password và các secret khác
được quản lý ngoài source repository.

Không cho phép client truyền JDBC URL hoặc credentials.

Không cho phép client tự thêm hoặc sửa connection profile
thông qua REST API.

Service phải kiểm tra profile và schema ở phía server.

### 3.3. Connection Pool

Sử dụng HikariCP để quản lý và tái sử dụng JDBC connections.

Connection phải được trả lại pool sau mỗi thao tác.

Không giữ một connection riêng cho mỗi phiên Codex.

Giới hạn:

- Maximum pool size.
- Connection timeout.
- Query timeout.
- Request timeout.
- Response size.

Ưu tiên sử dụng Oracle account có quyền tối thiểu,
chỉ được xem metadata cần thiết.

---

## 4. API Conventions

Base path:

/api/metadata

Các API đọc metadata sử dụng HTTP GET.

Query parameters sử dụng lowerCamelCase.

Ví dụ:

profile
schema
name
type
packageName
subprogramName

Tất cả endpoint phải trả application/json.

Các định danh Oracle phải được xử lý phù hợp với
quy tắc quoted/unquoted identifier.

Không tự chuyển đổi chữ hoa/chữ thường đối với
quoted identifier.

Khi object có nhiều overload hoặc bị trùng tên,
phải phân giải rõ identity thay vì chọn ngẫu nhiên.

---

## 5. Common Response Envelope

Mọi metadata endpoint sử dụng cấu trúc response chung:

{
"status": "OK",
"source": {
"connectionProfile": "oracle-dev",
"database": "ORCLDEV",
"schema": "PAYMENT",
"objectName": "PKG_PAYMENT",
"objectType": "PACKAGE_BODY",
"retrievedAt": "<ISO-8601 timestamp>",
"definitionHash": null
},
"data": {},
"coverage": {
"complete": true
},
"warnings": [],
"error": null
}

### Status

OK:
Truy xuất thành công dữ liệu trong phạm vi request.

PARTIAL:
Truy xuất được một phần nhưng còn thông tin thiếu.

NOT_FOUND:
Không tìm thấy object trong phạm vi được phép.

ACCESS_DENIED:
Không đủ quyền truy cập.

ERROR:
Lỗi kỹ thuật hoặc lỗi khác.

### Quy tắc

- source mô tả nguồn dữ liệu thực tế.
- data chứa kết quả riêng của từng endpoint.
- coverage mô tả mức độ đầy đủ của kết quả.
- warnings ghi các giới hạn hoặc thông tin cần lưu ý.
- error chứa mã lỗi và thông báo an toàn.

Trường không xác định được trả null hoặc UNKNOWN.

Không điền giá trị giả để hoàn thiện JSON.

coverage.complete không đồng nghĩa với việc
toàn bộ business dependency đã được xác minh.

---

## 6. REST Endpoints

### 6.1. GET /health

Purpose:
Kiểm tra Java Service có đang chạy hay không.

Request:

GET http://127.0.0.1:8089/health

Example response:

{
"status": "UP",
"service": "db-metadata-service",
"version": "1.0"
}

Health chỉ xác nhận service đang hoạt động.

Không coi health = UP là bằng chứng rằng một Oracle
connection profile cụ thể đang kết nối thành công.

Không trả về credential hoặc thông tin nhạy cảm.

---

### 6.2. GET /api/metadata/objects

Purpose:
Tìm database object theo tên và loại.

Query parameters:

- profile: required
- schema: optional
- namePattern: optional
- objectTypes: optional
- limit: optional
- cursor: optional

Example:

GET /api/metadata/objects
?profile=oracle-dev
&schema=PAYMENT
&namePattern=PKG_PAYMENT

Response data:

{
"objects": [
{
"schema": "PAYMENT",
"objectName": "PKG_PAYMENT",
"objectType": "PACKAGE"
},
{
"schema": "PAYMENT",
"objectName": "PKG_PAYMENT",
"objectType": "PACKAGE_BODY"
}
],
"nextCursor": null
}

Requirements:

- Chỉ tìm trong schema được phép.
- Hỗ trợ phân trang và giới hạn kết quả.
- Không truy vấn dữ liệu nghiệp vụ.
- Không coi object không xuất hiện trong kết quả
  bị giới hạn là object không tồn tại.

---

### 6.3. GET /api/metadata/definitions

Purpose:
Lấy source SQL/PLSQL của một database object.

Query parameters:

- profile: required
- schema: required
- name: required
- type: required
- startLine: optional, default 1
- maxLines: optional, server-limited

Supported types:

PROCEDURE
FUNCTION
PACKAGE
PACKAGE_BODY
VIEW
TRIGGER

Example:

GET /api/metadata/definitions
?profile=oracle-dev
&schema=PAYMENT
&name=PKG_PAYMENT
&type=PACKAGE_BODY

Response data:

{
"definition": "...",
"startLine": 1,
"endLine": 200,
"totalLines": 200,
"nextLine": null,
"definitionAvailable": true
}

Requirements:

- Trả về source gốc, không tóm tắt hoặc viết lại.
- Giữ đúng thứ tự dòng.
- Hỗ trợ lấy từng đoạn với source dài.
- nextLine khác null khi còn nội dung.
- definitionHash, nếu có, phải được tính trên
  toàn bộ definition chứ không chỉ đoạn hiện tại.

Đối với Oracle packaged procedure, lấy PACKAGE_BODY
để phân tích implementation.

PACKAGE specification chỉ mô tả interface và
không đủ để kết luận toàn bộ hành vi thực thi.

---

### 6.4. GET /api/metadata/parameters

Purpose:
Lấy tham số của procedure hoặc function.

Query parameters:

- profile: required
- schema: required
- name: required
- type: required
- packageName: optional
- subprogramName: optional
- overload: optional

Example standalone procedure:

GET /api/metadata/parameters
?profile=oracle-dev
&schema=PAYMENT
&name=SP_APPROVE_PAYMENT
&type=PROCEDURE

Example packaged procedure:

GET /api/metadata/parameters
?profile=oracle-dev
&schema=PAYMENT
&name=PKG_PAYMENT
&type=PACKAGE
&subprogramName=APPROVE

Response data:

{
"parameters": [
{
"name": "P_PAYMENT_ID",
"position": 1,
"direction": "IN",
"dataType": "NUMBER",
"hasDefault": false
},
{
"name": "P_RESULT",
"position": 2,
"direction": "OUT",
"dataType": "VARCHAR2",
"hasDefault": null
}
]
}

Requirements:

- Giữ nguyên thứ tự tham số.
- Hỗ trợ IN, OUT, INOUT và RETURN.
- Hỗ trợ packaged subprogram và overload.
- Không trộn tham số của nhiều overload.
- Với argument có cấu trúc phức tạp, bảo toàn
  metadata cần thiết nếu Oracle cung cấp.
- Không suy luận ý nghĩa nghiệp vụ của parameter.

Nếu không xác định được một overload duy nhất,
trả lỗi AMBIGUOUS_OBJECT hoặc yêu cầu thêm identity.

---

### 6.5. GET /api/metadata/dependencies

Purpose:
Lấy các object dependency đã được Oracle ghi nhận.

Query parameters:

- profile: required
- schema: required
- name: required
- type: required

Example:

GET /api/metadata/dependencies
?profile=oracle-dev
&schema=PAYMENT
&name=PKG_PAYMENT
&type=PACKAGE_BODY

Response data:

{
"dependencies": [
{
"targetSchema": "PAYMENT",
"targetObject": "PAYMENT_REQUEST",
"targetType": "TABLE",
"dependencyKind": "REFERENCE",
"resolution": "STATIC"
}
],
"metadataOnly": true,
"dynamicSqlDetected": "UNKNOWN",
"completeCallGraph": false
}

Requirements:

- Trả các dependency mà Oracle metadata ghi nhận.
- Không tự khẳng định dependencyKind = READ/WRITE
  khi metadata không cho biết loại thao tác.
- Không coi dependency package-level là bằng chứng
  rằng một subprogram cụ thể thực hiện lời gọi.
- Không coi danh sách dependency là call graph hoàn chỉnh.
- Dynamic SQL và unresolved reference phải được
  Codex tiếp tục kiểm tra từ source.

Nếu không thể xác minh toàn bộ dependency, phải
ghi rõ giới hạn.

---

### 6.6. GET /api/metadata/tables/{tableName}

Purpose:
Lấy cấu trúc bảng và constraint.

Query parameters:

- profile: required
- schema: required

Path parameter:

- tableName: required

Example:

GET /api/metadata/tables/PAYMENT_REQUEST
?profile=oracle-dev
&schema=PAYMENT

Response data:

{
"table": {
"schema": "PAYMENT",
"name": "PAYMENT_REQUEST"
},
"columns": [
{
"name": "PAYMENT_ID",
"dataType": "NUMBER",
"nullable": false,
"isPrimaryKey": true
},
{
"name": "STATUS",
"dataType": "NUMBER",
"nullable": true,
"isPrimaryKey": false
}
],
"constraints": [
{
"name": "PK_PAYMENT_REQUEST",
"type": "PRIMARY_KEY",
"columns": ["PAYMENT_ID"]
}
]
}

Requirements:

- Trả metadata về column và constraint.
- Hỗ trợ PK, FK, UNIQUE và các constraint liên quan.
- Không trả dữ liệu bản ghi nghiệp vụ.
- Không suy luận ý nghĩa của bảng/cột từ tên.
- Không tự tạo foreign key khi không tồn tại trong DB.

Các column được Business Investigator chọn lọc
theo mức độ liên quan khi sinh database.md.

---

### 6.7. GET /api/metadata/relationships

Purpose:
Lấy các quan hệ FK của một bảng với các bảng khác.

Query parameters:

- profile: required
- schema: required
- tableName: required

Response data:

{
"relationships": [
{
"sourceTable": "PAYMENT_DETAIL",
"sourceColumns": ["PAYMENT_ID"],
"targetTable": "PAYMENT_REQUEST",
"targetColumns": ["PAYMENT_ID"],
"constraintName": "FK_PAYMENT_DETAIL_REQUEST",
"evidenceType": "FOREIGN_KEY",
"cardinality": null
}
]
}

Requirements:

- Chỉ trả quan hệ được metadata xác nhận.
- Không tự khẳng định cardinality khi thiếu bằng chứng.
- Quan hệ logic phát hiện từ Java/SQL phải được
  Codex phân tích và dẫn evidence riêng.

---

### 6.8. GET /api/metadata/triggers

Purpose:
Tìm trigger liên quan đến thao tác trên một bảng.

Query parameters:

- profile: required
- schema: required
- tableName: required

Response data:

{
"triggers": [
{
"schema": "PAYMENT",
"triggerName": "TRG_PAYMENT_AUDIT",
"timing": "AFTER",
"events": ["UPDATE"],
"enabled": true,
"definitionAvailable": true
}
]
}

Requirements:

- Chỉ đọc trigger metadata.
- Không thực thi trigger.
- Có thể dùng definitions endpoint để xem source
  trigger khi cần điều tra side effects.

---

## 7. Oracle Metadata Sources

Oracle Adapter có thể sử dụng:

| Metadata      | Oracle Data Dictionary            |
| ------------- | --------------------------------- |
| Object list   | ALL_OBJECTS                       |
| PL/SQL source | ALL_SOURCE                        |
| Parameters    | ALL_ARGUMENTS                     |
| Columns       | ALL_TAB_COLUMNS                   |
| Constraints   | ALL_CONSTRAINTS, ALL_CONS_COLUMNS |
| Dependencies  | ALL_DEPENDENCIES                  |
| Triggers      | ALL_TRIGGERS                      |

Các view trên cung cấp metadata trong phạm vi
mà tài khoản Oracle có thể truy cập.

Không sử dụng quyền DBA chỉ để đáp ứng công cụ điều tra
nếu tài khoản thông thường có thể được cấp quyền cần thiết.

### Oracle-specific limitations

- Package specification và package body là hai object type
  khác nhau trong metadata source.
- Procedure/function bên trong package không nhất thiết
  xuất hiện như object độc lập trong ALL_OBJECTS.
- ALL_DEPENDENCIES thường cung cấp dependency ở
  cấp object/package, không phải toàn bộ subprogram call graph.
- Dynamic SQL có thể không xuất hiện trong dependency metadata.
- Definition bị wrapped hoặc hạn chế quyền có thể
  không đọc được đầy đủ.
- Thông tin overload cần được phân giải cẩn thận.

Không tự lấp đầy những giới hạn này bằng suy luận.

---

## 8. Error Handling

API cần phân biệt các error code:

INVALID_ARGUMENT
PROFILE_NOT_ALLOWED
NOT_FOUND
ACCESS_DENIED
AMBIGUOUS_OBJECT
UNSUPPORTED_OPERATION
TIMEOUT
METADATA_UNAVAILABLE
INTERNAL_ERROR

Error response:

{
"status": "ERROR",
"source": null,
"data": null,
"coverage": {
"complete": false
},
"warnings": [],
"error": {
"code": "PROFILE_NOT_ALLOWED",
"message": "The requested profile is not allowed.",
"retryable": false
}
}

HTTP status mapping đề xuất:

200: OK hoặc PARTIAL có dữ liệu hợp lệ
400: INVALID_ARGUMENT
403: PROFILE_NOT_ALLOWED / ACCESS_DENIED
404: NOT_FOUND
409: AMBIGUOUS_OBJECT
503: METADATA_UNAVAILABLE
504: TIMEOUT
500: INTERNAL_ERROR

Application status và HTTP status phải nhất quán.

Không trả stack trace, JDBC URL, password hoặc thông tin
nhạy cảm trong error response.

---

## 9. Security Requirements

Security phải được enforce ở Java Service.

Bắt buộc:

1. Bind vào 127.0.0.1.
2. Chỉ sử dụng connection profile được allowlist.
3. Giới hạn schema và object được phép truy cập.
4. Sử dụng Oracle account có quyền tối thiểu.
5. Không cung cấp endpoint thực thi arbitrary SQL.
6. Không thực thi business procedure/function.
7. Không cung cấp endpoint thay đổi DB hoặc credentials.
8. Giới hạn thời gian truy vấn và kích thước response.
9. Không trả về dữ liệu nghiệp vụ nhạy cảm.
10. Không ghi secrets vào log.

Không coi việc chạy trên localhost là thay thế hoàn toàn
cho authentication trong môi trường không đáng tin cậy.

---

## 10. Integration With Business Investigator

Codex sử dụng service theo trình tự:

1. Đọc project configuration.
2. Xác định connection profile được phép.
3. Kiểm tra GET /health.
4. Tìm hoặc xác định DB object.
5. Lấy definition và parameters.
6. Lấy dependency metadata.
7. Đọc nested procedure/function liên quan.
8. Lấy table schema, constraints và relationships.
9. Đọc trigger metadata khi cần.
10. Đối chiếu Java, PL/SQL và metadata.
11. Sinh báo cáo theo report-template.md.

Nếu service không cung cấp đủ thông tin, Codex tiếp tục
với source code hoặc SQL snapshot khi có.

Không tạo dữ liệu giả để bù thông tin thiếu.

---

## 11. Acceptance Criteria

Java Service v1.0 đạt yêu cầu khi:

[ ] Codex gọi được service qua localhost.

[ ] Service tái sử dụng Oracle connection pool.

[ ] Chỉ truy cập profile và schema được phép.

[ ] Lấy được source procedure/function/package.

[ ] Lấy được parameters, kể cả packaged subprogram
khi Oracle metadata hỗ trợ.

[ ] Lấy được dependency metadata có cảnh báo giới hạn.

[ ] Lấy được cấu trúc bảng, cột và constraint.

[ ] Lấy được quan hệ FK trong phạm vi truy cập.

[ ] Trả về JSON response envelope nhất quán.

[ ] Phân biệt OK, PARTIAL, NOT_FOUND và lỗi truy cập.

[ ] Không cung cấp arbitrary SQL execution.

[ ] Có thể dùng để sinh Business Investigation Report
mà không sửa output-requirements.md.

Các phần mở rộng như phân tích SQL tự động hoặc cache
metadata dài hạn không bắt buộc trong MVP.

---

## 12. Nguyên tắc hoàn thành

DB Metadata Service chỉ cung cấp thông tin kỹ thuật.

Business Investigator vẫn chịu trách nhiệm:

- Truy vết luồng Java/SQL.
- Xác định tác dụng của từng bảng trong nghiệp vụ.
- Chọn và giải thích các cột quan trọng.
- Tái dựng business rules và state transitions.
- Kiểm chứng kết luận.
- Ghi nhận INFERRED và UNKNOWN.
- Tạo báo cáo theo output requirements.

Không coi kết quả đọc metadata là bằng chứng đầy đủ
cho toàn bộ hành vi runtime.
