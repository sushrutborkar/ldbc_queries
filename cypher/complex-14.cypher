// :param person1Id: 933
// :param person2Id: 102
// copied from reference queries

MATCH (person1:Person {id: $person1Id}), (person2:Person {id: $person2Id})
CALL gds.shortestPath.dijkstra.stream({
  nodeQuery: 'MATCH (p:Person) RETURN id(p) AS id',
  relationshipQuery: '
    MATCH
      (pA:Person)-[knows:KNOWS]-(pB:Person),
      (pA)<-[:HAS_CREATOR]-(m1:Message)-[r:REPLY_OF]-(m2:Message)-[:HAS_CREATOR]->(pB)
    WITH
      id(pA) AS source,
      id(pB) AS target,
      count(r) AS numInteractions
    RETURN
      source,
      target,
      CASE WHEN floor(40-sqrt(numInteractions)) > 1 THEN floor(40-sqrt(numInteractions)) ELSE 1 END AS weight
    ',
  sourceNode: person1,
  targetNode: person2,
  relationshipWeightProperty: 'weight'
})
YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN [person IN nodes(path) | person.id] AS personIdsInPath, totalCost AS pathWeight
LIMIT 1