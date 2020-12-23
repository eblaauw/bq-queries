SELECT
  protopayload_auditlog.authenticationInfo.principalEmail as user,
  sum(CAST(5.0* (protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.job.jobStatistics.totalProcessedBytes/POWER(2,40)) AS numeric )) AS queryCostInUSD,

FROM
  `PROJECT_ID.stackdriver_logging.cloudaudit_googleapis_com_data_access_202012*`
WHERE
  protopayload_auditlog.servicedata_v1_bigquery .jobCompletedEvent.eventName="query_job_completed"
  AND protopayload_auditlog.servicedata_v1_bigquery .jobCompletedEvent.job.jobStatistics.totalProcessedBytes IS NOT NULL
GROUP BY
  protopayload_auditlog.authenticationInfo.principalEmail
ORDER BY
  queryCostInUSD DESC
