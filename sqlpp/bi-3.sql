FROM GRAPH snb.snbGraph
MATCH (country:Country)<-[:IS_PART_OF_1]-(:City)<-[:P_IS_LOCATED_IN]-(person:Person)<-[:HAS_MODERATOR]-(forum:Forum)-[:CONTAINER_OF]->(post:Message)<-[:REPLY_OF{1,5}]-(message:Message)-[:M_HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE country.name = 'Russia' AND tagClass.name = 'Politician' AND post.isPost = true
GROUP BY forum, person
GROUP AS g
SELECT forum.id AS forumId, forum.title, forum.creationDate, person.id AS personId, (SELECT VALUE COUNT(DISTINCT gi.message) FROM g gi)[0] AS messageCount
ORDER BY messageCount DESC, forumId ASC
LIMIT 20;

// add gi to subqueries for correct count (if repeated variable from main query, like 'message')