UPDATE [UWGISProduction].dbo.active_Floor set GROUNDELEV = (STACKLEVEL * 10) + 36
WHERE FLOORCODE = 'RF';