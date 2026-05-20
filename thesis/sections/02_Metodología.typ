#import "@preview/deal-us-tfc-template:1.2.1": *
#import "/utils/datos_sprints.typ": horas_estimadas, horas_reales
#import "/utils/riesgos.typ": riesgo
#import "/tables/tabla_costes_estimados.typ": *


= Metodología
<sec_metodología>

#pagebreak()

== Metodología del desarrollo
<sec_metodología_del_desarrollo>

El proyecto comenzó con un análisis de los competidores para hacer una recogida de las funcionalidades que Sparklet
podría tener. Las funcionalidades elegidas y el resto de requisitos del proyecto fueron divididos en _sprints_,
inspirados por la metodología ágil @ref_manifiesto_ágil, como se explicará en detalle en la siguiente sección.

Como política de ramas, los commits se hacen directamente sobre `main`. Al ser un proyecto en el que sólo trabaja un
desarrollador, no se considera necesario usar otras ramas. Usando _workflows_ de GitHub Actions se valida cada _push_
que el código compila, que todas las pruebas pasan, que el formato del código es correcto, y que no hay errores
ortográficos en el documento.

En cuanto a la política de _commits_, se realizan commits unitarios, es decir, cada commit corresponde al paso de una
versión funcional del código a otra. El mensaje del commit es una descripción corta de los cambios realizados en él.
Nuevamente, al ser un proyecto con un sólo desarrollador, no se considera necesario usar una política más compleja.

== Estrategia de pruebas
<sec_estrategia_de_pruebas>

Las pruebas se realizan de manera paralela al desarrollo, con las funcionalidades siendo probadas mientras se
implementan. El proyecto usa tres tipos de pruebas:

+ Los generadores de código imprimen a `stderr` comprobaciones de la validez del código que generan, que son revisadas
  manualmente al ejecutarlos. Por ejemplo, para validar la onda de seno, se muestran el nivel de algunas muestras junto
  a sus valores esperados, como que el nivel de la primera muestra es 0. Estas son revisadas manualmente al ejecutar la
  tabla.

+ La lógica de los módulos del proyecto se somete a pruebas unitarias y ocasionalmente de integración, dependiendo de la
  necesidad según el criterio del desarrollador. Se intenta generar la mínima cantidad de pruebas que garanticen la
  funcionalidad del sistema. Al momento de probar la salida de audio y otros componentes similares, se prueban las
  propiedades del sistema en lugar de la salida en sí misma. Por ejemplo, para validar el oscilador, se estima la
  frecuencia con cruces por cero y se compara con la esperada. Estas son ejecutadas automáticamente antes de hacer un
  commit, además de en un workflow de GitHub Action cada vez que se hace push.

+ Desde que el sintetizador ha sido capaz de leer MIDI y transmitir audio por USB, ha sido ejecutado en la placa de
  desarrollo manualmente para evitar regresiones. Se hace de forma regular durante el desarrollo, pero además se realiza
  una prueba rigurosa de toda su funcionalidad al final de cada fase antes de su cierre.

== Planificación
<sec_planificación>

Como se mencionó en la sección anterior, se ha estructurado en sprints. Sin embargo, ha sido adaptado a las necesidades
del proyecto: por ejemplo, hay un Sprint 0 para el planteamiento del proyecto, un Sprint 1 para su planificación, y un
Sprint 2 para aprender sobre el desarrollo empotrado y evaluar la viabilidad del ecosistema de desarrollo para el
proyecto. Cada sprint corresponde a dos semanas, estimando dos horas de trabajo por día, ignorando las vacaciones.
Además, se planificaron hitos, representando momentos en los que se consigue un paso en el proyecto.

Los sprints, su objetivo principal y las fechas en las que está se puede ver en la @tabla_sprints_objetivos. Se pueden
ver los hitos en la @tabla_hitos. La descripción detallada del trabajo realizado en cada sprint se puede ver en la
@tabla_sprints_descripciones. El tiempo de trabajo estimado y dedicado a cada sprint se puede ver en la
@tabla_sprints_tiempos. Finalmente, se representan los sprints como diagramas de Gantt en la @fig_gantt_antes_navidad y
@fig_gantt_después_navidad.

=== Desviaciones
<sec_desviaciones>

En general, ha habido una tendencia a no llegar a las horas estimadas en las etapas medias del proyecto y a sobrepasar
las horas estimadas en la etapa final del proyecto. Esto es debido a subestimar el esfuerzo de realizar la memoria. Se
comenta en más profundidad en la @sec_lecciones_aprendidas.

#include "/tables/tabla_sprints_objetivos.typ"
#pagebreak()
#include "/tables/tabla_hitos.typ"
#include "/tables/tabla_sprints_tiempos.typ"
#pagebreak()
#include "/tables/tabla_sprints_descripciones.typ"
#pagebreak()

#include "/figures/diagrama_gantt.typ"

#pagebreak()

== Presupuesto

#let coste_estimado = calcular_costes(horas_estimadas)
#let coste_real = calcular_costes(horas_reales)

#let total_estimado = coste_estimado.total
#let total_real = coste_real.total_parcial

