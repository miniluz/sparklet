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

#let calcular_costes(horas) = {
  let personal = sueldo_junior * (100 + seguridad_social) / 100 * horas
  let equipo = coste_equipo / (amortización_años * 12) * meses
  let electricidad = consumo_w * horas / 1000.0 * coste_electricidad_kwh
  let internet = coste_internet_mensual * meses

  let total_parcial = personal + equipo + electricidad + internet
  let reserva = total_parcial * reserva_porcentaje / 100.0
  let total = total_parcial + reserva

  (
    horas: horas,
    personal: personal,
    equipo: equipo,
    electricidad: electricidad,
    internet: internet,
    total_parcial: total_parcial,
    reserva: reserva,
    total: total,
  )
}

#let tabla_coste(costes, planificación, caption, label) = {
  import "/utils/table_format.typ": format_tables
  show: format_tables

  let pie
  if (planificación) {
    pie = (
      [Total parcial],
      [--],
      [$#(costes.total_parcial) "€"$],
      [Reserva (#reserva_porcentaje%)],
      [--],
      [$#(costes.reserva) "€"$],
      [Total],
      [--],
      [$#(costes.total) "€"$],
    )
  } else {
    pie = (
      [Total],
      [--],
      [$#(costes.total_parcial) "€"$],
    )
  }

  [
    #figure(
      table(
        columns: (auto, auto, auto),
        align: (center + horizon, center + horizon, right + horizon),

        table.header([Partida], [Cálculo], align(center)[Coste]),

        [Personal],
        [$#sueldo_junior "€/h" times #(100 + seguridad_social)% times #(costes.horas) "h"$],
        [$#(costes.personal) "€"$],

        [Equipo (amortizado)],
        [$#coste_equipo "€" div #(amortización_años * 12) "meses" times #meses "meses"$],
        [$#(costes.equipo) "€"$],

        [Electricidad],
        [$#consumo_w "W" times #(costes.horas) "h" times (1 "kW") / (1000 "W") times #coste_electricidad_kwh "€/kWh"$],
        [$#(costes.electricidad) "€"$],

        [Internet],
        [$#coste_internet_mensual "€/mes" times #meses "meses"$],
        [$#(costes.internet) "€"$],

        ..pie,
      ),
      caption: caption,
    )
    #label
  ]
}
