FROM GRAPH snb.snbGraph
MATCH (country1:Country)<-[:IS_PART_OF_1]-(city1:City)<-[:P_IS_LOCATED_IN]-(person1:Person)-[:KNOWS]-(person2:Person)-[:P_IS_LOCATED_IN]->(city2:City)-[:IS_PART_OF_1]->(country2:Country)
LET c1 =  EXISTS (FROM GRAPH snb.snbGraph
          MATCH (p1:Person)<-[:HAS_CREATOR]-(:Message)-[:REPLY_OF]->(:Message)-[:HAS_CREATOR]->(p2:Person)
          WHERE p1 = person1 AND p2 = person2
          SELECT VALUE 1 ),
    c2 =  EXISTS (FROM GRAPH snb.snbGraph
          MATCH (p1:Person)<-[:HAS_CREATOR]-(:Message)<-[:REPLY_OF]-(:Message)-[:HAS_CREATOR]->(p2:Person)
          WHERE p1 = person1 AND p2 = person2
          SELECT VALUE 1 ),
    c3 =  EXISTS (FROM GRAPH snb.snbGraph
          MATCH (p1:Person)-[:LIKES]->(:Message)-[:HAS_CREATOR]->(p2:Person)
          WHERE p1 = person1 AND p2 = person2
          SELECT VALUE 1 ),
    c4 =  EXISTS (FROM GRAPH snb.snbGraph
          MATCH (p1:Person)<-[:HAS_CREATOR]-(:Message)<-[:LIKES]-(p2:Person)
          WHERE p1 = person1 AND p2 = person2
          SELECT VALUE 1 )
WHERE country1.name = 'Chile' AND country2.name = 'Argentina'
SELECT DISTINCT person1.id AS person1id, person2.id AS person2id, city1.name,
    (CASE (c1) WHEN true THEN 4  ELSE 0 END) +
    (CASE (c2) WHEN true THEN 1  ELSE 0 END) +
    (CASE (c3) WHEN true THEN 10 ELSE 0 END) +
    (CASE (c4) WHEN true THEN 1  ELSE 0 END) AS score    
ORDER BY score DESC, person1id ASC, person2id ASC;