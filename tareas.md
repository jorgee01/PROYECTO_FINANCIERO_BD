# Proyecto Sicveca XML LR
## Sprint 2 FECHA DE ENTREGA domingo 3 junio 11:59pm.
## Entregable: base de datos y el código (TODO) de los escenarios completos con los
# CRUD.
Requerimiento
Utilizando la base de datos creada en la entrega anterior (con los cambios de la
revisión, y cambios que vean pertinentes).
Y tomando en cuenta todos los productos MINIMOS que deben viajar en el xml:
1. Cuentas a la vista
2. Depósitos a plazo
3. Cuentas de expediente simplificado
4. Cuentas para pago de planillas o servicios
5. Depósitos judiciales
6. Créditos directos
7. Créditos hipotecarios
8. Tarjetas de Crédito
9. Líneas de crédito
10. Descuento de facturas
11. Arrendamientos financieros
12. AVALES Y GARANTÍAS EMITIDAS.
13. Transferencias de fondos
14. Remesas de dinero
15. Compra y venta de divisas
16. Fideicomisos
17. Cajeros automáticos
18. Banca en línea y aplicaciones móviles
19. Cajas de seguridad.


Llenar/insertar los datos en las tablas catálogos, insertarse como clientes todos los del
grupo, y que cada uno del grupo tenga todos los productos, es decir que la tabla de
clientes tiene que tener 5 datos, y si tienen una tabla de productos vs clientes tienen
que haber 95 productos, completos y bien llenos. 5 pts
Requerimientos DEV


1-Realizar CRUD en el lenguaje de programación que prefieran (java, node.js, C,
emsamblador, C++….. ), esto quiere decir que deben crear las diferentes capas de
manejo de datos que tiene un proyecto (por ejemplo lógica/data/presentación(front
end)), a las tablas que se les debe realizar CRUD son a las
transaccionales(productos, transaciones) de todos los productos que requiere el
XML, es decir todas aquellas que no sean catálogos, esto se debe conectar a SQL
server(a la base de datos del proyecto), para la lectura datos usar funciones y para los
otros usar Store procedure. (y si se tiene que hacer esto por cada tabla) (utilizar
transacciones). 20pts


2-El sistema deberá implementar una calificadora de riesgo de clientes, utilizando
SQL, basada en la información contenida en los diferentes catálogos del archivo
“Catálogo CICAC - Estándar Electrónico”.
El objetivo es calcular un puntaje total de riesgo por cliente, mediante la evaluación
de múltiples variables (campos) asociadas al cliente, considerando que la ponderación
de dichas variables varía según el tipo de cliente, ya sea:
● Cliente físico
● Cliente jurídico
Cada variable del cliente tendrá asignado un peso (puntaje) previamente definido.
Estos pesos representan el nivel de riesgo asociado a cada característica del cliente.
El proceso de cálculo será el siguiente:
1. Para cada cliente, se evaluarán todos los campos relevantes definidos en los
catálogos.
2. A cada campo se le asignará un puntaje según:
o El valor del campo
o El tipo de cliente (físico o jurídico)
3. Cada puntaje individual se acumula (SUM) para obtener un puntaje total de
riesgo.
Es decir:
● Cada variable aporta una cantidad de puntos
● La suma de todos los puntos determina el riesgo final.
Puntaje Total =
(Peso Variable 1+(% de aporte el riesgo)) + (Peso Variable 2+(% de aporte el riesgo)) +
... + (Peso Variable N+(% de aporte el riesgo))
Ejemplo conceptual:
● Edad del cliente (18 a 33=0.33, 34 a 50 =0.66, de 50 a 85=0.99)→ 18 puntos
● Actividad económica → 25 puntos
● Ubicación geográfica → 15 puntos
Total = 58 puntos
El sistema deberá generar un resultado (se guardan en tablas en la base de datos) que
incluya como mínimo:
● Identificación del cliente
● Tipo de cliente (físico o jurídico)
● Puntaje total calculado
● Nivel de riesgo asignado (Bajo, Medio, Alto)
20pts


