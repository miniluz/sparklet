#import "/utils/tfc_template.typ": *
#import "/utils/table_format.typ": format_tables

#show: d => format_tables(d, extra_separators: (3,), fill_evens: true)

#show table.cell: c => pad(x: 2pt, y: 1pt, c)

== Estado del arte
<sec_estado_del_arte>

En esta sección, se analiza el estado del arte. Primero se comparan los sintetizadores que existen actualmente, tanto
abiertos como privativos, para identificar un hueco en el mercado. A continuación, se analiza el estado del ámbito
académico respecto a los algoritmos que usan los sintetizadores.

=== Sintetizadores

Primero, se analizan los sintetizadores de software libre o gratuitos. Aunque hay muchos, uno de los mas usados y
completos es Helm, un sintetizador aditivo. Helm @ref_web_helm se toma como referencia para saber qué funcionalidades
resultan útiles en un sintetizador, aunque su implementación no se puede usar como referencia al depender de operaciones
de coma flotante. Sin embargo, no son competencia directa, pues se está creando un producto hardware.

La competencia más directa son los sintetizadores de hardware. Se empieza por los privativos. Algunos de los generadores
de onda analógicos más baratos incluyen el Behringer 921B (40 €) o Behringer 110 (50 €), pero no pueden tocar más de una
nota a la vez. El Behringer Brains (90€) es una alternativa digital, también monofónica. Si se busca un generador
polifónico digital, una de las opciones más baratas es el OXI Instruments Coral, a la venta por unos 380 €.

En cuanto a sintetizadores hardware libres, la lista diy-synths @ref_web_diy_synths provee una lista curada de muchos
proyectos similares de calidad alta. Es un punto de referencia en la comunidad. A continuación se analizan todos:

#box(table(
  columns: (auto, 1fr),

  table.header([], [Sintetizadores que no son para teclado]),

  [Descripción],
  [
    Arpegiadores MIDI, unidades para efectos, sintetizadores de tambores, sintetizadores que no son controlables por
    MIDI o un voltaje de control, etc.
  ],

  [Diferenciación],
  [
    Sparklet es un sintetizador para teclado. No son el mismo tipo de sintetizador
  ],

  [Proyectos],
  [
    ArduTouch, Arpie, Coron DS7, DrumKid, Echo Rocket, Faderbank 16n, Fasma Festival, Groundbot, LMN-3, Le Strum,
    Lunchbeat, MIDIbox, MIDIvampire II, Matrix sequencer, N32B, Nano minipops, Nyblcore, Op-Synth, OpenDeck, Ottopot,
    PicoStepSeq, PicoTracker, Pikocore, Polaron, Poly555, Protean, Quantum DJ, Real SID shield, SC1000, Spires, Teensy
    Audio FX, Teensy Beats Shield, Totoro, WTPA2, Wee Noise Maker, Wirehead Freaq FM, Yowler, zeptocore.
  ],
))

#box(table(
  columns: (auto, 1fr),

  table.header([], [Sintetizadores experimentales y poco convencionales]),

  [Descripción],
  [
    Proyectos experimentales, por ejemplo en los que el sonido del sintetizador se controla con luz usando fotodiodos.
  ],

  [Diferenciación],
  [
    Sparklet es un sintetizador orientado a la interpretación de un músico con un teclado. Estos proyectos están
    orientados a un nicho que disfruta de explorar sonidos, generalmente ambientales.
  ],

  [Proyectos],
  [
    Beam Catcher, Hidden Sound Explorer, Hypjolin, Keep, Mega MIDI, Mozard, Multi, NSynth Super, Noise Toaster,
    Overcycler, PreenFM 2.
  ],
))

#box(table(
  columns: (auto, 1fr),

  table.header([], [Sintetizadores no aptos para usuarios no técnicos]),

  [Descripción],
  [
    Sintetizadores cuyo ensamblado se dificulta por falta de documentación clara orientada a usuarios poco
    experimentados, por ejemplo únicamente proveyendo esquemáticas del circuito electrónico.
  ],

  [Diferenciación],
  [
    Sparklet incluye manuales detallados para su instalación y uso, facilitando su instalación por usuarios menos
    técnicos.
  ],

  [Proyectos],
  [
    ATTiny-Punk-Console, Lil' mono, Meeblip, Mushsynth-8.
  ],
))

