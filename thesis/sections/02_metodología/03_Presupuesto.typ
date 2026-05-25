
#import "/utils/tfc_template.typ": *
#import "/utils/datos_sprints.typ": horas_estimadas, horas_reales
#import "/tables/tabla_costes_estimados.typ": *

== Presupuesto
<sec_presupuesto>

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

  + Personal: se usa un sueldo bruto de $#sueldo_junior "€/h"$, en base al salario medio de un desarrollador junior en
    España, más un #seguridad_social% por la seguridad social y otros gastos.
  + Equipo: figuran los $110 "€"$ del ordenador, los $60 "€"$ de la placa de desarrollo, los $10 "€"$ del segundo
    microcontrolador, y los 20 € del paquete de componentes electrónicos usados, dando un total de $200 "€"$ amortizado
    a #amortización_años años.
  + Electricidad: Se asume un consumo de $#consumo_w "W"$ constante durante el desarrollo con un coste de
    $#coste_electricidad_kwh "€/kWh"$.
  + Internet: se asume un coste de #coste_internet_mensual € por mes durante el desarrollo.

  Además, se establece una reserva estratégica del #reserva_porcentaje% sobre el total de los costes anteriores, y un
  margen de beneficio del #beneficio_porcentaje% sobre el total de costes más la reserva.

  Con todo ello, el presupuesto del proyecto asciende a $#total_estimado "€"$, desglosado como se puede ver en la
  @tabla_coste_estimado. Los costes reales incurridos son de $#total_real "€"$, como se puede ver en la
  @tabla_coste_real. El aumento en el total parcial es debido a que se han dedicado más horas de las estimadas. Sin
  embargo, la reserva ha bastado para cubrirlo, resultando en un superávit de $#(total_estimado - total_real) "€"$, un
  $#((total_estimado - total_real) / total_estimado * 100)%$ del presupuesto total.
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
  placement: bottom,
)
