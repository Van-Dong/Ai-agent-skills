# DB Metadata Service Contract v1.0

Use this reference only when the current project configuration sets
`database.contractVersion: "1.0"` and the configured DB Metadata
Service must be called. The project configuration and the authorized
service determine the base URL, profile, schema, and authentication
mechanism; never hardcode them in the skill.

## Preflight

1. Read `.ai-investigator/project.yaml`.
2. Resolve `database.metadataServiceBaseUrl`,
   `database.connectionProfile`, `database.defaultSchema`, and
   `database.contractVersion`.
3. Call `GET /health` to verify that the service is reachable.
4. Call the configured profile status endpoint with the service's
   required authentication and verify the expected database identity.
5. If the contract version is missing or unsupported, do not guess
   endpoint names or parameters. Continue from source evidence and
   record the metadata limitation.

`/health` is a liveness check only. It is not proof that Oracle is
reachable or that the selected profile is connected to the intended
database.

## Authentication and safety

- `/health` is unauthenticated; metadata endpoints require the
  configured service authentication.
- For the sample service, send `X-Metadata-Token` from the process
  environment (`DB_METADATA_API_TOKEN`). Do not put tokens in
  `project.yaml`, prompts, reports, or logs.
- Use only `GET` metadata endpoints.
- Never call arbitrary SQL execution endpoints or execute business
  procedures/functions.
- Never perform DML, DDL, or retrieve unnecessary business-row data.

## Common response envelope

Metadata endpoints return:

```json
{
  "status": "OK | PARTIAL | NOT_FOUND | ACCESS_DENIED | ERROR",
  "source": {},
  "data": {},
  "coverage": {"complete": true},
  "warnings": [],
  "error": null
}
```

Inspect `status`, `coverage`, `warnings`, and `error` before treating
the result as evidence. `PARTIAL`, omitted metadata, or an empty
dependency list is not proof that the underlying object has no more
information.

## Metadata endpoints

Use the following v1 endpoints and their documented query parameters:

- `GET /api/metadata/profiles/{profile}/status`
- `GET /api/metadata/objects`
  (`profile`, `schema`, `namePattern`, `objectTypes`, `limit`, `cursor`)
- `GET /api/metadata/definitions`
  (`profile`, `schema`, `name`, `type`, `startLine`, `maxLines`)
- `GET /api/metadata/parameters`
  (`profile`, `schema`, `name`, `type`, `packageName`,
  `subprogramName`, `overload`)
- `GET /api/metadata/dependencies`
  (`profile`, `schema`, `name`, `type`)
- `GET /api/metadata/tables/{tableName}`
  (`profile`, `schema`)
- `GET /api/metadata/relationships`
  (`profile`, `schema`, `tableName`)
- `GET /api/metadata/triggers`
  (`profile`, `schema`, `tableName`)

Use `PACKAGE_BODY` when investigating the implementation of a
packaged procedure. Follow `nextLine` or `nextCursor` until the
relevant result is complete.

## Oracle limitations

- `ALL_DEPENDENCIES` is object-level metadata, not a complete
  subprogram call graph.
- Dynamic SQL and unresolved references may be absent.
- Quoted case-sensitive identifiers and wrapped source are outside
  the v1 support scope unless the service explicitly documents them.
- Metadata visibility is limited by Oracle grants and the configured
  schema allowlist.
- Business meaning must be established by correlating metadata with
  Java, SQL, and PL/SQL source; do not infer it from object names.
