#import "@preview/deal-us-tfc-template:1.2.1": *

== Estado del arte
<sec_estado_del_arte>

En esta sección, se analiza el estado del arte. Primero se analizan los sintetizadores que existen actualmente, y a
continuación se analiza el estado del ámbito académico respecto a los algoritmos que usan los sintetizadores.

#todo([Aquí falta añadir referencias.])

=== Sintetizadores

Primero, se analizan los sintetizadores de software libre o gratuitos. Aunque hay muchos, uno de los mas usados y
completos es Helm, un sintetizador aditivo. Helm se toma como referencia para saber qué funcionalidades resultan útiles
en un sintetizador, aunque su implementación no se puede usar como referencia al depender de operaciones de coma
flotante. Sin embargo, no son competencia directa, pues se está creando un producto hardware.

La competencia más directa son los sintetizadores de hardware. Se empieza por los privativos. Algunos de los generadores
de onda analógicos más baratos incluyen el Behringer 921B (40 €) o Behringer 110 (50 €), pero no pueden tocar más de una
nota a la vez. El Behringer Brains (90€) es una alternativa digital, también monofónica. Si se busca un generador
polifónico digital, una de las opciones más baratas es el OXI Instruments Coral, a la venta por unos 380 €.

En cuanto a sintetizadores hardware libres, https://github.com/Atarity/diy-synths provee una lista de muchos proyectos
similares. La mayoría están basados en C y C++, y tienen documentación y extensión bastante pobre. Muchos de ellos se
basan en Arduinos, que son fáciles de programar y conseguir pero caros para la potencia de su CPU. Una inspección de
estos proyectos revela que la mayoría no tienen documentación o están mal documentados, dificultando saber qué
funcionalidades tienen, su instalación y su uso. Además, debido a su falta de pruebas, es difícil saber si funcionan.

Una gran excepción es Zynthian. Vende una plataforma de síntesis completa, pudiendo funcionar como sintetizador, como
unidad de efectos o incluso como una DAW mínima. Tanto el software como el hardware es libre y puede construirse desde
cero con componentes disponibles. También hay una tienda oficial en la que se vende ya ensamblado por 535 €, o como un
kit DIY por 360 €.

Sparklet, el sintetizador de este proyecto, puede rellenar un hueco en este mercado. Puede soportar varios
microcontroladores y componentes para que el usuario pueda usar las opciones más baratas que tenga disponibles, incluso
llegando a un precio inferior a 20 €. Con documentación suficiente para su instalación, su uso, su desarrollo y para dar
soporte a un nuevo dispositivo, podría ser instalado por usuarios menos técnicos sin leer todo el código fuente. El uso
de pruebas automáticas aporta confianza al usuario de la calidad del código y de que sea funcional. Puede ser un
proyecto con más calidad que la mayoría de sintetizadores libres pero con un precio muy inferior a los que ofrecen tanto
Zynthian como los competidores privativos.

=== Ámbito académico

Uno de los problemas de diseñar un sintetizador polifónico (que permite tocar más de una nota a la vez) es la estrategia
para el robo de voces. Es decir, cuando se tocan más notas de las que soporta el sintetizador, el algoritmo que decide
cuáles se dejan de tocar para permitir dar paso a las nuevas. Aunque en la literatura existen estrategias de asignación
de voces, estas suelen basarse en criterios heurísticos simples como la antigüedad de la nota, su amplitud o su estado
de liberación. En escenarios extremos, cuando se tocan muchas notas entre eventos de procesamiento o bajo eventos
rápidos de tocar y liberar una nota, pueden llevar a un comportamiento subóptimo, ya sea generando discontinuidades
perceptibles o al comportarse de forma contraintuitiva.

De forma similar, el diseño de envolventes ADSR en aritmética de punto fijo y con recursos limitados presenta desafíos.
Aunque existen soluciones optimizadas para sistemas empotrados, la gestión de cambios dinámicos en los parámetros del
envolvente pueden introducir artefactos perceptibles si no se realiza interpolación, y la interpolación puede resultar
demasiado cara para ciertos sistemas.

En este trabajo, se propone un algoritmo para el envolvente ADSR eficiente en aritmética de coma fija, capaz de ser
configurado dinámicamente sin artefactos audibles incluso ante cambios abruptos de los parámetros. Además, se propone un
sistema de gestión de polifonía eficiente, orientado a mejorar la estabilidad bajo estas situaciones extremas
manteniendo un coste computacional adecuado para sistemas empotrados.
