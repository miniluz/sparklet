#import "/utils/tfc_template.typ": *
#import "@preview/zero:0.6.1": num, set-group, set-num
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

#set-num(decimal-separator: ",")
#set-group(
  size: 3,
  separator: sym.space.thin,
  threshold: 5,
)

#show math.equation: it => {
  show regex(`\d+(?:\.\d+)?`.text): it => {
    num(it)
  }
  it
}

== Ejecutor
<sec_ejecutor>

El ejecutor (`runner`) es responsable de inicializar el hardware, definir los canales que usan los otros módulos para
comunicarse, y crear las tareas que llaman el resto de componentes. Es el primer módulo mencionado hasta el momento que
sólo se puede ejecutar en el sistema empotrado. En concreto, hace lo siguiente:

+ Inicialización del hardware (véase @sec_configuración_otros_dispositivos).

+ Inicialización del ejecutor de tareas de Embassy.

+ Inicialización del USB, si está activado.

+ Creación, sin inicializar, de la tarea MIDI, ya sea usando un conector DIN o USB.

+ Creación de la tarea de salida audio por USB.

+ Creación de la tarea de la gestión de la configuración.

+ Creación de la tarea del motor de síntesis.

+ Inicialización de la tarea MIDI, de configuración, de los botones y encoders rotativos, del motor de sínstesis, y de
  la salida de audio.

Una vez acaba, las tareas toman control del chip. La configuración se ejecuta cada cierto tiempo, y la generación de
audio se ejecuta únicamente cuando se pide una salida de audio.

=== Rendimiento
<sec_ejecutor_rendimiento>

El sintetizador es capaz de calcular cada muestra de audio en $857 "µs"$ bajo las condiciones que indica el
@rnf_rendimiento. Esto resulta en un margen del $#num(digits: 1, 14.3)%$, superando el 10% que pide dicho requisito y
así cumpliéndolo.
