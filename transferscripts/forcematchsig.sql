select /* getfm */ sql_id, plan_hash_value, to_char(force_matching_signature), substr(sql_text,1,100) sql_text
from v$sql
where upper(sql_text) like '%&search_text%'
and sql_text not like '%/* getfm */%';
