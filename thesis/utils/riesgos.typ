#let zero-pad(n, width) = {
  let s = str(n)
  while s.len() < width { s = "0" + s }
  s
}

#let list_from_array(items) = {
  list(..items.map(item => [#item]))
}

#let riesgo(nombre, descripción, impacto, probabilidad, mitigación) = context {
  let id = zero-pad(counter("riesgo").get().at(0) + 1, 3)
  let color = rgb("#ffe6e6")
  block(
    radius: 10pt,
    clip: true,
    stroke: color.darken(30%).saturate(20%) + 1.25pt,
    table(
      columns: (1fr, 3fr),
      inset: 6pt,
      stroke: color.darken(15%).saturate(10%) + 1pt,
      fill: color,
      table.header(
        table.cell(fill: color.darken(5%).saturate(5%))[*R-#id*],
        table.cell(fill: color.darken(5%).saturate(5%))[*#nombre*],
      ),
      [*Probabilidad*], [#probabilidad],
      [*Impacto*], [#impacto],
      [*Descripción*], [#descripción],
      [*Mitigación*],
      {
        if mitigación.len() > 0 { list_from_array(mitigación) } else {
          "Ninguna."
        }
      },
    ),
  )
  counter("riesgo").step()
}
