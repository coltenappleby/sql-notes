--SELECT *, "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications".title, "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications".received
--FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people"
--JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications"
--ON "57b91e17-da0f-4c2d-beb4-39d6eb216746-people".id = "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications".person_id
--LIMIT 10;


--SELECT *
--FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people"
--HAVING COUNT("57b91e17-da0f-4c2d-beb4-39d6eb216746-people".salutation) 
--	AND COUNT(*) > 0
--LIMIT 4;

SELECT *
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications"
WHERE "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications".expiration IS NOT NULL;



SELECT people.first_name, emails.email
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-email_addresses" emails
ON people.id = emails.record_id;

SELECT people.first_name, people.last_name, entries.created_at, stages.name
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
	FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_entries" entries ON people.id = entries.person_id
	FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_stages" stages ON entries.stage_id = stages.id;