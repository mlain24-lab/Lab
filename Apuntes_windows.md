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
## 🌐 5. Redes Core: DNS y DHCP

En un entorno Windows Server, estos dos servicios son el "sistema nervioso" de la red.

### 🔍 DNS (Domain Name System) - El Traductor
* **Sin DNS no hay Active Directory:** Los equipos usan el DNS para encontrar al Controlador de Dominio (DC). Si el DNS falla, los usuarios no pueden iniciar sesión porque el PC "no encuentra" al jefe.
* **Troubleshooting:** Si un PC tiene red pero no navega o no entra en dominio, lo primero es probar `nslookup [nombre-del-servidor]` para ver si el DNS responde.

### 🔌 DHCP (Dynamic Host Configuration Protocol) - El Repartidor
* **Función:** Asigna automáticamente direcciones IP, máscara de subred y puerta de enlace a los dispositivos.
* **El síntoma APIPA (169.254.x.x):** Si un ordenador tiene esta IP, significa que NO ha podido contactar con el servidor DHCP. 
* **Reserva de IP:** Es una técnica para que el DHCP siempre le dé la misma IP a un dispositivo específico (ej. una impresora o un servidor) basándose en su dirección MAC.
## ☁️ 6. Gestión de Dispositivos (Intune vs SCCM)

En entornos modernos, la administración no se limita solo a lo que hay dentro de la oficina.

### 📱 Microsoft Intune (El presente y futuro)
* **¿Qué es?** Una herramienta de gestión en la nube (MDM/MAM) integrada en Microsoft 365.
* **Uso principal:** Gestionar portátiles de teletrabajadores, móviles y tablets sin necesidad de que estén en la red local (LAN) o conectados por VPN.
* **Diferencia con GPO:** Mientras las GPO necesitan ver al Controlador de Dominio, Intune aplica políticas a través de internet.

### 🏗️ SCCM / MECM (La infraestructura pesada)
* **¿Qué es?** System Center Configuration Manager. Una herramienta local (on-premise) para gestionar miles de equipos.
* **Uso principal:** Despliegue masivo de sistemas operativos (instalar Windows en 200 PCs a la vez por red PXE), inventarios gigantescos y distribución de parches críticos.

### ⚖️ Resumen para soporte:
* **Entorno local:** Active Directory + GPOs.
* **Entorno híbrido/remoto:** Azure AD + Intune.
* **Entorno masivo local:** SCCM.
## 🛜 7. Troubleshooting de Redes (Kit de Supervivencia Helpdesk)

Además de DNS y DHCP, un técnico debe dominar estos conceptos y comandos para aislar problemas de conectividad:

### 🛡️ Conceptos de Red Corporativa
* **VPN (Virtual Private Network):** Crea un "túnel" seguro a través de internet. Permite a un teletrabajador estar virtualmente dentro de la red de la oficina.
* **VLAN (Virtual LAN):** Permite dividir un switch físico en varias redes lógicas independientes (Ej: VLAN Contabilidad y VLAN Invitados).
* **​Puertos de Oro (Firewall): 80/443 (Web), 3389 (Escritorio Remoto), 22 (SSH), 445 (Carpetas Compartidas / SMB).

### 💻 Comandos Prácticos de Diagnóstico (CMD y PowerShell)
Cuando un usuario reporta "no tengo internet", este es el orden de diagnóstico en su consola (`cmd`):

* **1. Aislamiento con PING:**
* `ping 127.0.0.1` -> Comprueba que la tarjeta de red física funciona.
* `ping 8.8.8.8` -> Si responde, el PC **sí** tiene salida a internet.
* `ping google.com` -> Si el paso anterior funcionó pero este falla, es culpa del servidor **DNS**.
* **2. Rastrear cortes con TRACERT:**
* `tracert 8.8.8.8` -> Muestra los saltos por los routers. Útil para ver si la conexión se corta dentro de la oficina o en la operadora de internet.
* **3. Limpiar la caché DNS:**
* `ipconfig /flushdns` -> Obliga al PC a olvidar IPs antiguas de webs o servidores actualizados.
* **4. Comprobar Puertos Abiertos (PowerShell):**
El ping no comprueba servicios, solo si la máquina está encendida. Para saber si un puerto (ej. 3389) está abierto, usa en PowerShell:
* `Test-NetConnection 192.168.1.50 -Port 3389`
*(Si devuelve `TcpTestSucceeded : True`, el servicio funciona perfectamente).*
### 🧠 Conceptos Avanzados de Redes para Helpdesk

**1. Firewalls y Filtrado Web**
El Firewall perimetral controla todo el tráfico de entrada y salida de la empresa. Si un equipo tiene resolución DNS y hace ping a `8.8.8.8`, pero no puede abrir ciertas webs corporativas o externas, el problema suele derivarse en un bloqueo del Firewall. Se escala a Nivel 2.

