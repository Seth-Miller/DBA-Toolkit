column BYTES_USED_MB format 99999999999999.9
column BYTES_FREE_MB format 99999999999999.9
column TOTAL_SPACE_MB format 99999999999999.9
column PERCENT_USED format 999.99
column PERCENT_FREE format 999.99
COLUMN TABLESPACE_NAME FORMAT A25
break on report
compute sum label TOTAL of total_space_mb on report
compute sum of bytes_used_mb on report

SET PAGESIZE 100
SET LINESIZE 150

select
  df.tablespace_name                          "TABLESPACE_NAME",
  df.totalspace/1024/1024                                "TOTAL_SPACE_MB",
  (df.totalspace - fs.freespace)/1024/1024               "BYTES_USED_MB",
  fs.freespace/1024/1024                                 "BYTES_FREE_MB",
  100 * ((df.totalspace - fs.freespace) / df.totalspace) "PERCENT_USED",
  100 * (fs.freespace / df.totalspace) "PERCENT_FREE"
from
   (select
      tablespace_name,
      sum(bytes) TotalSpace
   from
      dba_data_files
   group by
      tablespace_name
   union
   select
      tablespace_name,
      sum(bytes) TotalSpace
   from
      dba_temp_files
   group by
      tablespace_name
   ) df,
   (select
      tablespace_name,
      sum(bytes) FreeSpace
   from
      dba_free_space
   group by
      tablespace_name
   ) fs
where
   df.tablespace_name = fs.tablespace_name(+)
order by ((df.TotalSpace-fs.FreeSpace)/df.TotalSpace) desc
/
