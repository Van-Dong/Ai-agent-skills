---
name: business-investigator
description: >
  Investigate business features in Java/Spring Boot projects,
  including API flows, services, stored procedures, database
  tables, important columns, relationships, business rules,
  and data changes. Generate evidence-based Vietnamese
  onboarding and technical investigation reports.
  Use when asked to understand, document, or trace a business
  feature, API, Java method, stored procedure, or its database
  behavior. Do not use for ordinary coding tasks unless
  business investigation is requested.
---

# Business Investigator

## 1. Purpose

Investigate a business feature end-to-end and produce a report
that helps a developer unfamiliar with the project understand:

- What the business feature does and how it works.
- Which database tables are involved and their business roles.
- Which columns are important and how they are used.
- How tables relate to each other.
- How Java, SQL, and stored procedures implement the feature.
- Where data is read, inserted, updated, or deleted.
- Where to start when debugging or modifying the feature.

Prioritize business understanding and database knowledge,
not merely technical call-chain documentation.

Use Vietnamese for explanations and preserve original
technical identifiers.

## 2. Required References

Resolve all reference paths relative to this SKILL.md file,
not relative to the current project's working directory.

Required files:

- references/output-requirements.md
- references/investigation-workflow.md
- references/report-template.md

Database integration reference:

- references/db-tool-usage.md

Before starting an investigation:

1. Read output-requirements.md to understand the deliverables.
2. Read investigation-workflow.md and follow its execution steps.
3. Read db-tool-usage.md when an authorized local DB Metadata
   Service is configured or available for the current project.
4. Read report-template.md before generating the final report.

These references define the detailed requirements.

Do not duplicate their contents in this file.

If a required reference is missing or inaccessible, identify
the missing file. Do not claim full compliance with the
report specification.

## 3. Input & Scope

Accept one or more of the following:

- Business feature name or description.
- API endpoint.
- Java class or method.
- Stored procedure or function.
- Scheduled job, event listener, or other entry point.

Use the current project as the default investigation target.

Determine the investigation scope from the user's request
and available project evidence.

If multiple entry points belong to the same feature,
include the relevant paths and document their relationship.

Do not silently expand the investigation into unrelated
business features.

Record scope assumptions and unresolved ambiguity.

## 4. Project Preparation

Before investigating:

1. Identify the current repository and project root.
2. Read applicable project AGENTS.md instructions.
3. Read project README and relevant technical documentation.
4. Read .ai-investigator/project.yaml if it exists.
5. Identify source roots, framework, database technology,
   and data-access patterns.
6. Record the current Git commit when available.
7. Identify the authorized database environment.

### Database Service Configuration

If .ai-investigator/project.yaml exists, resolve:

- database.type
- database.connectionProfile
- database.defaultSchema
- database.metadataServiceBaseUrl
- database.contractVersion

When a DB Metadata Service is configured:

1. Read references/db-tool-usage.md.
2. Use metadataServiceBaseUrl directly from project.yaml.
3. Verify that the configured service URL is authorized.
4. Check service availability using its health endpoint.
5. Verify the selected connection profile is authorized.
6. Use only REST endpoints defined by the configured
   contract version.

Do not use a global service registry.

Do not guess or discover alternative service URLs,
connection profiles, or database environments.

Do not start, stop, restart, or reconfigure the Java service
automatically.

The Java service is expected to be started and configured
by the developer.

### Missing Configuration

Project configuration is optional.

If project.yaml is absent, discover project structure and
database usage from available source code.

Do not assume that Spring Boot, a particular JDBC library,
a specific database, or a DB Metadata Service is always present.

If metadataServiceBaseUrl, connectionProfile, or the intended
database environment cannot be established, do not query
a live database.

If the configured service is unavailable or incompatible,
do not automatically switch to another service or database.

Continue investigating using available source code,
SQL definitions, migrations, and metadata snapshots.

Record missing database evidence and investigation limitations.

Generate a Partial report when critical database information
cannot be verified.

## 5. Execute Investigation

Follow references/investigation-workflow.md.

The required stages are:

### Stage 1 — Scope Discovery

Identify the entry point, inputs, outputs, project version,
target DB environment, and investigation boundaries.

### Stage 2 — Java Trace

Follow relevant execution paths through:

Entry Point
-> Controller / Job / Listener
-> Service
-> Repository / DAO / Mapper
-> SQL / Stored Procedure

Inspect validation, branching, mapping, authorization,
transaction boundaries, exceptions, configuration,
and relevant external calls.

### Stage 3 — Database Trace

Inspect relevant SQL, procedures, functions, and tables.

Follow nested procedure/function calls.

Collect:

- Procedure parameters and important branches.
- Table inventory and dependencies.
- Important columns and value mappings.
- Table relationships.
- SELECT / INSERT / UPDATE / DELETE operations.
- Error handling, transactions, and relevant triggers.

Track visited objects to prevent repeated or cyclic analysis.

Do not assume that database dependency metadata is complete.

### Stage 4 — Business Analysis

Reconstruct:

- Business summary and execution flow.
- Business rules and state transitions.
- Business purpose of each relevant table.
- Important column meanings.
- Relationships and data changes.

Explain observed business behavior in plain Vietnamese.

### Stage 5 — Verification

Cross-check Java, SQL, configuration, metadata, and other
available evidence.

Classify important conclusions as:

- VERIFIED
- INFERRED
- UNKNOWN

Distinguish verified technical behavior from verified
business meaning.

Record contradictions, missing evidence, and unresolved
dependencies.

### Stage 6 — Report Generation

