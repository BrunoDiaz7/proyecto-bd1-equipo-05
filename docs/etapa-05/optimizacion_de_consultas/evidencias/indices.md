# **Documentación ETAPA 5: Optimización mediante índices** 

El propósito de esta etapa es evaluar y demostrar el impacto que tiene el diseño estratégico de índices no agrupados sobre el rendimiento de las consultas. Para simular un entorno real de alta demanda, se realizó una carga registros en la base de datos. A continuación, se registran y analizan las métricas de consumo de CPU, tiempos de ejecución y esfuerzo de memoria (lecturas lógicas) obtenidos bajo tres escenarios de optimización distintos. 

# **Tabla Persona** 

# <u>Métricas sobre la Consulta sin índices:</u> 

<img width="974" height="227" alt="image" src="https://github.com/user-attachments/assets/986918ac-7939-44fc-9818-46d08a4283af" />


|**Medicion**|**Valor**|
|---|---|
|**Tiempo CPU**|31 ms|
|**Tiempo Total**|40 ms|
|**Lecturas logicas**|4130|
|**Operación principal**|Clustered<br>Index Scan|



# <u>Metricas sobre la Consulta con índice NO agrupado:</u> 

<img width="1025" height="189" alt="image" src="https://github.com/user-attachments/assets/74e3da18-7db6-4900-8aad-7b9592ff8b04" />


|**Medicion**|**Valor**|
|---|---|
|**Tiempo CPU**|93 ms|
|**Tiempo Total**|527 ms|
|**Lecturas logicas**|4130 + 200|
|**Operación principal**|Clustered<br>Index Scan|

_Nota: En el escenario del índice sobre apellido se suman las 4130 lecturas de la tabla Persona y las 200 de la tabla Cliente debido al acoplamiento por el INNER JOIN.”_ 

# <u>Métricas sobre la Consulta con ííndice que cubre la consulta (INCLUDE)</u> 

<img width="1019" height="194" alt="image" src="https://github.com/user-attachments/assets/38f22b7e-aeb8-4a65-9535-3ad032dab3e5" />


|**Medicion**|**Valor**|
|---|---|
|**Tiempo CPU**|0 ms|
|**Tiempo Total**|0 ms|
|**Lecturas logicas**|3|
|**Operación principal**|Index Seek|



# <u>Comparacion Final</u> 

|**Escenario**|**Tiempo (ms)**|**<br>Lecturas Logicas**|**Operación Principal**|
|---|---|---|---|
|Sin Índice|40|4130|Clustered Index Scan|
|Índice sobre apellido|527|4330|Clustered Index Scan|
|Índice sobre cobertura|0|3|Index Seek|



# **Tabla Factura** 

# <u>Métricas sobre la Consulta sin índices:</u> 

<img width="2158" height="511" alt="image" src="https://github.com/user-attachments/assets/e9294a9d-e4f4-48cf-b5f5-8dad30004dea" />


|**Medicion**|**Valor**|
|---|---|
|**Tiempo CPU**|109 ms|
|**Tiempo Total**|376 ms|
|**Lecturas logicas**|14983|
|**Operación principal**|Clustered<br>IndexScan|



# <u>Metricas sobre la Consulta con índice NO agrupado:</u> 

<img width="1801" height="590" alt="image" src="https://github.com/user-attachments/assets/08b6d718-f8ae-418c-b9b5-373a6d3dfdde" />


|**Medicion**|**Valor**|
|---|---|
|**Tiempo CPU**|1921 ms|
|**Tiempo Total**|2158 ms|
|**Lecturas logicas**|14983|
|**Operación principal**|Clustered<br>IndexScan|



# <u>Métricas sobre la Consulta con ííndice que cubre la consulta</u> 

<img width="2022" height="809" alt="image" src="https://github.com/user-attachments/assets/f3502ae9-e682-492e-844d-bb17ef27287f" />



|**Medicion**|**Valor**|
|---|---|
|**Tiempo CPU**|31 ms|
|**Tiempo Total**|163 ms|
|**Lecturas logicas**|130|
|**Operación principal**|Index Seek|



# <u>Comparacion Final</u> 

|**Escenario**|**Tiempo (ms)**|**<br>**Lecturas Logicas****|**Operación Principal**|
|---|---|---|---|
|Sin Índice|109|14983|Clustered Index Scan|
|Índice sobre apellido|1921|2158|Clustered Index Scan|
|Índice sobre cobertura|31|130|Index Seek|
