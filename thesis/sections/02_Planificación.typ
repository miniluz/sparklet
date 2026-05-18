#import "@preview/deal-us-tfc-template:1.2.1": *

#show table.cell.where(y: 0): set text(weight: "semibold")

#let frame(stroke) = (x, y) => (
  left: if x > 0 { 0.6pt } else { stroke },
  right: stroke,
  top: if y < 2 { stroke } else { 0pt },
  bottom: stroke,
)

#set table(
  fill: (_, y) => if calc.odd(y) { rgb("eeeeee") },
  stroke: frame(1pt + rgb("21222C")),
)


= Planificación
<sec_planificación>

El desarrollo del proyecto se dividió en fases. Cada fase implementó cierta parte de la funcionalidad y fue asignada a
un periodo correspondiente con un o más meses. Las fases son las siguientes:


#figure(
  table(
    columns: (auto, 1fr, 4fr, auto, auto),
    align: (left, left, left, left, left),
    [Fase], [Nombre], [Descripción], [Horas], [Mes(es)],

    [1],
    [Prueba de Rust],
    [
      + Evaluar la viabilidad de usar Rust para desarrollar el proyecto.
      + Hacer proyectos de ejemplo en Rust que pudiesen compilar al chip y validen la posibilidad de implementar
        instrucciones DSP, gestionar I/O por los pines, y ejecutar pruebas.
      + Investigar sobre el desarrollo empotrado en Rust y en general.
    ],
    [30h],
    [Septiembre],

    [2],
    [Lectura MIDI],
    [
      + Leer MIDI en un puerto DIN con un pin.
      + Programar el banco de voces.
      + Investigar cómo organizar la arquitectura de una aplicación empotrada.
    ],
    [20h],
    [Octubre],

    [3],
    [Sintetizador],
    [
      + Programar el envolvente ADSR.
      + Programar el oscilador de tabla de onda.
      + Conectar el ADSR, el oscilador y el banco de voces.
    ],
    [20h],
    [Noviembre],

    [4],
    [Configuración],
    [
      + Hacer un componente capaz de leer hardware para hacer configuración.
      + Programar el envolvente ADSR.
      + Programar el oscilador de tabla de onda.
      + Conectar el ADSR, el oscilador y el banco de voces.
    ],
    [20h],
    [Noviembre],
  ),
  caption: "Errores en cents para algunas notas usando un incremento de 16 bits",
  placement: auto,
)<tabla_fases>
