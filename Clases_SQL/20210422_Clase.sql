CREATE TABLE CLIENTES(
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