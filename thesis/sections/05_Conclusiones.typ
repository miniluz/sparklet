#import "@preview/deal-us-tfc-template:1.2.1": *
#import "/sections/01_Introducción.typ": (
  objetivos_aprendizaje, objetivos_proyecto,
)

= Conclusiones

#pagebreak()

== Cumplimiento

En esta sección se evalúa el cumplimiento de los objetivos del proyecto y de aprendizaje, indicados en la
@sec_objetivos, con los requisitos, indicados en la @sec_requisitos, y si se ha aportado al estado del arte, según lo
identificado en la @sec_estado_del_arte.

=== Objetivos del proyecto

Cabe repetir los objetivos del proyecto para poder evaluarlos:

#objetivos_proyecto

Se ha creado un sintetizador musical completo (@sec_osciladores, @sec_adsr, @sec_banco_de_voces, @sec_generador,
@sec_eq, @sec_midi, @sec_usb), configurable (@sec_configuración) y con manuales accesibles (@sec_manuales). Además, se
presentó una arquitectura basada en la multitarea cooperativa para crear sintetizadores capaces de operar en múltiples
dispositivos con limitaciones de rendimiento de manera fiable (@sec_diseño). Todos los requisitos planteados se han
cumplido. Así, se aporta al estado del arte de los sintetizadores, llenando un hueco en el mercado.

Además, se presentaron los algoritmos para el envolvente ADSR (@sec_adsr) y el robo de voces (@sec_banco_de_voces) con
suficiente detalle para ser recreados e implementados en la práctica. Estos nuevos algoritmos funcionan de forma fiable
bajo las condiciones limitadas del microcontrolador, y soportan interpolación y situaciones extremas respectivamente sin
artefactos perceptibles. Su desarrollo contribuye al estado del arte de la literatura.

En conclusión, se han cumplido todos los objetivos del proyecto, todos los requisitos, y se ha aportado al estado del
arte lo se se planteó.

=== Objetivos de aprendizaje

Similarmente, se repiten los objetivos de aprendizaje:

#objetivos_aprendizaje

Considerando que antes del trabajo no había trabajado con sistemas empotrados más allá de proyectos pequeños con
Arduino, considero que he aprendido bastante. He tenido que aprender, entre otras cosas, sobre la multitarea cooperativa
y apropiativa, cómo realizar compilación cruzada o compilación condicional, cómo realizar pruebas para plataformas
empotradas y cómo probar código que se puede compilar a un microcontrolador en un ordenador, aprender de los protocolos
MIDI, USB y UART, cómo leer hardware tanto por interrupciones como por polling, cómo escribir código en situaciones con
memoria y poder de procesamiento limitados, y cómo generar de antemano código al no poder usar floats y para configurar
el sistema en la compilación.

En cuanto al procesamiento de señales digitales, tenía más conocimiento, pero no era consiente de que la mayoría de este
dependía de los números de coma flotante para funcionar. Al operar en tiempo real en sistemas con limitaciones de
velocidad de procesamiento y sin usar números de coma flotante, muchas técnicas dejan de ser viables.

En definitiva, si cometí un error, fue el de subestimar la cantidad de conocimiento que tendría que adquirir para poder
realizar este trabajo.

== Lecciones aprendidas
<sec_lecciones_aprendidas>

En esta sección se discuten algunas de las lecciones aprendidas durante el desarrollo.

En primer lugar, al planificar se intentó sobrestimar la dedicación horaria de todos los sprints por un factor del 50%,
tomando en cuenta mi falta de conocimiento del dominio. Dado que el rendimiento se ha ajustado a lo esperado, esto
resultó ser necesario; al principio del proyecto, pensaba que me adelantaría y podría ampliar el alcance. Aprender de un
nuevo área toma mucho tiempo, y no puede ser ignorado.

Además, a pesar de sobrestimar la dedicación horaria a la memoria por un 100%, se acabó subestimado el tiempo que
tomaría, como se mencionó en la @sec_desviaciones. En particular, no se tomó en cuenta la cantidad de revisiones que han
ocurrido y el esfuerzo que se ha dedicado a que el texto sea legible, didáctico, y que estuviera acompañado de figuras
que aporten a la explicación. En el siguiente proyecto, tendré en cuenta el tiempo que toma hacer documentación legible,
y en general los aspectos del desarrollo que no son escribir código.

Otro problema ha sido el retrabajo. Se realizaron implementaciones erróneas o incompatibles con la literatura, que
tuvieron que ser reemplazadas. Un ejemplo fue usar interrupciones para leer los botones y encoders rotativos en lugar de
muestreo, lo que llevaba a que si se generaban demasiados eventos se retrasase la generación del bloque de audio lo
suficiente para generar ruido. Del mismo modo, aunque las pruebas automáticas se desarrollaron a la par que los
componentes, las pruebas de rendimiento se realizaron en sprints posteriores, en ocasiones llevando a tener que volver a
visitar código y optimizarlo una vez se había perdido el contexto por trabajar en otras áreas. Hasta cierto punto, esto
es inevitable, pero podría haber sido reducido si se hubiese investigado un poco más antes de realizar las
implementaciones.

Por último, se plantea que esta lección se puede ver desde otro punto de vista. Si no se hubiese tenido en cuenta la
necesidad de dar soporte a múltiples dispositivos, de poder ejecutar pruebas en un ordenador, y de usar librerías para
los cálculos DSP a la hora de diseñar la arquitectura, habría sido difícil cambiar el código para introducirlo. En el
futuro, antes de empezar con una funcionalidad compleja, investigaré la mejor forma de hacerla. Como se atribuye a
Lincoln de forma apócrifa @ref_quote_lincoln, "si tuviera cinco minutos para cortar un árbol, pasaría los primeros tres
afilando mi hacha".

== Trabajo futuro

Considero que, en cuanto a Sparklet, la línea de trabajo futuro más clara es hacerlo compatible con los sistemas
modulares y el formato Eurorack. Usando las entradas ADC del microcontrolador, se podrían proveer varias entradas de
voltaje de control (un formato en el que se especifica una nota con voltaje) para soportar la polifonía. Usando un DAC
externo, se podría proveer una salida analógica de 3.5mm. Además, se podría también proveer un archivo CAD para poder
crear a mano o con impresión 3D un caparazón compatible con Eurorack, aunque estaría dificultado por el hecho de que se
soportan varios microcontroladores.

Otro aspecto mejorable es la autosuficiencia del sintetizador, si se busca usarlo por sí mismo y no como parte de un
sistema modular. Se podrían implementar más efectos como la reverberación, el _delay_, o la distorsión, ampliando la
gama de sonidos que el sintetizador permite.

Finalmente, se propone que el ecualizador podría tener una respuesta más plana si no se modifica la ganancia de ninguna
banda. La dificultad está en el rendimiento, en usar números de coma fija, y en buscar dividir la señal en 6 segmentos.
Si se usase Q31 internamente se podrían más filtros para el cálculo, como filtros de Linkwitz-Riley, a coste de tener un
peor rendimiento. Incluso así, los efectos sobre las fases harían imposible partir la señal en 6 segmentos de frecuencia
arbitraria con una respuesta plana. No pude encontrar una respuesta, pero dada mi falta de conocimiento del dominio, no
descarto que sea posible.
