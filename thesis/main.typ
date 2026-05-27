#import "/utils/tfc_template.typ": *

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
  dedicatoria: "A quienes son mi familia por sangre y a quienes lo son por elección.",
  agradecimientos: [
    Quiero agradecer a mi familia por su apoyo infinito y por haberme dado la libertad de convertirme en quien soy.
    Valoro todo el esfuerzo que habéis hecho por mi, en sus mil formas. Me hace gracia que no se me haya ocurrido que
    quisierais venir a ver mi graduación. Que estáis tan orgulloso de mi como yo de vosotros. Estoy deseando veros
    cuando vuelva a casa. Tengo mucha suerte de teneros.

    Agradezco a Emil, mi otra mitad, que me ha escuchado cada noche, siempre con una sonrisa y un apoyo incondicional.
    Amo tenerte en mis brazos mientras hablas de tus plantas y de tus sueños, sin querer tejiendo en el aire hilos de
    luz que revelan la belleza de tu ser. Espero hacerte sentir tan amado como tú me haces sentir a mí, aun creyéndolo
    imposible.

    Quiero agradecer, también, a todos los que me acompañaron estos cuatro años. Al haber superado juntos esta odisea,
    al haber pasado años manteniéndonos cuerdos los unos a los otros, vuestras almas han dejado una marca indeleble en
    la mía: de cada uno de vosotros me llevo un fragmento en mí.

    De vosotros resalto a tres. Pepe, me doy cuenta ahora, tarde, que quizá nunca te dije lo mucho que te admiro, y lo
    siento por ello. Eres un referente para mí en mil aspectos. Juan, valoro cada momento que he pasado contigo, y
    lamento no haberte visto este año tanto como me habría gustado. Fuiste el primero en hacerme sentir verdaderamente
    bienvenido en Sevilla. Emilio, te tengo tanto afecto que no sé qué hacer con él. Quizá nunca hayas hecho una gracia
    que no me haya hecho reír. Gracias por mantenerme cuerdo este año. Sabéis que os quiero, pero os lo vuelvo a decir.
    Escribiendo esto, pensando en que se acaba esta etapa de nuestra vida, no puedo evitar llorar. De verdad os merecéis
    lo mejor del mundo.

    Finalmente, agradezco a los que me han acompañado por más tiempo. A Rafa y a Gianca, con quienes he pasado mil
    tardes y superado mil pesares, y a quienes veo mucho menos de lo que me gustaría. A Nico, a quien he llegado a
    querer un poco más que a mí. Nunca podré pagarte todo la ayuda que me has prestado. Vosotros tres os merecéis mucho,
    mucho más de lo que el mundo ha querido daros. Espero veros pronto. A Sofía, quien considero mi hermana puesto que
    la conozco desde que tengo memoria. Estoy deseando verte actuar en Broadway.

    Por último, agradezco a aquellos con quien me descubrí. A Alba, un torbellino de talento. A Corral, el _genius loci_
    de Premià. A Cristian, sin quien no habría sobrevivido al bachillerato. Y a Ena, mi confidente. Me enorgullezco de
    haber crecido con vosotros, y de las personas en las que os habéis convertido.

    Espero que la vida os sonría.
  ],
  resumen: [
    Aunque el avance de la tecnología ha llevado a la democratización del acceso a la música, determinados ámbitos
    siguen presentando desafíos técnicos y económicos. Los sintetizadores de hardware, ya sean analógicos o digitales,
    continúan siendo dispositivos de elevada complejidad y precio. Este Trabajo de Fin de Grado presenta Sparklet, un
    sintetizador musical implementado sobre sistemas empotrados, orientado a músicos con interés en la tecnología.
    Rellena un hueco en el mercado, siendo un sintetizador de código abierto diseñado para ser barato, accesible,
    extensible y bien documentado.

    La literatura de la síntesis musical en sistemas empotrados de bajo rendimiento, en particular con aritmética de
    coma fija, es escasa. Uno de los problemas que destaca es el diseño de envolventes ADSR que soporten configuración
    dinámica. Para remediarlo, se propone un algoritmo para el envolvente ADSR configurable dinámicamente, basado en los
    condensadores que usaban los sintetizadores analógicos para modular la amplitud de la onda.

    Otro problema es la gestión eficiente de la polifonía mediante una estrategia de robo de voces robusta ante
    condiciones extremas. Se aporta un algoritmo eficiente para la asignación de voces orientado a responder con rapidez
    a la interpretación del músico sin producir artefactos perceptibles, combinando las heurísticas clásicas de
    antigüedad, amplitud y estado de liberación con una cola intermedia.

    El resultado es un sistema que contribuye tanto a la democratización de la síntesis #box[_do it yourself_] (DIY)
    como al estado del arte en algoritmos de síntesis musical para sistemas con recursos computacionales limitados. El
    uso de pruebas automáticas, el soporte de múltiples microcontroladores, y la documentación de su uso, instalación,
    desarrollo y extensión hacen que resalte frente a las alternativas.
  ],
  palabras-clave: (
    "síntesis de audio",
    "síntesis musical",
    "síntesis polifónica",
    "sistemas empotrados",
    "hardware libre",
    "procesamiento de señales digitales",
    "aritmética de coma fija",
    "envolvente ADSR",
    "asignación de voces",
    "ecualización",
    "MIDI",
    "USB",
  ),
  abstract: [
    Although technological advances have led to the democratization of music, certain aspects continue to present
    technical and economical challenges. Hardware synthesizers, both analog and digital, remain complex and costly. This
    Bachelor's Thesis introduces Sparklet, a musical synthesizer implemented on embedded systems, aimed at musicians
    with a technical inclination. It fills a gap in the market, being an open-source synthesizer designed to be
    affordable, accessible, extensible and well-documented.

    Literature on musical synthesizers for low-performance embedded systems, particularly those using fixed-point
    arithmetic, is sparse. A notable problem is the design of ADSR envelopes that support dynamic reconfiguration. As a
    solution, the thesis proposes a dynamically configurable ADSR envelope algorithm modeled after the capacitor-based
    circuits found in analogue synthesizers that modulate wave amplitude.

    A second problem is the efficient management of polyphony, particularly a voice-stealing strategy that holds up
    under extreme conditions. The thesis contributes an efficient voice allocation algorithm designed to respond quickly
    to the performer's input without producing artifacts, combining the classical heuristics of note age, amplitude and
    release stage with an intermediate queue.

    The result is a system that contributes both to the democratizacion of #box[do-it-yourself] (DIY) synthesis and to
    the state of the art in musical synthesis algorithms for computationally constrained platforms. Automated testing,
    support for multiple microcontrollers, and thorough documentation covering usage, installation, development and
    extension set it apart from alternatives.
  ],
  keywords: (
    "audio synthesis",
    "musical synthesis",
    "polyphonic synthesis",
    "embedded systems",
    "open-source hardware",
    "digital signal processing",
    "fixed-point arithmetic",
    "ADSR envelope",
    "voice allocation",
    "equalization",
    "MIDI",
    "USB",
  ),
  font: "TeX Gyre Pagella",
  bibliografia: bibliography("/bibliografía.bib"),
)

#set enum(numbering: "1.a.")

#include "sections/01_Introducción.typ"
#include "sections/02_Metodología.typ"
#include "sections/03_Análisis.typ"
#include "sections/04_Implementación.typ"
#include "sections/05_Conclusiones.typ"
#include "sections/06_Anexo.typ"
