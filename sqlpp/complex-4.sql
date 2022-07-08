FROM GRAPH snb.snbGraph
MATCH (person:Person)-[:KNOWS]-(friend:Person)<-[:HAS_CREATOR]-(post:Message)-[:M_HAS_TAG]->(tag:Tag),
      (person)-[:KNOWS]-(:Person)<-[:HAS_CREATOR]-(post2:Message)
WHERE
    person.id = 933 AND post.isPost = true AND post2.isPost = true
    AND 1313579421570 <= post.creationDate AND post.creationDate < 1313579421570 + 29223923803
    AND post2.creationDate < 1313579421570 AND
    NOT EXISTS ( FROM GRAPH snb.snbGraph 
                 MATCH (inner_post:Message)-[:M_HAS_TAG]->(inner_tag:Tag)
                 WHERE inner_post = post2 AND inner_tag = tag
                 SELECT VALUE 1 )
GROUP BY tag
GROUP AS g
SELECT tag.name, (SELECT VALUE COUNT(DISTINCT post) FROM g)[0] as postCount
ORDER BY postCount DESC, tag.name ASC
LIMIT 10;