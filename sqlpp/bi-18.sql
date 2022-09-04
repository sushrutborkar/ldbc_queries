FROM GRAPH snb.snbGraph
MATCH (tag:Tag)<-[:HAS_INTEREST]-(person1:Person)-[:KNOWS]-(mutualFriend:Person)-[:KNOWS]-(person2:Person)-[:HAS_INTEREST]->(tag)
WHERE tag.name = 'Frank_Sinatra'
  AND NOT EXISTS ( FROM GRAPH snb.snbGraph
                   MATCH (p1:Person)-[:KNOWS]-(p2:Person)
                   WHERE p1 = person1 AND p2 = person2
                   SELECT VALUE 1 )
GROUP BY person1, person2                   
SELECT person1.id AS person1Id, person2.id AS person2Id, count(DISTINCT mutualFriend) AS mutualFriendCount
ORDER BY mutualFriendCount DESC, person1Id ASC, person2Id ASC
LIMIT 20;

//temp:

FROM GRAPH snb.snbGraph
MATCH (tag:Tag)<-[:HAS_INTEREST]-(person1:Person)-[:KNOWS]-(mutualFriend:Person)-[:KNOWS]-(person2:Person)-[:HAS_INTEREST]->(tag)
WHERE tag.name = 'Frank_Sinatra'
  AND NOT EXISTS ( FROM GRAPH snb.snbGraph
                   MATCH (p1:Person)-[:KNOWS]->(p2:Person)
                   WHERE p1 = person1 AND p2 = person2
                   SELECT VALUE 1 )
  AND NOT EXISTS ( FROM GRAPH snb.snbGraph
                   MATCH (p1:Person)<-[:KNOWS]-(p2:Person)
                   WHERE p1 = person1 AND p2 = person2
                   SELECT VALUE 1 )                   
GROUP BY person1, person2                   
GROUP AS g
SELECT person1.id AS person1Id, person2.id AS person2Id, (SELECT VALUE COUNT (DISTINCT gi.mutualFriend) FROM g gi)[0] AS mutualFriendCount
ORDER BY mutualFriendCount DESC, person1Id ASC, person2Id ASC
LIMIT 20;