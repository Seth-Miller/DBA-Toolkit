select output from v$rman_output join v$rman_backup_job_details using (session_stamp) where trunc(start_time) = trunc(&day_of_backup) order by recid;
