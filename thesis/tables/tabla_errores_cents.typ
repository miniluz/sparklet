#import "/utils/table_format.typ": format_tables
#show: format_tables

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    [Nota], [Referencia], [Frecuencia], [Error],
    [B0],
    [Cuerda grave de un bajo de 5 cuerdas],
    [$30.86 "Hz"$],
    [$41 "cents"$],

    [ E1 ], [ Cuerda grave de un bajo ], [ $41.2 "Hz"$ ], [ $30 "cents"$ ],
    [ E2 ], [ Cuerda grave de una guitarra ], [ $82.4 "Hz"$ ], [ $15 "cents"$ ],
    [ A3 ],
    [ Primera nota con error imperceptible ($< 6 "cents"$) #linebreak() Cuerda grave de una viola ],
    [ $220 "Hz"$ ],
    [ $5.7 "cents"$ ],

    [ C4 ], [ La nota central del piano ], [ $261.6 "Hz"$ ], [ $4.8 "cents"$ ],
  ),
  caption: "Errores en cents para algunas notas usando un incremento de 16 bits",
  placement: auto,
)<tabla_errores_cents>
