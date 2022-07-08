FROM GRAPH snb.snbGraph
MATCH (person:Person)<-[:HAS_CREATOR]-(message:Message)-[:REPLY_OF{5,5}]->(post:Message)-[:HAS_CREATOR]->(originalPoster:Person)
WHERE person.id = 4194 AND post.label = 0
SELECT
    message.id AS messageID,
    coalesce(message.content, message.imageFile) as content,
    message.creationDate,
    post.id as postID,
    originalPoster.id as originalPosterID,
    originalPoster.firstName,
    originalPoster.lastName
ORDER BY message.creationDate DESC, message.id DESC
LIMIT 10;






FROM GRAPH snb.snbGraph
MATCH (message:Message)-[:REPLY_OF{1,2}]->(post:Message)-[:HAS_CREATOR]->(originalPoster:Person)
WHERE post.label = 0 AND message.id IN 
	( FROM GRAPH snb.snbGraph
	  MATCH (person:Person)<-[:HAS_CREATOR]-(message:Message)
      WHERE person.id = 4194
      SELECT VALUE message.id
      ORDER BY message.creationDate DESC
      LIMIT 10 )
SELECT
    message.id AS messageID,
    coalesce(message.content, message.imageFile) as content,
    message.creationDate,
    post.id as postID,
    originalPoster.id as originalPosterID,
    originalPoster.firstName,
    originalPoster.lastName
ORDER BY message.creationDate DESC, message.id DESC
LIMIT 10;




FROM GRAPH snb.snbGraph
MATCH (message:Message)-[:REPLY_OF]->(post:Message)-[:HAS_CREATOR]->(originalPoster:Person)
WHERE post.label = 0 AND message.id IN 
	( FROM GRAPH snb.snbGraph
	  MATCH (person:Person)<-[:HAS_CREATOR]-(message:Message)
      WHERE person.id = 4194
      SELECT VALUE message.id
      ORDER BY message.creationDate DESC
      LIMIT 10 )
SELECT
    message.id AS messageID,
    coalesce(message.content, message.imageFile) as content,
    message.creationDate,
    post.id as postID,
    originalPoster.id as originalPosterID,
    originalPoster.firstName,
    originalPoster.lastName
ORDER BY message.creationDate DESC, message.id DESC
LIMIT 10;