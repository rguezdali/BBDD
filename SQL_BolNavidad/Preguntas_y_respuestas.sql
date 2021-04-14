/*Desarrolle una consulta que liste el nombre del empleado, el código del departamento y fecha de inicio que empezó a trabajar, 
ordenando el resultado por departamento y por fecha de inicio, el ultimo que entro a trabajar va de primero.*/
SELECT FIRST_NAME, DEPARTMENT_ID, START_DATE
FROM EMPLOYEES, DEPARTMENTS, JOB_HISTORY
;
--No va, da errores de compilación... Además de que la respuesta que da el profesor tampoco funciona correctamente.
/*Esta es la solución que propone Antonio: */
SELECT PRIMER_NOMBRE, DEPARTAMENTO_ID, FECHA_CONTRATACION
FROM EMPLEADOS
ORDER BY DEPARTAMENTO_ID, FECHA_CONTRATACION DESC;
