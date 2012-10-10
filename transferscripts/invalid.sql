select owner, object_name, object_type, count(*) from dba_objects
where status = 'INVALID'
group by owner, object_name, object_type
order by 1,2,3;
