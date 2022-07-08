DROP DATAVERSE snb IF EXISTS;
CREATE DATAVERSE snb;
USE snb;

CREATE TYPE PostType AS closed {
    id: bigint,
    imageFile: string?,
    creationDate: bigint,
    locationIP: string,
    browserUsed: string,
    language: string?,
    content: string?,
    length: int,
    creatorId: bigint,
    forumId: bigint?,
    placeId: bigint
};

CREATE TYPE CommentType AS closed {
    id: bigint,
    creationDate: bigint,
    locationIP: string,
    browserUsed: string,
    content: string?,
    length: int,
    creatorId: bigint,
    placeId: bigint,
    replyOfPostId: bigint?,
    replyOfCommentId: bigint?
};

CREATE TYPE MessageType_ AS closed {
    id: bigint,
    imageFile: string?,
    creationDate: bigint,
    locationIP: string,
    browserUsed: string,
    language: string?,
    content: string?,
    length: int,
    creatorId: bigint,
    forumId: bigint?,
    placeId: bigint,
    replyOfMessageId: bigint?,
    isPost: boolean
};

CREATE TYPE MessageType AS closed {
    id: bigint,
    imageFile: string?,
    creationDate: bigint,
    locationIP: string,
    browserUsed: string,
    language: string?,
    content: string?,
    length: int,
    creatorId: bigint,
    forumId: bigint?,
    placeId: bigint,
    replyOfMessageId: bigint?,
    isPost: boolean,
    tags: [bigint]
};

CREATE TYPE ForumType_ AS closed {
    id: bigint,
    title: string,
    creationDate: bigint,
    moderatorId: bigint
};

CREATE TYPE ForumType AS closed {
    id: bigint,
    title: string,
    creationDate: bigint,
    moderatorId: bigint,
    tags: [bigint]
};

CREATE TYPE ForumPersonType AS closed {
    forumId: bigint,
    personId: bigint,
    joinDate: bigint
};

CREATE TYPE ForumTagType AS closed {
    forumId: bigint,
    tagId: bigint
};

CREATE TYPE OrganizationType AS closed {
    id: bigint,
    otype: string,
    name: string,
    url: string,
    placeId: bigint
};

CREATE TYPE UniversityType AS closed {
    id: bigint,
    name: string,
    url: string,
    placeId: bigint
};

CREATE TYPE PersonType_ AS closed {
    id: bigint,
    firstName: string,
    lastName: string,
    gender: string,
    birthday: bigint,
    creationDate: bigint,
    locationIP: string,
    browserUsed: string,
    placeId: bigint,
    language: string,
    email: string
};

CREATE TYPE UniversityYearType AS closed {
    organizationId: bigint,
    classYear: int
};

CREATE TYPE CompanyYearType AS closed {
    organizationId: bigint,
    workFrom: int
};

CREATE TYPE PersonType AS closed {
    id: bigint,
    firstName: string,
    lastName: string,
    gender: string,
    birthday: bigint,
    creationDate: bigint,
    locationIP: string,
    browserUsed: string,
    placeId: bigint,
    language: [string],
    email: [string],
    universities: [UniversityYearType],
    companies: [CompanyYearType]
};

CREATE TYPE PersonTagType AS closed {
    personId: bigint,
    tagId: bigint
};

CREATE TYPE KnowsType AS closed {
    startId: bigint,
    endId: bigint,
    creationDate: bigint
};

CREATE TYPE LikesType AS closed {
    personId: bigint,
    messageId: bigint,
    creationDate: bigint
};

CREATE TYPE PersonUniversityType AS closed {
    personId: bigint,
    organizationId: bigint,
    classYear: int
};

CREATE TYPE PersonCompanyType AS closed {
    personId: bigint,
    organizationId: bigint,
    workFrom: int
};

CREATE TYPE PlaceType AS closed {
    id: bigint,
    name: string,
    url: string,
    ptype: string,
    containerId: bigint?
};

CREATE TYPE LocationType AS closed {
    id: bigint,
    name: string,
    url: string,
    containerId: bigint?
};

CREATE TYPE MessageTagType AS closed {
    messageId: bigint,
    tagId: bigint
};

CREATE TYPE TagClassType AS closed {
    id: bigint,
    name: string,
    url: string,
    isSubclassOf: bigint?
};

CREATE TYPE TagType AS closed {
    id: bigint,
    name: string,
    url: string,
    tagClassId: bigint
};

CREATE DATASET Posts (PostType) PRIMARY KEY id;
CREATE DATASET Comments (CommentType) PRIMARY KEY id;
CREATE DATASET Messages_ (MessageType_) PRIMARY KEY id;
CREATE DATASET Messages (MessageType) PRIMARY KEY id;
CREATE DATASET Forums (ForumType) PRIMARY KEY id;
CREATE DATASET Forums_ (ForumType_) PRIMARY KEY id;
CREATE DATASET ForumPerson (ForumPersonType) PRIMARY KEY forumId, personId;
CREATE DATASET ForumTag (ForumTagType) PRIMARY KEY forumId, tagId;
CREATE DATASET Organizations (OrganizationType) PRIMARY KEY id;
CREATE DATASET Universities (UniversityType) PRIMARY KEY id;
CREATE DATASET Companies (UniversityType) PRIMARY KEY id;
CREATE DATASET Persons_ (PersonType_) PRIMARY KEY id;
CREATE DATASET Persons (PersonType) PRIMARY KEY id;
CREATE DATASET PersonTag (PersonTagType) PRIMARY KEY personId, tagId;
CREATE DATASET Knows (KnowsType) PRIMARY KEY startId, endId;
CREATE DATASET Likes (LikesType) PRIMARY KEY personId, messageId;
CREATE DATASET LikesComment (LikesType) PRIMARY KEY personId, messageId;
CREATE DATASET LikesPost (LikesType) PRIMARY KEY personId, messageId;
CREATE DATASET PersonUniversity (PersonUniversityType) PRIMARY KEY personId, organizationId;
CREATE DATASET PersonCompany (PersonCompanyType) PRIMARY KEY personId, organizationId;
CREATE DATASET Places (PlaceType) PRIMARY KEY id;
CREATE DATASET Cities (LocationType) PRIMARY KEY id;
CREATE DATASET Countries (LocationType) PRIMARY KEY id;
CREATE DATASET Continents (LocationType) PRIMARY KEY id;
CREATE DATASET MessageTag (MessageTagType) PRIMARY KEY messageId, tagId;
CREATE DATASET CommentTag (MessageTagType) PRIMARY KEY messageId, tagId;
CREATE DATASET PostTag (MessageTagType) PRIMARY KEY messageId, tagId;
CREATE DATASET TagClasses (TagClassType) PRIMARY KEY id;
CREATE DATASET Tags (TagType) PRIMARY KEY id;




