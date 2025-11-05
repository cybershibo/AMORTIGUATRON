# Instalación de Drivers para STM32 Black Pill

## Driver Necesario

Tu proyecto usa un **STM32 Black Pill F411CE** que se comunica vía **USB CDC (Virtual COM Port)**. Para que Windows reconozca el dispositivo como puerto COM, necesitas instalar el driver.

## Opción 1: Driver STM32 VCP (Recomendado)

### Descarga del Driver

1. **Driver oficial de STMicroelectronics:**
   - Nombre: **STM32 Virtual COM Port Driver (VCP)**
   - Descarga desde: https://www.st.com/en/development-tools/stsw-stm32102.html
   - O busca directamente: "STM32 VCP driver" en el sitio de STMicroelectronics

2. **Instalación:**
   - Descarga el archivo ZIP
   - Extrae el contenido
   - Ejecuta `VCP_V1.5.0_Setup_W7_x64_64bits.exe` (o la versión correspondiente a tu Windows)
   - Sigue el asistente de instalación
   - Reinicia la computadora si es necesario

### Verificación

1. Conecta tu STM32 Black Pill a la computadora por USB
2. Abre el **Administrador de dispositivos** (Win + X → Administrador de dispositivos)
3. Busca en **"Puertos (COM y LPT)"**:
   - Deberías ver algo como: **"STM32 Virtual COM Port (COMx)"**
   - O: **"STMicroelectronics Virtual COM Port (COMx)"**
4. Si aparece con un signo de exclamación amarillo, el driver no está instalado correctamente

## Opción 2: Driver WinUSB (Alternativa)

Si el driver oficial no funciona, puedes usar **Zadig** para instalar WinUSB:

1. Descarga **Zadig** desde: https://zadig.akeo.ie/
2. Abre Zadig
3. Conecta tu STM32 Black Pill
4. Selecciona el dispositivo en la lista
5. Elige **WinUSB** como driver
6. Haz clic en "Install Driver" o "Reinstall Driver"

## Opción 3: Drivers Alternativos (Si usas adaptador USB-Serial)

Si usas un adaptador USB-Serial externo en lugar de la conexión USB nativa:

### Adaptador CH340/CH341:
- Descarga: https://github.com/WCHSoftGroup/ch34xser_linux
- O busca: "CH340 driver Windows"

### Adaptador FTDI:
- Descarga desde: https://ftdichip.com/drivers/vcp-drivers/

### Adaptador CP210x:
- Descarga desde: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers

## Verificar que el Puerto Funciona

1. Conecta el STM32 Black Pill
2. Abre el Administrador de dispositivos
3. Busca el puerto COM asignado (por ejemplo: COM3, COM4, COM5)
4. En tu programa Python, el puerto se detectará automáticamente si COM4 no está disponible
5. Puedes ver los puertos disponibles ejecutando:
   ```python
   import serial.tools.list_ports
   ports = serial.tools.list_ports.comports()
   for port in ports:
       print(port.device)
   ```

## Solución de Problemas

### "El dispositivo no se reconoce"
- Instala el driver STM32 VCP
- Prueba otro cable USB (debe ser cable de datos, no solo carga)
- Prueba otro puerto USB

### "Acceso denegado al puerto COM"
- Cierra otros programas que puedan estar usando el puerto (Arduino IDE, otro monitor serial)
- Desconecta y vuelve a conectar el dispositivo

### "No se detecta ningún puerto COM"
- Verifica que el microcontrolador esté encendido (LED de alimentación)
- Reinstala el driver
- Prueba en otra computadora para descartar problema del hardware

## Información Técnica

- **Dispositivo:** STM32 Black Pill F411CE
- **Conexión:** USB CDC (Virtual COM Port)
- **Velocidad:** 115200 baud
- **VID:** 0x0483 (STMicroelectronics)
- **PID:** 0x5740

## Notas Importantes

- El programa Python detecta automáticamente puertos COM disponibles
- Si COM4 no está disponible, intentará usar otro puerto
- El ejecutable portátil **NO incluye drivers** - deben instalarse en cada computadora
- Los drivers son específicos del sistema operativo (Windows/Linux/Mac)

