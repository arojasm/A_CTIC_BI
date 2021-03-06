
-------------------------------------------
-- FORMATEAMOS LOS VALORES DE LOS SALDOS
SELECT 
SALDO,
REPLACE (SALDO, '.', ','),
TO_NUMBER(REPLACE (SALDO, '.', ','))
FROM TMP_DEUDACLIENTE D

--------------------------------------------
-- SUMATORIA DE LOS SALDOS DE LAS DEUDAS PARA UN MES
SELECT 
SUM(TO_NUMBER (REPLACE (SALDO, '.', ',')))
FROM TMP_DEUDACLIENTE
WHERE PERIODO = 201601



---------------------------------


SELECT * FROM TMP_PERSONA

--- creamos la tabla en el esquema operacional 
CREATE TABLE MAE_PERSONA 
(
NumDoc VARCHAR2(50),
DigVer VARCHAR2(50),
GrpVot VARCHAR2(50),
Ubigeo VARCHAR2(50),
ApPaterno VARCHAR2(50),
ApMaterno VARCHAR2(50),
Nombres VARCHAR2(50),
FecNacimiento DATE,
Sexo VARCHAR2(50)
)



insert into MAE_PERSONA(
NUMDOC,
DIGVER,
GRPVOT,
UBIGEO,
APPATERNO,
APMATERNO,
NOMBRES,
FECNACIMIENTO,
SEXO
)
select
NUMDOC,
DIGVER,
GRPVOT,
UBIGEO,
APPATERNO,
APMATERNO,
NOMBRES,
TO_DATE (FECNAC,'YYYYMMDD'),
SEXO
from tmp_persona;

COMMIT;

SELECT DISTINCT SEXO from tmp_persona;

SELECT SEXO, COUNT(*) from tmp_persona
GROUP BY SEXO

SELECT * from tmp_persona
WHERE TRIM(SEXO) IS NULL


SELECT * from tmp_persona
WHERE TRIM(SEXO) IS NULL


SELECT GRPVOT, COUNT(*) from tmp_persona
GROUP BY GRPVOT 

SELECT LENGTH(GRPVOT) , COUNT(*) from tmp_persona
GROUP BY LENGTH(GRPVOT)

SELECT * from tmp_persona
WHERE LENGTH(GRPVOT) = 10

-------------------------
--ALT 1 -> IMPUTAR VALOR CON NULO
SELECT 
CASE WHEN GRPVOT ='PARCHE EQX' THEN NULL
ELSE GRPVOT
END,
GRPVOT
from tmp_persona
WHERE
LENGTH(GRPVOT) = 10

---
-- ALT 2: VALIDAR OWNER




19641021
YYYYMMDD
------------------------------------

SELECT DISTINCT TIPO FROM TMP_ENTIDADES

SELECT MIN(TIPO), MAX(TIPO) FROM TMP_ENTIDADES

----------------------------------
SELECT MIN(COD_SBS_CLI), MAX(COD_SBS_CLI) FROM TMP_DEUDACLIENTE


SELECT 
MIN(LENGTH(TO_NUMBER(COD_SBS_CLI))), 
MAX(LENGTH(TO_NUMBER(COD_SBS_CLI)))
FROM TMP_DEUDACLIENTE


SELECT *
FROM TMP_DEUDACLIENTE
WHERE 
LENGTH(COD_SBS_CLI) = 4

----------------------------------------------------------

SELECT 
SALDO,
REPLACE(SALDO, '.', ',' )AS SALDO_FORMATO_REPLACE,
TO_NUMBER(REPLACE(SALDO, '.', ',' )) AS SALDO_FORMATO_REPLACE_TONUMBER,
A.*
FROM 
TMP_DEUDACLIENTE A
WHERE 
COD_SBS_CLI = '4448'


---

SELECT 
'12,324.00' ,
(REPLACE ('12,324.00', ',', NULL)),
REPLACE (REPLACE ('12,324.00', ',', NULL), '.', ',')
FROM DUAL
 

