# Notes

Importing a SQL dump and createing a new database

### Access Postgres SHELL in Terminal

```sh
psql postgres
```

### Deleting a Database

Access the Posgres SHELL, then enter the below
```sh
DROP DATABASE IF EXISTS "nameofdb";
```

### Start a Database from Terminal
```sh
psql -p 5432 -d "nameofDB"
```

### Navigating Postgres.app

Open App and double click on a Database. This will open a postgres terminal window. Here you can use postgres commands such as \l to list all databases.


### =# vs -#

You must end all lines with a semicolon. -# means that the system is waiting for more input.


## postgres shell commands
\l --- lists all databases
\q --- quits current database

## Limiting One
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

## Concating two columns together into one
```SQL
	CONCAT (db.first_name, ' ', db.last_name) as full_name
```

## Joing three tables
``` SQL
-- Joining Three Tables
    SELECT people.first_name, people.last_name, entries.created_at, stages.name
    FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-people" people
        FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_entries" entries ON people.id = entries.person_id
        FULL OUTER JOIN "57b91e17-da0f-4c2d-beb4-39d6eb216746-pipeline_stages" stages ON entries.stage_id = stages.id;
```

## Count Function
```SQL
    --  Count of a records for each user - record_id is the user_id
    SELECT addresses.record_id, count(addresses.record_id) as count
    FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-email_addresses" addresses
    GROUP BY addresses.record_id
    ORDER BY count DESC ;
```

## Trying to remove columns that are only NULL
```SQL
    SELECT *
    FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications"
    WHERE "57b91e17-da0f-4c2d-beb4-39d6eb216746-certifications".expiration IS NOT NULL;
```