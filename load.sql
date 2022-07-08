USE snb;


LOAD DATASET Posts USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/post_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));
 
LOAD DATASET Comments USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/comment_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET Forums_ USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/forum_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET ForumPerson USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/forum_hasMember_person_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET ForumTag USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/forum_hasTag_tag_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET Organizations USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/static/organisation_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET Persons_ USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET PersonTag USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_hasInterest_tag_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET Knows USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_knows_person_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET LikesComment USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_likes_comment_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET LikesPost USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_likes_post_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET PersonUniversity USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_studyAt_organisation_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET PersonCompany USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/person_workAt_organisation_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET Places USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/static/place_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET CommentTag USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/comment_hasTag_tag_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET PostTag USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/dynamic/post_hasTag_tag_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET TagClasses USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/static/tagclass_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));

LOAD DATASET Tags USING localfs
(("path"="127.0.0.1:///home/sushrut/data_input/static/tag_0_0.csv"),
("format"="delimited-text"),("delimiter"="|"),("null"=""),("header"="true"));


INSERT INTO Messages_ (SELECT P.*, true AS isPost FROM Posts P);
INSERT INTO Messages_ (SELECT C.id, C.creationDate, C.locationIP, C.browserUsed, C.content, C.length, C.creatorId, C.placeId,
                      false AS isPost, coalesce(C.replyOfPostId, C.replyOfCommentId) AS replyOfMessageId FROM Comments C);

INSERT INTO Likes (SELECT VALUE P FROM LikesPost P);
INSERT INTO Likes (SELECT VALUE C FROM LikesComment C);

INSERT INTO MessageTag (SELECT VALUE P FROM PostTag P);
INSERT INTO MessageTag (SELECT VALUE C FROM CommentTag C);

INSERT INTO Messages (SELECT M.*, (SELECT VALUE T.tagId FROM MessageTag T WHERE M.id = T.messageId) AS tags FROM Messages_ M);
INSERT INTO Forums (SELECT F.*, (SELECT VALUE T.tagId FROM ForumTag T WHERE F.id = T.forumId) AS tags FROM Forums_ F);


INSERT INTO Persons
    (SELECT P.*, split(language, ';') AS language, split(email, ';') AS email,
       (SELECT U.organizationId, U.classYear FROM PersonUniversity U WHERE P.id = U.personId) AS universities,
       (SELECT C.organizationId, C.workFrom FROM PersonCompany C WHERE P.id = C.personId) AS companies
     FROM Persons_ P);

INSERT INTO Cities (SELECT P.id, P.name, P.url, P.containerId FROM Places P WHERE P.ptype = 'city');
INSERT INTO Countries (SELECT P.id, P.name, P.url, P.containerId FROM Places P WHERE P.ptype = 'country');
INSERT INTO Continents (SELECT P.id, P.name, P.url FROM Places P WHERE P.ptype = 'continent');

INSERT INTO Universities (SELECT O.id, O.name, O.url, O.placeId FROM Organizations O WHERE O.otype = 'university');
INSERT INTO Companies (SELECT O.id, O.name, O.url, O.placeId FROM Organizations O WHERE O.otype = 'company');

DROP DATASET Posts;
DROP DATASET Comments;
DROP DATASET LikesPost;
DROP DATASET LikesComment;
DROP DATASET PostTag;
DROP DATASET CommentTag;
DROP DATASET Persons_;
DROP DATASET Messages_;
DROP DATASET Forums_;
DROP DATASET MessageTag;
DROP DATASET ForumTag;
DROP DATASET PersonCompany;
DROP DATASET PersonUniversity;
DROP DATASET Places;
DROP DATASET Organizations;
