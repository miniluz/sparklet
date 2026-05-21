#import "/utils/table_format.typ": format_tables
#show: format_tables

#let sueldo_junior = 24.0
#let seguridad_social = 50.0
#let coste_equipo = 200.0
#let amortización_años = 6.0
#let consumo_w = 65.0
#let coste_electricidad_kwh = 0.2
#let coste_internet_mensual = 40.0
#let meses = 9.0
#let reserva_porcentaje = 10.0
#let beneficio_porcentaje = 10.0

#let calcular_costes(horas) = {
  let personal = sueldo_junior * (100 + seguridad_social) / 100 * horas
  let equipo = coste_equipo / (amortización_años * 12) * meses
  let electricidad = consumo_w * horas / 1000.0 * coste_electricidad_kwh
  let internet = coste_internet_mensual * meses

  let total_parcial = personal + equipo + electricidad + internet
  let reserva = total_parcial * reserva_porcentaje / 100.0
  let beneficio = (total_parcial + reserva) * beneficio_porcentaje / 100.0
  let total = total_parcial + reserva + beneficio

  (
    horas: horas,
    personal: personal,
    equipo: equipo,
    electricidad: electricidad,
    internet: internet,
    total_parcial: total_parcial,
    reserva: reserva,
    beneficio: beneficio,
    total: total,
  )
}

#let tabla_coste(costes, planificación, caption, label) = {
  import "/utils/table_format.typ": format_tables

  show: d => format_tables(d, extra_separators: (5, 8))

  import "@preview/zero:0.6.1": num, set-group, set-num
  set-num(decimal-separator: ",", digits: 2)
  set-group(
    size: 3,
    separator: sym.space.thin,
    threshold: 5,
  )

  let pie = if (planificación) {
    (
      [Total parcial],
      [$"Personal" + "Equipo" + "Electricidad" + "Internet"$],
      [$#num(costes.total_parcial) "€"$],
      [Reserva (#reserva_porcentaje%)],
      [$"Total parcial" times #(100 + reserva_porcentaje)%$],
      [$#num(costes.reserva) "€"$],
      [Beneficio (#beneficio_porcentaje%)],
      [$("Total parcial" + "Reserva") times #(100 + beneficio_porcentaje)%$],
      [$#num(costes.beneficio) "€"$],
      [Total],
      [$"Total parcial" + "Reserva" + "Beneficio"$],
      [$#num(costes.total) "€"$],
    )
  } else {
    (
      [Total],
      [$"Personal" + "Equipo" + "Electricidad" + "Internet"$],
      [$#num(costes.total_parcial) "€"$],
    )
  }

  [
    #figure(
      table(
        columns: (auto, auto, auto),
        align: (center + horizon, center + horizon, right + horizon),

        table.header([Partida], [Cálculo], align(center)[Coste]),

        [Personal],
        [$#num(sueldo_junior) "€/h" times #(100 + seguridad_social)% times #num(costes.horas, digits: 1) "h"$],
        [$#num(costes.personal) "€"$],

        [Equipo],
        [$#num(coste_equipo) "€" div #(amortización_años * 12) "meses" times #meses "meses"$],
        [$#num(costes.equipo) "€"$],

        [Electricidad],
        [$#consumo_w "W" times #num(costes.horas, digits: 1) "h" times (1 "kW") / (1000 "W") times #num(coste_electricidad_kwh) "€/kWh"$],
        [$#num(costes.electricidad) "€"$],

        [Internet],
        [$#num(coste_internet_mensual) "€/mes" times #meses "meses"$],
        [$#num(costes.internet) "€"$],

        ..pie,
      ),
      caption: caption,
    )
    #label
  ]
}
