--Creación de tabla:
CREATE TABLE CLIENTES_NURIA(
    Nombre VARCHAR2(15) NOT NULL,
    Apellido VARCHAR2(30) NOT NULL,
    DNI VARCHAR2(9),
    Direccion VARCHAR2(30),
    F_Naci DATE,
    EstadoCivil VARCHAR2(1) NOT NULL,
    EntidadBancaria NUMBER(4),
    Sucursal NUMBER(4),
    DC NUMBER(2),
    Cuenta NUMBER(10),
    CONSTRAINT PK_CLIENTES PRIMARY KEY (DNI),
    CONSTRAINT CK_CLIENTES_ESTADOCIVIL CHECK (ESTADOCIVIL IN ('S', 'C', 'D', 'V'))
);

--Tabla que vamos a usar de ejemplos por ahora:
CREATE TABLE ORDERS (
    ID INTEGER,
    NOMBRE VARCHAR2(20),
    PRECIO INTEGER,
    UNIDAD INTEGER,
    SUBTOTAL NUMBER
);

ALTER TABLE
    ORDERS
ADD
    PRIMARY KEY (ID);

--Aquí cremos o modificamos el uso de un trigger
CREATE
OR REPLACE TRIGGER ActualizaSubtotal --NOMBRE
BEFORE --CUANDO
INSERT
    OR
UPDATE
    --ACCIONES QUE DISPARAN EL CODIGO PLSQL
    ON ORDERS --EN QUE TABLA SE REALIZA LA ACCION 
    FOR EACH ROW --POR CADA FILA
    DECLARE V_TOTAL NUMBER;

BEGIN V_TOTAL := :NEW.PRECIO * :NEW.UNIDAD;

:NEW.SUBTOTAL := V_TOTAL;

END;

/ SHOW ERRORS;

--CON ERROR CONTROLADO:
CREATE
OR REPLACE TRIGGER NoCambiarDeptno --NOMBRE
BEFORE --CUANDO
UPDATE
    OF DEPTNO --ACCCIONES QUE DISPARAN EL CODIGO PLSQL
    ON ORDERS -- EN QUE TABLA SE REALIZA LA ACCION 
    FOR EACH ROW -- POR CADA FILA
    BEGIN if :NEW.DEPTNO <> :OLD.DEPTNO THEN raise_application_error (-20600, 'NO PUEDES CAMBIAR EL DEPARTAMENTO');

END IF;

END;

/ SHOW ERRORS;

--Aquí actualizamos la tabla creada para los triggers:
/* INSERT INTO ORDERS (ID,NOMBRE, PRECIO,UNIDAD) VALUES (3,'HOLA2', 33,3); */
UPDATE
    ORDERS
SET
    SUBTOTAL = 33
WHERE
    ID = 1;

SELECT
    *
FROM
    ORDERS;

--Alteramos en la tabla de BK haciendo un insert con valores
CREATE
OR REPLACE TRIGGER ORDERS_BK
AFTER
UPDATE
    OR DELETE ON ORDERS FOR EACH ROW BEGIN
insert into
    orders_copia(
        id,
        nombre,
        precio,
        unidad,
        subtotal,
        deptno,
        fecha
    )
values
    (
        :OLD.id,
        :OLD.nombre,
        :OLD.precio,
        :OLD.unidad,
        :OLD.subtotal,
        :OLD.deptno,
        sysdate
    );

END;

/ SHOW ERRORS;

--Aquí abajo un ejercicio de clase:
/* En la tabla orders, modificar el trigger ActualizaSubtotal de tal forma que si el id a 
 insertar sea par multiplicar por 2 el subototal y si es impar dividir por 2, de la misma 
 forma en las actualizaciones si el id es par multiplicar por 3 y si no lo es dividir por 3 */
CREATE
OR REPLACE TRIGGER ActualizaSubtotal --NOMBRE
BEFORE --CUANDO
INSERT
    OR
UPDATE
    --ACCCIONES QUE DISPARAN EL CODIGO PLSQL
    ON ORDERS -- EN QUE TABLA SE REALIZA LA ACCION 
    FOR EACH ROW DECLARE V_AUX INTEGER := 2;

BEGIN IF MOD(:NEW.ID, 2) = 0 THEN IF UPDATING THEN V_AUX := 3;

END IF;

ELSE V_AUX := 1 / 2;

IF UPDATING THEN V_AUX := 1 / 3;

END IF;

END IF;

:NEW.SUBTOTAL := :NEW.PRECIO * :NEW.UNIDAD * V_AUX;

END;

/ SHOW ERRORS;

--Crear y rellenar un paquete
CREATE
OR REPLACE PACKAGE pckDEPT is PROCEDURE spInsertaDEPT(
    pdeptno dept.deptno % type,
    pdname dept.dname % type,
    ploc dept.loc % type
);

PROCEDURE spBorraDEPT(pdeptno dept.deptno % type);

PROCEDURE spActualizaDEPT(
    pdeptno dept.deptno % type,
    pdname dept.dname % type,
    ploc dept.loc % type
);

end;

/ CREATE
OR REPLACE PACKAGE body pckDEPT is PROCEDURE spInsertaDEPT(
    pdeptno dept.deptno % type,
    pdname dept.dname % type,
    ploc dept.loc % type
) is begin
insert into
    dept(deptno, dname, loc)
values
    (pdeptno, pdname, ploc);

end;

PROCEDURE spBorraDEPT(pdeptno dept.deptno % type) is begin
delete from
    dept
where
    deptno = pdeptno;

end;

PROCEDURE spActualizaDEPT(
    pdeptno dept.deptno % type,
    pdname dept.dname % type,
    ploc dept.loc % type
) is begin
update
    DEPT
set
    dname = pdname,
    loc = ploc
where
    deptno = pdeptno;

end;

end;

/ SHOW ERRORS;

/ execute pckDEPT.spInsertaDEPT(33, 'NACHO', 'PERDON');

/
SELECT
    *
FROM
    DEPT;

/ execute pckDEPT.spBorraDEPT(33);

/
SELECT
    *
FROM
    DEPT;

--TAREA MÁS LO QUE QUIERE PARA EL PRÓXIMO DÍA:
CREATE TABLE CALENDARIO (
    FECHA DATE,
    DIASEM INTEGER,
    SEMANYO INT,
    DIA INT,
    MES INT,
    ANYO INT
);

ALTER TABLE
    CALENDARIO
ADD
    PRIMARY KEY (FECHA);

/* AÑADIR 1000 DIAS A CALENDARIO A PARTIR DE 01/01/2020
 PARA LA INSERCCION EN CALENDARIO, CREAR UN PROCEDIMIENTO. spInsertaCalendario */
