// :param tag: 'Slavoj_Žižek'
// :param delta: 8

MATCH
  (person1:Person)<-[:HAS_CREATOR]-(message1:Message)-[:REPLY_OF*0..]->(post1:Post)<-[:CONTAINER_OF]-(forum1:Forum),
  (message1)-[:HAS_TAG]->(tag:Tag),
  (forum1)-[:HAS_MEMBER]->(person2:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:HAS_TAG]->(tag),
  (forum1)-[:HAS_MEMBER]->(person3:Person)<-[:HAS_CREATOR]-(message2:Message),
  (comment)-[:REPLY_OF]->(message2)-[:REPLY_OF*0..]->(post2:Post)<-[:CONTAINER_OF]-(forum2:Forum)
MATCH (comment)-[:HAS_TAG]->(tag)
MATCH (message2)-[:HAS_TAG]->(tag)
WHERE forum1 <> forum2 AND tag.name = $tag
  AND message2.creationDate > message1.creationDate + $delta * 60 * 60 * 1000
  AND NOT exists((forum2)-[:HAS_MEMBER]->(person1))
RETURN person1.id, count(DISTINCT message2) AS messageCount
ORDER BY messageCount DESC, person1.id ASC
LIMIT 10;