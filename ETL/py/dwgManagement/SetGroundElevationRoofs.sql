

UPDATE [UWGISProduction].dbo.active_Floor set GROUNDELEV = SCHELEV + 12
WHERE GROUNDELEV = SCHELEV + 36 or GROUNDELEV is null;

UPDATE [UWGISProduction].dbo.active_Floor set GROUNDELEV = (STACKLEVEL * 10) + 12
WHERE FLOORCODE = 'RF';