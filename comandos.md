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

## 🔍 3. Trucos de Administrador
* `grep [palabra] [archivo]`: El buscador láser. Busca una palabra exacta dentro de un archivo gigante (Ej: `grep it_staff /etc/group`).
* `history`: Muestra el historial de todos los comandos que he escrito.
* **Tecla Tabulador (`Tab`)**: El superpoder del técnico. Autocompleta rutas y comandos para no cometer errores ortográficos.

## 🐙 4. El Ciclo de Guardado (Git)
* `git add .`: Mete todos los cambios en la "caja" de preparación.
* `git commit -m "Mensaje"`: Cierra la caja y le pone una etiqueta que explica qué he hecho.
* `git push`: Envía la caja a mi repositorio en la nube de GitHub.
* `gh auth setup-git`: Comando mágico de Codespaces para arreglar el Error 403 (Permiso denegado).