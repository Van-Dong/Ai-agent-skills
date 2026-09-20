# Business Investigator — Hướng dẫn khởi tạo và sử dụng

> Codex Skill dùng chung để điều tra nghiệp vụ Spring Boot/Java và Oracle, giải thích vai trò các bảng/cột, truy vết stored procedure và tạo báo cáo Markdown. Hướng dẫn này dành cho **Windows + Codex chạy local**.

## 1. Kiến trúc

```text
Codex + $business-investigator
           |
           | Đọc .ai-investigator/project.yaml
           v
Local Java Metadata Service (REST API)
           |
           | Oracle JDBC / connection pool
           v
        Oracle Dev

Codex đọc thêm source Java/SQL trong project nghiệp vụ
và xuất docs/business-investigations/<feature-name>/
```

**Phân biệt hai thành phần:** Skill chỉ chứa quy trình, template và hướng dẫn gọi REST. Java Service là ứng dụng **do bạn tự chạy**; có thể dùng service mẫu trong repo hoặc service tự viết đáp ứng [REST Contract v1.0](docs/db-metadata-service-contract.md). **Không cần tạo Java Service mới mỗi lần điều tra.** Không sử dụng MCP, Java CLI hoặc `services.yaml` trong thiết kế này.

## 2. Cần chuẩn bị

- Codex trên Windows, có quyền chạy lệnh terminal và truy cập service ở `127.0.0.1`.
- Skill `business-investigator` đã được cài trên máy.
- Một Java REST Service đang hoặc có thể chạy trên máy, có quyền đọc metadata của Oracle Dev. Nếu dùng service mẫu: **JDK 21, Maven 3.9+**, mạng/VPN đến Oracle Dev và tài khoản Oracle có quyền xem metadata cần thiết.
- Một project nghiệp vụ có source code mà Codex được phép đọc.

> **Quan trọng:** Nếu Codex chạy trên cloud, WSL hoặc môi trường tách biệt, `127.0.0.1` có thể **không phải** máy Windows chứa service. Phải xác minh khả năng kết nối thực tế. Không công khai service ra mạng chỉ để sửa lỗi này.

## 3. Cài Skill — chỉ làm một lần trên máy

Nếu **đã cài skill**, bỏ qua mục này và sang mục 4.

### Cách A: Cài trực tiếp bằng Codex từ GitHub

Trong Codex (nếu môi trường có `$skill-installer`), nhập:

```text
$skill-installer install https://github.com/YOUR_ORG/ai-agent-skills/tree/main/skills/business-investigator
```

Thay `YOUR_ORG` và tên branch phù hợp. Repo private yêu cầu môi trường cài đặt có quyền GitHub. Sau khi cài, mở phiên Codex mới và kiểm tra skill có thể được gọi bằng `$business-investigator`. Bản được cài theo cách sao chép **không tự cập nhật** khi Git thay đổi.

### Cách B: Git Clone + Junction bằng CMD (thuận tiện khi tự sửa skill)

```bat
cd /d D:\Dev
git clone https://github.com/YOUR_ORG/ai-agent-skills.git
mkdir "%USERPROFILE%\.agents\skills"
mklink /J "%USERPROFILE%\.agents\skills\business-investigator" "D:\Dev\ai-agent-skills\skills\business-investigator"
```

Nếu thư mục đích đã tồn tại, **không ghi đè**; kiểm tra bản cài cũ trước. Có thể thay bước `mkdir`/`mklink` bằng `scripts\install-skill.bat` nếu repo của bạn có script này. Kiểm tra:

```bat
dir /AL "%USERPROFILE%\.agents\skills"
type "%USERPROFILE%\.agents\skills\business-investigator\SKILL.md"
```

Với Junction, chỉ cần `git pull --ff-only` trong repo và tạo phiên Codex mới khi cần nhận thay đổi.

## 4. Chuẩn bị Java Metadata Service — thiết lập một lần, chạy khi cần

### 4.1. Nếu bạn tự phát triển service

Service có thể chạy ở bất kỳ cổng local nào, ví dụ `http://127.0.0.1:9090`, **miễn là** triển khai các endpoint, tham số và JSON theo REST Contract v1.0, hoặc bạn có lớp adapter chuyển đổi về contract đó.

Tối thiểu cần:

| Endpoint                                      | Mục đích                                |
| --------------------------------------------- | --------------------------------------- |
| `GET /health`                                 | Kiểm tra process đang chạy              |
| `GET /api/metadata/profiles/{profile}/status` | Xác minh profile và danh tính DB        |
| `GET /api/metadata/objects`                   | Tìm object                              |
| `GET /api/metadata/definitions`               | Đọc source procedure/package            |
| `GET /api/metadata/parameters`                | Lấy parameters                          |
| `GET /api/metadata/dependencies`              | Lấy dependencies được metadata ghi nhận |
| `GET /api/metadata/tables/{tableName}`        | Đọc cột, PK/FK, constraint              |

