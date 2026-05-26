#import "/utils/tfc_template.typ": *
#import "/utils/capítulos.typ": cita, resumen
#import "/sections/01_Introducción.typ": (
  objetivos_aprendizaje, objetivos_proyecto,
)

= Conclusiones

#cita[
  "Y si ven un chico que viene hasta ustedes, si ríe, si tiene pelo como de oro,
  #linebreak()
  si no contesta cuando ustedes le preguntan, ya sabrán quién es."
][Antoine de Saint-Exupéry (El principito)]

#resumen[
  En este capítulo se evalúan los resultados del proyecto. En la @sec_cumplimiento se indica el cumplimiento con los
  objetivos del proyecto, en la @sec_lecciones_aprendidas se listan lecciones que se han aprendido durante su
  realización y en la @sec_trabajo_futuro se presentan posibles líneas de trabajo futuro.
]

#pagebreak()

== Cumplimiento
<sec_cumplimiento>

En esta sección se evalúa el cumplimiento con los objetivos del proyecto y de aprendizaje, indicados en la
@sec_objetivos, con los requisitos, indicados en la @sec_requisitos, y si se ha aportado al estado del arte, según lo
identificado en la @sec_estado_del_arte.

=== Objetivos del proyecto

Cabe repetir los objetivos del proyecto para poder evaluarlos:

#objetivos_proyecto

Se ha creado un sintetizador musical completo (@sec_osciladores, @sec_adsr, @sec_banco_de_voces, @sec_generador,
@sec_eq, @sec_midi, @sec_usb), configurable (@sec_configuración) y con manuales accesibles (@sec_manual). Además, se
presentó una arquitectura basada en la multitarea cooperativa para crear sintetizadores capaces de operar en múltiples
dispositivos con limitaciones de rendimiento de manera fiable (@sec_diseño). Todos los requisitos planteados se han
cumplido. Así, se aporta al estado del arte de los sintetizadores, llenando un hueco en el mercado.

Además, se presentaron los algoritmos para el envolvente ADSR (@sec_adsr) y el robo de voces (@sec_banco_de_voces) con
suficiente detalle para ser recreados e implementados en la práctica. Estos nuevos algoritmos funcionan de forma fiable
bajo las condiciones limitadas del microcontrolador, y soportan interpolación en el caso del ADSR y situaciones extremas
en el caso del robo de voces sin generar artefactos perceptibles. Su desarrollo contribuye al estado del arte de la
literatura.

En conclusión, se han cumplido todos los objetivos del proyecto, todos los requisitos, y se ha aportado al estado del
arte lo se se planteó.

=== Objetivos de aprendizaje

Similarmente, se repiten los objetivos de aprendizaje:

#objetivos_aprendizaje

He tenido que aprender, entre otras cosas, sobre la multitarea cooperativa y apropiativa, cómo realizar compilación
cruzada o compilación condicional, cómo realizar pruebas para plataformas empotradas y cómo probar código que se puede
compilar a un microcontrolador en un ordenador; que entender los protocolos MIDI, USB y UART, cómo leer hardware tanto
por interrupciones como por polling, cómo escribir código en situaciones con memoria y poder de procesamiento limitados,
y cómo generar de antemano código al no poder usar floats y para configurar el sistema en la compilación. Considerando
que antes del trabajo no había desarrollado para sistemas empotrados más allá de proyectos pequeños con Arduino,
considero que he aprendido bastante.

En cuanto al procesamiento de señales digitales, tenía más conocimiento, pero no era consiente de que la mayoría de este
dependía de los números de coma flotante para funcionar. Al operar en tiempo real en sistemas con limitaciones de
velocidad de procesamiento y sin usar números de coma flotante, muchas técnicas dejan de ser viables.

Además, diseñar un producto musical da una perspectiva muy distinta a la que tenía antes, que era más teórica. Se vuelve
una herramienta para conseguir una buena experiencia de usuario y un sonido agradable. También ha tenido mucho valor.

En definitiva, si cometí un error, fue el de subestimar la cantidad de conocimiento que tendría que adquirir para poder
realizar este trabajo. Sin embargo, no me arrepiento.

== Lecciones aprendidas
<sec_lecciones_aprendidas>

