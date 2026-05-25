#import "/utils/table_format.typ": format_tables
#show: format_tables

#import "@preview/zero:0.6.1": num, set-group, set-num
#set-num(decimal-separator: ",", digits: 1)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    [Nota], [Referencia], [Frecuencia], [Error],
    [B0],
    [Cuerda grave de un bajo de 5 cuerdas],
    [$#num(30.86) "Hz"$],
    [$41 "cents"$],

    [ E1 ],
    [ Cuerda grave de un bajo ],
    [ $#num(41.2) "Hz"$ ],
    [ $30 "cents"$ ],

    [ E2 ],
    [ Cuerda grave de una guitarra ],
    [ $#num(82.4) "Hz"$ ],
    [ $15 "cents"$ ],

    [ A3 ],
    [ Primera nota con error imperceptible ($< 6 "cents"$) #linebreak() Cuerda grave de una viola ],
    [ $220 "Hz"$ ],
    [ $#num(5.7) "cents"$ ],

    [ C4 ],
    [ La nota central del piano ],
    [ $#num(261.6) "Hz"$ ],
    [ $#num(4.8) "cents"$ ],
  ),
  caption: "Errores en cents para algunas notas usando un incremento de 16 bits.",
  placement: bottom,
)<tabla_errores_cents>
