FROM GRAPH snb.snbGraph
MATCH (message:Message)-[:REPLY_OF{1,5}]->(post:Message)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MODERATOR]->(moderator:Person)
WHERE message.id = 1236950581249 AND post.label = 0	
SELECT forum.id AS forumId, forum.title, moderator.id as moderatorId, moderator.firstName, moderator.lastName;