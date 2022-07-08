FROM GRAPH snb.snbGraph
MATCH (person:Person)-[:IS_LOCATED_IN]->(city:City)
WHERE person.id = 4194
SELECT
    person.firstName,
    person.lastName,
    person.birthday,
    person.locationIP,
    person.browserUsed,
    city.id,
    person.gender,
    person.creationDate;