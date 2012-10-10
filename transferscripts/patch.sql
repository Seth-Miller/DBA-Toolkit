col action_time for a50
col action for a10
col version for a10
col bundle_series for a10
select action_time, action, version, id, bundle_series from sys.registry$history;
