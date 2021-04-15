/*
 * En la base de datos de jardinería
 */
 
--DECIR EL PAIS DONDE SE HA GASTADO MAS  
/* Con esto de aquí abajo lo que hacemos es el unir las tablas */
SELECT *
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
;
