set linesize 110 pagesize 80
col name for a50
col space_limit_GB for 999999.9
col space_used_GB for 999999.9
col space_recl_GB for 999999.9
col num_file for 99999
select name, space_limit/1024/1024/1024 space_limit_GB, space_used/1024/1024/1024 space_used_GB, space_reclaimable/1024/1024/1024 space_recl_GB, number_of_files num_file from v$recovery_file_dest;
