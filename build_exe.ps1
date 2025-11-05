# Script PowerShell para compilar ejecutable portable
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Construyendo ejecutable portable..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que PyInstaller esté instalado
Write-Host "Verificando PyInstaller..." -ForegroundColor Yellow
try {
    python -c "import PyInstaller" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "PyInstaller no está instalado. Instalando..." -ForegroundColor Yellow
        pip install pyinstaller
    }
} catch {
    Write-Host "PyInstaller no está instalado. Instalando..." -ForegroundColor Yellow
    pip install pyinstaller
}

Write-Host ""
Write-Host "Instalando dependencias..." -ForegroundColor Yellow
pip install -r requirements.txt

Write-Host ""
Write-Host "Creando ejecutable..." -ForegroundColor Yellow

# Verificar PyQt5
try {
    python -c "import PyQt5" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "PyQt5 detectado. Incluyendo soporte Qt5Agg para mejor rendimiento." -ForegroundColor Green
    } else {
        Write-Host "PyQt5 no está instalado. El ejecutable usará TkAgg (funciona pero más lento)." -ForegroundColor Yellow
        Write-Host "Para mejor rendimiento GPU, instala PyQt5: pip install PyQt5" -ForegroundColor Yellow
    }
} catch {
    Write-Host "PyQt5 no está instalado. El ejecutable usará TkAgg (funciona pero más lento)." -ForegroundColor Yellow
}

# Ejecutar PyInstaller
$pyinstallerArgs = @(
    "--name=SensorMonitor",
    "--onefile",
    "--windowed",
    "--icon=NONE",
    "--hidden-import=serial",
    "--hidden-import=serial.tools.list_ports",
    "--hidden-import=matplotlib",
    "--hidden-import=matplotlib.backends.backend_tkagg",
    "--hidden-import=matplotlib.backends.backend_qt5agg",
    "--hidden-import=matplotlib.backends.backend_qtagg",
    "--hidden-import=matplotlib.backends._backend_tk",
    "--hidden-import=tkinter",
    "--hidden-import=tkinter.ttk",
    "--collect-all=matplotlib",
    "--collect-all=PyQt5",
    "--noconsole",
    "src/graph.py"
)

pyinstaller @pyinstallerArgs

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Ejecutable creado en: dist\SensorMonitor.exe" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

