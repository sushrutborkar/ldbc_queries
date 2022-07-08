// :param personId: 933
// :param country: 'Bolivia'
// :param tagClass: 'Monarch'
// :param minPathDistance: 3
// :param maxPathDistance: 4

MATCH
    path = shortestPath((person:Person)-[:KNOWS*]-(expertCandidatePerson:Person)),
    (expertCandidatePerson)-[:IS_LOCATED_IN]->(:City)-[:IS_PART_OF]->(country:Country)
WHERE person.id = $personId AND country.name = $country AND 
      $minPathDistance <= LENGTH(path) AND LENGTH(path) <= $maxPathDistance
MATCH (expertCandidatePerson)<-[:HAS_CREATOR]-(message:Message)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE tagClass.name = $tagClass
MATCH (message)-[:HAS_TAG]->(tag:Tag)
WITH expertCandidatePerson, tag, COUNT(DISTINCT message) as messageCount
RETURN expertCandidatePerson.id, tag.name, messageCount
ORDER BY messageCount DESC, tag.name ASC, expertCandidatePerson.id ASC
LIMIT 100;
