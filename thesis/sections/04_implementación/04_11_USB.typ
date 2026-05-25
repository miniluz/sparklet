#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== USB
<sec_usb>

La manera más fácil de usar Sparklet es mediante una conexión USB. Sparklet permite usar USB para la salida de audio,
según el @rf_audio_usb, y la entrada de MIDI según el @rf_midi_usb, permitiendo que opere con una única conexión a
cualquier ordenador moderno.

Sparklet usa `embassy-usb` para gestionar la conexión, que abstrae la mayoría de la complejidad. `embassy-usb`
proporciona la implementación de una interfaz para recibir MIDI, pero no tiene una interfaz de entrada de audio, aunque
sí una de salida de audio. Se realizó un _fork_ de `embassy-usb` para implementar la entrada de audio síncrona, que
debido a la librería más que nada consistió en copiar otros fragmentos de código y cambiar ciertas constantes de acuerdo
a la especificación de USB @ref_web_usb_audio. En Sparklet, su uso es muy sencillo: se añaden a la descripción del
dispositivo las interfaces usadas, que pueden ser MIDI y/o una entrada de audio dependiendo de la configuración.

Como se mencionó, se usa la transmisión de audio en el modo síncrono. En este modo, el dispositivo maestro pide cada
milisegundo un bloque de audio al dispositivo esclavo @ref_web_usb_audio. Se usa para ahorrar la complejidad de tener un
reloj interno independiente y de mantenerlo sincronizado con el dispositivo maestro. Además, se soporta controlar el
volumen y el silenciamiento del sintetizador con señales USB. Cuando se reciben estos eventos, se almacena el factor
equivalente en amplitud y se almacena en el estado, que a su vez se multiplica por el bloque de audio antes de
transmitirlo.
