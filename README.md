# Intelisoft

## Descarga programatica de transacciones bancarias

### Contexto
La banca chilena no tiene APIs de talforma de poder acceder a informacion de
transacciones programaticamente. Al parecer, existen un par de bancos trabjando
en ello pero nada oficial.

Por lo tanto necesitamos crear rutinas de Web Scraping para distintos bancos
asi automatizar el proceso de descarga de informacion bancaria a formato csv.

### Requerimientos
Usar alguna tecnologia de Web Scraping como Pupeteer o Selenium para poder
imitar usiarios y poder extraer la info solicitada.

### Mapa conceptual
1. Acceder a paginas de bancos programaticamente
2. Poder hacer travesia dentro de las paginas con el fin de exponer transacciones
3. Leer HTML y descargar informacion a CSV para alimetar otro sistema

Nota:
El punto 3 prodria ser reempazado con la descarga de cartolas en archivos excel

### Conocimientos requeridos
* HTML
* CSS para entender como seleccionar nodos del DOM
* Javascript o algun otro leguaje con el cual se puedan programar las rutinas
* GIT para control de version
* GitHub para colaboracion y control

### Ejemplo usando Pupeteer.js
[Banco BCI](bci.js)