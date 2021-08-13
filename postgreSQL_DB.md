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