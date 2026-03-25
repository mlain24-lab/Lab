# 🪟 NAVAJA SUIZA: Windows Server y Active Directory

Este documento contiene los conceptos clave, arquitectura y resolución de incidencias (Troubleshooting) para entornos corporativos Microsoft.

## 🏢 1. Arquitectura Base de Active Directory (AD)
*AD no es un programa, es el corazón de la empresa. Si el AD cae, nadie trabaja.*

* **Controlador de Dominio (DC):** El servidor físico o virtual que tiene instalado el Active Directory. Es el "jefe" que manda sobre todos los ordenadores.
* **Dominio:** El nombre de la red de la empresa (Ej: `artemadera.local` o `empresa.com`). Todos los PCs deben estar "metidos en dominio" para obedecer al DC.
* **Bosque (Forest):** El conjunto de todos los dominios de una gran multinacional. (Ej: El dominio de España y el dominio de Francia forman un Bosque).
* **Unidades Organizativas (OUs):** Son como "carpetas" donde ordenamos a los usuarios y ordenadores (Ej: OU_Ventas, OU_Contabilidad). Sirven para aplicarles normas distintas a cada departamento.
## 👤 2. Gestión de Identidades y Permisos (Regla de Oro)

En Active Directory (AD), el mayor error de un informático novato es darle permisos directamente a un usuario. 

**LA REGLA DE ORO:** Los permisos NUNCA se dan al usuario, se dan al GRUPO.
1. Creas el Usuario (Ej: Laura).
2. Metes al Usuario en un Grupo de Seguridad (Ej: Grupo_RRHH).
3. Le das el permiso de leer/escribir en la carpeta a ese Grupo.

¿Por qué? Porque si mañana Laura se va y entra Carlos, solo tienes que meter a Carlos en el grupo "Grupo_RRHH" y automáticamente tendrá los mismos accesos, sin tener que ir carpeta por carpeta configurando nada.

* **Permisos Compartidos (Share):** Permisos de red (quién puede ver la carpeta a través del cable). Lo normal es dar "Control Total" a Todos aquí y filtrar en el siguiente paso.
* **Permisos NTFS (Seguridad):** Los permisos reales del disco duro (quién puede Leer, Escribir o Modificar). Estos son los que mandan.

Las OUs aplican Políticas (GPOs). Los Grupos de Seguridad aplican Permisos (Carpetas NTFS/Compartidas). NUNCA se dan permisos a una OU ni a un Usuario individual.
## 🕵️‍♂️ 3. Troubleshooting de Permisos (Carpetas Compartidas)

**El Misterio de la "Carpeta Invisible" (ABE)**
Si un usuario indica que no ve una carpeta compartida en el servidor, pero otros compañeros de su mismo departamento sí la ven, el problema casi nunca es de red, es de permisos.
* **Access-Based Enumeration (ABE):** Es una función de Windows Server que oculta visualmente las carpetas y archivos a los usuarios que no tienen permisos NTFS para leerlos. Previene que los usuarios intenten entrar donde no deben y evita la saturación visual.

**La Actualización de Permisos y el "Ticket" de Sesión**
Si metes a un usuario en un Grupo de Seguridad nuevo mientras está trabajando, NO tendrá acceso inmediato a la nueva carpeta.
* **El motivo:** Windows genera el "ticket" de permisos (Kerberos) del usuario únicamente en el momento del inicio de sesión. 
* **La solución en Helpdesk:** NUNCA le digas que ya puede entrar. Debes decirle: *"Ya te he dado acceso. Por favor, cierra sesión en Windows, vuelve a meter tu contraseña para entrar y ya verás la carpeta"*.
## 🪄 4. GPOs (Directivas de Grupo) y Automatización

Las GPOs (Group Policy Objects) son el "superpoder" del SysAdmin. Son "cajas de normas" que sirven para automatizar configuraciones, instalar software y aplicar normativas de seguridad en cientos de equipos a la vez sin moverte de la silla.

**La Regla de Separación (GPOs vs Grupos):**
* **Grupos de Seguridad** = Sirven exclusivamente para dar PERMISOS (Quién entra a qué carpeta o aplicación).
* **OUs + GPOs** = Sirven exclusivamente para dar NORMAS (Cómo se comporta el ordenador o qué restricciones tiene el usuario). NUNCA se dan permisos de carpetas a una OU.

**¿Dónde se aplican y cómo funciona la Herencia?**
* Se pueden vincular a una **OU específica** (Ej: Poner un programa de contabilidad solo a la OU_Contabilidad).
* Se pueden vincular a la **Raíz del Dominio** (Ej: `empresa.local`). Al hacerlo en la raíz, la política cae en "cascada" (Herencia) y afecta obligatoriamente a TODOS los ordenadores de la empresa por debajo (Ej: Bloquear todos los puertos USB, o poner el logo corporativo como fondo de pantalla inamovible).

**El Comando Mágico: gpupdate /force**
Cuando creas o modificas una GPO en el servidor, los ordenadores de los usuarios tardan un tiempo aleatorio en enterarse (normalmente unos 90 minutos por defecto). 
* Si necesitas que la nueva norma (GPO) se aplique DE INMEDIATO en el ordenador de un usuario, abres su consola (CMD) y ejecutas el comando: `gpupdate /force`

* *Aviso de oro:* Este comando fuerza la actualización de POLÍTICAS (GPOs), pero **NO** actualiza los permisos de Grupos de Seguridad (para eso, como vimos antes, el usuario tiene que cerrar sesión).