Các endpoint relationships/triggers được sử dụng khi có hỗ trợ. **Không cung cấp endpoint thực thi SQL bất kỳ hay chạy business procedure.** Định nghĩa URL/profile/schema ở project, không đặt cố định trong Global Skill. Tài khoản Oracle và allowlist phải được service kiểm tra ở phía server.

> **Đồng bộ hướng dẫn:** Nếu bạn đang dùng bản `db-tool-usage.md` từ ZIP ban đầu, ví dụ curl trong đó còn ghi cố định `127.0.0.1:8089` và `oracle-dev`. Cập nhật các ví dụ này thành biến lấy từ `project.yaml` khi dùng service/port khác; không cần thay đổi workflow, output requirements hoặc report template. Tên endpoint/response chỉ thay đổi khi bạn chủ đích nâng phiên bản contract.

### 4.2. Nếu dùng Java Service mẫu trong repository

1. Mở `tools/db-metadata-service` bằng IntelliJ IDEA (hoặc Maven).
2. Dựa trên `tools/db-metadata-service/.env.example`, cấu hình các biến môi trường trong **Run Configuration local** (không commit):

   ```text
   DB_METADATA_API_TOKEN=<random-secret>
   ORACLE_JDBC_URL=jdbc:oracle:thin:@//<host>:1521/<service>
   ORACLE_USERNAME=<metadata-reader>
   ORACLE_PASSWORD=<secret>
   ORACLE_EXPECTED_DB_NAME=<expected-db-name>
   ORACLE_ALLOWED_SCHEMAS=PAYMENT,CUSTOMER
   ```

   `ORACLE_EXPECTED_DB_NAME` phải khớp giá trị `SYS_CONTEXT('USERENV','DB_NAME')` của instance được phép; có thể xác minh bằng công cụ DB/DBA. Cấu hình `metadata.profiles.oracle-dev` hiện nằm ở `tools/db-metadata-service/src/main/resources/application.yml`.

3. Build/test trong terminal của module (nếu máy tải được dependencies):

   ```bat
   mvn clean test package
   ```

4. Chạy `DbMetadataApplication` trong IntelliJ với các biến môi trường trên, hoặc chạy JAR từ terminal đã được cấp những biến đó:

   ```bat
   java -jar target\db-metadata-service-1.0.0.jar
   ```

**Windows CMD không tự đọc file `.env`.** Nếu muốn dùng `.env`, hãy tự cấu hình cơ chế nạp bí mật an toàn. Script `scripts/run-local.sh` trong bản ZIP dùng Bash, không dành cho CMD.

### 4.3. Kiểm tra service trước khi dùng Codex

Ví dụ với service mẫu tại `127.0.0.1:8089` và profile `oracle-dev`:

```bat
curl.exe --silent --show-error --fail-with-body http://127.0.0.1:8089/health

curl.exe --silent --show-error --fail-with-body ^
  -H "X-Metadata-Token: %DB_METADATA_API_TOKEN%" ^
  http://127.0.0.1:8089/api/metadata/profiles/oracle-dev/status
```

Biến `DB_METADATA_API_TOKEN` phải có trong **terminal thực hiện yêu cầu**; với service tự viết, dùng cơ chế xác thực tương ứng. Kết quả profile phải cho biết `connected=true` và đúng danh tính Oracle Dev. **`/health` trả UP không chứng minh DB đã kết nối.** Không in token lên màn hình hoặc đưa token vào repository, prompt hay báo cáo. Khi truyền token qua curl CLI, cân nhắc chính sách bảo mật máy local vì đối số process có thể bị quan sát bởi phần mềm khác.

## 5. Cấu hình từng project nghiệp vụ — một lần cho mỗi project

Tại root của project cần điều tra, tạo `.ai-investigator/project.yaml`:

```yaml
project:
  name: payment-service

database:
  type: oracle
  connectionProfile: oracle-dev
  defaultSchema: PAYMENT
  metadataServiceBaseUrl: http://127.0.0.1:8089
  contractVersion: "1.0"

investigation:
  sourceRoots:
    - src/main/java
    - src/main/resources
  outputDirectory: docs/business-investigations
  reportLanguage: vi
  traceNestedProcedures: true
  includeDataImpact: true
  includeErrorHandling: true
```

Thay `payment-service`, `PAYMENT`, URL và profile theo project và service thực tế. `contractVersion` là khai báo contract kỳ vọng để hướng dẫn Codex; service mẫu không tự kiểm tra trường YAML này. **Không lưu JDBC URL, mật khẩu hoặc API token trong `project.yaml`.**

File cấu hình này là quy ước của Business Investigator, không phải file Codex tự nhận diện nếu không có hướng dẫn Skill. Mỗi project dùng riêng một cấu hình; không cần copy Skill vào từng repository.

