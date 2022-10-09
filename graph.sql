USE snb;
DROP GRAPH snbGraph IF EXISTS;

CREATE GRAPH snbGraph AS

VERTEX (:Message)    PRIMARY KEY (id) AS Messages,
VERTEX (:Forum)      PRIMARY KEY (id) AS Forums,
VERTEX (:Person)     PRIMARY KEY (id) AS Persons,
VERTEX (:Tag)        PRIMARY KEY (id) AS Tags,
VERTEX (:TagClass)   PRIMARY KEY (id) AS TagClasses,
VERTEX (:University) PRIMARY KEY (id) AS Universities,
VERTEX (:Company)    PRIMARY KEY (id) AS Companies,
VERTEX (:City)       PRIMARY KEY (id) AS Cities,
VERTEX (:Country)    PRIMARY KEY (id) AS Countries,
VERTEX (:Continent)  PRIMARY KEY (id) AS Continents,

EDGE (:Message)-[:REPLY_OF]->(:Message)
SOURCE KEY (id) DESTINATION KEY (replyOfMessageId)
AS ( SELECT id, replyOfMessageId FROM Messages WHERE isPost = false ),

EDGE (:Message)-[:HAS_CREATOR]->(:Person)
SOURCE KEY (id) DESTINATION KEY (creatorId)
AS ( SELECT id, creatorId FROM Messages ),

EDGE (:Message)-[:M_IS_LOCATED_IN]->(:Country)
SOURCE KEY (id) DESTINATION KEY (placeId)
AS ( SELECT id, placeId FROM Messages ),

EDGE (:Message)-[:M_HAS_TAG]->(:Tag)
SOURCE KEY (id) DESTINATION KEY (tagId)
AS ( SELECT M.id, tagId FROM Messages M UNNEST M.tags tagId ),

EDGE (:Forum)-[:CONTAINER_OF]->(:Message)
SOURCE KEY (forumId) DESTINATION KEY (id)
AS ( SELECT id, forumId FROM Messages WHERE isPost = true ),

EDGE (:Forum)-[:HAS_MODERATOR]->(:Person)
SOURCE KEY (id) DESTINATION KEY (moderatorId)
AS ( SELECT id, moderatorId FROM Forums ),

EDGE (:Forum)-[:HAS_MEMBER]->(:Person)
SOURCE KEY (forumId) DESTINATION KEY (personId)
AS ( SELECT forumId, personId, joinDate FROM ForumPerson ),

EDGE (:Forum)-[:F_HAS_TAG]->(:Tag)
SOURCE KEY (id) DESTINATION KEY (tagId)
AS ( SELECT F.id, tagId FROM Forums F UNNEST F.tags tagId ),

EDGE (:Person)-[:KNOWS]->(:Person)
SOURCE KEY (startId) DESTINATION KEY (endId)
AS ( SELECT startId, endId, creationDate FROM Knows ),

EDGE (:Person)-[:HAS_INTEREST]->(:Tag)
SOURCE KEY (personId) DESTINATION KEY (tagId)
AS ( SELECT personId, tagId FROM PersonTag ),

EDGE (:Person)-[:P_IS_LOCATED_IN]->(:City)
SOURCE KEY (id) DESTINATION KEY (placeId)
AS ( SELECT id, placeId FROM Persons ),

EDGE (:Person)-[:STUDY_AT]->(:University)
SOURCE KEY (id) DESTINATION KEY (organizationId)
AS ( SELECT P.id, U.organizationId, U.classYear FROM Persons P UNNEST P.universities U ),

EDGE (:Person)-[:WORK_AT]->(:Company)
SOURCE KEY (id) DESTINATION KEY (organizationId)
AS ( SELECT P.id, C.organizationId, C.workFrom FROM Persons P UNNEST P.companies C ),

EDGE (:Person)-[:LIKES]->(:Message)
SOURCE KEY (personId) DESTINATION KEY (messageId)
AS ( SELECT personId, messageId, creationDate FROM Likes ),

EDGE (:Tag)-[:HAS_TYPE]->(:TagClass)
SOURCE KEY (id) DESTINATION KEY (tagClassId)
AS ( SELECT id, tagClassId FROM Tags ),

EDGE (:TagClass)-[:IS_SUBCLASS_OF]->(:TagClass)
SOURCE KEY (id) DESTINATION KEY (isSubclassOf)
AS ( SELECT id, isSubclassOf FROM TagClasses ),

EDGE (:University)-[:U_IS_LOCATED_IN]->(:City)
SOURCE KEY (id) DESTINATION KEY (placeId)
AS ( SELECT id, placeId FROM Universities ),

EDGE (:Company)-[:C_IS_LOCATED_IN]->(:Country)
SOURCE KEY (id) DESTINATION KEY (placeId)
AS ( SELECT id, placeId FROM Companies ),

EDGE (:City)-[:IS_PART_OF]->(:Country)
SOURCE KEY (id) DESTINATION KEY (containerId)
AS ( SELECT id, containerId FROM Cities ),

EDGE (:Country)-[:IS_PART_OF]->(:Continent)
SOURCE KEY (id) DESTINATION KEY (containerId)
AS ( SELECT id, containerId FROM Countries ),

EDGE (:Person)-[:KNOWS19]->(:Person)
SOURCE KEY (person1id) DESTINATION KEY (person2id)
AS ( SELECT person1id, person2id, weight FROM Knows19 ),

EDGE (:Person)-[:KNOWS20]->(:Person)
SOURCE KEY (person1id) DESTINATION KEY (person2id)
AS ( SELECT person1id, person2id, weight FROM Knows20 ),

EDGE (:Person)-[:KNOWS14]->(:Person)
SOURCE KEY (person1id) DESTINATION KEY (person2id)
AS ( SELECT person1id, person2id, weight FROM Knows14 ),

EDGE (:Person)-[:KNOWS15]->(:Person)
SOURCE KEY (person1id) DESTINATION KEY (person2id)
AS ( SELECT person1id, person2id, weight FROM Knows15 );
