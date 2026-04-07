# ==============================================================
# 1. CONFIGURACION DE RUTAS
# ==============================================================
$Origenes = @(
    "C:\Users\migue\Documents",
    "C:\Users\migue\Saved Games",
    "C:\Users\migue\Pictures"
)

$DestinoVault = "C:\.sys_vault\"
$DestinoNube = "C:\Users\migue\OneDrive\BackUps_Seguros\"
$Prefijo = "Backup_DobleCapa_"

# ==============================================================
# 2. EJECUCION DEL BACKUP (CON MANEJO DE ERRORES)
# ==============================================================
$Fecha = Get-Date -Format "yyyyMMdd_HHmm"
$ArchivoLocal = $DestinoVault + $Prefijo + $Fecha + ".zip"
$ArchivoNube = $DestinoNube + $Prefijo + $Fecha + ".zip"

try {
    Write-Host "Iniciando compresion multiple local..." -ForegroundColor Cyan
    # El -ErrorAction Stop obliga a saltar al Catch si algo falla
    Compress-Archive -Path $Origenes -DestinationPath $ArchivoLocal -Force -ErrorAction Stop
    
    Write-Host "Enviando copia de seguridad a la Nube..." -ForegroundColor Cyan
    Copy-Item -Path $ArchivoLocal -Destination $ArchivoNube -Force -ErrorAction Stop

    Write-Host "Fase de copia completada. Iniciando limpieza..." -ForegroundColor Cyan

    # ==============================================================
    # 3. POLITICA DE RETENCION (GARBAGE COLLECTION)
    # ==============================================================
    $DiasRetencion = 3
    $FechaLimite = (Get-Date).AddDays(-$DiasRetencion)
    
    Get-ChildItem -Path "$DestinoVault\*.zip" | Where-Object { $_.CreationTime -lt $FechaLimite } | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path "$DestinoNube\*.zip" | Where-Object { $_.CreationTime -lt $FechaLimite } | Remove-Item -Force -ErrorAction SilentlyContinue

    Write-Host "OPERACION EXITOSA: Backup y limpieza completados sin errores." -ForegroundColor Green
}
catch {
    # ==============================================================
    # 4. GESTION DE FALLOS (EL "IF NOT")
    # ==============================================================
    Write-Host ""
    Write-Host "===================================================" -ForegroundColor Red
    Write-Host "ERROR CRITICO: El backup automatico ha fallado." -ForegroundColor Red
    Write-Host "Detalle del error: $_" -ForegroundColor Red
    Write-Host "===================================================" -ForegroundColor Red
    Write-Host ""
}