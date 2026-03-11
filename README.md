Sistema de Gestión de Turnos y Estudios Médicos
Descripción

Este proyecto implementa una base de datos para la gestión de pacientes, médicos, turnos y estudios clínicos utilizando SQL Server.

El sistema permite:

Registrar pacientes y médicos

Gestionar turnos médicos

Registrar estudios clínicos

Importar datos desde archivos externos

Generar informes para obras sociales

El proyecto está implementado mediante scripts SQL organizados por etapas, desde la creación de tablas hasta la generación de reportes.

Estructura del Proyecto

El repositorio contiene los siguientes archivos principales:

Dataset

Carpeta que contiene los archivos de datos utilizados para las importaciones, como:

Pacientes

Médicos

Sedes

Prestadores

Parámetros de autorización de estudios

Estos archivos son utilizados por los Stored Procedures de importación.

Scripts SQL

Los scripts están organizados en orden de ejecución.

00_DeCreaciondeTablas.sql

Este script se encarga de crear toda la estructura de la base de datos, incluyendo:

Schemas

Tablas

Relaciones entre tablas

Claves primarias y foráneas

Las tablas principales pertenecen a los siguientes schemas:

datos_paciente

servicio

comercial

personal

01_CreaciondeStoreProceduresyFunciones.sql

Este archivo contiene la creación de:

Stored Procedures

Funciones

Permiten realizar operaciones sobre el sistema como:

Inserción de registros

Actualización de datos

Eliminación lógica

Consultas específicas

02_CreacionDeSPImportaciondeArchivos.sql

Define los Stored Procedures encargados de importar datos desde archivos externos.

Se utilizan archivos:

CSV

JSON

Ejemplos de procedimientos:

Importación de pacientes

Importación de médicos

Importación de sedes

Importación de prestadores

Importación de parámetros de autorización de estudios

Esto permite realizar cargas masivas de información en la base de datos.

03_Ejecucion de SP de ImportacionTesting1.sql

Script utilizado para probar la ejecución de los Stored Procedures de importación.

Permite verificar que los datos de los archivos:

CSV

JSON

se carguen correctamente en las tablas correspondientes.

04_EjecuciondeStoreProcTesting2.sql

Script de pruebas adicionales para validar el funcionamiento de los stored procedures del sistema.

Incluye pruebas de:

inserciones

modificaciones

consultas

05_ExportarXMLInformeObraSocial.sql

Este script genera un informe en formato XML con información relevante para una obra social.

El XML puede incluir datos como:

estudios realizados

pacientes

cobertura médica

costos

Esto permite intercambiar información con sistemas externos.

06_EjecuciondeStoreProcInformeObraSocial.sql

Script que ejecuta el Stored Procedure encargado de generar el informe para la obra social.

Permite validar la generación del XML final.

Tecnologías Utilizadas

SQL Server

T-SQL

Stored Procedures

Importación de archivos CSV

Procesamiento de archivos JSON

Exportación de datos en XML

Orden de Ejecución

Para levantar el proyecto correctamente se recomienda ejecutar los scripts en el siguiente orden:

1. 00_DeCreaciondeTablas.sql
2. 01_CreaciondeStoreProceduresyFunciones.sql
3. 02_CreacionDeSPImportaciondeArchivos.sql
4. 03_Ejecucion de SP de ImportacionTesting1.sql
5. 04_EjecuciondeStoreProcTesting2.sql
6. 05_ExportarXMLInformeObraSocial.sql
7. 06_EjecuciondeStoreProcInformeObraSocial.sql
Objetivo del Proyecto

El objetivo de este sistema es centralizar la gestión de información médica, permitiendo:

organizar pacientes y médicos

administrar turnos

registrar estudios clínicos

importar grandes volúmenes de datos

generar reportes para obras sociales
