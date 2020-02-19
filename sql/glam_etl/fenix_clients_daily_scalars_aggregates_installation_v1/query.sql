-- Query generated by: python3 -m bigquery_etl.glam.glean_scalar_aggregates --agg-type scalars --table-id org_mozilla_fenix_stable.installation_v1
WITH filtered AS (
  SELECT
    *,
    DATE(submission_timestamp) AS submission_date,
    client_info.client_id,
    REPLACE(ping_info.ping_type, "_", "-") AS ping_type,
    COALESCE(
      SAFE_CAST(SPLIT(client_info.app_display_version, '.')[OFFSET(0)] AS INT64),
      0
    ) AS app_version,
    client_info.os AS os,
    client_info.app_build AS app_build_id,
    client_info.app_channel AS channel
  FROM
    `moz-fx-data-shared-prod.org_mozilla_fenix_stable.installation_v1`
  WHERE
    DATE(submission_timestamp) = @submission_date
    AND client_info.app_channel IN ("release", "fenixProduction")
    AND client_info.client_id IS NOT NULL
),
aggregated AS (
  SELECT
    client_id,
    ping_type,
    submission_date,
    os,
    app_version,
    app_build_id,
    channel,
    ARRAY<STRUCT<metric STRING, metric_type STRING, key STRING, agg_type STRING, value FLOAT64>>[
    ] AS scalar_aggregates
  FROM
    filtered
  GROUP BY
    client_id,
    ping_type,
    submission_date,
    os,
    app_version,
    app_build_id,
    channel
)
SELECT
  *
FROM
  aggregated
