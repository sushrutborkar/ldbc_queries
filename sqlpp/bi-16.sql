1347753600000
1336435200000
:param [{ tagA, dateA, tagB, dateB, maxKnowsLimit }] => { RETURN
  'Hamid_Karzai' AS tagA,
  datetime('2012-09-16') AS dateA,
  'Rumi' AS tagB,
  datetime('2012-05-08') AS dateB,
  4 AS maxKnowsLimit
}

// knows edge undirected, get_year -> day, lower maxKnowsLimit


WITH T AS (
FROM GRAPH snb.snbGraph
MATCH (person1:Person)<-[:HAS_CREATOR]-(message1:Message)-[:M_HAS_TAG]->(tag:Tag)
LET cp2 = (FROM GRAPH snb.snbGraph
           MATCH (p1:Person)-[:KNOWS]->(person2:Person)<-[:HAS_CREATOR]-(message2:Message)-[:M_HAS_TAG]->(t:Tag)
           WHERE person1 = p1 AND t = tag AND get_year(datetime_from_unix_time_in_ms(message2.creationDate)) = 2012
           SELECT VALUE COUNT(DISTINCT person2))[0]
WHERE tag.name = 'Hamid_Karzai' AND cp2 < 20 AND get_year(datetime_from_unix_time_in_ms(message1.creationDate)) = 2012
GROUP BY person1
SELECT person1.id, COUNT(DISTINCT message1) AS messageCountA, 0 AS messageCountB

UNION ALL

FROM GRAPH snb.snbGraph
MATCH (person1:Person)<-[:HAS_CREATOR]-(message1:Message)-[:M_HAS_TAG]->(tag:Tag)
LET cp2 = (FROM GRAPH snb.snbGraph
           MATCH (p1:Person)-[:KNOWS]->(person2:Person)<-[:HAS_CREATOR]-(message2:Message)-[:M_HAS_TAG]->(t:Tag)
           WHERE person1 = p1 AND t = tag AND get_year(datetime_from_unix_time_in_ms(message2.creationDate)) = 2012
           SELECT VALUE COUNT(DISTINCT person2))[0]
WHERE tag.name = 'Rumi' AND cp2 < 20 AND get_year(datetime_from_unix_time_in_ms(message1.creationDate)) = 2012
GROUP BY person1
SELECT person1.id, 0 AS messageCountA, COUNT(DISTINCT message1) AS messageCountB )

FROM T
GROUP BY T.id
SELECT T.id, SUM(messageCountA) AS messageCountA, SUM(messageCountB) AS messageCountB
ORDER BY messageCountA + messageCountB DESC, T.id ASC
LIMIT 20;



FROM GRAPH snb.snbGraph
MATCH (person1:Person)<-[:HAS_CREATOR]-(message1:Message)-[:M_HAS_TAG]->(tag:Tag WHERE tag.name = 'Hamid_Karzai')
LEFT MATCH (person1)-[:KNOWS]-(person2:Person)<-[:HAS_CREATOR]-(message2:Message WHERE get_year(datetime_from_unix_time_in_ms(message2.creationDate)) = 2012)-[:M_HAS_TAG]->(tag)
WHERE  get_year(datetime_from_unix_time_in_ms(message1.creationDate)) = 2012
GROUP BY person1
HAVING count(DISTINCT person2)  <= 20
SELECT person1.id, count(DISTINCT message1) AS cm