# 🐧 Mi Manual de Supervivencia Linux y Git

## 📁 1. Navegación y Archivos
* `pwd`: Print Working Directory. Me dice en qué ruta exacta estoy (Mi GPS).
* `ls -la`: Lista los archivos de un directorio, incluyendo ocultos (`-a`) y con detalles (`-l`).
* `cd [ruta]`: Change Directory. Entra a una carpeta (`cd ..` sube un nivel, `cd /` va a la raíz absoluta del sistema).
* `mkdir [nombre]`: Crea una carpeta nueva.
* `touch [archivo]`: Crea un archivo de texto vacío.
* `cat [archivo]`: Escupe el contenido de un archivo en la terminal para leerlo sin riesgo de modificarlo.

## 👤 2. Usuarios, Grupos y Permisos
* `whoami`: Me dice con qué usuario estoy trabajando ahora mismo.
* `su - [usuario]`: Switch User. Cambia mi sesión a la de otro usuario (`exit` para volver al mío).
* `sudo adduser [nombre]`: Crea un usuario nuevo de forma interactiva.
* `sudo addgroup [nombre]`: Crea un grupo nuevo (equivalente a una Unidad Organizativa en AD).
* `sudo usermod -aG [grupo] [usuario]`: Añade un usuario a un grupo **SIN** borrarlo de sus otros grupos (`-a` de Append es vital para no romper nada).
* `id [usuario]`: Muestra el "carné de identidad" del usuario (ID y a qué grupos pertenece).
* `chmod 700 [carpeta]`: Cierra los permisos. 700 significa "Solo el propietario puede leer, escribir y entrar".
* `/etc/passwd`: Archivo donde viven las configuraciones de todos los usuarios.
* `/etc/group`: Archivo donde viven las configuraciones de todos los grupos.
* `chmod [números] [archivo]`: Cambia permisos sumando valores (Lectura=4, Escritura=2, Ejecución=1). Ej: 644 (archivos) o 755 (carpetas).
* `chown [usuario] [archivo]`: Cambia el dueño absoluto de un archivo.
* `chown [usuario]:[grupo] [archivo]`: Cambia el dueño y el grupo a la vez (Ej: chown tecnico1:it_staff secreto.txt).

## 🔍 3. Trucos de Administrador
* `grep [palabra] [archivo]`: El buscador láser. Busca una palabra exacta dentro de un archivo gigante (Ej: `grep it_staff /etc/group`).
* `history`: Muestra el historial de todos los comandos que he escrito.
* **Tecla Tabulador (`Tab`)**: El superpoder del técnico. Autocompleta rutas y comandos para no cometer errores ortográficos.

