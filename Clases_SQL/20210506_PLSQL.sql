/* CREAR UNA FUNCIÓN QUE DEVUELVA CUÁNTO SE GASTA EN CADA CIUDAD EL EMPLEADO,
PASANDO UNA CIUDAD POR PARÁMETRO SABER EL CUÁNTO SE HA GASTADO. */
CREATE OR REPLACE FUNCTION F_GASTO_EN_CIUDAD(P_CIUDAD VARCHAR2)
RETURN NUMBER
IS

  V_GASTO  NUMBER:=0;

BEGIN
  SELECT nvl(SUM(DP.PRECIOUNIDAD*DP.CANTIDAD),0)
    INTO V_GASTO
  FROM OFICINAS O, EMPLEADOS E, CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP
  WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
  AND E.CODIGOEMPLEADO = C.CODIGOEMPLEADOREPVENTAS
  AND C.CODIGOCLIENTE = P.CODIGOCLIENTE
  AND P.CODIGOPEDIDO=DP.CODIGOPEDIDO
  AND UPPER(O.CIUDAD) = UPPER(P_CIUDAD);

  RETURN V_GASTO;

EXCEPTION 
WHEN OTHERS THEN

  dbms_output.put_line('ERROR EN F_GASTO_EN_CIUDAD');
  RETURN -1;
  
  
END;

--PARA PROBAR LO ANTERIOR:
select F_GASTO_EN_CIUDAD('Madrid') from dual;
/
declare
  a number;
begin

 a:=F_GASTO_EN_CIUDAD('Madrid');

 dbms_output.put_line(a);

end;

/* DEDUCIR DEL CÓDIGO EL ENUNCIADO Y ES BÁSICAMENTE USAR Y MOSTRAR LO ANTERIOR: */
SELECT 'EN LA CIUDAD '||O.CIUDAD||' SE HA GASTADO '||F_GASTO_EN_CIUDAD(O.CIUDAD)
FROM OFICINAS O;

--Primera opción "peor" la de arriba, y mejor la de abajo

DECLARE

  CURSOR C_CIUDAD IS SELECT O.CIUDAD FROM OFICINAS O;
  
  V_CIUDAD OFICINAS.CIUDAD%TYPE;
  
  V_GASTO NUMBER :=0;

BEGIN
  OPEN C_CIUDAD;
  LOOP
    FETCH C_CIUDAD INTO V_CIUDAD;
    EXIT WHEN C_CIUDAD%NOTFOUND;
    
    V_GASTO := F_GASTO_EN_CIUDAD(V_CIUDAD);
    
    dbms_output.put_line(' EN LA CIUDAD '|| v_ciudad||' SE HA GASTADO '||v_gasto);
    
  END LOOP;
  CLOSE C_CIUDAD;
END;

/* QUE TRADUZCA LOS NOMBRES AL ESPAÑOL */
SELECT DECODE(UPPER(O.CIUDAD),'TOKYO','TOKIO','SYDNEY','SIDNEY',UPPER(O.CIUDAD))
FROM OFICINAS O;

/* CÓMO ES HACER O TENER UN PAQUETE */
CREATE OR REPLACE PACKAGE pckDEPT is

  PROCEDURE spInsertaDEPT(pdeptno dept.deptno%type,pdname dept.dname%type,ploc dept.loc%type);
  PROCEDURE spBorraDEPT(pdeptno dept.deptno%type);
  PROCEDURE spActualizaDEPT(pdeptno dept.deptno%type,pdname dept.dname%type,ploc dept.loc%type);

end;
/
CREATE OR REPLACE PACKAGE body pckDEPT is

PROCEDURE spInsertaDEPT(pdeptno dept.deptno%type,pdname dept.dname%type,ploc dept.loc%type)
is
begin
  insert into dept(deptno, dname, loc) values (pdeptno, pdname, ploc);
end;
PROCEDURE spBorraDEPT(pdeptno dept.deptno%type)
is
begin
  delete from dept 
  where deptno = pdeptno;
end;

PROCEDURE spActualizaDEPT(pdeptno dept.deptno%type,pdname dept.dname%type,ploc dept.loc%type)
is
begin
  update DEPT
  set dname = pdname,
      loc = ploc
  where deptno = pdeptno;
end;

end;

/
SHOW ERRORS;
/

execute pckDEPT.spInsertaDEPT(33,'NACHO','PERDON');
/
SELECT * FROM DEPT;
/
execute pckDEPT.spBorraDEPT(33);
/
SELECT * FROM DEPT;

/* HACER UNA COPIA DE 3 TABLAS DEL DEPARTAMENTO: */
DROP TABLE DEPT_COPIA_SAL;
CREATE TABLE DEPT_COPIA_SAL 
AS 
SELECT DEPTNO AS NUMDEPT, DNAME AS NOMBRE, LOC AS LUGAR, 0  AS TOTAL_SALARIO
FROM DEPT WHERE 1 =0;
DESC DEPT_COPIA_SAL;