-- SUMAREMOS EL SALDO

SELECT 
COD_SBS_CLI ,
--SUM(TO_NUMBER(SALDO))
SUM(REPLACE(SALDO, '.', ',' )),
SUM(TO_NUMBER(REPLACE(SALDO, '.', ',' )))
FROM 
TMP_DEUDACLIENTE A
WHERE 
COD_SBS_CLI = '4448'
GROUP BY 
COD_SBS_CLI


--------------

SELECT 
COD_SBS_CLI ,
COD_CUENTA,
TIP_CREDITO,
SITCRE,
CASE WHEN SUBSTR(SITCRE, 4,1) IN ('1','3','4','5','6') AND 
          SUBSTR(COD_CUENTA, 1, 2) = '14' AND
          TIP_CREDITO = '10' THEN 'Prestamo Peque�a Empresa'
  ELSE 'OTROS'
  END CAMPO,
--SUM(TO_NUMBER(REPLACE(SALDO, '.', ',' )))
TO_NUMBER(REPLACE(SALDO, '.', ',' ))
FROM 
TMP_DEUDACLIENTE A
WHERE 
SUBSTR(COD_CUENTA, 1, 2) = '14'
AND TIP_CREDITO = '10'
SUBSTR(SITCRE, 4,1) IN ('1','3','4','5','6')


ORDER BY CAMPO DESC

COD_SBS_CLI = '4448'


---------------------------------------------------------------
-- CALIDA DE DATOS
---------------------------------------------------------------




SELECT * FROM
TMP_DEUDACLIENTE;

--- CREACION DE LA TABLA PERFILAMIENTO 
DROP TABLE PERFILAMIENTO_DATOS

CREATE TABLE PERFILAMIENTO_DATOS(
PERIODO CHAR(6),
ENTIDAD VARCHAR2(50),
ATRIBUTO VARCHAR2(50),
LONGITUD_MAXIMA INT,
LONGITUD_MINIMA INT,
VALOR_MAXIMO INT,
VALOR_MINIMO INT,
SUMATORIA NUMBER,
PROMEDIO DECIMAL (14,2),
CTD_REGISTROS_ENTIDAD INT,
CTD_REGISTROS_CAMPO INT,
PORCENTAJE_NULOS DECIMAL (6,2),
FECHA_ACTUALIZACION DATE
)

SELECT 
PERIODO, COUNT(*)
FROM
TMP_DEUDACLIENTE
GROUP BY PERIODO;


