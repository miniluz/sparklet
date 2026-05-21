#import "/utils/datos_sprints.typ": horas_estimadas, horas_reales, sprints;

#import "@preview/zero:0.6.1": num, set-group, set-num

#set-num(decimal-separator: ",", digits: 1)
#set-group(
  size: 3,
  separator: sym.space.thin,
  threshold: 5,
)

#import "/utils/table_format.typ": format_tables

#let table_length = sprints.len() + 2
#show: d => format_tables(d, extra_separators: (table_length - 1,))

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (
      center + horizon,
      center + horizon,
      right + horizon,
      right + horizon,
    ),

    table.header([Sprint], [Fechas], [Horas estimadas], [Horas reales]),

    ..for sprint in sprints {
      (
        [#(sprint.id)],
        [#(sprint.start_date) a #(sprint.end_date)],
        [#(sprint.hours_goal)],
        [#num(sprint.hours_actual)],
      )
    },

    [Total], [--], [#horas_estimadas], [#num(horas_reales)],
  ),
  caption: "Horas estimadas y reales dedicadas a cada sprint del proyecto.",
)<tabla_sprints_tiempos>
