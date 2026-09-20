# DB Tool Usage — Local Java HTTP Service

## Purpose

Use the locally running Java DB Metadata Service to
retrieve Oracle metadata for business investigation.

The service is expected to be started by the developer.
Codex must not assume it is running or start another
instance automatically.

## Service Discovery & Configuration

Before accessing database metadata:

1. Read the current project's configuration:
   .ai-investigator/project.yaml

2. Resolve the following properties:
   - database.metadataServiceBaseUrl
   - database.connectionProfile
   - database.defaultSchema
   - database.contractVersion

3. Verify that the configured service URL is authorized.

4. Check service health and verify the selected
   database connection profile.

5. Use the REST endpoints defined by the configured
   contract version.

Do not hardcode a service URL or connection profile.

Do not guess missing configuration values.

Do not discover or connect to other database services
when the configured service is unavailable.

If the service is unreachable or its contract is
incompatible, continue investigating available source
code and record the database investigation limitation.

For contract version `1.0`, read
`references/metadata-contract-v1.md` before making metadata calls.
It defines the endpoint names, request parameters, response envelope,
authentication boundary, and Oracle-specific limitations for this
skill. Do not substitute an endpoint from memory or from another
contract version.

Never expose authentication tokens or database credentials
in generated reports.

## Preflight

Before database investigation:

1. Check GET /health.
2. Confirm that the service is reachable.
3. Confirm that the intended DB profile is authorized.
4. If unavailable, continue with available source code
   and record the database investigation limitation.

## Metadata Operations

Use the documented REST endpoints to retrieve:

- Object definitions.
- Procedure/function parameters.
- Object dependencies.
- Table columns and constraints.
- Table relationships when supported.

Use curl or another available HTTP client.

Do not invent endpoints or request parameters.

## Oracle-specific Rules

Inspect PACKAGE_BODY when investigating packaged
procedure implementations.

Do not treat ALL_DEPENDENCIES as a complete subprogram
call graph.

Inspect source for nested calls and dynamic SQL.

## Response Handling

Inspect status, data, warnings, and error.

Do not treat PARTIAL, ACCESS_DENIED or missing metadata
as successful full verification.

If the service cannot provide important evidence,
generate a Partial report and record the limitations.

## Security

Only call the configured local metadata service.

Never call arbitrary SQL execution endpoints.
Never execute business procedures.
Never modify database data.
Never expose credentials or sensitive information.

## Report Generation

Follow investigation-workflow.md and report-template.md.

Use the Java service only for metadata collection.
Codex remains responsible for business interpretation,
evidence verification, and report generation.
