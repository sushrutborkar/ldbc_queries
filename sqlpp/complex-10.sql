FROM GRAPH snb.snbGraph
MATCH (person:Person)-[:KNOWS{2,2}]-(foaf:Person)-[:P_IS_LOCATED_IN]->(city:City)
LET bd = get_month(datetime_from_unix_time_in_ms(foaf.birthday)),
  common = ( FROM GRAPH snb.snbGraph
             MATCH (inner_person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:M_HAS_TAG]-(post:Message)-[:HAS_CREATOR]->(inner_foaf:Person)
             WHERE inner_person = person AND inner_foaf = foaf AND post.isPost = true
             SELECT VALUE COUNT(DISTINCT post) )[0],
uncommon = ( FROM GRAPH snb.snbGraph
             MATCH (post:Message)-[:HAS_CREATOR]->(inner_foaf:Person)
             WHERE inner_foaf = foaf AND post.isPost = true AND
                NOT EXISTS ( FROM GRAPH snb.snbGraph
                             MATCH (inner_person:Person)-[:HAS_INTEREST]->(:Tag)<-[:M_HAS_TAG]-(inner_post:Message)
                             WHERE inner_post.isPost = true AND inner_post = post AND inner_person = person 
                             SELECT VALUE 1 )
             SELECT VALUE COUNT(DISTINCT post) )[0]          
WHERE person.id = 933 AND
    NOT EXISTS ( FROM GRAPH snb.snbGraph
                 MATCH (inner_person:Person)-[:KNOWS]-(inner_foaf:Person)
                 WHERE inner_person = person AND inner_foaf = foaf
                 SELECT VALUE 1 ) AND
    ((bd.month = 3 AND bd.day >= 21) OR (bd.month = (3%12)+1 AND bd.day < 22))
SELECT
    foaf.id,
    foaf.firstName,
    foaf.lastName,
    common - uncommon as commonInterestScore,
    foaf.gender,
    city.name
ORDER BY commonInterestScore DESC, foaf.id ASC
LIMIT 10;