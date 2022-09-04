FROM GRAPH snb.snbGraph
MATCH (tagClass:TagClass)<-[:HAS_TYPE]-(tag:Tag)
LET countWindow1 = ( FROM GRAPH snb.snbGraph
      MATCH (inner_tag:Tag)<-[:M_HAS_TAG]-(m1:Message)
      WHERE inner_tag = tag AND 1313579421570 <= m1.creationDate AND m1.creationDate < 1313579421570 + 8640000000
      SELECT VALUE COUNT(DISTINCT m1) )[0] ,
    countWindow2 = ( FROM GRAPH snb.snbGraph
      MATCH (inner_tag:Tag)<-[:M_HAS_TAG]-(m2:Message)
      WHERE inner_tag = tag AND 1313579421570 + 8640000000 <= m2.creationDate AND m2.creationDate < 1313579421570 + 17280000000
      SELECT VALUE COUNT(DISTINCT m2) )[0]
WHERE tagClass.name = 'Politician'
SELECT DISTINCT tag.name AS tagName, countWindow1, countWindow2, countWindow1 - countWindow2 AS diff
ORDER BY diff DESC, tagName ASC
LIMIT 100;


FROM GRAPH snb.snbGraph
MATCH (tagClass:TagClass)<-[:HAS_TYPE]-(tag:Tag)
LEFT MATCH (tag)<-[:M_HAS_TAG]-(m1:Message WHERE 1313579421570 <= m1.creationDate AND m1.creationDate < 1313579421570 + 8640000000)
LEFT MATCH (tag)<-[:M_HAS_TAG]-(m2:Message WHERE 1313579421570 + 8640000000 <= m2.creationDate AND m2.creationDate < 1313579421570 + 17280000000)
WHERE tagClass.name = 'Politician'
GROUP BY tag
SELECT tag.name AS tagName, COUNT(DISTINCT m1) AS countWindow1, COUNT(DISTINCT m2) AS countWindow2, abs(COUNT(DISTINCT m1) - COUNT(DISTINCT m2)) as diff
ORDER BY diff DESC, tagName ASC
LIMIT 100;