## 6. Khởi chạy điều tra — mỗi lần sử dụng

1. Mở/kiểm tra Java Metadata Service đang chạy và Oracle profile hợp lệ.
2. Mở Codex **trong root project nghiệp vụ**, không phải trong repo `ai-agent-skills`.
3. Đảm bảo tiến trình Codex có biến token/cơ chế xác thực phù hợp nếu service yêu cầu. Ví dụ, nếu dùng Codex CLI, khởi chạy từ terminal đã được cấu hình biến `DB_METADATA_API_TOKEN`.
4. Nhập yêu cầu:

```text
$business-investigator

Điều tra nghiệp vụ phê duyệt thanh toán.
Entry point: PaymentService.approvePayment

Yêu cầu:
- Truy vết luồng Java và các procedure/function Oracle liên quan.
- Giải thích vai trò từng bảng DB và các cột quan trọng.
- Xác định quan hệ bảng, business rules, trạng thái và thao tác đọc/ghi.
- Tạo báo cáo bằng tiếng Việt theo report-template.md.
- Không sửa application code và không thực thi business procedure.
```

Codex đọc `project.yaml`, truy vết source, gọi service qua REST, xác minh evidence rồi tạo báo cáo. **Codex không tự tạo, khởi động hoặc cấu hình lại Java Service.**

### Kết quả dự kiến

```text
payment-service/
└── docs/business-investigations/
    └── payment-approval/
        ├── README.md             # Tổng quan nghiệp vụ, flow, bảng chính
        ├── database.md           # Vai trò bảng, cột, quan hệ, read/write
        ├── technical-flow.md     # Java -> PL/SQL -> DB, lỗi, transaction
        └── open-questions.md     # Những phần chưa xác minh
```

Với nghiệp vụ nhỏ, skill có thể gộp nội dung vào `README.md`; các file chi tiết chỉ tạo khi cần. Báo cáo phải ghi `VERIFIED / INFERRED / UNKNOWN` và `Complete / Partial` theo bằng chứng thực tế.

## 7. Kiểm tra lỗi thường gặp

| Hiện tượng                                | Cách xử lý                                                                                      |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Codex không thấy `$business-investigator` | Kiểm tra thư mục cài và `SKILL.md`; mở phiên Codex mới.                                         |
| `/health` không gọi được                  | Kiểm tra service đang chạy, port/bind address và môi trường mạng của Codex.                     |
| HTTP `401`                                | Kiểm tra cơ chế auth/token trong terminal chạy Codex; không in token.                           |
| HTTP `403`                                | Kiểm tra connection profile, schema allowlist và quyền Oracle.                                  |
| Profile báo không kết nối / HTTP `503`    | Kiểm tra VPN, Oracle JDBC URL, tài khoản và `ORACLE_EXPECTED_DB_NAME`.                          |
| `NOT_FOUND` hoặc source không đọc được    | Kiểm tra schema, object type (`PACKAGE` khác `PACKAGE_BODY`), quyền `ALL_SOURCE`, wrapped code. |
| Không thấy procedure lồng nhau            | `ALL_DEPENDENCIES` là dependency cấp object; cần kiểm tra source PL/SQL và dynamic SQL.         |
| Codex gọi sai URL hoặc profile            | Đồng bộ `project.yaml` với `db-tool-usage.md`; không sử dụng `services.yaml`.                   |
| Báo cáo thiếu thông tin DB                | Xem `open-questions.md`; nếu nguồn quan trọng thiếu, báo cáo phải là `Partial`.                 |

## 8. Tài liệu tham chiếu và cập nhật

- `skills/business-investigator/SKILL.md`: bộ điều phối.
- `skills/business-investigator/references/output-requirements.md`: đặc tả báo cáo.
- `skills/business-investigator/references/investigation-workflow.md`: quy trình điều tra.
- `skills/business-investigator/references/report-template.md`: mẫu Markdown.
- `skills/business-investigator/references/db-tool-usage.md`: hướng dẫn gọi Local REST Service.
- `skills/business-investigator/references/metadata-contract-v1.md`: contract REST v1.0 dùng khi gọi metadata service.
- `docs/db-metadata-service-contract.md`: API contract chuẩn.
- `tools/db-metadata-service/README.md`: hướng dẫn service mẫu (nếu dùng).

Nếu cài Skill bằng **Junction**, cập nhật repo với `git pull --ff-only`. Nếu cài bằng **Skill Installer**, bản sao trên máy không tự đồng bộ; cần cập nhật bản đã cài theo cơ chế installer. Java Service chỉ cần chạy một lần trong phiên làm việc và tái sử dụng connection pool cho nhiều lượt điều tra.

**An toàn:** chỉ truy cập Oracle Dev qua service được cho phép; không chạy SQL tùy ý, business procedure, DML/DDL, không đưa secrets hoặc dữ liệu nhạy cảm vào báo cáo.
