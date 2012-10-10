set linesize 110 pagesize 80
col file_type for a30
col per_used for a8 
col per_recl for a8
col num_file for 99999
select file_type, percent_space_used||'%' per_used, percent_space_reclaimable||'%' per_recl, number_of_files num_file from v$flash_recovery_area_usage;
