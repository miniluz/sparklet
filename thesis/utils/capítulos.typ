#import "@preview/droplet:0.3.1": dropcap

#set par(justify: true)

#let cita(texto, autor) = {
  align(right)[
    #set text(
      style: "italic",
    )

    #block(
      width: 90%,
      inset: 0pt,
    )[
      #texto

      #if autor != none [
        #autor
      ]
    ]
  ]

  v(6em)
}

#let resumen(texto) = {
  set text(
    style: "italic",
  )

  dropcap(
    height: 3,
    gap: 4pt,
    hanging-indent: 1em,
    overhang: 8pt,
    texto,
  )
}
