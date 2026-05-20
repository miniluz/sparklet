#import "@preview/deal-us-tfc-template:1.2.1": *

= Introducción

#todo[En todos los títulos voy a añadir un resumen de la sección y quizá una cita relevante.]

#pagebreak()

== Motivación

#todo[Aquí falta añadir referencias.]

La aplicación de la ingeniería informática a la música ha abierto nuevas posibilidades creativas, mejorado la
experiencia de los músicos y, sobre todo, democratizado el arte. El famoso Minimoog Model D (véase la @fig_minimoog),
uno de los primeros sintetizadores portátiles y ampliamente usados en conciertos, salió en 1970. Su precio era de 1200
\$, equivalente a casi 8900 € considerando la inflación. Hoy en día, es posible e incluso fácil instalar una estación de
audio digital (DAW) de código abierto, como Ardour, un sintetizador gratuito, como Helm, y componer una canción usando
exclusivamente software libre.

A pesar de las facilidades que ofrece trabajar con software, el estilo de síntesis modular que seguía Robert Moog sigue
en uso. La estandarización ha permitido combinar módulos de distintas compañías para formar un sintetizador propio
(véase la @fig_modular_synth), de forma similar a la combinación de pedales que hacen los guitarristas para conseguir el
tono que buscan. El espíritu artesanal y experimental de la comunidad ha llevado incluso a la creación de kits _do it
yourself_ (DIY), en los que el cliente recibe los componentes y un manual de ensamblaje, a menudo también con fines
didácticos.

Quizá el único ámbito que aún resiste el movimiento DIY es el de los sintetizadores. Sean analógicos o digitales, son
mucho más complejos que otros módulos como mezcladores y ecualizadores. Aún no existe una solución accesible, buena y
barata para crear un sintetizador por tu cuenta. Además, un desarrollador que lo investigue se encontrará con una falta
de literatura sobre los algoritmos concretos usados para las partes más complejas de crear uno. Este trabajo intenta
remediar ambos problemas.

#figure(
  grid(
    columns: (1.47fr, 1fr),
    align: (x, y) => if (y == 0) { center + horizon } else { center + top },
    inset: (x: 0.5em),
    row-gutter: 4pt,
    column-gutter: 1em,

    [
      #image("/figures/minimoog_model_d.jpg")
    ],
    [
      #image("/figures/modular_synthesizer.jpg")

    ],

    [
      #figure(
        none,
        caption: [
          El Minimoog Model D. Imagen de Andrew Russeth @ref_img_minimoog, usada bajo licencia #box[CC BY-SA 2.0]
          @ref_img_cc2
        ],
      )<fig_minimoog>
    ],
    [
      #figure(
        none,
        caption: [
          Un sintetizador modular. Imagen de Daniel Larsen @ref_img_modular, usada bajo licencia #box[CC BY-SA 2.0]
          @ref_img_cc2
        ],
      )<fig_modular_synth>
    ],
  ),
  numbering: none,
  placement: bottom,
)

== Objetivos

Los objetivos del software del proyecto son los siguientes:

- Crear un sintetizador musical en un sistema empotrado que resulte útil para músicos con un interés tecnológico.
  - Configurable para soportar diversos dispositivos y componentes.
  - Con manuales de instalación, uso, desarrollo, y soporte de nuevos dispositivo.
- Presentar una arquitectura viable para el desarrollo de sintetizadores en microcontroladores.
- Elaborar un algoritmo completo y eficiente para la gestión del robo de voces.

Y los objetivos de aprendizaje son los siguientes:

- Aprender sobre el desarrollo empotrado.
  - Para soportar múltiples sistemas empotrados con el mismo código.
  - Conseguir una buena experiencia de desarrollo.
- Aprender del procesamiento de señales digitales.
  - En sistemas con limitaciones de velocidad de cálculo (CPU).
  - En sistemas que no tienen disponible coma flotante.
