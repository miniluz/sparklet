#let format_tables(doc) = {
  show table.cell: set text(fill: rgb("#29010c"))

  show table.cell.where(x: 0): set text(
    weight: "semibold",
    fill: rgb("#4f0319"),
  )
  show table.cell.where(y: 0): set text(
    weight: "semibold",
    fill: rgb("#4f0319"),
  )

  let frame(stroke) = (x, y) => (
    left: if x > 0 { 0.6pt } else { stroke },
    right: stroke,
    top: if y < 2 { stroke } else { 0pt },
    bottom: stroke,
  )

  set table(
    fill: (_, y) => if calc.odd(y) { rgb("#fffbed") },
    stroke: frame(1pt + rgb("#4f0319")),
  )

  doc
}