INSERT INTO PERFILAMIENTO_DATOS
SELECT 
PERIODO,
'TMP_DEUDACLIENTE' AS ENTIDAD,
'SALDO' AS ATRIBUTO,
MAX(LENGTH(SALDO)),
MIN(LENGTH(SALDO)),
MAX(TO_NUMBER(REPLACE(SALDO, '.', ',' ))) MAXIMO,
MIN(TO_NUMBER(REPLACE(SALDO, '.', ',' ))) MINIMO,
SUM(TO_NUMBER(REPLACE(SALDO, '.', ',' ))) SUMATORIA,
ROUND(AVG(TO_NUMBER(REPLACE(SALDO, '.', ',' ))), 2) AS "PROMEDIO",
COUNT(*),
COUNT(SALDO),
(1 - (COUNT(SALDO) / COUNT(*))) * 100 AS "PORCENTAJE NULOS",
SYSDATE
FROM
TMP_DEUDACLIENTE
GROUP BY PERIODO 
UNION
SELECT 
PERIODO,
'TMP_DEUDACLIENTE' AS ENTIDAD,
'TIP_REG' AS ATRIBUTO,
MAX(LENGTH(TIP_REG)),
MIN(LENGTH(TIP_REG)),
MAX(TO_NUMBER(REPLACE(TIP_REG, '.', ',' ))) MAXIMO,
MIN(TO_NUMBER(REPLACE(TIP_REG, '.', ',' ))) MINIMO,
SUM(TO_NUMBER(REPLACE(TIP_REG, '.', ',' ))) SUMATORIA,
ROUND(AVG(TO_NUMBER(REPLACE(TIP_REG, '.', ',' ))), 2) AS "PROMEDIO",
COUNT(*),
COUNT(TIP_REG),
(1 - (COUNT(TIP_REG) / COUNT(*))) * 100 AS "PORCENTAJE NULOS",
SYSDATE
FROM
TMP_DEUDACLIENTE
GROUP BY PERIODO 
UNION
SELECT 
PERIODO,
'TMP_DEUDACLIENTE' AS ENTIDAD,
'TIP_CREDITO' AS ATRIBUTO,
MAX(LENGTH(TIP_CREDITO)),
MIN(LENGTH(TIP_CREDITO)),
MAX(TO_NUMBER(REPLACE(TIP_CREDITO, '.', ',' ))) MAXIMO,
MIN(TO_NUMBER(REPLACE(TIP_CREDITO, '.', ',' ))) MINIMO,
SUM(TO_NUMBER(REPLACE(TIP_CREDITO, '.', ',' ))) SUMATORIA,
ROUND(AVG(TO_NUMBER(REPLACE(TIP_CREDITO, '.', ',' ))), 2) AS "PROMEDIO",
COUNT(*),
COUNT(TIP_CREDITO),
(1 - (COUNT(TIP_CREDITO) / COUNT(*))) * 100 AS "PORCENTAJE NULOS",
SYSDATE
FROM
TMP_DEUDACLIENTE
GROUP BY PERIODO ;

COMMIT;

SELECT * FROM PERFILAMIENTO_DATOS;


------------------------------------------------
------------------------------------------------
-- PERSONAS
-- CALCULO DE LA EDAD

SELECT
NUMDOC,
SYSDATE,
FECNAC,
TO_DATE(FECNAC,'YYYYMMDD'),
MONTHS_BETWEEN( TRUNC(SYSDATE), TO_DATE(FECNAC,'YYYYMMDD')) MESES,
MONTHS_BETWEEN( TRUNC(SYSDATE), TO_DATE(FECNAC,'YYYYMMDD')) / 12 A�OS,
FLOOR(MONTHS_BETWEEN( TRUNC(SYSDATE), TO_DATE(FECNAC,'YYYYMMDD')) / 12) EDAD
FROM 
TMP_PERSONA


SELECT a.*,( TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) -  TO_NUMBER(TO_CHAR(FECNAC,'YYYYMMDD') ) ) / 10000 AS Edad_decimal,
 TRUNC( ( TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) -  TO_NUMBER(TO_CHAR(FECNAC,'YYYYMMDD') ) ) / 10000) AS Edad
FROM TMP_PERSONA a
WHERE NUMDOC = '15336570'


select 
TRUNC(months_between(TRUNC(sysdate),MPE_FECNAC)/12)
as EDAD 
from TMP_PERSONA;


------

SELECT 
A.*, ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE(FECNAC,'YYYYMMDD'))/12,0) EDAD 
FROM TMP_PERSONA  A;  

19601208



------------------------------------------------
------------------------------------------------
-- ANALISIS CLIENTES Y PERSONAS
--- 
SELECt 
NUMDOC
FROM 
TMP_PERSONA
GROUP BY NUMDOC
HAVING COUNT(*) >1;

SELECt 
COD_SBS_CLI, PERIODO, COUNT(*)
FROM 
TMP_CLIENTE
GROUP BY COD_SBS_CLI, PERIODO
HAVING COUNT(*) >1;

SELECt 
DOC_IDENTIDAD, PERIODO, COUNT(*)
FROM 
TMP_CLIENTE
GROUP BY DOC_IDENTIDAD, PERIODO
HAVING COUNT(*) >1;

