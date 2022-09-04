FROM GRAPH snb.snbGraph
MATCH (person:Person)<-[:HAS_CREATOR]-(post:Message)<-[:REPLY_OF{1,5}]-(message:Message)
WHERE 1313579421570 < post.creationDate AND post.creationDate < 1342803345373
  AND 1313579421570 < message.creationDate AND message.creationDate < 1342803345373
  AND post.isPost = true
GROUP BY person  
SELECT person.id, person.firstName, person.lastName, COUNT(DISTINCT post) as threadCount, COUNT(DISTINCT message) as messageCount
ORDER BY messageCount DESC, person.id ASC
LIMIT 100;
