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

El ejecutor (`runner`) es responsable de inicializar el microcontrolador y sus periféricos, definir los canales que usan
los otros módulos para comunicarse, y crear las tareas que ejecutan el resto de componentes. En concreto, hace lo
siguiente:

+ Inicializa el microcontrolador y sus periféricos.

+ Inicializa el ejecutor de tareas de Embassy.

+ Configura la salida USB, si es necesaria.

+ Ejecuta el gestor de configuración, si está activada la configuración en ejecución, sea por los periféricos o por
  MIDI.

+ Ejecuta la tarea de lectura de MIDI si está activada, sea por DIN o USB.

+ Ejecuta la tarea de salida de audio por USB, si está activada.

+ Ejecuta el motor de síntesis.

+ Envía la configuración por defecto, si no está activada la configuración en ejecución.

+ Ejecuta la tarea de lectura de periféricos, si está activada.

Una vez acaba este proceso, el ejecutor de Embassy toma control de la ejecución, y se encarga de coordinar las tareas
ejecutadas.

=== Pruebas

El ejecutor y CMSIS Native son los únicos módulos que sólo pueden ejecutarse en el sistema empotrado (y no en el
ordenador usado para el desarrollo), por lo que son los únicos que no tienen pruebas automáticas. El ejecutor es probado
manualmente con regularidad durante el transcurso de cada sprint, y se ejecuta una prueba final de toda la funcionalidad
del sistema antes de cerrarlo, como se mencionó en la @sec_estrategia_de_pruebas.

=== Rendimiento
<sec_ejecutor_rendimiento>

El sintetizador es capaz de calcular cada muestra de audio en $857 "µs"$ bajo las condiciones que indica el
@rnf_rendimiento. Esto resulta en un margen del $#num(digits: 1, 14.3)%$ del tiempo disponible, superando el 10% que
pide este requisito y, por lo tanto, cumpliéndolo.
