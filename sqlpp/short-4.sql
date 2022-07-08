FROM GRAPH snb.snbGraph
MATCH (message:Message)
WHERE message.id = 1236950581249
SELECT 
    message.creationDate AS messageCreationDate,
    coalesce(message.content, message.imageFile) AS messageContent;