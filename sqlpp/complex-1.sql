FROM GRAPH snb.snbGraph
MATCH (person:Person)-[p:KNOWS{1,3}]-(otherPerson:Person)-[:P_IS_LOCATED_IN]->(locationCity:City)
LET companies = ( FROM GRAPH snb.snbGraph
                  MATCH (oPerson:Person)-[w:WORK_AT]->(company:Company)-[:C_IS_LOCATED_IN]->(companyCountry:Country)
                  WHERE oPerson = otherPerson
                  SELECT company.name AS companyName, w.workFrom, companyCountry.name AS countryName),
 universities = ( FROM GRAPH snb.snbGraph
                  MATCH (oPerson:Person)-[s:STUDY_AT]->(university:University)-[:U_IS_LOCATED_IN]->(universityCity:City)
                  WHERE oPerson = otherPerson
                  SELECT university.name AS universityName, s.classYear, universityCity.name AS cityName)
WHERE person.id = 933 AND otherPerson.firstName = 'Jack'
GROUP BY otherPerson, locationCity, companies, universities
GROUP AS g        
SELECT
    otherPerson.id,
    otherPerson.lastName,
    (SELECT VALUE MIN(PATH_HOP_COUNT(gi.p)) FROM g gi)[0] AS distanceFromPerson,
    otherPerson.birthday,
    otherPerson.creationDate,
    otherPerson.gender,
    otherPerson.browserUsed,
    otherPerson.locationIP,
    otherPerson.email,
    otherPerson.speaks,
    locationCity.name,
    universities,
    companies
ORDER BY distanceFromPerson ASC, otherPerson.lastName ASC, otherPerson.id ASC
LIMIT 20;
