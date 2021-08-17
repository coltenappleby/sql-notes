-------------------------- CURRENT --------------------------

---- Candidates ----

SELECT people.*,
--	people.id, people.first_name, people.last_name, -- For testing
	certifications.title as certification_title, certifications.received as certification_received, certifications.expiration as certification_expiration, -- expiration is probably uncessary
	educations.school, educations.degree, educations.area as education_area, educations.description,
	addresses.email, addresses.type as email_type, addresses.primary as email_primary, addresses.do_not_email,
	phone_numbers.raw_format as phone_number, phone_numbers.primary as phone_number_primary,
	CASE phone_numbers.type -- PHONE NUMBER TYPE (data from JSON file)
			WHEN 1 THEN 'home'
			WHEN 2 THEN 'work'
			WHEN 3 THEN 'mobile'
			ELSE NULL
	END as phone_number_type,
	tags.name as tags_name,
	entries.id as pipeline_entry_id,
	stages.name as stage_name, stages.position as stage_num,
	jobs.position_title as job_title, jobs.id as job_id, companies.name,
	CONCAT (hiring_managers.first_name, ' ', hiring_managers.last_name) as hiring_manager
	
-- People	
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
		ON true
-- Tags
	LEFT JOIN LATERAL (SELECT taggings.*	-- Takes the most recent pipeline entry (by created_at). Removes the rest
		FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-taggings" taggings 
		WHERE people.id = taggings.record_id
		ORDER BY taggings.id DESC
		FETCH FIRST 1 ROW ONLY) taggings
		ON true
	LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-tags" tags on taggings.tag_id = tags.id

-- JOB + STAGE + Hiring Manager
	LEFT JOIN LATERAL (SELECT entries.*	-- Takes the most recent pipeline entry (by created_at). Removes the rest
		FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_entries" entries 
		WHERE people.id = entries.person_id
		ORDER BY entries.updated_at DESC
		FETCH FIRST 1 ROW ONLY) entries
		ON true
	LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_stages" stages on entries.stage_id = stages.id
	LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipelines" pipelines on entries.pipeline_id = pipelines.id
	LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-jobs" jobs on pipelines.job_id = jobs.id
	LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-companies" companies on jobs.company_id = companies.id
	LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-users" hiring_managers on jobs.owner_id = hiring_managers.id
ORDER BY people.id;


---- JOBS ----

SELECT jobs.*, tags.name as tag, 
	CASE jobs.job_type
		WHEN 0 THEN 'direct_hire'
		WHEN 1 THEN 'contract'
		WHEN 2 THEN 'temp_to_hire'
		ELSE NULL
	END as job_type,
	CASE jobs.status
		WHEN 0 THEN 'open'
		WHEN 1 THEN 'active_contract'
		WHEN 2 THEN 'closed'
		WHEN 3 THEN 'filled'
		WHEN 4 THEN 'cancelled'
		WHEN 5 THEN 'on_hold'
		ELSE NULL
	END as job_status,
	CASE jobs.job_type
		WHEN 0 THEN 'direct_hire'
		WHEN 1 THEN 'contract'
		WHEN 2 THEN 'temp_to_hire'
		ELSE NULL
	END as job_type,
	CASE jobs.compensation_type
		WHEN 0 THEN 'per_hour'
		WHEN 1 THEN 'per year'
		ELSE NULL
	END as compensation_type,
	CASE jobs.priority
		WHEN 0 THEN 'not_specified'
		WHEN 1 THEN 'C'
		WHEN 2 THEN 'B'
		WHEN 3 THEN 'A'
		ELSE NULL
	END as job_priority,
	CASE jobs.remote_option
		WHEN 0 THEN 'full'
		WHEN 1 THEN 'no'
		WHEN 2 THEN 'available'
		WHEN 3 THEN 'not_specified'
		ELSE NULL
	END as remote_option,
	CASE jobs.fee_type
		WHEN 0 THEN 'percentage'
		WHEN 1 THEN 'amount'
		ELSE NULL
	END as fee_type,
	CONCAT (hiring_manager.first_name, ' ', hiring_manager.last_name) as hiring_manager,
	companies.name as company_name
FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-jobs" jobs
LEFT JOIN LATERAL (SELECT taggings.*	-- Takes the most recent pipeline entry (by taggings). Removes the rest
	FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-taggings" taggings 
	WHERE jobs.id = taggings.record_id
	ORDER BY taggings.id DESC
	FETCH FIRST 1 ROW ONLY) taggings
	ON true
LEFT  JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-tags" tags on taggings.tag_id = tags.id
LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-users" hiring_manager on jobs.owner_id = hiring_manager.id
LEFT JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-companies" companies on jobs.company_id = companies.id;