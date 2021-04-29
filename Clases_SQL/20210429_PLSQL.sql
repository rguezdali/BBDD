--Primer código de la mañana, donde declaramos una excepción:
DECLARE DIVIDE_ZERO EXCEPTION;

V_A INTEGER := 12;

V_B INTEGER := 10;

V_C NUMBER(5, 2) := 0;

BEGIN IF V_B = 0 THEN RAISE DIVIDE_ZERO;

END IF;

V_C := V_A / V_B;

dbms_output.put_line(V_C);

dbms_output.put_line('TERMINO BIEN');

EXCEPTION
WHEN DIVIDE_ZERO THEN dbms_output.put_line('CUIDADO QUE VAS A DIVIDIR POR CERO');

END;