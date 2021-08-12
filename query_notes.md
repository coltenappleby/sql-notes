### SQL Notes



## Joins

# LEFT JOIN
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

# INNER JOIN
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