col member for a80
select
GROUP#
,STATUS
,TYPE 
,substr(MEMBER,1,80) MEMBER
,IS_RECOVERY_DEST_FILE
from v$logfile
order by group#, member;
