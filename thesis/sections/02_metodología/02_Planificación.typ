
#import "@preview/deal-us-tfc-template:1.2.1": *
#import "/utils/datos_sprints.typ": horas_estimadas, horas_reales
#import "/tables/tabla_costes_estimados.typ": *

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
