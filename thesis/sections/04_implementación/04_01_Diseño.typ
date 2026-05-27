#import "/utils/tfc_template.typ": *

#import "@preview/zero:0.6.1": num, set-group, set-num
#set-num(decimal-separator: ",", digits: 0)
#set-group(
  size: 3,
  separator: sym.space.thin,
  threshold: 5,
)

== Diseño
<sec_diseño>

=== Arquitectura

#figure(
  image("/figures/Diagrama de la arquitectura.drawio.pdf", width: 67%),
  caption: "Diagrama de la arquitectura de Sparklet.",
  placement: bottom,
)<fig_diagrama_arquitectura>

La arquitectura de Sparklet se puede ver en el @fig_diagrama_arquitectura. Consiste en 5 grupos de tareas: el motor de
síntesis, el gestor de configuración, los periféricos, la entrada MIDI, y la salida de audio, conectados con primitivas
asíncronas.

La salida de audio es muestreada por el dispositivo maestro periódicamente. En USB, con una frecuencia de muestreo de
$#num(48000) "Hz"$, el maestro solicita al esclavo bloques de 48 muestras cada $1000 "Hz"$ @ref_web_usb_audio. Esto
garantiza la sincronización de la frecuencia de muestreo entre los dispositivos, y evita tener que mantener un reloj
interno y sincronizarlo con el del maestro. Cuando Sparklet recibe una solicitud de un bloque de audio, tiene responder
de forma casi inmediata, por lo que el bloque tiene que haber sido calculado de antemano. Debido a esto, la generación
de los bloques de audio se realiza en otra tarea: el motor de síntesis. Son conectadas con una cola de 2 bloques de
audio con _back-pressure_, lo que implica que la cola bloquea al escritor hasta que hay un espacio libre. En este caso,
enviar un bloque (liberar un espacio) permite al motor de síntesis generar el siguiente (desbloquea al escritor).

El motor de audio tiene una cola de eventos MIDI que han llegado desde la generación del último bloque de audio. La
tarea de entrada MIDI lee un _stream_ de bytes y añade a la cola los eventos MIDI que hay en él, descartándolos si
Sparklet no es compatible o si la cola está llena.

Idealmente, se procesarían los eventos MIDI en una tarea aparte, en lugar de ser parte de la de generación de audio. Sin
embargo, el algoritmo de robo de voces requiere de información privada al motor de síntesis, por lo que no es práctico.

La configuración, sin embargo, no depende de información privada, por lo que se extrae a una tarea separada. Sparklet
puede ser configurado por periféricos y por MIDI, como indican el @rf_configuración_periféricos y el
@rf_configuración_midi. Ambas entradas se comunican con el gestor de configuración usando una cola con descarte. La
configuración se comunica al motor de síntesis por un triple _buffer_, que nunca bloquea la lectura ni la escritura,
para evitar retrasos en la generación de audio.

=== Compatibilidad con múltiples dispositivos
<sec_múltiples_dispositivos>

Ya que la mayoría del código es independiente de la plataforma, y debido a que tanto Embassy como CMSIS-DSP son
compatibles con casi todos los dispositivos STM32 que usan un ARM Cortex M4 o M7 (con y sin coma flotante), la cantidad
de código que varía entre dos dispositivos es mínima. En particular, únicamente cambia la configuración del hardware (p.
ej. los pines y la configuración USB).

Todo el código que especifica estos detalles se encuentra en un único módulo, `hardware`. Se hace de esta forma para
facilitar añadir nuevos dispositivo y depurar problemas con el dispositivo actual. Cada dispositivo indica los
periféricos y la configuración de su hardware en un formato común. El módulo `hardware` exporta únicamente la
implementación del dispositivo activo, y las tareas importan lo que exporta el módulo hardware, como se puede ver en la
@fig_hardware.

#figure(
  grid(
    columns: 1,
    gutter: 2em,
    [

      #figure(
        image("/figures/hardware.drawio.pdf", width: 95%),
        caption: "Diagrama representando la arquitectura usada para ofrecer compatibilidad con múltiples dispositivos.",
      )<fig_hardware>
    ],
    [

      #figure(
        image("/figures/CMSIS Interface.drawio.pdf", width: 55%),
        caption: "Diagrama del uso de CMSIS Interface.",
      )<fig_cmsis_interface>
    ],
  ),
  numbering: none,
  placement: auto,
)

=== Instrucciones DSP
<sec_inst_dsp>


Para poder realizar un procesamiento de señales con la velocidad suficiente es preciso aprovechar una biblioteca
eficiente, como CMSIS-DSP. Sin embargo, para conseguir un rendimiento elevado, esta biblioteca usar instrucciones que
únicamente están disponibles en la arquitectura ARM Cortex, y que por lo tanto no se pueden ejecutar en el ordenador
usado para el desarrollo @ref_web_cmsis_dsp. Para poder ejecutar los mismos módulos tanto en el chip como en el
ordenador (y en las pruebas automáticas, como indica el @rnf_pruebas), las operaciones necesarias se abstraen detrás de
una interfaz: CMSIS Interface.

Hay dos implementaciones de esta interfaz, como se indica en la @fig_cmsis_interface. Una usa Rust puro y se puede
compilar a `x86_64` (CMSIS Rust), y se proporciona a los módulos en las pruebas automáticas. La otra usa las funciones
de la biblioteca CMSIS-DSP, y se proporciona en la ejecución (CMSIS Native).

CMSIS Rust y CMSIS Native se someten a la misma batería de pruebas, para garantizar que sus implementaciones son
idénticas. Se usan macros definidas en el módulo CMSIS Interface para generar las pruebas de ambas implementaciones,
garantizando que son iguales. Las pruebas de CMSIS Rust se pueden ejecutar automáticamente en `x86_64`, pero las de
CMSIS Native han de ser ejecutadas en el chip manualmente cada vez que se añade una función a la interfaz.
