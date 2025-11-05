@echo off
echo ========================================
echo Construyendo ejecutable portable (con consola)...
echo ========================================
echo.

REM Verificar que PyInstaller esté instalado
python -c "import PyInstaller" >nul 2>&1
if errorlevel 1 (
    echo PyInstaller no está instalado. Instalando...
    pip install pyinstaller
)

echo.
echo Instalando dependencias...
pip install -r requirements.txt

echo.
echo Creando ejecutable...
REM Intentar incluir PyQt5 si está disponible (opcional)
python -c "import PyQt5" >nul 2>&1
if errorlevel 1 (
    echo PyQt5 no está instalado. El ejecutable usará TkAgg (funciona pero más lento).
    echo Para mejor rendimiento GPU, instala PyQt5: pip install PyQt5
) else (
    echo PyQt5 detectado. Incluyendo soporte Qt5Agg para mejor rendimiento.
)

pyinstaller --name="SensorMonitor" --onefile --icon=NONE --hidden-import=serial --hidden-import=serial.tools.list_ports --hidden-import=matplotlib --hidden-import=matplotlib.backends.backend_tkagg --hidden-import=matplotlib.backends.backend_qt5agg --hidden-import=matplotlib.backends.backend_qtagg --hidden-import=matplotlib.backends._backend_tk --hidden-import=tkinter --hidden-import=tkinter.ttk --collect-all=matplotlib --collect-all=PyQt5 src/graph.py

echo.
echo ========================================
echo Ejecutable creado en: dist\SensorMonitor.exe
echo ========================================
pause

