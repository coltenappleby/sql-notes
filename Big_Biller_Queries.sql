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

-- Joining Three Tables
SELECT people.first_name, people.last_name, entries.created_at, stages.name
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
	FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_entries" entries ON people.id = entries.person_id
	FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_stages" stages ON entries.stage_id = stages.id;


-- Trying to select one row for each left table instance
SELECT people.id, people.first_name, people.last_name, certifications.*
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
	JOIN (SELECT certifications.*, row_number() over (partition by certifications.id order by id) as seqnum FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications" certifications ) certifications  ON people.id = certifications.person_id;
GROUP BY people.id, people.first_name, people.last_name;

-- OR *PREFERED METHOD*
SELECT people.id, people.first_name, people.last_name, certifications.*
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
	LEFT JOIN LATERAL (SELECT certifications.* 	
	FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications" certifications 
	WHERE people.id = certifications.person_id
	FETCH FIRST 1 ROW ONLY) certifications
	ON true;



--  Count of a records for each user - record_id is the user_id
SELECT addresses.record_id, count(addresses.record_id) as count
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-email_addresses" addresses
GROUP BY addresses.record_id
ORDER BY count DESC ;

-- view all the emails for the three uses on teh last line. 
SELECT people.id, people.first_name, people.last_name, addresses.email
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-email_addresses" addresses 
	ON people.id = addresses.record_id
WHERE people.id = 'b815d6ff-8997-42fd-bb45-39eafb3c08ef' OR people.id = '41fc4eec-8e1f-4153-b840-75270f709d7e' OR people.id = '214839be-88fe-4081-8132-a27391624239';
	
GROUP BY people.id, people.first_name, people.last_name;





-- CURRENT QUERY:
SELECT people.id, people.first_name, people.last_name, 
	certifications.title as certification_title, certifications.received as certification_received, certifications.expiration as certification_expiration, -- expiration is probably uncessary
	educations.school, educations.degree, educations.area as education_area, educations.description,
	addresses.email, addresses.type as email_type, addresses.primary as email_primary, addresses.do_not_email,
	phone_numbers.raw_format as phone_number, phone_numbers.primary as phone_number_primary,
	CASE phone_numbers.type 
			WHEN 1 THEN 'home'
			WHEN 2 THEN 'work'
			WHEN 3 THEN 'mobile'
			ELSE NULL
	END as phone_number_type 
	
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
-- Certifications
	LEFT JOIN LATERAL (SELECT certifications.*	-- Takes the longest title certification. Removes the rest
	FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications" certifications 
	WHERE people.id = certifications.person_id
	ORDER BY Length(certifications.title) DESC
	FETCH FIRST 1 ROW ONLY) certifications
	ON true
-- EDUCATION 	
	LEFT JOIN LATERAL (SELECT educations.*	-- Takes the highest education level from degree. Removes the rest
	FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-educations" educations 
	WHERE people.id = educations.person_id
	ORDER BY educations.degree DESC
	FETCH FIRST 1 ROW ONLY) educations
	ON true
-- Email Addresses
	LEFT JOIN LATERAL (SELECT addresses.*	-- Takes the most recent created email address. Removes the rest
	FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-email_addresses" addresses 
	WHERE people.id = addresses.record_id
	ORDER BY addresses.created_at DESC
	FETCH FIRST 1 ROW ONLY) addresses
	ON true
-- Phone Numbers
	LEFT JOIN LATERAL (SELECT phone_numbers.*	-- Takes the most recent created phone number. Removes the rest
	FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-phone_numbers" phone_numbers 
	WHERE people.id = phone_numbers.record_id
	ORDER BY phone_numbers.created_at DESC
	FETCH FIRST 1 ROW ONLY) phone_numbers
	ON true;