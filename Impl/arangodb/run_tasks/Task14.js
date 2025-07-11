let res = db._query(` 
LET Z1 = 5  LET Z2 = 10     
LET AB = (     
  FOR cell IN Finedust_idx         
  FILTER (Z1 <= cell.timestamp) AND (cell.timestamp <= Z2)                  
  LET AVG = (             
    FOR wcell IN Finedust_idx                  
    FILTER (wcell.timestamp == cell.timestamp) AND ((cell.latitude - 2) <= wcell.latitude) AND (wcell.latitude <= (2 + cell.latitude)) AND ((cell.longitude - 2) <= wcell.longitude) AND (wcell.longitude <= (2 + cell.longitude))
    RETURN wcell.pm10
  )          
  RETURN { timestamp: cell.timestamp, latitude: cell.latitude, longitude: cell.longitude, date: FLOOR(cell.timestamp / 8), pm10_avg: AVERAGE(AVG)}
)  
LET Ct2 = ( 
  FOR doc IN AB          
  COLLECT date = doc.date         
  AGGREGATE pm10_max = MAX(doc.pm10_avg)         
  RETURN {date: date, pm10_max: pm10_max} 
)  
LET C = (     
  FOR t1 IN AB         
  FOR t2 IN Ct2             
  FILTER t1.pm10_avg == t2.pm10_max AND t1.date == t2.date             
  RETURN {m: t2.pm10_max, date: t1.date, latitude: t1.latitude, longitude: t1.longitude, timestamp: t1.timestamp} 
)  
LET D = (     
  FOR c IN C         
  LET NEAR = (              
    FOR site IN Site_centroid                 
    FILTER site.properties.type == 'building'                 
    SORT GEO_DISTANCE([-118.34501002237936 + (c.longitude * 0.000216636), 34.011898718557454 + (c.latitude * 0.000172998)], site.centroid) ASC                 
    LIMIT 1                 
    RETURN site         
  )                  
  SORT c.date ASC                  
  RETURN { date: c.date, timestamp: c.timestamp, site_id: NEAR[0].site_id} 
)  
RETURN Length(D)
`);
let res2 = res.getExtra();

print(res);
print(res2['stats']['executionTime']);
