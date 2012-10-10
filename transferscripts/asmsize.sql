col free_gb for 99999.99
col total_gb for 99999.99
select name, total_mb/1024 total_gb, free_mb/1024 free_gb from v$asm_diskgroup;
