@echo off
echo ========================================
echo Construyendo ejecutable portable...
echo ========================================
echo.

REM Verificar que PyInstaller esté instalado
python -c "import PyInstaller" 2>nul
if errorlevel 1 (
    echo PyInstaller no está instalado. Instalando...
    pip install pyinstaller
)

echo.
echo Instalando dependencias...
pip install -r requirements.txt

echo.
echo Creando ejecutable...
pyinstaller --name="SensorMonitor" ^
    --onefile ^
    --windowed ^
    --icon=NONE ^
    --add-data "requirements.txt;." ^
    --hidden-import=serial ^
    --hidden-import=serial.tools.list_ports ^
    --hidden-import=matplotlib ^
    --hidden-import=matplotlib.backends.backend_tkagg ^
    --hidden-import=matplotlib.backends._backend_tk ^
    --hidden-import=tkinter ^
    --hidden-import=tkinter.ttk ^
    --collect-all=matplotlib ^
    --noconsole ^
    src/graph.py

echo.
echo ========================================
echo Ejecutable creado en: dist\SensorMonitor.exe
echo ========================================
pause

