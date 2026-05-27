#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Generador
<sec_generador>

El generador encapsula los componentes que calculan la señal de audio, antes de ser procesados posteriormente por los
efectos como el ecualizador. Coordina los osciladores, el ADSR y el banco de voces. Su método principal es
`render_samples`, que recibe un buffer de longitud `L` y lo llena de las siguientes $L$ muestras siguiendo los
siguientes pasos:

+ Hace que el `VoiceBank` procese los eventos MIDI que le han llegado desde el último `render_samples`, como se explica
  en la @sec_procesado_midi.
+ Por cada voz:
  + Calcula las muestras que genera el oscilador para ese periodo.
  + Calcula las muestras del envolvente ADSR para ese periodo.
  + Modula la amplitud de la salida del oscilador con la envolvente ADSR, multiplicándolas como indica la
    @eq_adsr_modulación.
  + La divide para acomodar el número de voces total.#footnote[En concreto, hace el mínimo _bit shift_ a la derecha para
      que se divida entre al menos la cantidad de voces $|V|$.]
  + La suma al buffer de salida, que se inicializa a cero.

=== Rendimiento
<sec_rendimiento_generador>

Se midió experimentalmente el tiempo que tarda el generador calcular un bloque de audio de un milisegundo. Se realizó la
medida con Sparklet siendo ejecutado en su totalidad, incluyendo la gestión de eventos MIDI, el algoritmo de robo de
voces (que se activaba cada muestra), la transmisión de audio por USB y la comunicación entre tareas por canales. Aunque
se mide el tiempo entre la generación de la señal y que se marque el paquete como enviado, es posible que otras tareas
se hayan ejecutado durante la generación, en cuyo caso añadirían tiempo a la medida realizada.

Con 8 voces tarda $508 "µs"$, y con 16 tarda $979 "µs"$. Asumiendo que la relación entre la cantidad de voces y el
tiempo es afín, se puede estimar que cada voz conlleva $59 "µs"$ de cálculo, y que se emplean $37 "µs"$ que no escalan
en relación a las voces. Sabiendo que el CPU de la placa STM32H723ZG opera a $550 "MHz"$, se puede estimar que calcular
48 muestras para cada voz ocupa $37 "µs" times 550 "MHz" = 20350 "ciclos"$, o $424 "ciclos"$ por muestra. Esto es
suficiente para cumplir con el @rnf_rendimiento, como se explicará en la @sec_ejecutor_rendimiento.
