#import "/utils/table_format.typ": format_tables
#show: format_tables

#import "/utils/datos_sprints.typ": sprints;

#figure(
  [
    #set text(size: 10.5pt)
    #table(
      columns: (auto, auto, auto),
      align: (center + horizon, center + horizon, left + horizon),

      table.header([Sprint], [Fechas], [Objetivo]),

      ..for sprint in sprints {
        (
          [#(sprint.id)],
          [#(sprint.start_date) a #(sprint.end_date)],
          [#(sprint.objective)],
        )
      },
    )],
  caption: "Los sprints del proyecto, su objetivo principal y las fechas entre las que ocurre.",
  placement: auto,
)<tabla_sprints_objetivos>
