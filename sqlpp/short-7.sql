FROM GRAPH snb.snbGraph
MATCH (message:Message)<-[:REPLY_OF]-(comment:Message),
      (comment)-[:HAS_CREATOR]->(replyAuthor:Person),
      (message)-[:HAS_CREATOR]->(messageAuthor:Person)
LEFT MATCH (replyAuthor)-[k:KNOWS]-(messageAuthor)      
WHERE message.id = 1649267441688
SELECT 
    comment.id AS commentId,
    comment.content,
    comment.creationDate AS commentCreationDate,
    replyAuthor.id AS replyAuthorId,
    replyAuthor.firstName,
    replyAuthor.lastName,
    k.creationDate AS knowsCreationDate
ORDER BY comment.creationDate DESC, replyAuthor.id ASC;