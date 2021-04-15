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
select DevolverCodDept('SaLeS') from dual;
--Y esta línea del select es una prueba de que la función está hecha correctamente.