SELECT  
*
FROM 
TMP_CLIENTE

SELECT  PERIODO, COUNT(*)
FROM 
TMP_CLIENTE C
GROUP BY PERIODO

--- LEFT JOIN
SELECT  
PERIODO,
COUNT(*),
CASE WHEN TRIM(P.NUMDOC) IS NULL THEN 'VACIOS' ELSE 'VALOR' END  VALOR_CLIENTE
FROM 
TMP_CLIENTE C,
TMP_PERSONA P
WHERE 
C.DOC_IDENTIDAD = P.NUMDOC (+) 
GROUP BY PERIODO,
CASE WHEN TRIM(P.NUMDOC) IS NULL THEN 'VACIOS' ELSE 'VALOR' END
ORDER BY 1 DESC
-- 320217 -- 334777 LEFT JOIN

SELECT 320217 - 334777 FROM DUAL
-- 14560

SELECT COUNT(*) 
FROM 
TMP_PERSONA P,
( SELECT DISTINCT DOC_IDENTIDAD FROM TMP_CLIENTE -- 28524
) C
WHERE 
P.NUMDOC = C.DOC_IDENTIDAD(+)
AND C.DOC_IDENTIDAD IS NULL

SELECT COUNT(*) FROM TMP_PERSONA -- 28524

SELECT  
COUNT(*),
FROM 
TMP_CLIENTE C,
TMP_PERSONA P
WHERE 
P.NUMDOC = C.DOC_IDENTIDAD(+) 
GROUP BY PERIODO,


SELECT  
PERIODO,
COUNT(*),
CASE WHEN TRIM(P.NUMDOC) IS NULL THEN 'VACIOS' ELSE 'VALOR' END  VALOR_CLIENTE
FROM 
TMP_CLIENTE C,
TMP_PERSONA P
WHERE 
P.NUMDOC = C.DOC_IDENTIDAD(+) 
GROUP BY PERIODO,
CASE WHEN TRIM(P.NUMDOC) IS NULL THEN 'VACIOS' ELSE 'VALOR' END
ORDER BY 1 DESC


----
--- ATRIBUTO EDAD - DIMENSION CLENTE

SELECT  
PERIODO,
COUNT(*),
FLOOR(MONTHS_BETWEEN( TRUNC(SYSDATE), TO_DATE(P.FECNAC,'YYYYMMDD')) / 12) EDAD
FROM 
TMP_CLIENTE C,
TMP_PERSONA P
WHERE 
C.DOC_IDENTIDAD = P.NUMDOC(+) 
AND PERIODO = '201511'
GROUP BY PERIODO,
FLOOR(MONTHS_BETWEEN( TRUNC(SYSDATE), TO_DATE(P.FECNAC,'YYYYMMDD')) / 12)
ORDER BY 3 DESC


CASE WHEN TRIM(P.NUMDOC) IS NULL THEN 'VACIOS' ELSE 'VALOR' END
ORDER BY 1 DESC



------------------------------------------------
------------------------------------------------
-- ANALISIS PARA CREAR LA FACT DE SALDOS
14190201000000

SELECT 
PERIODO,
COD_CUENTA,
TIP_CREDITO,
CASE 
    WHEN SUBSTR(TRIM(COD_CUENTA), 4, 1) IN ('1','3','4', '5', '6') AND
         SUBSTR(TRIM(COD_CUENTA), 1, 2) = '14' AND
         TIP_CREDITO = '09' THEN 'Prestamo Peque�a Empresa'
    WHEN SUBSTR(TRIM(COD_CUENTA), 4, 1) IN ('1','3','4', '5', '6') AND
         SUBSTR(TRIM(COD_CUENTA), 1, 2) = '14' AND
         TIP_CREDITO = '10' THEN 'Prestamo MicroEmpresa'