#[

  #import "@preview/zero:0.6.1": num, set-group, set-num
  #set-num(decimal-separator: ",", digits: 2)
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

  Para el cálculo del presupuesto y el coste, se toman en cuenta los siguientes aspectos:

  + Personal: se establece un sueldo bruto de $#sueldo_junior "€/h"$, tomando como referencia el salario medio de un
    desarrollador junior en España, costando un #seguridad_social% más tomando en cuenta la seguridad social y otros
    gastos.

  + Equipo: figuran los $110 "€"$ de coste del ordenador, los $60 "€"$ de la placa de desarrollo (STM32H723ZG), los
    $10 "€"$ del segundo microcontrolador (STM32F401RC), y los 20 € del paquete de componentes electrónicos usados,
    dando un total de $200 "€"$. Todo est equipo se amortiza a #amortización_años años.

  + Electricidad: Se asume un consumo de $#consumo_w "W"$ constante durante el desarrollo con un coste de
    $#coste_electricidad_kwh "€/kWh"$.

  + Internet: se asume un coste de #coste_internet_mensual € por mes durante el desarrollo.

  + Reserva: se establece una reserva para riesgos del 10% sobre el total de los costes anteriores.

  + Beneficio: se establece un margen de beneficio del 15% sobre el total de costes más la reserva.

  Con todo ello, el presupuesto del proyecto asciende a $#total_estimado "€"$, desglosado como se puede ver en la
  @tabla_coste_estimado. Los costes incurridos durante la ejecución son de $#total_real "€"$, desglosados como se puede
  ver en la @tabla_coste_real. El aumento en el coste se debe a que se han dedicado más horas de las estimadas. Sin
  embargo, gracias a la reserva se ha podido cubrir dicho aumento, obteniendo un superávit de
  $#(total_estimado - total_real) "€"$, un $#((total_estimado - total_real) / total_estimado * 100)%$ del presupuesto
  total.
]

#figure(
  grid(
    columns: 1,
    inset: 0.5em,
    [
      #tabla_coste(
        coste_estimado,
        true,
        [Desglose del presupuesto del proyecto.],
        <tabla_coste_estimado>,
      )
    ],
    [
      #tabla_coste(
        coste_real,
        false,
        [Desglose del coste del proyecto.],
        <tabla_coste_real>,
      )
    ],
  ),
  numbering: none,
  placement: auto,
)

#pagebreak()

== Análisis de riesgos

#todo[Citar la técnica usada.]

Se ha realizado un análisis cuantitativo de los riegos asociados al proyecto usando una matriz de probabilidad e
impacto. Se estimó su probabilidad de ocurrir como baja (1 punto), media (2 puntos) o alta (3 puntos), y del mismo modo
su impacto. Se puntuaron según el producto de ambos valores. A continuación se muestran las que consiguieron una
puntuación de al menos 4, junto a las estrategias usados para mitigarlos:

#riesgo(
  [Imposibilidad práctica de utilizar Rust en el entorno embebido],
  [
    El proyecto depende en gran medida del ecosistema de Rust y de librerías específicas para desarrollo embebido, por
    lo que problemas de compatibilidad, compilación o soporte hardware podrían dificultar la implementación prevista.
  ],
  [Alto.],
  [Media.],
  (
    [Validación temprana del uso de Rust.],
    [Investigación previa de librerías para DSP, USB y lectura MIDI.],
  ),
)

#riesgo(
  [Rendimiento insuficiente en microcontroladores de bajo coste],
  [
    El objetivo de soportar dispositivos muy económicos y sin soporte de coma flotante puede provocar limitaciones de
    rendimiento o memoria al ejecutar síntesis polifónica, interpolación de ADSR y procesamiento en tiempo real
    simultáneamente.
  ],
  [Alto.],
  [Media.],
  (
    // Mitigaciones
    [Uso de CMSIS-DSP para optimizar las operaciones de procesamiento.],
    [Posibilidad de reducir la polifonía o ciertas funcionalidades para adaptarse a las capacidades del dispositivo.],
  ),
)

#riesgo(
  [Dificultad para mantener compatibilidad entre múltiples plataformas],
  [
    El soporte para distintos microcontroladores, componentes y configuraciones hardware puede aumentar
    significativamente la complejidad del código y dificultar su mantenimiento y depuración.
  ],
  [Medio.],
  [Alta.],
  (
    [Arquitectura diseñada para permitir este uso.],
    [Código genérico que funciona sin importar el dispositivo.],
    [Usar archivos que únicamente definen el hardware para el dispositivo para simplificar su cambio.],
  ),
)

#riesgo(
  [Falta de validación práctica con usuarios reales],
  [
    Aunque el proyecto busca resultar útil para músicos interesados en la tecnología, la ausencia de pruebas extensivas
    con usuarios puede provocar decisiones de diseño poco intuitivas o flujos de trabajo incómodos.
  ],
  [Medio.],
  [Media.],
  (
    // Mitigaciones
    [El autor del trabajo es un músico experimentando en el área.],
    [Realización de pruebas manuales durante el desarrollo.],
    [Priorización de funcionalidades comunes en sintetizadores existentes.],
    [Documentación orientada a usuarios no expertos en programación.],
  ),
)
