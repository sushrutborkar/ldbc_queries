SET       `graphix.semantics.pattern` "homomorphism";

FROM GRAPH snb.snbGraph
MATCH
    (expertCandidatePerson:Person)-[:P_IS_LOCATED_IN]->(:City)-[:IS_PART_OF_1]->(country:Country),
    (expertCandidatePerson)<-[:HAS_CREATOR]-(message:Message)-[:M_HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tagClass:TagClass),
    (message)-[:M_HAS_TAG]->(tag:Tag)
WHERE country.name = 'China' AND tagClass.name = 'MusicalArtist' AND expertCandidatePerson.id IN
    ( FROM GRAPH snb.snbGraph
      MATCH (person:Person)-[k:KNOWS{1,4}]-(expertCandidatePerson:Person)
      WHERE person.id = 933
      GROUP BY person, expertCandidatePerson
      GROUP AS g
      HAVING ( FROM g gi SELECT VALUE MIN(PATH_HOP_COUNT(gi.k)))[0] >= 3
      SELECT VALUE expertCandidatePerson.id )
GROUP BY expertCandidatePerson, tag
GROUP AS g
SELECT expertCandidatePerson.id, tag.name, (SELECT VALUE COUNT(DISTINCT gi.message) FROM g gi)[0] AS messageCount
ORDER BY messageCount DESC, tag.name ASC, expertCandidatePerson.id ASC
LIMIT 100;

// change knows to directed relationship in ddl

/*
SET       `graphix.semantics.pattern` "homomorphism";

FROM GRAPH snb.snbGraph
MATCH
    (person:Person)-[:KNOWS{3,4}]-(expertCandidatePerson:Person)-[:P_IS_LOCATED_IN]->(:City)-[:IS_PART_OF_1]->(country:Country),
    (expertCandidatePerson)<-[:HAS_CREATOR]-(message:Message)-[:M_HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tagClass:TagClass),
    (message)-[:M_HAS_TAG]->(tag:Tag)
WHERE person.id = 933 AND country.name = 'China' AND tagClass.name = 'MusicalArtist'
    AND NOT EXISTS ( FROM GRAPH snb.snbGraph
                     MATCH (iperson:Person)-[:KNOWS{1,2}]-(iexpertCandidatePerson:Person)
                     WHERE iperson = person AND iexpertCandidatePerson = expertCandidatePerson
                     SELECT VALUE 1 )
GROUP BY expertCandidatePerson, tag
GROUP AS g
SELECT expertCandidatePerson.id, tag.name, (SELECT VALUE COUNT(DISTINCT gi.message) FROM g gi)[0] AS messageCount
ORDER BY messageCount DESC, tag.name ASC, expertCandidatePerson.id ASC
LIMIT 100;

*/