FROM GRAPH snb.snbGraph
MATCH (country:Country),
(a:Person)-[:P_IS_LOCATED_IN]->(:City)-[:IS_PART_OF_1]->(country),
(b:Person)-[:P_IS_LOCATED_IN]->(:City)-[:IS_PART_OF_1]->(country),
(c:Person)-[:P_IS_LOCATED_IN]->(:City)-[:IS_PART_OF_1]->(country),
(a)-[k1:KNOWS]-(b)-[k2:KNOWS]-(c)-[k3:KNOWS]-(a)
WHERE a.id < b.id AND b.id < c.id
  AND 1313579421570 <= k1.creationDate AND k1.creationDate <= 1342803345373
  AND 1313579421570 <= k2.creationDate AND k2.creationDate <= 1342803345373
  AND 1313579421570 <= k3.creationDate AND k3.creationDate <= 1342803345373
  AND country.name = 'China'
SELECT VALUE COUNT(DISTINCT [a,b,c]);