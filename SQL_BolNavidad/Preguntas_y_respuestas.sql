/*Desarrolle una consulta que liste el nombre del empleado, el código del departamento y fecha de inicio que empezó a trabajar, 
ordenando el resultado por departamento y por fecha de inicio, el ultimo que entro a trabajar va de primero.*/
SELECT FIRST_NAME, DEPARTMENT_ID, START_DATE
FROM EMPLOYEES, DEPARTMENTS, JOB_HISTORY
;
--No va, da errores de compilación...
