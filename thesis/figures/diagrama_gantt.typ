#import "@preview/timeliney:0.4.0"
#import "/utils/datos_sprints.typ": milestones as project-milestones, sprints

#let parse-date(s) = {
  let parts = s.split("-")
  datetime(
    year: int(parts.at(0)),
    month: int(parts.at(1)),
    day: int(parts.at(2)),
  )
}

#let days-between(a, b) = int((b - a).hours() / 24)

#let month-names = (
  "En",
  "Feb",
  "Mar",
  "Abr",
  "May",
  "Jun",
  "Jul",
  "Ago",
  "Sep",
  "Oct",
  "Nov",
  "Dic",
)

#let build-month-groups(t-start, t-end) = {
  let total = days-between(t-start, t-end)
  let groups = ()
  let current-month = t-start.month()
  let current-year = t-start.year()
  let count = 0

  for offset in range(total + 1) {
    let d = t-start + duration(days: offset)
    if d.month() == current-month and d.year() == current-year {
      count += 1
    } else {
      groups.push((month-names.at(current-month - 1), count))
      current-month = d.month()
      current-year = d.year()
      count = 1
    }
  }
  groups.push((month-names.at(current-month - 1), count))
  groups
}


#let gantt-figure(sprint-slice, t-start, t-end, caption-text) = {
  set text(fill: rgb("#4f0319"))

  let month-groups = build-month-groups(t-start, t-end)
  let span = days-between(t-start, t-end)

  timeliney.timeline(
    spacing: 4pt,
    show-grid: true,
    cell-line-style: (stroke: 0.9pt + rgb("#4f0319")),
    grid-style: (stroke: 0.25pt + luma(66.67%)),
    line-style: (
      stroke: stroke(paint: rgb("#e53935"), thickness: 10pt, cap: "butt"),
    ),
    milestone-line-style: (
      stroke: stroke(paint: rgb("#4f0319"), thickness: 1.5pt, dash: "dashed"),
    ),
    {
      import timeliney: *

      headerline(
        ..month-groups.map(g => group((
          text(weight: "semibold", g.at(0)),
          g.at(1),
        ))),
      )

      for s in sprint-slice {
        let from = days-between(t-start, parse-date(s.start_date))
        let to = days-between(t-start, parse-date(s.end_date))
        task(
          text(weight: "semibold")[Sprint #s.id],
          (from: from, to: to + 1),
        )
      }

      for m in project-milestones {
        let at = days-between(t-start, parse-date(m.date))
        if at >= 0 and at <= span {
          let name
          let parts = str(m.name).split(" ")
          if parts.len() > 1 {
            name = pad(x: 1em, align(center)[
              #(parts.slice(0, -1).join(" ")) #linebreak() #(parts.at(-1))
            ])
          } else {
            name = m.name
          }
          milestone(at: at + 1, name)
        }
      }
    },
  )
}

// ── Split ─────────────────────────────────────────────────────────────────────

#let sprints-a = sprints.filter(s => s.id <= 7)
#let sprints-b = sprints.filter(s => s.id > 7)

#let t-start-a = parse-date(sprints-a.first().start_date)
#let t-end-a = parse-date(sprints-a.last().end_date)

#let t-start-b = parse-date(sprints-b.first().start_date)
#let t-end-b = parse-date(sprints-b.last().end_date)

// ── Figures ───────────────────────────────────────────────────────────────────


#figure(
  grid(
    columns: 1,
    inset: 0.5em,
    [
      #figure(
        gantt-figure(sprints-a, t-start-a, t-end-a, ""),
        caption: "Diagrama de Gantt de los sprints anteriores a las vacaciones de invierno.",
      ) <fig_gantt_antes_navidad>
    ],
    [
      #figure(
        gantt-figure(sprints-b, t-start-b, t-end-b, ""),
        caption: "Diagrama de Gantt de los sprints posteriores a las vacaciones de invierno.",
      ) <fig_gantt_después_navidad>
    ],
  ),
  numbering: none,
  placement: auto,
)
