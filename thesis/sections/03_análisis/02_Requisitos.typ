#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Requisitos
<sec_requisitos>

En base al estado del arte de los sintetizadores, se proponen los siguientes requisitos, orientados a especificar un
sistema útil que supere el estado del arte.

=== Requisitos funcionales

#req("rf_midi_usb", "F")[MIDI USB][
  El sintetizador ha de ser configurable en compilación para conectarse a MIDI por USB.]
#req("rf_midi_din", "F")[MIDI DIN][
  El sintetizador ha de ser configurable en compilación para conectarse a MIDI por un puerto DIN.]
#req("rf_audio_usb", "F")[Audio USB][
  El sintetizador ha de ser configurable en compilación para conectarse al audio por USB.]
#req("rf_ondas", "F")[Generación de ondas][
  El sintetizador ha de poder generar ondas sinusoidales, cuadradas, de diente de sierra y triangulares.]
#req("rf_adsr", "F")[ADSR][
  El sintetizador ha de modular la amplitud de la onda con un envolvente ADSR configurable.]
#req("rf_ecualizador", "F")[Ecualización][
  El sintetizador ha de ser configurable en compilación para poder ecualizar la señal.]
#req("rf_polifonía", "F")[Polifonía][
  El sintetizador ha de tener una cantidad de voces configurable en compilación.]
#req("rf_multi_dispositivos", "F")[Multiples dispositivos][
  El sintetizador ha de poder ser instalado en al menos dos dispositivos empotrados distintos.]
#req("rf_añadir_dispositivos", "F")[Añadir dispositivos][
  Debe estar documentado cómo configurar el sintetizador para un nuevo dispositivo empotrado.]
#req("rf_configuración_ejecución", "F")[Configuración en ejecución][
  El sintetizador ha de ser configurable en ejecución con elementos físicos conectados a la placa.]

=== Requisitos no funcionales

#req("rnf_rendimiento", "NF")[Rendimiento][
  El sintetizador, con salida de audio por USB, entrada de MIDI por USB e incluyendo el ecualizador, ha de poder acabar
  de producir cada bloque de audio antes de que el siguiente se solicite con un margen del 10% al ejecutarse en una
  placa STM32H723ZG.
]
#req("rnf_fiabilidad", "NF")[Fiabilidad][
  El sintetizador ha de operar continuamente sin necesitar un reinicio.]
#req("rnf_calidad_de_audio", "NF")[Calidad de audio][
  El sintetizador ha de producir audio libre de distorsiones perceptibles.]
#req("rnf_pruebas", "NF")[Pruebas][
  El sintetizador ha de tener pruebas que validen su funcionalidad ejecutadas automáticamente durante el desarrollo de
  forma visible.
]
