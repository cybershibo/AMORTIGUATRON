# Guía para crear ejecutable portable

## Opción 1: Usar los scripts batch (Recomendado)

### Para ejecutable sin consola (solo ventana gráfica):
```bash
build_exe.bat
```

### Para ejecutable con consola (útil para debug):
```bash
build_exe_console.bat
```

## Opción 2: Usar archivo .spec (Configuración avanzada)

Si necesitas más control sobre la compilación, puedes usar el archivo `SensorMonitor.spec`:

```bash
pyinstaller SensorMonitor.spec
```

Para cambiar entre consola/no-consola, edita la línea `console=False` a `console=True` en el archivo .spec.

## Opción 3: Instalación manual

1. **Instalar PyInstaller:**
   ```bash
   pip install pyinstaller
   ```

2. **Instalar dependencias:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Crear ejecutable (sin consola):**
   ```bash
   pyinstaller --name="SensorMonitor" --onefile --windowed --noconsole --hidden-import=serial --hidden-import=matplotlib --collect-all=matplotlib src/graph.py
   ```

4. **Crear ejecutable (con consola para debug):**
   ```bash
   pyinstaller --name="SensorMonitor" --onefile --hidden-import=serial --hidden-import=matplotlib --collect-all=matplotlib src/graph.py
   ```

## Resultado

El ejecutable se creará en la carpeta `dist/SensorMonitor.exe`

- **Portable**: No requiere instalación, solo ejecuta el .exe
- **Autocontenido**: Incluye todas las librerías necesarias
- **Único archivo**: Todo está en un solo .exe

## Notas importantes

- El ejecutable es específico para el sistema operativo donde lo compiles (Windows)
- El tamaño será aproximadamente 50-100 MB porque incluye todas las dependencias
- Los archivos CSV se crearán en el mismo directorio donde ejecutes el .exe
- Puedes renombrar y mover el .exe a cualquier lugar, sigue funcionando

## Solución de problemas

Si el ejecutable no funciona:
1. Usa la versión con consola (`build_exe_console.bat`) para ver errores
2. Verifica que todas las dependencias estén instaladas
3. Asegúrate de que el puerto COM esté disponible

