FROM GRAPH snb.snbGraph
MATCH (tag:Tag)<-[:M_HAS_TAG]-(message1:Message)-[:HAS_CREATOR]->(person1:Person)
LEFT MATCH (message1)<-[:LIKES]-(person2:Person)<-[:HAS_CREATOR]-(message2:Message)
LEFT MATCH (message2)<-[:LIKES]-(person3:Person)
WHERE tag.name = 'Diego_Maradona'
GROUP BY person1, person2
SELECT person1, person2, COUNT(person3) as popularityScore
LIMIT 100;