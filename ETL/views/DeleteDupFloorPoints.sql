
delete from UWGISProduction.dbo.FLOOR_POINT where objectid in
(select oid from dbo.qaduplicatefloorpoints);

(select * from dbo.qaduplicatefloorpoints);


 