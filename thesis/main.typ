#import "@preview/deal-us-tfc-template:1.2.1": *

#show: TFC.with(
  titulo: par(
    justify: false,
    "Sparklet: Síntesis musical en múltiples dispositivos empotrados",
  ), // cspell:disable-line
  alumno: "Javier Ignacio Milá de la Roca Dos Santos",
  titulacion: // cspell:disable-line
  "Grado en Ingeniería Informática – Ingeniería del Software",
  director: [Alberto Jesús Molina Cantero],
  departamento: "Tecnología Electrónica",
  convocatoria: "Convocatoria de junio, curso 2025/26",
  dedicatoria: "Aquí la dedicatoria del trabajo",
  agradecimientos: [
    Quiero agradecer a Z por...

    También quiero agradecer a Y por...
  ],
  resumen: [
    Incluya aquí un resumen de los aspectos generales de su trabajo, en español
  ],
  palabras-clave: (
    "palabra clave 1",
    "palabra clave 2",
    "...",
    "palabra clave N",
  ),
  abstract: [
    This section should contain an English version of the Spanish abstract.
  ],
  keywords: (
    "keyword 1",
    "keyword 2",
    "...",
    "keyword N",
  ),
  font: "TeX Gyre Pagella",
  bibliografia: bibliography("/bibliografía.bib"),
)

#include "sections/01_Introducción.typ"
#include "sections/02_Metodología.typ"
#include "sections/03_Análisis.typ"
#include "sections/04_Implementación.typ"
#include "sections/05_Conclusiones.typ"
#include "sections/06_Anexo.typ"
