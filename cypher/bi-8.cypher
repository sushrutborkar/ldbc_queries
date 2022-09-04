// :param tag: Hamid_Karzai
// :param startDate: 1313579421570
// :param endDate: 1342803345373

MATCH (tag:Tag)<-[:HAS_TAG]-(message:Message), (person:Person)
WHERE tag.name = $tag AND (exists((tag)<-[:HAS_INTEREST]-(person)) OR exists((message)-[:HAS_CREATOR]->(person)))
      AND $startDate < message.creationDate AND message.creationDate < $endDate
WITH person, tag
OPTIONAL MATCH (tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]->(person)
WHERE $startDate < message.creationDate AND message.creationDate < $endDate
WITH person, tag, toInteger(exists((tag)<-[:HAS_INTEREST]-(person)))*100 + COUNT(DISTINCT message) AS score
MATCH (tag)<-[:HAS_TAG]-(message:Message)
WHERE $startDate < message.creationDate AND message.creationDate < $endDate
OPTIONAL MATCH (person)-[:KNOWS]-(friend:Person)
WHERE exists((tag)<-[:HAS_INTEREST]-(friend)) OR exists((message)-[:HAS_CREATOR]->(friend))
WITH person, score, friend, tag
OPTIONAL MATCH (tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]->(friend)
WHERE $startDate < message.creationDate AND message.creationDate < $endDate
WITH person, score, friend, toInteger(exists((tag)<-[:HAS_INTEREST]-(friend)))*100 + COUNT(DISTINCT message) AS friendScore
RETURN person.id, score, SUM(friendScore) as friendScore
ORDER BY score + friendScore DESC, person.id ASC
LIMIT 100;