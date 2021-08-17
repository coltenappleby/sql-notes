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
	LEFT JOIN LATERAL (SELECT educations.*	-- Takes the highest education level from degree. Removes the rest
		FROM "57b91e17-da0f-4c2d-beb4-39d6eb216746-educations" educations 
		WHERE people.id = educations.person_id
		ORDER BY educations.degree DESC
		FETCH FIRST 1 ROW ONLY) educations
		ON true
``` 

## Concating two columns together into one
```SQL
	CONCAT (db.first_name, ' ', db.last_name) as full_name
```