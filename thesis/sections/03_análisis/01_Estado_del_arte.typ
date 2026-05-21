#import "/utils/tfc_template.typ": *

== Estado del arte
<sec_estado_del_arte>

En esta sección, se analiza el estado del arte. Primero se analizan los sintetizadores que existen actualmente, y a
continuación se analiza el estado del ámbito académico respecto a los algoritmos que usan los sintetizadores.

=== Sintetizadores

Primero, se analizan los sintetizadores de software libre o gratuitos. Aunque hay muchos, uno de los mas usados y
completos es Helm, un sintetizador aditivo. Helm @ref_web_helm se toma como referencia para saber qué funcionalidades
resultan útiles en un sintetizador, aunque su implementación no se puede usar como referencia al depender de operaciones
de coma flotante. Sin embargo, no son competencia directa, pues se está creando un producto hardware.

La competencia más directa son los sintetizadores de hardware. Se empieza por los privativos. Algunos de los generadores
de onda analógicos más baratos incluyen el Behringer 921B (40 €) o Behringer 110 (50 €), pero no pueden tocar más de una
nota a la vez. El Behringer Brains (90€) es una alternativa digital, también monofónica. Si se busca un generador
polifónico digital, una de las opciones más baratas es el OXI Instruments Coral, a la venta por unos 380 €.

En cuanto a sintetizadores hardware libres, la lista diy-synths @ref_web_diy_synths provee una lista de muchos proyectos
similares.

Se clasifican en las siguientes tres categorías:

+ Proyectos que no son sintetizadores de melodía y armonía, sino que son por ejemplo arpegiadores MIDI, efectos o
  sintetizadores de baterías: Arpie, Coron DS7, DrumKid, Echo Rocket, Faderbank 16n, Fasma Festival, Groundbot, LMN-3,
  Le Strum, Lunchbeat, MIDIbox, MIDIvampire II, Matrix sequencer, N32B, Nano minipops
+ Proyectos poco documentados: ATTiny-Punk-Console, Lil' mono, Meeblip, Mushsynth-8,
+ Proyectos de ejemplo: proyectos muy simples sin las capacidades que se esperan de un sintetizador real (p. ej. sin
  poder controlar la frecuencia con un dispositivo externo): ArduTouch, Totoro,
+ Proyectos experimentales cuyas peculiaridades hacen que no sean competencia, como por ejemplo que se controlen las
  notas con luz: Beam Catcher, Hidden Sound Explorer, Hypjolin, Keep, Mega MIDI, Mozard, Multi, NSynth Super,
+ Sintetizadores con 4 voces o menos: Aciduino, Ambika, Anushuri, D-D_Teensy, Hog, Kastle, miniMO, Mixtape Alpha, NTH
  synth,
+ Sintetizadores completos con precio superior a 100€: Bread Modular
+ Competencia fuerte: Flounder, KELPIE, MiniDexed,

#todo([Explicar en detalle la competencia fuerte.])

#todo(
  [Resulta que la competencia de sintetizadores hardware libres es más intensa de lo que pensaba, por lo que tengo
    que reescribir esto. El foco será que Sparklet provee un ecualizador, polifonía, un precio muy bajo, y flexibilidad en
    los componentes.],
)

// Una gran excepción es Zynthian @ref_web_zynthian. Vende una plataforma de síntesis completa, pudiendo funcionar como
// sintetizador, como unidad de efectos o incluso como una DAW mínima. Tanto el software como el hardware es libre y puede
// construirse desde cero con componentes disponibles. También hay una tienda oficial en la que se vende ya ensamblado por
// 535 €, o como un kit DIY por 360 €.

Sparklet, el sintetizador de este proyecto, puede rellenar un hueco en este mercado. Puede soportar varios
microcontroladores y componentes para que el usuario pueda usar las opciones más baratas que tenga disponibles, incluso
llegando a un precio inferior a 20 €. Por este precio, se consigue una polifonía de 12 voces, apropiada para tocar con
un teclado usando ambas manos, un gran diferenciador. Además, incluye ecualización. Con documentación suficiente para su
instalación, su uso, su desarrollo y para dar soporte a un nuevo dispositivo, podría ser instalado por usuarios menos
técnicos. Las pruebas automáticas aportan confianza al usuario de la calidad del código y de que sea funcional. En
resumen, puede ofrecer una funcionalidad superior al resto de sintetizadores de su rango de precio.

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
