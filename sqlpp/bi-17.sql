FROM GRAPH snb.snbGraph
MATCH
  (person1:Person)<-[:HAS_CREATOR]-(message1:Message)-[:REPLY_OF{1,5}]->(post1:Message)<-[:CONTAINER_OF]-(forum1:Forum),
  (message1)-[:M_HAS_TAG]->(tag:Tag),
  (forum1)-[:HAS_MEMBER]->(person2:Person)<-[:HAS_CREATOR]-(comment:Message)-[:M_HAS_TAG]->(tag),
  (forum1)-[:HAS_MEMBER]->(person3:Person)<-[:HAS_CREATOR]-(message2:Message),
  (tag)<-[:M_HAS_TAG]-(comment)-[:REPLY_OF]->(message2)-[:REPLY_OF{1,5}]->(post2:Message)<-[:CONTAINER_OF]-(forum2:Forum),
  (message2)-[:M_HAS_TAG]->(tag)
WHERE forum1 <> forum2 AND tag.name = 'Slavoj_Žižek' AND post1.isPost = true AND post2.isPost = true AND comment.isPost = false
  AND message2.creationDate > message1.creationDate + 8 * 60 * 60 * 1000
//  AND NOT exists((forum2)-[:HAS_MEMBER]->(person1))
GROUP BY person1
SELECT person1.id, count(DISTINCT message2) AS messageCount
ORDER BY messageCount DESC, person1.id ASC
LIMIT 10;