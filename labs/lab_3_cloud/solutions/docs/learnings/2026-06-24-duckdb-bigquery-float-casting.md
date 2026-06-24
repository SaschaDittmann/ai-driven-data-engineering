# Learning: BigQuery and DuckDB Float Casting Differences

## Problem

When porting a dbt project from a local DuckDB instance to a cloud BigQuery instance, SQL type casting issues can arise due to differences in SQL dialects.

Specifically, in `fct_competitive_moves.sql`, we attempted to cast the base power of a move to a floating-point data type using `FLOAT64` (the native BigQuery type for double-precision floats):

```sql
cast(moves.power as float64) * 1.5
```

This succeeded in BigQuery compilation but failed during local testing on DuckDB with:
```
Catalog Error: Type with name float64 does not exist! Did you mean "float4"?
```

Similarly, casting to `double` succeeded on DuckDB but is not natively supported as a casting type in BigQuery.

## Solution

To resolve this dialect difference and support dual-destination execution (DuckDB for local development/testing, BigQuery for production deployment), we utilized dbt's Jinja context to dynamically select the correct target data type based on the active target profile type:

```sql
cast(moves.power as {{ 'float64' if target.type == 'bigquery' else 'double' }})
```

By querying `target.type`, dbt compiles the code to `float64` when deploying to BigQuery in production, and automatically falls back to `double` when running tests locally on DuckDB.

## Key Takeaway

Always check type cast statements in models when developing for dual targets (e.g., DuckDB and BigQuery). Use `target.type` conditional syntax in Jinja for incompatible type names like `float64` vs `double`, or use standard types supported by both databases (such as `decimal`/`numeric` or `string` instead of `varchar`).
