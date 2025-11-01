import serial
import matplotlib.pyplot as plt
from collections import deque
import time

SERIAL_PORT = 'COM4'
SERIAL_BAUD = 115200
READ_TIMEOUT = 1.0  # timeout de lectura en segundos
RECONNECT_DELAY = 2.0  # tiempo de espera antes de reconectar

ser = None

def connect_serial():
    """Intenta conectar al puerto serie. Retorna True si tiene éxito."""
    global ser
    try:
        if ser is not None and ser.is_open:
            ser.close()
        ser = serial.Serial(SERIAL_PORT, SERIAL_BAUD, timeout=READ_TIMEOUT)
        time.sleep(2)  # esperar a que se estabilice la conexión
        ser.reset_input_buffer()  # limpiar buffer de entrada
        print(f"Conectado a {SERIAL_PORT}")
        return True
    except serial.SerialException as e:
        print(f"Error al conectar: {e}. Reintentando en {RECONNECT_DELAY} segundos...")
        return False
    except Exception as e:
        print(f"Error inesperado al conectar: {e}")
        return False

# Conectar inicialmente
if not connect_serial():
    print("No se pudo conectar inicialmente. El programa seguirá intentando...")

plt.ion()
fig, ax = plt.subplots()

data1 = deque([0]*100, maxlen=100)
data2 = deque([0]*100, maxlen=100)

line1, = ax.plot(data1, label="Sensor 1")
line2, = ax.plot(data2, label="Sensor 2")

ax.set_ylim(0, 2000)
ax.set_ylabel("Distancia (mm)")
ax.set_xlabel("Tiempo (muestras)")
ax.legend()

last_update_time = time.time()
consecutive_errors = 0
MAX_CONSECUTIVE_ERRORS = 10

while True:
    try:
        # Verificar conexión y reconectar si es necesario
        if ser is None or not ser.is_open:
            if not connect_serial():
                time.sleep(RECONNECT_DELAY)
                plt.pause(0.1)  # mantener la gráfica viva
                continue

        # Intentar leer línea con timeout
        try:
            line = ser.readline().decode(errors='ignore').strip()
        except serial.SerialTimeoutException:
            # Timeout normal, continuar sin actualizar datos
            consecutive_errors = 0
            plt.pause(0.01)
            continue
        except serial.SerialException:
            # Error de conexión, cerrar y marcar para reconectar
            print("Conexión perdida. Intentando reconectar...")
            if ser is not None:
                try:
                    ser.close()
                except:
                    pass
            ser = None
            consecutive_errors = 0
            plt.pause(0.1)
            continue

        if not line:
            consecutive_errors += 1
            if consecutive_errors > MAX_CONSECUTIVE_ERRORS:
                print("Muchas líneas vacías. Verificando conexión...")
                consecutive_errors = 0
            plt.pause(0.01)
            continue

        # Resetear contador de errores si recibimos datos
        consecutive_errors = 0

        # Parsear datos
        parts = line.split(',')
        if len(parts) == 2:
            try:
                d1 = float(parts[0])
                d2 = float(parts[1])

                # Ignorar valores nulos o erróneos
                # Si hay valores inválidos, usar el último valor válido si existe
                if d1 == 0 or d1 > 8200:
                    d1 = data1[-1] if len(data1) > 0 else 0
                if d2 == 0 or d2 > 8200:
                    d2 = data2[-1] if len(data2) > 0 else 0

                data1.append(d1)
                data2.append(d2)

                line1.set_ydata(data1)
                line2.set_ydata(data2)

                # Actualizar límites del eje Y solo si hay datos válidos
                if len(data1) > 0 and len(data2) > 0:
                    ymin = min(min(data1), min(data2)) - 50
                    ymax = max(max(data1), max(data2)) + 50
                    ax.set_ylim(max(ymin, 0), min(ymax, 2000))

                last_update_time = time.time()
            except (ValueError, IndexError) as e:
                # Error al parsear, ignorar esta línea
                pass

        plt.pause(0.01)
        
    except KeyboardInterrupt:
        print("Finalizado por el usuario")
        break
    except Exception as e:
        print(f"Error inesperado: {e}")
        consecutive_errors += 1
        if consecutive_errors > MAX_CONSECUTIVE_ERRORS:
            print("Muchos errores consecutivos. Verificando conexión...")
            if ser is not None:
                try:
                    ser.close()
                except:
                    pass
            ser = None
            consecutive_errors = 0
        plt.pause(0.1)  # mantener la gráfica viva incluso con errores

# Cerrar conexión al finalizar
if ser is not None and ser.is_open:
    ser.close()
