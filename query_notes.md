# SQL Notes



## Joins

### LEFT JOIN
Will grab everthing from the first table and only the information that is available for those lines on the second table

Schema
* sailorsenshi schema
	* id
	* senshi_name
	* real_name_jpn
	* school_id
	* cat_id
* cats schema
	* id
	* name
schools schema
	* id
	* school

```SQL
SELECT senshi_name as sailor_senshi, real_name_jpn as real_name, cats.name as cat, schools.school
FROM sailorsenshi
LEFT JOIN cats ON cats.id = sailorsenshi.cat_id
LEFT JOIN schools ON schools.id = sailorsenshi.school_id
```

Outputs to
| sailor_senshi  | real_name     | cat     | school                              |
|----------------|---------------|---------|-------------------------------------|
| Sailor Moon    | Usagi Tsukino | Luna    | Juuban Municipal Junior High School |
| Sailor Mercury | Ami Mizuno    | Luna    | Juuban Municipal Junior High School |
| Sailor Mars    | Rei Hino      | Luna    | TA Academy for Girls                |
| Sailor Jupiter | Makoto Kino   | Luna    | Juuban Municipal Junior High School |
| Sailor Venus   | Minako Aino   | Artemis | Juuban Municipal Junior High School |
| Tuxedo Mask    | Mamoru Chiba  |         | Moto Azabu High School              |
| Sailor Uranus  | Haruka Tenou  |         | Infinity Academy                    |
| Sailor Neptune | Michiru Kaiou |         | Infinity Academy                    |
| Sailor Saturn  | Hotaru Tomoe  |         | Infinity Academy                    |
| Sailor Pluto   | Setsuna Meiou |         |                                     |

### INNER JOIN
Will return only the lines that have information from both tables 
```SQL
SELECT senshi_name as sailor_senshi, real_name_jpn as real_name, cats.name as cat, schools.school
FROM sailorsenshi
INNER JOIN cats ON cats.id = sailorsenshi.id
INNER JOIN schools ON schools.id = sailorsenshi.id
```
Output
sailor_senshi	real_name		cat		school
Sailor Moon		Usagi Tsukino	Luna	Juuban Municipal Junior High School
Sailor Mercury	Ami Mizuno		Artemis	TA Academy for Girls

### Limiting a JOIN to one row for each left join table row
```SQL 
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
``` 



## Other Functions

### Concating two columns together into one
```SQL
	CONCAT (db.first_name, ' ', db.last_name) as full_name
```

### Count Function
```SQL
    --  Count of a records for each user - record_id is the user_id
    SELECT addresses.record_id, count(addresses.record_id) as count
    FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-email_addresses" addresses
    GROUP BY addresses.record_id
    ORDER BY count DESC ;
```
## Other SQL Query Notes 

### Trying to remove columns that are only NULL
```SQL
    SELECT *
    FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications"
    WHERE "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications".expiration IS NOT NULL;
```

### Cases
```SQL
	CASE dbt.column_name
		WHEN 0 THEN 'open'
		WHEN 1 THEN 'active_contract'
		WHEN 2 THEN 'closed'
		WHEN 3 THEN 'filled'
		WHEN 4 THEN 'cancelled'
		WHEN 5 THEN 'on_hold'
		ELSE NULL
	END as named_query
```
Create these in Excel using concat()