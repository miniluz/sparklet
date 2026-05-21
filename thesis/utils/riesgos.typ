#import "./table_format.typ": format_tables

#let zero-pad(n, width) = {
  let s = str(n)
  while s.len() < width { s = "0" + s }
  s
}

#let list_from_array(items) = {
  list(..items.map(item => [#item]))
}

#let riesgo(nombre, descripción, impacto, probabilidad, mitigación) = context {
  show: d => format_tables(d, extra_separators: (4,), fill_evens: true)

  let id = zero-pad(counter("riesgo").get().at(0) + 1, 3)
  table(
    columns: (1fr, 3fr),
    inset: 6pt,
    table.header([RK#id], [#nombre]),
    [Probabilidad], [#probabilidad],
    [Impacto], [#impacto],
    [Descripción], [#descripción],
    [Mitigación],
    {
      if mitigación.len() > 0 { list_from_array(mitigación) } else {
        "Ninguna."
      }
    },
  )
  counter("riesgo").step()
}
