#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== USB
<sec_usb>

USB es un formato universal y genérico para la transmición de datos. Un dispositivo USB puede integrar varias
funcionalidades @ref_web_usb. Por ejemplo, una cámara podría exponer un _endpoint_ para transmitir video y otro para
transmitir audio. Sparklet puede expone un endpoint para la salida de MIDI (salida desde el punto de vista del maestro,
no de Sparklet) y otro para la entrada de audio, como indican el @rf_audio_usb y el @rf_midi_usb. Es quizá la manera más
fácil de usarlo, permitiendo que opere con una única conexión a cualquier ordenador con un puerto USB.

Sparklet usa `embassy-usb` para gestionar la conexión, que abstrae la mayoría de la complejidad. `embassy-usb`
proporciona la implementación de un endpoint para recibir MIDI. Sin embargo, aunque tiene un endpoint para la salida de
audio, no tiene uno para su entrada. Debido a esto se realizó un _fork_ de `embassy-usb` que lo implementa. Debido a la
estructura modular de la biblioteca, más que nada consistió en copiar otros fragmentos de código y cambiar ciertas
constantes de acuerdo a la especificación de USB @ref_web_usb_audio. En Sparklet, su uso es muy sencillo: se añaden a la
descripción del dispositivo las interfaces usadas, que pueden ser MIDI y/o una entrada de audio dependiendo de la
configuración.

Se usa la transmisión de audio en el modo síncrono, en el que el dispositivo maestro pide cada milisegundo un bloque de
audio al dispositivo esclavo @ref_web_usb_audio. Se usa para ahorrar la complejidad de tener un reloj interno
independiente y de mantenerlo sincronizado con el dispositivo maestro.

Además, se admite controlar el volumen y el silenciamiento del sintetizador con señales USB. Cuando se reciben estos
eventos, se almacena el factor equivalente en amplitud y se almacena en el estado, que a su vez se multiplica por el
bloque de audio antes de transmitirlo.
