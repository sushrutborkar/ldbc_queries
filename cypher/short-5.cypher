// :param messageId: 1236950581249

MATCH (message:Message)-[:HAS_CREATOR]->(person:Person)
WHERE message.id = $messageId
RETURN person.id, person.firstName, person.lastName;