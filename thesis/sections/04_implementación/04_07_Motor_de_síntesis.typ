#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Motor de síntesis
<sec_motor_de_síntesis>

El motor de síntesis integra el generador con los efectos (como el ecualizador). Es la capa exterior del sistema de
audio. Proporciona una interfaz sencilla que inicializa todos sus componentes y abstrae su funcionamiento.

=== Prueba extremo a extremo

En el archivo `sparklet/synth-engine/examples/midi_render.rs` se puede encontrar una prueba que lee un archivo MIDI del
dominio público (The Entertainer de Scott Joplin) y usa el motor de síntesis para sintetizar el audio que le
corresponde. El script `sparklet/synth-engine/render_all.sh` ejecuta la prueba con varias configuraciones para ver cómo
afectan al audio. Una vez ejecutado, habrá un archivo de audio por permutación de la configuración. Por ejemplo, en
`sparklet/synth-engine/test-results/entertainer_sawtooth_mid_16v.wav` se podrá escuchar cómo se comporta el motor de
síntesis configurado con la onda de diente de sierra, dieciséis voces y ataque, decaimiento y relajación intermedios.

=== Conexión con la salida de audio

La salida de audio funciona por muestreo. Cuando el controlador de la salida recibe una solicitud de transmición de un
bloque de audio, ha de responder de forma casi inmediata. Debido a esto, la generación se ejecuta en otra tarea, y
genera los siguientes dos bloques de antemano. Cuando se recibe un muestreo, para transmitirlos únicamente hay que
copiarlos, lo que permite responder a tiempo.

Los bloques que calcula el motor de síntesis se transmiten a la tarea de salida de audio con un
`embassy_sync::zerocopy_channel`. Es un canal con _back-pressure_, lo que significa que al momento de enviar un mensaje,
si la cola esta llena, se tiene que esperar a que se abra un espacio. La salida de audio elimina de la cola un bloque
cuando lo acaba de transmitir, lo que desbloquea a la generación de audio para que genere el siguiente. Así se
sincronizan las dos tareas. El `zerocopy_channel` además no copia los datos internamente al transmitir un mensaje, lo
que lo hace más eficiente para bloques grandes como son los de audio.

Usar una cola para los bloques conlleva un retraso. Si se muestrea una vez cada milisegundo, entonces se responde con un
bloque generado hace tantos milisegundos como tenga bloques la cola. Sin embargo tener una cola de más de un bloque
ayuda a soportar picos de procesamiento (que podrían ocurrir, por ejemplo, si ocurren muchas interrupciones) sin generar
artefactos de audio, ayudando a cumplir el @rnf_calidad_de_audio. Debido a esto Sparklet usa una cola de dos bloques.