#box(table(
  columns: (auto, 1fr),

  table.header([], [Sintetizadores con un límite de 4 voces o menos]),

  [Descripción],
  [
    Sintetizadores que tienen un límite de polifonía de 4 o menos. Es decir, que pueden tocar como máximo 4 notas a la
    vez.
  ],

  [Diferenciación],
  [
    Sparklet está orientado a la interpretación de un músico con un teclado usando ambas manos. El límite de polifonía
    que ofrecen estos proyectos es insuficiente para este propósito.
  ],

  [Proyectos],
  [
    Aciduino, Ambika, Anushuri, D-D_Teensy, Flounder, Hog, Kastle, miniMO, Mixtape Alpha, NTH synth, Paper Bits, Polykit
    X1, Roundabout, S54 Liv's Synth, Sigma-6, Shruthi, Totoro, Wirehead Mutant, YM2149 Synth, ZeKit, x0xb0x.
  ],
))

#box(table(
  columns: (auto, 1fr),

  table.header([], [Sintetizadores con precio superior a 100€]),

  [Descripción],
  [
    Sintetizadores con un precio de ensamblaje superior a 100€. Suelen ser muy completos, y a menudo incluyen pantallas
    y memoria para poder guardar parches, entre otras funcionalidades.
  ],

  [Diferenciación],
  [
    Sparklet se puede ejecutar en un STM32F401RC sin ningún componente adicional con funcionalidad completa, por lo que
    puede ser ensamblado por tan solo el precio de este chip, que el autor consiguió por 12 €. En caso de que el usuario
    no pueda adquirir ese microcontrolador, es fácil adaptarlo para que soporte cualquier dispositivo de la familia
    STM32, incluso configurando su funcionalidad para adaptarse a la potencia del microcontrolador.
  ],

  [Proyectos],
  [
    Bread Modular, KELPIE, MiniDexed, Norns Shield, OTTO, Plinky, Portable synth, Sound Lab Mini-Synth (y el Mk II),
    Zynthian.

  ],
))

En conclusión, Sparklet puede rellenar un hueco en este mercado. Puede soportar varios microcontroladores y componentes
para que el usuario pueda usar las opciones más baratas que tenga disponibles, incluso llegando a un precio inferior a
20 €. Por este precio, se consigue una polifonía de 12 voces, apropiada para tocar con un teclado usando ambas manos, un
gran diferenciador. Además, incluye ecualización. Con documentación suficiente para su instalación, su uso, su
desarrollo y para dar soporte a un nuevo dispositivo, podría ser instalado por usuarios menos técnicos. Las pruebas
automáticas aportan confianza al usuario de la calidad del código y de que sea funcional. En resumen, puede ofrecer una
funcionalidad superior al resto de sintetizadores de su rango de precio.

=== Ámbito académico

#let citas = [#cite(<ref_book_theory_music>, form: "prose"),
  #cite(<ref_book_music_tutorial>, form: "prose")]

Uno de los problemas de diseñar un sintetizador polifónico (que permite tocar más de una nota a la vez) es la estrategia
para el robo de voces @ref_book_theory_music. Es decir, cuando se tocan más notas de las que soporta el sintetizador, el
algoritmo que decide cuáles se dejan de tocar para permitir dar paso a las nuevas. Aunque en la literatura existen
estrategias de asignación de voces (véase #citas), estas suelen basarse en criterios heurísticos simples como la
antigüedad de la nota, su amplitud o su estado de liberación. En escenarios extremos, cuando se tocan muchas notas entre
eventos de procesamiento o bajo eventos rápidos de tocar y liberar una nota, pueden llevar a un comportamiento
subóptimo, ya sea generando discontinuidades perceptibles o al comportarse de forma contraintuitiva.

De forma similar, el diseño de envolventes ADSR en aritmética de punto fijo y con recursos limitados presenta desafíos.
Aunque existen soluciones optimizadas para sistemas empotrados (véase #citas), la gestión de cambios dinámicos en los
parámetros del envolvente pueden introducir artefactos perceptibles si no se realiza interpolación, y la interpolación
puede resultar demasiado cara para ciertos sistemas.

En este trabajo, se propone un algoritmo para el envolvente ADSR eficiente en aritmética de coma fija, capaz de ser
configurado dinámicamente sin artefactos audibles incluso ante cambios abruptos de los parámetros. Además, se propone un
sistema de gestión de polifonía eficiente, orientado a mejorar la estabilidad bajo estas situaciones extremas
manteniendo un coste computacional adecuado para sistemas empotrados.
