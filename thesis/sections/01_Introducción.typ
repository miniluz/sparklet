#import "/utils/tfc_template.typ": *
#import "/utils/capítulos.typ": cita, resumen

= Introducción

#cita[
  "Cuando el misterio es demasiado impresionante, es imposible desobedecer."
][Antoine de Saint-Exupéry (El principito)]

#resumen[
  Este capítulo aporta el contexto necesario para entender el proyecto. En la @sec_motivación se introducen las
  circunstancias que motivan su ejecución y en la @sec_objetivos se establecen los objetivos de alto nivel.
]

#pagebreak()

== Motivación
<sec_motivación>

La aplicación de la ingeniería informática a la música ha abierto nuevas posibilidades creativas, mejorado la
experiencia de los músicos y, sobre todo, democratizado el arte. El famoso Minimoog Model D (véase la @fig_minimoog),
uno de los primeros sintetizadores portátiles y ampliamente usados en conciertos, salió en 1970 @ref_web_moog_history.
Su precio en 1974 era de 1595 \$ @ref_web_moog_price, equivalente a unos 9266 € actuales, tomando en cuenta la
inflación. Hoy en día, es posible e incluso fácil instalar una estación de audio digital (DAW) de código abierto, como
Ardour @ref_web_ardour, un sintetizador gratuito, como Helm @ref_web_helm, y componer una canción usando exclusivamente
software libre.

A pesar de las facilidades que ofrece trabajar con software, el estilo de síntesis modular que seguía Robert Moog sigue
en uso. La estandarización ha permitido combinar módulos de distintas compañías para formar un sintetizador propio
@ref_web_eurorack (véase la @fig_modular_synth), de forma similar a la combinación de pedales que hacen los guitarristas
para conseguir el tono que buscan. El espíritu artesanal y experimental de la comunidad ha llevado incluso a la creación
de kits _do it yourself_ (DIY), en los que el cliente recibe los componentes y un manual de ensamblaje, a menudo también
con fines didácticos @ref_web_diy_kits.

Quizá el único ámbito que aún resiste el movimiento DIY es el de los sintetizadores. Sean analógicos o digitales, son
mucho más complejos que otros módulos como mezcladores y ecualizadores. Aún no existe una solución accesible, buena y
barata para crear un sintetizador por tu cuenta, como se explora en la @sec_estado_del_arte. Además, un desarrollador
que lo investigue se encontrará con una falta de literatura sobre los algoritmos concretos usados para las partes más
complejas de crear uno. Este trabajo intenta remediar ambos problemas.

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
<sec_objetivos>

Los objetivos de alto nivel del trabajo son los siguientes:

#let objetivos_proyecto = [
  - Crear un sintetizador musical en un sistema empotrado que resulte útil para músicos con interés en la tecnología.
    - Configurable para soportar diversos dispositivos y componentes.
    - Con manuales de instalación, uso, desarrollo, y soporte de nuevos dispositivo.
  - Presentar una arquitectura viable para el desarrollo de sintetizadores similares en microcontroladores.
  - Elaborar un algoritmo eficiente para el envolvente ADSR en aritmética de coma fija que permita interpolar su
    configuración.
  - Elaborar una estrategia eficiente para el robo de voces que sea intuitivo y no genere artefactos bajo condiciones
    extremas.
]

#objetivos_proyecto

Y los objetivos de aprendizaje son los siguientes:

#let objetivos_aprendizaje = [
  - Aprender sobre el desarrollo empotrado.
    - Para soportar múltiples sistemas empotrados con el mismo código.
    - Conseguir una buena experiencia de desarrollo.
  - Aprender del procesamiento de señales digitales.
    - En sistemas con limitaciones de velocidad de cálculo (CPU).
    - En sistemas que no tienen disponible coma flotante.
]

#objetivos_aprendizaje
