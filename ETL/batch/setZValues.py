import os,re,arcpy

wsDelim = 'UWGISStaging.DBO.'

ws = arcpy.GetParameterAsText(0)
ws = r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\\'+wsDelim+'Floorplan'

#fcs = ['Floor_Area','Floor_Outline','Floor_Point','Floor_Poly','FloorplanLine','InteriorSpace','InteriorSpace_Point']
fcs = ['FloorplanLine']
table = arcpy.GetParameterAsText(1)
table = os.path.join(r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde','pubFloors')
field = arcpy.GetParameterAsText(2)
field = 'SchematicElevation'
# Identify the geometry field
#
def main(argv = None):

    elevValues = getElevValues(table,field) # get elevation value for each floorid
    for fc in fcs:
        infc = os.path.join(ws,wsDelim+fc)
        
        desc = arcpy.Describe(infc)
        shapefieldname = desc.ShapeFieldName
        spRef = desc.SpatialReference
        print "Processing",fc
        # Create cursor
        cursor = arcpy.UpdateCursor(infc)

        # Enter for loop for each feature/row
        for row in cursor:
            # Create the geometry object
            feat = row.getValue(shapefieldname)
            floorid = row.getValue("FLOORID")
            elev = elevValues[floorid] * 0.3048 # convert ft to meters

            wkt = feat.WKT
            wkt = setZParts(wkt,elev)
            try:
                geom = arcpy.FromWKT(wkt,spRef)
                row.setValue(shapefieldname,geom)
                cursor.updateRow(row)
            except:
                if wkt.find(' 0,') == -1 or wkt.find(' 0)') == -1: # will fail to set to 0, but already set to 0...
                    print "Error for Objectid",row.getValue("OBJECTID")
                    print wkt
                
    del elevValues, cursor
    print "process completed"

def setZParts(wkt,elev):
    
    wkt = re.sub(r'[^ \)]+\)', str(elev) + ')',wkt) # replace elev)  
    wkt = re.sub(r'[^\d,]+\d,', ' ' + str(elev) + ',',wkt) # replace elev,
   
    return wkt

def getElevValues(table,fieldname):
    theValues = {} # dict of floorid values
    try:
        cursor = arcpy.SearchCursor(table)
        row = cursor.next()
    except Exception, ErrorDesc:
        print( "Unable to read the Dataset, Python error is: ")
        #showTraceback()
        row = None

    while row:
        try:
            currentValue = row.getValue(fieldname)
            floorid = row.getValue("FLOORID")
            theValues[floorid] = currentValue 
            #print "floorid ", floorid, "elev",currentValue
        except:
            err = "Exception caught: unable to get field values"
            print(err)
        row = cursor.next()

    del cursor
    return theValues

if __name__ == "__main__":
    main()
