### SQL Notes

## Joins

#LEFT JOIN
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
LEFT JOIN cats ON cats.id = sailorsenshi.id
LEFT JOIN schools ON schools.id = sailorsenshi.id
```

Outputs to
sailor_senshi	real_name		cat		school
Sailor Moon		Usagi Tsukino	Luna	Juuban Municipal Junior High School
Sailor Mercury	Ami Mizuno		Artemis	TA Academy for Girls
Sailor Mars		Rei Hino				Infinity Academy
Sailor Jupiter	Makoto Kino				Moto Azabu High School
Sailor Pluto	Setsuna Meiou		
Sailor Venus	Minako Aino


#INNER JOIN
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