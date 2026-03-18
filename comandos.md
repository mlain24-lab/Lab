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
