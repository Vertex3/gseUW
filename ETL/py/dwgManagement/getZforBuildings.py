## getZForBuildings - Use the USGS NED service to get an elevation value where it is null for a building.
## SG Dec, 2014
##
# ---------------------------------------------------------------------------

import arcpy,urllib, urllib2, xml.dom.minidom
# Local variables...
debug = True

url="http://ned.usgs.gov/epqs/pqs.php"

# Parameters
dataset = arcpy.GetParameterAsText(0) # dataset for Building Table to update argument
if dataset == None or dataset == '#' or dataset == '':
    dataset = r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde\Building_Outline_Point'
    #dataset = r'C:\Apps\Gizinta\gseUW\DataModels\bldg.mdb\PointsZ'
successParameterNumber = 1

debug = True

def main(argv = None):
    success = True
        
    retcode = False
    sr = arcpy.SpatialReference(4326)
    with arcpy.da.UpdateCursor(dataset, ["Z","SHAPE@XY"],'',sr) as cursor:
            for row in cursor:
                z = row[0]
                xy = row[1]
                if z == None:
                    z = getZValue(xy[0],xy[1])
                    row[0] = z
                    print xy[0],xy[1], z
                    cursor.updateRow(row)
                    
    return retcode

def getZValue(x,y):
    elev = None
    theData = [('x', x),('y',y),('units','Feet'),('output','xml')]
    params = urllib.urlencode(theData)
    f = urllib2.urlopen(url, params)
    fdata = f.read()
    fxml = xml.dom.minidom.parseString(fdata)
    znode = fxml.getElementsByTagName('Elevation')[0]
    try:
        elev = float(collect_text(znode))
    except:
        pass
    return elev

def collect_text(node):
    # "A function that collects text inside 'node', returning that text."
    s = ""
    for child_node in node.childNodes:
        if child_node.nodeType == child_node.TEXT_NODE:
            s += child_node.nodeValue
        else:
            s += collect_text(child_node)
    return s  

if __name__ == "__main__":
    main()
