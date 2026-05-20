#import "/utils/table_format.typ": format_tables
#show: format_tables

#import "/utils/datos_sprints.typ": milestones;

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, center + horizon),

    table.header([Nombre del hito], [Fecha estimada], [Fecha real]),

    ..for milestone in milestones {
      (
        [#(milestone.name)],
        [#(milestone.date)],
        [#(milestone.date)],
      )
    },
  ),
  caption: "Hitos del proyecto con su fecha estimada y la fecha en la que se consiguió.",
)<tabla_hitos>