## 🐙 4. El Ciclo de Guardado (Git)
* `git add .`: Mete todos los cambios en la "caja" de preparación.
* `git commit -m "Mensaje"`: Cierra la caja y le pone una etiqueta que explica qué he hecho.
* `git push`: Envía la caja a mi repositorio en la nube de GitHub.
* `gh auth setup-git`: Comando mágico de Codespaces para arreglar el Error 403 (Permiso denegado).
## 📦 5. Gestión de Servicios (Pilar 2)
* `sudo apt update`: Actualiza el catálogo de programas.
* `sudo apt install [programa] -y`: Instala un programa sin preguntar.
* `sudo service [nombre] status`: Mira si el servicio está vivo (Usar en contenedores/Codespaces).
* `systemctl status [nombre]`: Mira si el servicio está vivo (Usar en servidores reales/VMs).
* `sudo service [nombre] start`: Enciende el servicio.
* `sudo service [nombre] stop`: Apaga el servicio.
* `sudo service [nombre] restart`: Apaga y enciende (Útil tras cambiar configuraciones).
## 🕵️ 6. Logs y Redirecciones (Nivel Pro)
* `tail -n 10 [archivo]`: Muestra solo las últimas 10 líneas de un archivo. Herramienta obligatoria para leer logs sin que la pantalla se vuelva loca.
* `> [archivo]`: El embudo. Redirige el texto de un comando hacia un archivo y **machaca** (sobrescribe) todo lo que hubiera antes.
* `>> [archivo]`: El embudo seguro. Añade el texto **al final** del archivo sin borrar lo que ya existía.
* `sudo bash -c 'comando > archivo'`: Truco maestro. Abre una terminal temporal con poderes absolutos para poder inyectar texto en archivos protegidos.
* `/var/log/`: La carpeta sagrada donde todos los programas guardan su historial de errores y accesos.
* `/var/www/html/`: La carpeta pública. El escaparate de tu servidor. Todo lo que pongas aquí dentro será visible en internet.
* `Puerto 80 (HTTP)`: La puerta estándar por donde entra y sale el tráfico web normal. Si un firewall cierra este puerto, tu web desaparece.
## 🧱 7. Tuberías (Pipes) y Filtros (Pilar 3)
* `|` (Pipe): Conecta comandos. La salida (texto) del comando de la izquierda se inyecta directamente como entrada al comando de la derecha.
* `wc -l`: (Word Count) Cuenta el número de líneas que recibe. Ideal para ponerlo al final de una tubería para obtener totales.
* `comando1 | comando2 | comando3`: Puedes encadenar todos los comandos que necesites para procesar datos paso a paso (Ej: cat archivo | grep palabra | wc -l).
* `&&`: Operador lógico AND. Ejecuta el segundo comando SOLO si el primero ha terminado con éxito (Ej: apt update && apt install).
## 🤖 8. Bash Scripting y Automatización (Pilar 4)
* `#!/bin/bash`: (Shebang) La primera línea obligatoria de cualquier script. Le dice al sistema qué intérprete usar.
* `chmod +x archivo.sh`: Da permisos de eXecución a un script para que pueda cobrar vida.
* `./script.sh`: Ejecuta un script que está en la carpeta actual.
* `crontab -e`: Abre la agenda de tareas programadas (Cron).
* `crontab -l`: Lee y muestra las tareas programadas actualmente.
* `crontab -r`: Borra TODA la agenda de tareas programadas (Botón del pánico).
* Sintaxis de Cron: `* * * * * comando` (Minuto, Hora, Día del mes, Mes, Día de la semana).
## 🔀 9. Redirecciones y Trucos Pro (El nivel Ninja)
* `>>` (Redirección segura): Envía el resultado de un comando a un archivo de texto, añadiéndolo al final **SIN borrar** lo que ya había (Ej: `comando >> archivo.log`).
* `>` (Redirección destructiva): Envía el resultado a un archivo, pero **BORRANDO** todo el contenido anterior. Lo machaca por completo. ¡Cuidado!
* `echo "texto"`: El megáfono. Imprime un texto. Se usa muchísimo combinado con redirecciones para escribir en archivos sin tener que abrir editores (Ej: `echo "hola" >> saludo.txt`).
* `$(comando)`: Comandos anidados. Ejecuta un comando dentro de otro y pone el resultado ahí mismo (Ej: `echo "Mi ruta es $(pwd)"` inyecta la ruta automáticamente).
* **Truco Pro de Grep:** No hace falta usar `cat` para leer un archivo antes de filtrarlo. Puedes hacerlo directo: `grep "palabra" /ruta/al/archivo`.
## 📡 10. Redes y Procesos (El Radar de Ciberseguridad)
* `ip a` o `ip addr`: Muestra tus tarjetas de red y tus direcciones IP (sustituye al antiguo `ifconfig`).
* `ping [IP o dominio]`: Envía paquetes de red (ICMP) para comprobar si una máquina está encendida y si llegas hasta ella.
* `ps aux`: Hace una "fotografía" de todos los procesos y programas que se están ejecutando en ese milisegundo por todos los usuarios del sistema.
* `top` o `htop`: Muestra los procesos en tiempo real, ordenados por cuánta CPU y RAM consumen (es el Administrador de Tareas de la terminal).
* `kill -9 [PID]`: El francotirador. Mata un proceso malicioso o bloqueado usando su número identificador (PID). El `-9` significa "fuerza la muerte inmediata sin preguntar".
* `ss -tuln` o `netstat -tuln`: El escáner de puertos. Te muestra una lista de qué puertos de tu máquina están abiertos y "escuchando" hacia internet. Vital para auditorías.
* `curl [URL]`: El navegador de la terminal. Permite ver el código de una web, interactuar con APIs o descargar archivos directamente desde la consola.
* `wget [URL]`: Descarga archivos desde internet directamente a la carpeta donde estés ubicado.
