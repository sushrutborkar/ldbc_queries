FROM GRAPH snb.snbGraph
MATCH (tag:Tag)<-[:M_HAS_TAG]-(:Message)<-[:REPLY_OF]-(comment:Message)-[:M_HAS_TAG]->(relatedTag:Tag)
WHERE tag.name = 'Diego_Maradona' AND comment.isPost = false
GROUP BY relatedTag
SELECT relatedTag.name, COUNT(comment) as count_
ORDER BY count_ DESC, relatedTag.name ASC
LIMIT 100;