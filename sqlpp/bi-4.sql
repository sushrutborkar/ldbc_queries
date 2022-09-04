WITH topForums AS (
FROM 
( FROM GRAPH snb.snbGraph
  MATCH (country:Country)<-[:IS_PART_OF_1]-(city:City)<-[:P_IS_LOCATED_IN]-(member:Person)<-[:HAS_MEMBER]-(forum:Forum)
  WHERE forum.creationDate > 1313579421570
  GROUP BY forum, country
  SELECT forum, country, COUNT(member) as memberCount ) AS T
GROUP BY T.forum
SELECT VALUE T.forum.id
ORDER BY MAX(T.memberCount) DESC
LIMIT 100 )

FROM GRAPH snb.snbGraph
MATCH (person:Person)<-[:HAS_MEMBER]-(forum2:Forum)
LEFT MATCH (forum1:Forum WHERE forum1.id IN topForums)-[:CONTAINER_OF]->(post:Message WHERE post.isPost = true)<-[:REPLY_OF{1,4}]-(message:Message)-[:HAS_CREATOR]->(person)
WHERE forum2.id IN topForums
GROUP BY person
SELECT person.id, person.firstName, person.lastName, person.creationDate, COUNT(DISTINCT message) AS messageCount
ORDER BY messageCount DESC, person.id ASC
LIMIT 100;


// or


FROM GRAPH snb.snbGraph
MATCH (person:Person)<-[:HAS_MEMBER]-(forum2:Forum)
LET messageCount = ( FROM GRAPH snb.snbGraph
                     MATCH (forum1:Forum)-[:CONTAINER_OF]->(post:Message)<-[:REPLY_OF]-(message:Message)-[:HAS_CREATOR]->(p:Person)
                     WHERE person = p AND forum1 IN topForums AND post.isPost = true
                     SELECT VALUE COUNT(DISTINCT message) )[0]
WHERE forum2 IN topForums
SELECT person.id, person.firstName, person.lastName, person.creationDate, messageCount
ORDER BY messageCount DESC, person.id ASC
LIMIT 100;