En primer lugar, al planificar se intentó sobrestimar la dedicación horaria de todos los sprints por un factor del 50%,
tomando en cuenta mi falta de conocimiento del dominio. Al principio del proyecto, pensaba que esto era exagerado, que
me adelantaría y podría ampliar el alcance. Al final, apenas ha resultado suficiente para cubrir el tiempo empleado en
el desarrollo. Tener que aprender un nuevo ámbito toma mucho tiempo, y este no puede ser ignorado al planificar.

Algo similar ocurrió con la memoria. A pesar de sobrestimar su dedicación horaria por un 100%, también se acabó
subestimado el tiempo que tomaría, como se mencionó en la @sec_desviaciones. En particular, no se tomó en cuenta la
cantidad de revisiones que han ocurrido y el esfuerzo que se ha dedicado a que el texto sea legible, didáctico, y que
estuviera acompañado de figuras que aporten a la explicación. En el siguiente proyecto, tendré en cuenta el tiempo que
toma hacer documentación legible, y en general los aspectos del desarrollo que no son escribir código.

Otro problema ha sido el retrabajo. Se realizaron implementaciones erróneas o incompatibles con la literatura, que
tuvieron que ser reemplazadas. Un ejemplo fue usar interrupciones para leer los botones y encoders rotativos en lugar de
muestreo. Resultó en que cuando se generaban demasiados eventos se retrasaba la generación del bloque de audio lo
suficiente para generar artefactos. Del mismo modo, aunque las pruebas automáticas se desarrollaron a la par que los
componentes, las pruebas de rendimiento se realizaron en sprints posteriores, en ocasiones llevando a tener que volver a
visitar código y optimizarlo a posteriori, una vez se había perdido el contexto. Hasta cierto punto, esto es inevitable,
pero podría haber sido reducido si se hubiese investigado un poco más antes de realizar las implementaciones.

Por último, se analiza la lección anterior desde otro punto de vista. Si no se hubiesen tenido en cuenta al diseñar la
arquitectura aspectos como la necesidad de dar soporte a múltiples dispositivos, de poder ejecutar pruebas en un
ordenador, y de usar librerías para los cálculos DSP, se habría tardado mucho más en implementarlo. En el futuro, antes
de empezar con un proyecto complejo, analizaré las partes que pueden generar más complejidad e investigaré para
encontrar una solución compatible. Como se atribuye a Lincoln de forma apócrifa @ref_quote_lincoln, "si tuviera cinco
minutos para cortar un árbol, pasaría los primeros tres afilando mi hacha".

== Trabajo futuro
<sec_trabajo_futuro>

Considero que, en cuanto a Sparklet, la línea de trabajo futuro más clara es hacerlo compatible con los sistemas
modulares y el formato Eurorack. Usando las entradas ADC del microcontrolador, se podrían proveer varias entradas de
voltaje de control (un formato en el que se especifica una nota con voltaje) para soportar la polifonía. Usando un DAC
externo, se podría proveer una salida analógica de 3.5mm. Además, se podría también proveer un archivo CAD para poder
crear a mano o con impresión 3D un caparazón compatible con Eurorack. Una dificultad sería intentar mantener la
flexibilidad de Sparklet en cuanto a microcontroladores y componentes, que aporta mucho a reducir su precio.

Otro aspecto mejorable es la autosuficiencia del sintetizador, si se busca usarlo por sí mismo y no como parte de un
sistema modular. Se podrían implementar más efectos como la reverberación, el _delay_, o la distorsión, ampliando la
gama de sonidos que el sintetizador permite.

Finalmente, se propone que el ecualizador podría tener una respuesta más plana. La dificultad está en el rendimiento, en
usar números de coma fija, y en buscar dividir la señal en 6 segmentos. Si se usase Q31 internamente se podrían más
filtros para el cálculo, como filtros de Linkwitz-Riley, a coste de tener un peor rendimiento. Incluso así, no he podido
encontrar filtros de alto rendimiento capaces de partir la señal en seis segmentos con frecuencias arbitrarias que den
una respuesta plana. Sin embargo, dada mi falta de conocimiento del dominio, no descarto que sea posible.
