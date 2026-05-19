#import "/utils/table_format.typ": format_tables
#show: format_tables

#import "/utils/datos_sprints.typ": sprints;

#pagebreak()

#table(
  columns: (auto, auto),
  align: (center + horizon, left + horizon),

  table.header([Sprint], [Descripción del trabajo realizado]),

  ..for sprint in sprints {
    (
      [#(sprint.id)],
      [#(sprint.description)],
    )
  },
)
#figure(
  none,
  kind: table,
  caption: "Sprints del proyecto con su descripción detallada.",
)<tabla_sprints_descripciones>
