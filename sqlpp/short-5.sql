FROM GRAPH snb.snbGraph
MATCH (message:Message)-[:HAS_CREATOR]->(person:Person)
WHERE message.id = 1236950581249
SELECT person.id, person.firstName, person.lastName;