ELSE 'OTROS'
END AS SUBPRODUCTO,
SALDO
FROM 
TMP_DEUDACLIENTE S
WHERE 
SUBSTR(TRIM(COD_CUENTA), 4, 1) IN ('1','3','4', '5', '6');


------------------------------------------------
-- CREANDO LA FACT DEL AMBIENTE OPERACIONAL
------------------------------------------------

CREATE TABLE H_SALDOCLIENTE
(
PERIODO CHAR(6),
CODCLIENTESBS NUMBER,
CODENTIDADFINANCIERA CHAR(5),
TIPCREDITO CHAR(2),
CODCUENTA CHAR(14),
DIAATRASO INT,
MTODEUDA NUMBER(16,2),
CLASIFICACION INT,
FECACTUALIZACION DATE
)

INSERT INTO H_SALDOCLIENTE(
PERIODO,
CODCLIENTESBS,
CODENTIDADFINANCIERA,
TIPCREDITO,
CODCUENTA,
DIAATRASO,
MTODEUDA,
CLASIFICACION,
FECACTUALIZACION
)
SELECT
PERIODO,
COD_SBS_CLI,
COD_EMPRESA,
TIP_CREDITO,
COD_CUENTA,
CONDICION,
TO_NUMBER (REPLACE (SALDO, '.', ',')) SALDO,
CLASIFICACION,
TRUNC(SYSDATE)
FROM 
TMP_DEUDACLIENTE;

-- 2.099.544

COMMIT;

SELECT * FROM H_SALDOCLIENTE;

------------------------------------
-- CREACION DE TABLA DIMENSIONAL
------------------------------------
DROP TABLE FACT_SALDOCLIENTE;

CREATE TABLE FACT_SALDOCLIENTE
(
PERIODO CHAR(6),
CODCLIENTESBS NUMBER,
CODENTIDADFINANCIERA CHAR(5),
DIAATRASO INT,
MTODEUDA NUMBER(16,2),
SUBPRODUCTO CHAR(2),
FECACTUALIZACIONTABLA DATE
)


INSERT INTO FACT_SALDOCLIENTE (
PERIODO,
CODCLIENTESBS,
CODENTIDADFINANCIERA,
DIAATRASO,
MTODEUDA,
SUBPRODUCTO,
FECACTUALIZACIONTABLA
)
SELECT
PERIODO,
CODCLIENTESBS,
CODENTIDADFINANCIERA,
DIAATRASO,
MTODEUDA,
CASE WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO = '09' 
          THEN '1' --'PRESTAMO PEQUE�A EMPRESA' 
     WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO = '10' 
          THEN '2' --'PRESTAMO MICRO EMPRESA'  
    WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO = '13'
          AND SUBSTR(CODCUENTA, 7, 2) NOT IN ( '23', '24', '25') 
          THEN '3' --'HIPOTECARIO NORMAL'
    WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO = '13'
          AND SUBSTR(CODCUENTA, 7, 2) IN ( '23', '24', '25') 
          THEN '4' --'HIPOTECARIO MIVIVIENDA'      
    WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO IN ( '11', '12')
          AND SUBSTR(CODCUENTA, 7, 2) = '06' AND SUBSTR(CODCUENTA, 7, 4) NOT IN '0602' 
          THEN '5' --'PRESTAMO EFECTIVO'
WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO IN ( '11', '12')
          AND SUBSTR(CODCUENTA, 7, 2) = '06' AND SUBSTR(CODCUENTA, 7, 4)  IN '0602' 
          THEN '6' --'PRESTAMO VEHICULAR'      
WHEN SUBSTR(CODCUENTA, 4, 1) IN ('1','3', '4', '5', '6' ) AND 
          SUBSTR(CODCUENTA, 1, 2) = '14' AND TIPCREDITO IN ( '11', '12')
          AND SUBSTR(CODCUENTA, 7, 2) = '02' 
          THEN '7' --'SALDO TARJETA CREDITO'           
