# Guía de Portabilidad - SensorMonitor

## ✅ ¿Es completamente portable?

**Sí**, el proyecto puede generar un ejecutable completamente portable que incluye todas las dependencias necesarias.

## ¿Qué incluye el ejecutable portable?

El ejecutable `SensorMonitor.exe` es **autocontenido** y incluye:

- ✅ Python runtime embebido
- ✅ Todas las librerías Python necesarias (pyserial, matplotlib, tkinter)
- ✅ Backends de matplotlib (TkAgg y Qt5Agg si PyQt5 está disponible)
- ✅ Soporte completo para comunicación serial
- ✅ Interfaz gráfica completa

## Cómo crear el ejecutable portable

### Opción 1: Script automático (Recomendado)

Ejecuta uno de estos archivos batch:

```bash
# Ejecutable sin ventana de consola (producción)
build_exe.bat

# Ejecutable con consola (útil para debug)
build_exe_console.bat
```

### Opción 2: Manual

1. Instala PyInstaller:
   ```bash
   pip install pyinstaller
   ```

2. Instala dependencias:
   ```bash
   pip install -r requirements.txt
   ```

3. Compila:
   ```bash
   pyinstaller SensorMonitor.spec
   ```

## Uso del ejecutable portable

1. **Copia el ejecutable**: El archivo `dist/SensorMonitor.exe` es todo lo que necesitas
2. **Ejecuta en cualquier PC Windows**: No requiere instalación de Python ni librerías
3. **Archivos CSV**: Se crearán automáticamente en el mismo directorio donde ejecutes el .exe
4. **Puerto COM**: El programa pedirá seleccionar el puerto COM al inicio

## Requisitos del sistema destino

- **Sistema operativo**: Windows 7 o superior (32-bit o 64-bit según la arquitectura donde compilaste)
- **Driver del microcontrolador**: El driver USB debe estar instalado (ver `DRIVER_INSTALL.md`)
- **Puerto COM disponible**: El microcontrolador debe estar conectado y reconocido como puerto COM

## Notas importantes

### PyQt5 (Opcional pero recomendado)

- Si PyQt5 está instalado durante la compilación → El ejecutable tendrá mejor rendimiento GPU
- Si PyQt5 NO está instalado → El ejecutable funcionará igual pero usará TkAgg (más lento)
- El código tiene fallback automático, así que funciona en ambos casos

### Tamaño del ejecutable

- **Con PyQt5**: ~80-120 MB
- **Sin PyQt5**: ~50-80 MB

### Portabilidad entre sistemas

- ✅ **Mismo sistema operativo**: El .exe funciona en cualquier PC Windows de la misma arquitectura (32-bit o 64-bit)
- ❌ **Diferente sistema operativo**: Necesitas compilar en cada sistema (Windows, Linux, macOS)

## Distribución

Para distribuir el programa:

1. Copia solo el archivo `dist/SensorMonitor.exe`
2. Incluye `DRIVER_INSTALL.md` si los usuarios necesitan instalar drivers
3. No necesitas incluir nada más: el .exe es autocontenido

## Verificación de portabilidad

Para verificar que el ejecutable es portable:

1. Cópialo a una carpeta nueva
2. Ejecútalo desde esa carpeta
3. Verifica que:
   - Se abre correctamente
   - Muestra la ventana de selección de puerto COM
   - Puede crear archivos CSV en el directorio actual

## Solución de problemas

### El ejecutable no se abre

1. Usa `build_exe_console.bat` para crear versión con consola y ver errores
2. Verifica que el sistema tenga los drivers necesarios
3. Asegúrate de compilar en el mismo tipo de arquitectura (32-bit vs 64-bit)

### Error de "backend no encontrado"

- Normal si PyQt5 no está instalado
- El programa usará TkAgg automáticamente
- Funciona igual, solo será más lento en pantalla completa

### Archivos CSV no se crean

- Verifica permisos de escritura en el directorio
- El ejecutable debe tener permisos de escritura en la carpeta donde está

