FROM     GRAPH snb.snbGraph
MATCH    (person1:Person)-[k:KNOWS{1,3}]-(person2:Person)
WHERE    person1.id = 933 AND person2.id = 102
GROUP BY person1, person2
GROUP AS g
LET      shortestPath = ( FROM g gi SELECT VALUE MIN(PATH_HOP_COUNT(gi.k)))[0]
SELECT   shortestPath;
