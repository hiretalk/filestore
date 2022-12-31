MERGE (u: User {id: 'nW74cjPEpQZVafCSHSqdT4fW8Yy1'})
SET u +={   createdAt: 1651223538098,
            displayName: 'Mathew Mozer',
            email: 'mat@hiretalk.io',
            seed:true,
            finishedOnboardingWizard: false,
            isAdmin: false,
            profileImage: 'https://lh3.googleusercontent.com/a/AATXAJxFh4KqIUgtLS7Y7ipCQIdZ-QrlaSh6eXvGdEMx=s96-c',
            updatedAt: 1651223538098
        }
MERGE (company:Company {id: '4926d699-db33-45ad-91a1-c05b21c88040'})
SET company +={
            createdAt: 1651223538288,
            createdBy: 'nW74cjPEpQZVafCSHSqdT4fW8Yy1',
            employees: 10.0,
            hires: 10.0,
            industry: 'HR',
            name: 'HireTalk',
            updatedAt: 1651223538288,
            website: 'http://www.google.com'
}
MERGE (company)-[:HAS]->(setting: Setting { type:'company', phraseTypes:['Possible', 'Mandatory', 'Optional']})
MERGE (u)-[:PERMISSION { remove : true , update: true , read: true , create_question: true , update_question: true , remove_question: true }]->(company)
MERGE (u)-[:WORKS_FOR]->(company)
MERGE (u)-[:CREATED]->(company)

// Create the campaign
MERGE (campaign:Campaign {id: '007775b3-268f-489c-9f9c-cee19cd8ec69'})
SET campaign +={
                companyId: '4926d699-db33-45ad-91a1-c05b21c88040',
                createdAt: 1651223602772,
                createdBy: 'nW74cjPEpQZVafCSHSqdT4fW8Yy1',
                label: 'Software Engineer',
                updatedAt: timestamp()
                }
MERGE (u)-[:CREATED]->(campaign)
MERGE (company)-[:LAUNCHED]->(campaign)
// End of create campaign

// Create the campaign
MERGE (campaign2:Campaign {id: '007775b3-268f-572c-9f9c-cee19cd8ab56'})
SET campaign2 +={
                companyId: '4926d699-db33-45ad-91a1-c05b21c88040',
                createdAt: 1651223602772,
                createdBy: 'nW74cjPEpQZVafCSHSqdT4fW8Yy1',
                label: 'QA Engineer',
                updatedAt: timestamp()
                }
MERGE (u)-[:CREATED]->(campaign2)
MERGE (company)-[:LAUNCHED]->(campaign2)
// End of create campaign

// Create a question
MERGE (q: Question {
	 id: '4926d699-db33-45ad-91b2-c05b21c89044', createdBy: 'nW74cjPEpQZVafCSHSqdT4fW8Yy1' })
SET q +={
	label: 'Who let the dogs out?',
    createdAt: apoc.date.currentTimestamp(),
    updatedAt : apoc.date.currentTimestamp()
}

MERGE (u)-[:CREATED]->(q)
MERGE (company)-[:IS_ASKING]->(q)
MERGE (campaign)-[:INCLUDES]->(q)
// End of create question

// Create a question
MERGE (q2: Question {
	 id: '4926d699-db33-45ad-91b2-c05b99c27612', createdBy: 'nW74cjPEpQZVafCSHSqdT4fW8Yy1' })
SET q2 +={
	label: 'What is your name?',
    createdAt: apoc.date.currentTimestamp(),
    updatedAt : apoc.date.currentTimestamp()
}

MERGE (u)-[:CREATED]->(q2)
MERGE (company)-[:IS_ASKING]->(q2)
MERGE (campaign2)-[:INCLUDES]->(q2)
MERGE (campaign2)-[:INCLUDES]->(q)
// End of create question
WITH [
    {
        label:"react is cool",
        importance:"HIGH",
        points:9
    },
    {
        label:"context is key",
        importance:"LOW",
        points:5
    },
    {
        label:"rubber ducky",
        importance:"LOW",
        points:-1
    }
] as phrases, u, company, setting,campaign,q,q2,campaign2
UNWIND phrases as phrase
MERGE (p: Phrase { label: phrase.label })
MERGE (q)-[e:EXPECTS]->(p)

set e += {
    importance: phrase.importance,
    points: phrase.points
}

WITH [
    {
        label:"right components",
        importance:"HIGH",
        points:4
    },
    {
        label:"Declarative views",
        importance:"LOW",
        points:2
    },
    {
        label:"Simple views",
        importance:"LOW",
        points:-3
    }
] as phrases, u, company, setting,campaign,q,q2,campaign2

UNWIND phrases as phrase
MERGE (p: Phrase { label: phrase.label })
MERGE (q2)-[e:EXPECTS]->(p)

set e += {
    importance: phrase.importance,
    points: phrase.points
}
RETURN u, company, setting,campaign,q,p
