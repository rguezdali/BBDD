/* Mi intento: */
--OBTENER EL NOMBRE DE LOS CLIENTES ORDENADOS DESCENDENTEMENTE, DE AQUELLOS QUE HAN PAGADO MAS DE 10000 EUROS
SELECT NOMBRECLIENTE
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
AND 
ORDER BY DESC 
;

/* Corrección del anterior: */
--OBTENER EL NOMBRE DE LOS CLIENTES ORDENADOS DESCENDENTEMENTE, DE AQUELLOS QUE HAN PAGADO MAS DE 10000 EUROS
SELECT C.NOMBRECLIENTE, SUM(PA.CANTIDAD)
FROM CLIENTES C, PAGOS PA
WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
--AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
GROUP BY C.NOMBRECLIENTE
HAVING (SUM(PA.CANTIDAD) >= 10000)    --FUNCIÓN AGREGACIÓN
ORDER BY C.NOMBRECLIENTE DESC;´

/* Mi intento: */
--v.1 DE ENTRE TODOS LOS CLIENTES QUE CONTIENEN UNA 'A', AQUEL QUE HA PAGADO MÁS
SELECT C.NOMBRECLIENTE, MAX(SUM(PA.CANTIDAD)) --ROWNUM?
FROM CLIENTES C, PAGOS PA
WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
GROUP BY C.NOMBRECLIENTE;
HAVING MAX(SUM(PA.CANTIDAD)); --NO
--ORDER BY C.NOMBRECLIENTE DESC

--v.2 DE ENTRE TODOS LOS CLIENTES QUE CONTIENEN UNA 'A', AQUEL QUE HA PAGADO MÁS
SELECT *
FROM (
      SELECT C.NOMBRECLIENTE, ROWNUM(SUM(PA.CANTIDAD)) --ROWNUM?
      FROM CLIENTES C, PAGOS PA
      WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
      AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
      GROUP BY C.NOMBRECLIENTE;
      HAVING MAX(SUM(PA.CANTIDAD)); --NO
      --ORDER BY C.NOMBRECLIENTE DESC
     )
;

/* Corrección del anterior: */
--v.1 DE ENTRE TODOS LOS CLIENTES QUE CONTIENEN UNA 'A', AQUEL QUE HA PAGADO MÁS
SELECT * FROM (
               SELECT C.NOMBRECLIENTE, SUM(PA.CANTIDAD)
               FROM CLIENTES C, PAGOS PA
               WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
               AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
               GROUP BY C.NOMBRECLIENTE
               HAVING SUM(PA.CANTIDAD) >= 10000     --NO ES NECESARIO
               ORDER BY 2 DESC    --ESTO ES PARA QUE MUESTRE PRIMERO EL MAYOR
              )
WHERE ROWNUM <= 3;
--AQUÍ PONEMOS CUANTOS QUEREMOS QUE NOS MUESTRE (?)

--V.2 DE ENTRE TODOS LOS CLIENTES QUE CONTIENEN UNA 'A', AQUEL QUE HA PAGADO MÁS
SELECT C.NOMBRECLIENTE, SUM(PA.CANTIDAD) AS TOT
FROM CLIENTES C, PAGOS PA
WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
GROUP BY C.NOMBRECLIENTE
HAVING SUM(PA.CANTIDAD) = (
                           SELECT MAX(SUM(PA.CANTIDAD))
                           FROM CLIENTES C, PAGOS PA
                           WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
                           AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
                           GROUP BY C.NOMBRECLIENTE
                          )
;

/*
Crear una función fRellenarCalendario que dada una fecha y un numero
(pNum) rellene desde ese día en adelante ese número de días, si por lo que
fuere ese día estuviera relleno no se tendrá en cuenta y continuará hasta
encontrar uno que se pueda insertar y se continuará así hasta insertar pNum
nuevos, devolver el último día insertado. En el caso de que ciertos días
estuvieran insertados no se debería hacer nada, sólo continuar. Como ayuda,
recordar que si yo inserto dos veces un registro igual en una tabla con una
clave primaria la segunda inserción me daría un error con la excepción
DUP_VAL_ON_INDEX. (2 puntos)
*/
--CREAR LA FUNCIÓN (HECHA POR ANTONIO):
CREATE OR REPLACE FUNCTION fRellenarCalendario (pFecha Date, pNum int)
return DATE
IS
       vFin int;
       vFecha date;