**2. VPN (Client-to-Site) y RADIUS**
* **Flujo de autenticación:** Usuario en casa -> Programa VPN -> Firewall perimetral -> Petición RADIUS -> Active Directory.
* **Troubleshooting:** Si la VPN rechaza la conexión, el primer paso en Helpdesk es comprobar en el *Active Directory local* si la cuenta del usuario está bloqueada o la contraseña ha expirado. 

**3. VLANs y Problemas de Capa 2**
* **Concepto:** División lógica de un switch físico para separar tráfico (Ej: VLAN Empleados vs VLAN Impresoras).
* **Troubleshooting:** Si un usuario cambia físicamente de mesa u oficina y pierde acceso a sus recursos de red, el problema suele ser que la nueva roseta de red está "parcheada" a un puerto del switch que pertenece a una VLAN incorrecta para su departamento.

## ☁️ 8. Soporte Cloud: Microsoft 365 y Entra ID

En entornos modernos, la identidad local se sincroniza con la nube para acceder a servicios como Exchange (Correo), Teams y OneDrive.

### 🔄 Entorno Híbrido (AD Connect)
* **Concepto:** Herramienta que sincroniza los usuarios y contraseñas del Active Directory local (On-Premise) con Microsoft Entra ID (Cloud).
* **Troubleshooting:** Si un usuario cambia su contraseña en el PC de la oficina pero no puede entrar al correo web, suele ser porque la sincronización de AD Connect tarda unos minutos (por defecto 30 min) en subir el cambio a la nube.

### 📱 MFA (Autenticación Multifactor) y Cambio de Dispositivo
El ticket más común en Helpdesk Nivel 1 es la pérdida de acceso al Microsoft Authenticator por cambio, rotura o pérdida del teléfono móvil.
* **Resolución (Portal Entra ID):** 1. Buscar al usuario en el centro de administración.
  2. Ir a *Métodos de autenticación*.
  3. Ejecutar la acción: **"Requerir volver a registrar la autenticación multifactor"**.
  4. La próxima vez que el usuario inicie sesión, el sistema le pedirá configurar la aplicación desde cero con un nuevo código QR.

## 🎫 9. Gestión de Incidencias (Ticketing y SLAs)

El trabajo diario de soporte técnico se basa en la correcta priorización y documentación de las incidencias bajo el marco de buenas prácticas ITIL.

### ⏱️ SLAs (Service Level Agreements) y Priorización
Los tickets no se atienden por orden de llegada, sino por el impacto en el negocio:
* **P1 (Crítica):** Caída de servicios core (Redes, Servidores, ERP). Máxima prioridad.
* **P2 (Alta):** Afectación a grupos de usuarios o perfiles VIP (Dirección).
* **P3 (Media):** Incidencias individuales que no bloquean totalmente el trabajo del usuario.
* **P4 (Baja):** Peticiones de servicio (Service Requests) no urgentes.

### 🔄 Estados y Buenas Prácticas
* **Pausa de SLA:** Si se requiere información del usuario para continuar el diagnóstico, el ticket debe pasar a estado "Pendiente del Usuario" para pausar las métricas de tiempo.
* **Trazabilidad:** Toda acción, diagnóstico (comandos ejecutados) y comunicación telefónica debe quedar registrada por escrito en el ticket. "Si no está documentado, no ha ocurrido".
* **Escalado:** Si tras aplicar el troubleshooting de Nivel 1 (Ping, DNS, revisión de logs, AD local) la incidencia no se resuelve en un tiempo prudencial, documentar los pasos realizados y escalar al Nivel 2 (Sistemas/Redes).

## ⚡ 10. Automatización con PowerShell

Como Administrador de Sistemas, la creación masiva de usuarios no se hace a mano (GUI), se automatiza mediante scripts para evitar errores humanos y ahorrar tiempo.

### 📝 Creación masiva de usuarios desde un Excel (CSV)
Cuando Recursos Humanos envía una lista de nuevas incorporaciones, se exporta a formato `.csv` y se utiliza un bucle `foreach` en PowerShell para iterar sobre cada fila y crear el usuario en el Active Directory.

**Ejemplo de Script de Alta Masiva:**
```powershell
# 1. Importamos el archivo CSV con los datos (Nombre, Apellido, Departamento, Usuario)
$usuarios = Import-Csv -Path "C:\IT\nuevos_usuarios.csv"

# 2. Iniciamos el bucle para leer fila por fila
foreach ($user in $usuarios) {
    
    # 3. Ejecutamos el comando de creación inyectando las variables del CSV
    New-ADUser -Name "$($user.Nombre) $($user.Apellido)" `
               -SamAccountName $user.Usuario `
               -Department $user.Departamento `
               -Enabled $true
    
    # 4. Mostramos por pantalla un mensaje de confirmación
    Write-Host "Usuario $($user.Usuario) creado correctamente en AD." -ForegroundColor Green
}
