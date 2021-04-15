--Aquí iré poniendo las cosas del día.
--De primeras hacemos los ejercicios del siguiente boletín: PLSQL-EjerciciosFaciles.pdf
--La tabla usada es la de empleados y departamentos.

/* Haz una función llamada DevolverCodDept que reciba el nombre de un departamento y devuelva su código. */
CREATE OR REPLACE FUNCTION DevolverCodDept(nom in dept.dname%type) 
return dept.deptno%type
is

  v_cod dept.deptno%type := 0;
  
begin

  select deptno
    into v_cod
  from dept
  where upper(dname) = upper(nom);
  
  RETURN v_cod;

exception
when no_data_found then
  return -1;            --Con esto gestionamos mejor el error y saca un -1 cuando no encuentra datos.
when others then       --Y en este se controlan el resto de errores con el mensaje error.
RETURN 'ERROR';

end;
/
show errors;
/
--Con esto tendríamos creada la función correspondiente.
select DevolverCodDept('SaLeSs') from dual; --Habría que quitarle la última 's' porque es para que falle.
--Y esta línea del select es una prueba de que la función está hecha correctamente.

/* 
 * Un cursor es una forma de llevarte una tabla o consulta entera a memoria.
 */
DECLARE
  CURSOR C_EMP
  IS SELECT EMPNO, ENAME, SAL
    FROM EMP
    ORDER BY 1 DESC;
    
  V_EMPNO EMP.EMPNO%TYPE;
  V_ENAME EMP.ENAME%TYPE;
  V_SAL EMP.SAL%TYPE;
  
BEGIN

OPEN C_EMP;

  LOOP --Esto hace un bucle pero nunca para.
    FETCH C_EMP INTO V_EMPNO, V_ENAME, V_SAL; --Con esto cargamos lo que hay dentro del cursor, pero solo una vez.
    DBMS_OUTPUT.PUT_LINE(V_ENAME||' COBRA '||V_SAL);
    EXIT WHEN C_EMP%NOTFOUND; --Con esto haces que el bucle tenga un final cuando no encuentre nada más nuevo.
  END LOOP; --Debido al bucle salen a veces 2 veces los datos aunque solo estén una vez en las tablas. Porque al acabar repite una vez más y añade una nueva a modo de "copia" de otra.

END;
/
--Aquí hay una "breve" explicación de lo que es un cursor más el ejemplo que hace.