Generate the report using report-template.md.

### Stage 7 — Quality Check

Validate the report against output-requirements.md
before declaring completion.

Do not skip the verification or quality-check stages.

## 6. Database Access Policy

Use the authorized local Java DB Metadata Service when
it is configured and reachable from the current environment.

The service runs independently from Codex and manages
Oracle connections using JDBC and a connection pool.

Codex must not manage JDBC connections, credentials,
or database sessions.

### Service Access

Before calling the service:

1. Read references/db-tool-usage.md.
2. Resolve the configured base URL and connection profile.
3. Check service health.
4. Confirm that the requested database environment is allowed.
5. Use only documented metadata endpoints.

Use curl or another available HTTP client to retrieve metadata.

Do not invent endpoints, parameters, or response fields.

Do not change the service configuration or start another
service instance automatically.

### Supported Metadata Operations

Use the service to retrieve:

- Database object lists and identities.
- Procedure, function, and package definitions.
- Procedure/function parameters.
- Object dependencies.
- Table columns and constraints.
- Database relationships and trigger metadata when supported.

For Oracle packaged subprograms, inspect PACKAGE_BODY
to understand the implementation.

Do not assume ALL_DEPENDENCIES contains a complete
subprogram-level call graph.

Inspect relevant PL/SQL source for nested calls and
dynamic SQL.

### Response Handling

Inspect the response envelope:

- status
- source
- data
- coverage
- warnings
- error

If a definition is paginated, retrieve all relevant pages
before concluding that the source has been fully analyzed.

If a result is PARTIAL, identify the missing information.

If an object is NOT_FOUND, verify its identity and scope.

If access is denied, do not attempt to bypass permissions.

Do not treat an empty dependency list as proof that an
object has no dependencies.

### Database Safety

Use only authorized local service URLs and connection profiles.

Never call arbitrary SQL execution endpoints.

Never execute business procedures or functions.

Never perform DML, DDL, or operations that modify database state.

Never retrieve unnecessary personal or sensitive data.

Never expose credentials, connection strings, or access tokens.

The Java service must enforce these restrictions independently
of the instructions in this skill.

### Fallback

If the service is unavailable, cannot be reached, or cannot
provide the required metadata:

1. Continue investigating the available Java source.
2. Inspect SQL definitions, migrations, and metadata snapshots.
3. Mark database-specific findings appropriately.
4. Record missing evidence and unresolved dependencies.
5. Generate a Partial report when critical information
   cannot be established.

Never fabricate procedure definitions, table structures,
column meanings, or database relationships.

## 7. Evidence Requirements

Every important business conclusion must have traceable
evidence.

For Java, prefer:

- Repository-relative file path.
- Class and method.
- Relevant line range when available.
- Git commit.

For database objects, prefer:

- Database and environment.
- Schema and object name.
- Relevant SQL section or statement.
- Metadata retrieval time when available.

Use actual source locations, not invented links or line numbers.

Do not infer status/type/error-code meanings solely from
their names or numeric values.

Do not claim an operation committed unless the relevant
transaction behavior has been established.

Do not claim that runtime behavior was tested unless
an authorized test was actually performed.

When a conclusion cannot be verified, record the available
evidence and mark the unresolved part INFERRED or UNKNOWN.

## 8. Report Output

Use the output directory configured by the project when
provided and valid.

Otherwise use:

docs/business-investigations/<feature-name>/

Generate:

- README.md
  Business overview, flow, states, database overview,
  business rules, and debug guide.

- database.md
  Table roles, important columns, value mappings,
  relationships, data read/write, and evidence.

- technical-flow.md
  Java call chain, procedure call graph, transactions,
  errors, and end-to-end mapping.

- open-questions.md
  Missing evidence, uncertainties, contradictions,
  and questions requiring confirmation.

README.md must be the entry point for the report.

For small features, these sections may be consolidated
into README.md while preserving the required information.

Create only the files needed for the selected report structure.
Never create links to nonexistent files.

All discovered relevant tables must appear in the
Table Inventory.

Analyze Core Tables in detail. Summarize less relevant
Supporting, Audit/Integration, and Indirect Tables as
appropriate without hiding known dependencies.

Do not remove important columns merely to make the
report shorter.

Write investigation reports only in the designated output
directory. Do not modify application code, database schemas,
business configuration, or existing tests as part of
report generation.

## 9. Completion Criteria

Before finishing, verify that:

- The business flow and important branches are documented.
- Relevant Java and database calls are traced or marked
  as unresolved.
- Every discovered relevant table is recorded.
- Core Tables have business explanations and important columns.
- Table relationships and value mappings are evidence-based.
- Important data mutations and transaction behavior are covered.
- Business rules include conditions, results, and evidence.
- Unverified findings are clearly identified.
- Internal report links and identifiers are consistent.
- The report contains no secrets or unnecessary sensitive data.

Use Complete only when the defined investigation scope
has been sufficiently covered and no critical evidence gap
prevents understanding the requested business behavior.

Otherwise use Partial and state the limitations.

Do not continue tracing unrelated functionality merely
to make the report appear exhaustive.

## 10. Final Response

After generating the report, provide a concise Vietnamese
summary containing:

- Investigated feature and scope.
- Location of generated report files.
- Main database tables and their roles.
- Important findings.
- Investigation status: Complete or Partial.
- Critical unresolved questions or access limitations.

Link to generated files when supported by the environment.

Do not claim successful file creation, DB access, or validation
unless the corresponding operation actually succeeded.

Do not reproduce the entire report in the final response.
