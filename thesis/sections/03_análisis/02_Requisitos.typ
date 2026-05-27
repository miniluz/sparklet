#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Requisitos
<sec_requisitos>

Para crear un sintetizador útil que aporte al estado del arte, se proponen los siguientes requisitos. El sintetizador:

#v(-0.4cm)

==== Requisitos funcionales

#req("rf_midi_usb", "F")[MIDI USB][
  Ha de admitir entrada de MIDI por USB.]
#req("rf_midi_din", "F")[MIDI DIN][
  Ha de admitir entrada de por un puerto DIN.]
#req("rf_audio_usb", "F")[Audio USB][
  Ha de admitir salida de audio por USB.]
#req("rf_ondas", "F")[Generación de ondas][
  Ha de poder generar ondas sinusoidales, cuadradas, de diente de sierra y triangulares, podiendo cambiar entre ellas en
  ejecución.]
#req("rf_adsr", "F")[ADSR][
  Ha de modular la amplitud de la onda con un envolvente ADSR configurable en ejecución.]
#req("rf_ecualizador", "F")[Ecualización][
  Ha de tener un ecualizador multibanda configurable en ejecución.]
#req("rf_polifonía", "F")[Polifonía][
  Ha de tener una cantidad de voces configurable en compilación.]
#req("rf_multi_dispositivos", "F")[Multiples dispositivos][
  Ha de poder ser instalado en al menos dos dispositivos empotrados distintos.]
#req("rf_añadir_dispositivos", "F")[Añadir dispositivos][
  Debe estar documentado cómo configurar el sintetizador para un nuevo dispositivo empotrado.]
#req("rf_configuración_periféricos", "F")[Configuración por periféricos][
  Ha de ser configurable en ejecución por periféricos electrónicos conectados a la placa.]
#req("rf_configuración_midi", "F")[Configuración por MIDI][
  Ha de ser configurable en ejecución por MIDI.]

#v(-0.4cm)

==== Requisitos no funcionales

#req("rnf_rendimiento", "NF")[Rendimiento][
  Ha de poder acabar de producir cada bloque de audio antes de que el siguiente se solicite con un margen del 10%, al
  ejecutarse configurado con salida de audio por USB, entrada de MIDI por USB e incluyendo el ecualizador en una placa
  STM32H723ZG.
]
#req("rnf_fiabilidad", "NF")[Fiabilidad][
  Ha de operar continuamente sin necesitar un reinicio.]
#req("rnf_calidad_de_audio", "NF")[Calidad de audio][
  Ha de producir audio libre de distorsiones perceptibles.]
#req("rnf_pruebas", "NF")[Pruebas][
  Ha de tener pruebas ejecutadas automáticamente durante el desarrollo, con resultados disponibles en público.
]
#req("rnf_manual", "NF")[Manual][
  Ha de tener un manual disponible online, que detalle tanto la instalación y el uso del sintetizador como el desarrollo
  del software (en particular, cómo añadir soporte a un nuevo dispositivo).
]