BEGIN

       vFin := pNum-1;
       vFecha := pFecha;
         
       if pNum > 0 then
       
         FOR k in 0..vFin
         loop
            BEGIN 
            
                insert into CALENDARIO(fecha, diasem, semanyo)    --Necesitas tener esto
                values(pFecha+k, to_number(to_char(pFecha+k,'D')), to_number(to_char(pFecha+k,'WW')));
            
            EXCEPTION 
            WHEN DUP_VAL_ON_INDEX THEN
                vFin := vFin + 1;
            END;
         end loop;
         vFecha := vFecha + vFin;
       else 
         vFecha := pFecha;
       end if;
       
       return vFecha;
       
END;
/
show errors;

/* v.1 Ejercicio directo de Antonio: */
CREATE OR REPLACE FUNCTION fRellenarCalendario (pFecha Date, pNum int)
return DATE
IS
  
  vFin int;
  vFecha date;
  
BEGIN

  vFin := pNum-1;
  vFecha := pFecha;

if pNum>0 then

  FOR k in 0..vFin
  loop
     
    BEGIN
  
      insert into CALENDARIO(fecha,diasem,semanyo)
      values (vFecha+k,to_number(to_char(vFecha+k,'D')),to_number(to_char(vFecha+k,'WW')));
      
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      vFin := vFin +1;
    END;
  end loop;
  
  vFecha := vFecha+vFin;
else
  vFecha := pFecha;
end if;  

return vFecha;

END;
/
SHOW ERRORS;

/* v.2 Ejercicio directo de Antonio: */
CREATE OR REPLACE FUNCTION fRellenarCalendario2 (pFecha Date, pNum int)
return DATE
IS
  
  vFin int;
  vFecha date;
    v_existe int:=0;
  
BEGIN

  vFin := pNum-1;
  vFecha := pFecha;

if pNum>0 then

  FOR k in 0..vFin
  loop
  
     select nvl(count(fecha),0)
     into v_existe
     from calendario
     where fecha=vFecha+k;
     
     if v_existe = 0 then
        insert into CALENDARIO(fecha,diasem,semanyo)
        values (vFecha+k,to_number(to_char(vFecha+k,'D')),to_number(to_char(vFecha+k,'WW')));
      
     else
      vFin := vFin +1;
    END if;
  end loop;
  
  vFecha := vFecha+vFin;
else
  vFecha := pFecha;
end if;  

return vFecha;

END;
/
SHOW ERRORS;

-- v.1 SACAR EL QUE MÁS HA PAGADO CON PL/SQL
CREATE OR REPLACE FUNCTION fClienteMasPaga
return CLIENTES.NOMBRECLIENTE%TYPE --varchar2
IS

       vNombre CLIENTES.NOMBRECLIENTE%TYPE := '';

BEGIN

SELECT C.NOMBRECLIENTE into vNombre
FROM CLIENTES C, PAGOS PA
WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
GROUP BY C.NOMBRECLIENTE
HAVING SUM(PA.CANTIDAD)=(SELECT MAX(SUM(PA.CANTIDAD))
                         FROM CLIENTES C, PAGOS PA
                         WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
                         AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
                         GROUP BY C.NOMBRECLIENTE);
      return vNombre;
       
END;
/
SHOW ERRORS;
/
--SELECT fClienteMasPaga() FROM DUAL;
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE(fClienteMasPaga());
END;

-- v.2 SACAR EL QUE MÁS HA PAGADO CON PL/SQL
CREATE OR REPLACE FUNCTION fClienteMasPaga2
return CLIENTES.NOMBRECLIENTE%TYPE
IS
  
  vNombre CLIENTES.NOMBRECLIENTE%TYPE:='';
  vCantidadMax number:=0;
  
BEGIN

SELECT MAX(SUM(PA.CANTIDAD)) into vCantidadMax
FROM CLIENTES C, PAGOS PA
WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
GROUP BY C.NOMBRECLIENTE;


SELECT C.NOMBRECLIENTE INTO vNombre
FROM CLIENTES C, PAGOS PA
WHERE C.CODIGOCLIENTE = PA.CODIGOCLIENTE
AND UPPER(C.NOMBRECLIENTE) LIKE '%A%'
GROUP BY C.NOMBRECLIENTE
HAVING SUM(PA.CANTIDAD)=vCantidadMax;

return vNombre;

END;
/
SHOW ERRORS;
/
SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE(fClienteMasPaga2());
END;