3- Realizar una búsqueda inteligente en el CRUD de cliente/ciudadanos registrados en
el padrón electoral de Costa Rica, con el objetivo de facilitar la localización de
información aun cuando los datos ingresados por el usuario sean incompletos o
contengan errores.

La búsqueda deberá admitir múltiples criterios de entrada, tales como número de
cédula (de forma exacta o parcial), nombre completo, apellidos, así como datos
geográficos como provincia, cantón, distrito, El sistema deberá permitir combinar estos
criterios para refinar los resultados.

Se deberá implementar una búsqueda flexible que ignore diferencias entre mayúsculas
y minúsculas, así como tildes, y que además soporte coincidencias parciales.

Asimismo, el sistema deberá ofrecer funcionalidades de autocompletado que sugieran
posibles coincidencias en tiempo real conforme el usuario escribe.

Los resultados deberán presentarse ordenados por nivel de relevancia (es decir los
clientes frecuentes), priorizando coincidencias exactas sobre coincidencias parciales, y
mostrando información clave como nombre completo, número de cédula.

Como requisitos no funcionales, el sistema deberá garantizar tiempos de respuesta
menores a 3 segundos en consultas estándar, ser capaz de manejar grandes
volúmenes de datos, mantener una alta disponibilidad.15pts

4.1-Realizar 3 escenario de prueba en un solo proyecto (todos los escenario se
deben ejecutar n veces sin eliminar los anteriores):


Escenario 1: crear un programa( puede ser en bd un sp o puede ser desde el código
JAVA) que inserte 5 clientes nuevos de la lista de personas del padrón, por los
meses que van de este año (es decir si estamos en mayo deberá insertar 25 en total) a
cada uno de estos clientes se le tiene que agregar un tipo de producto diferente en
cada mes de manera aleatoria.
Además, para cada mes tiene que registrar 5 transacciones para cada producto y que
este se vea reflejado en cada tabla correspondiente al producto, es decir si tienen una
tabla de transacciones tienen que registrar esa transacción de ingresos, egresos, y el
tipo de transacción, es decir los datos tienen que fluir con respecto a todo el flujo de
datos de la base de datos.15pts


Escenario 2: Crear un programa que inserte 27 transacciones aleatoriamente del mes
de abril para 5 clientes random, distribuidos en los diferentes tipos de productos
de los clientes seleccionados, para este escenario, deben ingresar los datos tipo:
transporte(gasolina, uber, bus, taxi, mototaxi), comida afuera, el diario(comida de la
casa), gym, entrenador personal, nutricionista, psicólogo, agua, luz, internet, celular,
Netflix(apps de streaming), ropa, zapatos, hobbie, juego en línea, sinpe móvil,
depósitos, deposito del plazo, pago de planilla, depósito de pensiones, comida del gato,
pago con tarjetas crédito, débito, ahorro, pago leasing, por ejemplo.
De igual manera al punto 4.1, la de las transacciones se tiene que ver reflejado en las
cuentas correspondientes, y si tiene un balance del estado actual también se tiene que
actualizar. 15 pts

Escenario 3: Crear un programa que genere el XML completo con todas sus partes y a
estos datos se les debe aplicar todas las validaciones del documento (07. Legitimación
con base a riesgo de la entrega 1) que se encuentran en el requerimiento, el objetivo
es validar la data(se pueden poner datos mal para validar que funcione). 10pts

Escenario 4(opcional): Crear transacciones de remesas, compra y venta de divisas,
comisiones por sacar dinero de cajeros, comisiones de sinpe, Swift, todas estas
ganancias son de la entidad financiera y se deben registrar en sus tablas
correspondientes. +10tps.
Todos los escenarios anteriores usan los CRUD del punto 1.