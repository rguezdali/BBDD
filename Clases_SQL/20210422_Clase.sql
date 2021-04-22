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
                                              
--Versión óptima de lo anterior:
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

BEGIN :NEW.SUBTOTAL := :NEW.PRECIO * :NEW.UNIDAD;

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