WHEN     SUBSTR(CODCUENTA, 1, 2) = '81' AND TIPCREDITO IN ( '11', '12')
          AND SUBSTR(CODCUENTA, 4, 3) = '923' 
          THEN '8' --'LINEA TARJETA CREDITO'
ELSE '9' --'OTRAS CUENTAS CONTABLES'
END SUBPRODUCTO,
TRUNC(SYSDATE)
FROM 
H_SALDOCLIENTE;
-- 2.099.544
--where periodo = 201601

COMMIT;

select * from FACT_SALDOCLIENTE

---------------------
CREATE TABLE DIM_TIEMPO
(

)

INSERT INTO DIM_TIEMPO
SELECT 
DISTINCT PERIODO FROM TMP_DEUDACLIENTE
UNION 
SELECT  DISTINCT PERIODO FROM TMP_CLIENTE
---------------------

SELECT 
TIP_PERSONA,
COUNT(*)
FROM TMP_CLIENTE
GROUP BY TIP_PERSONA




DROP TABLA DIM_SUBPRODUCTO;

CREATE TABLE DIM_SUBPRODUCTO (
CODSUBPRODUCTO NUMBER ,
CODPRODUCTO NUMBER ,
DESCODSUBPRODUCTO VARCHAR2(50)
)

INSERT INTO DIM_SUBPRODUCTO VALUES (	1	,	100	,	 '	Prestamo Peque�a Empresa	 ');
INSERT INTO DIM_SUBPRODUCTO VALUES (	2	,	200	,	 'Prestamo MicroEmpresa');
INSERT INTO DIM_SUBPRODUCTO VALUES (	3	,	300	,	 'HIPOTECARIO NORMAL ');
INSERT INTO DIM_SUBPRODUCTO VALUES (	4	,	300	,	 'HIPOTECARIO MIVIVIENDA ');
INSERT INTO DIM_SUBPRODUCTO VALUES (	5	,	400	,	 'PRESTAMO EFECTIVO');
INSERT INTO DIM_SUBPRODUCTO VALUES (	6	,	400	,	 'PRESTAMO VEHICULAR');
INSERT INTO DIM_SUBPRODUCTO VALUES (	7	,	500	,	 'SALDO DE TARJETA DE CREDITO');
INSERT INTO DIM_SUBPRODUCTO VALUES (	8	,	500	,	 'LINEA DE TARJETA DE CREDITO');
INSERT INTO DIM_SUBPRODUCTO VALUES (	9	,	600	,	 'OTRAS CUENTAS CONTABLES');

COMMIT;

SELECT * FROM DIM_SUBPRODUCTO;


--creando la Dimension producto

CREATE TABLE DIM_PRODUCTO
(
CODPRODUCTOSBS NUMBER,
DESPRODUCTOSBS VARCHAR2(50)
)


INSERT INTO DIM_PRODUCTO VALUES (	100	,	 'Prestamo Peque�a Empresa');
INSERT INTO DIM_PRODUCTO VALUES (	200	,	 'Prestamo MicroEmpresa');
INSERT INTO DIM_PRODUCTO VALUES (	300	,	 'Prestamo Hipotecario');
INSERT INTO DIM_PRODUCTO VALUES (	400	,	 'Prestamo de Consumo');
INSERT INTO DIM_PRODUCTO VALUES (	500	,	 'Tarjeta de Credito');
INSERT INTO DIM_PRODUCTO VALUES (	600	,	 'Otras cuentas contables');
COMMIT;


select
sum(mtodeuda),
DESCODSUBPRODUCTOSBS,
count(*)
from 
FACT_SALDOCLIENTE x,
DIM_SUBPRODUCTO s,
DIM_PRODUCTO y
where
x.subproducto = s.CODSUBPRODUCTOsbs and
s.codproductosbs = y.codproductosbs
group by DESCODSUBPRODUCTOSBS;
