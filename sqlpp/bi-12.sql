WITH table AS
( FROM GRAPH snb.snbGraph
  MATCH (person:Person)<-[:HAS_CREATOR]-(message:Message)-[:REPLY_OF{1,5}]->(post:Message)
  WHERE message.content IS NOT NULL
    AND message.length < 20
    AND message.creationDate > 1313579421570
    AND post.language IN ['ar', 'hu']
    AND post.isPost = true
  GROUP BY person
  GROUP AS g
  SELECT person, (SELECT VALUE COUNT(gi.message) FROM g gi)[0] AS messageCount) 

FROM table T
GROUP BY T.messageCount
SELECT T.messageCount, COUNT(T.person);