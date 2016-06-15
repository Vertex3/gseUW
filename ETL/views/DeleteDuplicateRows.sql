/****** Delete duplicate rows from a table  ******/
-- Note: You must set SQLCMD mode for this script to work:
-- In the "Query" menu in SSMS, simply toggle "SQLCMD Mode"

:setvar schema "dbo"
:setvar db "UWCadSde"
:setvar tablename "FACILITY_TABLE"
:setvar dupfield "BUILDINGID"
:setvar keyfield "OBJECTID"

-- set the database where views will be created
USE $(db);
-- 

--select * from $(tablename)
DELETE FROM $(tablename)
WHERE $(keyfield) NOT IN
(SELECT MAX($(keyfield)) from $(tablename) group by $(dupfield)
HAVING MAX($(keyfield)) is not NULL)
