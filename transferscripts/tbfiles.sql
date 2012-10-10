col file_name for a70
col tablespace_name for a30
select tablespace_name, file_name, bytes/1024/1024 size_mb from dba_data_files where tablespace_name = upper('&&TABLESPACE');

undefine tablespace
