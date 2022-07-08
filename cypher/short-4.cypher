// :param messageId: 1236950581249

MATCH (message:Message)
WHERE message.id = $messageId
RETURN 
    message.creationDate AS messageCreationDate,
    coalesce(message.content, message.imageFile) AS messageContent;