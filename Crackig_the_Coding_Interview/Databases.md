# Databases

### Implicit vd Explicit
Explicit Join
``` SQL
SELECT CourseName, TeacherName
FROM Courses INNER JOIN Teachers
ON Courses.TeacherID = Teachers.TeacherID;
```

Implicit Join
``` SQL
SELECT  CourseName, TeacherName
FROM    Courses, Teachers
WHERE   Courses.TeacherID = 
        Teachers.TeacherID;
```

### Denormalized vs Normalized Databases
Normalized databases 
* designed to minimize redundancy
* Data is unique in each table

<br> Denormalized Database <br>
* Designed to be optimize read time
* Data is is stored in redundant places to prevent joins to be needed to query data
