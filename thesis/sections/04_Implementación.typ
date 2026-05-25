#import "/utils/tfc_template.typ": *
#import "/utils/capítulos.typ": cita, resumen
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

= Implementación
<sec_implementación>

#cita[
  "Es una ocupación muy bonita y por ser bonita es verdaderamente útil."
][Antoine de Saint-Exupéry (El principito)]

#resumen[
  En este capítulo se explica la implementación final de Sparklet. En la sección @sec_diseño se especifica la
  arquitectura del sistema. Entre la @sec_osciladores y la @sec_motor_de_síntesis se explica el procesamiento de audio
  del sintetizador. En la sección @sec_configuración se documenta cómo se logró que fuese configurable en compilación y
  ejecución. Entre la @sec_ejecutor y la @sec_operaciones_dsp se especifica la parte del sistema específica al hardware
  usado. Finalmente, en la @sec_manual se comenta la implementación de los manuales del sistema.
]

#pagebreak()

#include "04_implementación/04_01_Diseño.typ"

#include "04_implementación/04_02_Oscilador.typ"

#include "04_implementación/04_03_ADSR.typ"

#include "04_implementación/04_04_Banco_de_voces.typ"

#include "04_implementación/04_05_Generador.typ"

#include "04_implementación/04_06_Ecualización.typ"

#include "04_implementación/04_07_Motor_de_síntesis.typ"

#include "04_implementación/04_08_Configuración.typ"

#include "04_implementación/04_09_Ejecutor.typ"

#include "04_implementación/04_10_MIDI.typ"

#include "04_implementación/04_11_USB.typ"

#include "04_implementación/04_12_Operaciones_DSP.typ"

#include "04_implementación/04_13_Manual.typ"
