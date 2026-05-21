#import "/utils/tfc_template.typ": *
#import "/utils/riesgos.typ": riesgo

== Análisis de riesgos
<sec_riesgos>

#todo[Citar la técnica usada.]

Se ha realizado un análisis cuantitativo de los riegos asociados al proyecto usando una matriz de probabilidad e
impacto. Se estimó su probabilidad de ocurrir como baja (1 punto), media (2 puntos) o alta (3 puntos), y del mismo modo
su impacto. Se puntuaron según el producto de ambos valores. A continuación se muestran las que consiguieron una
puntuación de al menos 4, junto a las estrategias usados para mitigarlos:

#riesgo(
  [Imposibilidad práctica de utilizar Rust en el entorno embebido],
  [
    El proyecto depende en gran medida del ecosistema de Rust y de librerías específicas para desarrollo embebido, por
    lo que problemas de compatibilidad, compilación o soporte hardware podrían dificultar la implementación prevista.
  ],
  [Alto.],
  [Media.],
  (
    [Validación temprana del uso de Rust.],
    [Investigación previa de librerías para DSP, USB y lectura MIDI.],
  ),
)

#riesgo(
  [Rendimiento insuficiente en microcontroladores de bajo coste],
  [
    El objetivo de soportar dispositivos muy económicos y sin soporte de coma flotante puede provocar limitaciones de
    rendimiento o memoria al ejecutar síntesis polifónica, interpolación de ADSR y procesamiento en tiempo real
    simultáneamente.
  ],
  [Alto.],
  [Media.],
  (
    // Mitigaciones
    [Uso de CMSIS-DSP para optimizar las operaciones de procesamiento.],
    [Posibilidad de reducir la polifonía o ciertas funcionalidades para adaptarse a las capacidades del dispositivo.],
  ),
)

#riesgo(
  [Dificultad para mantener compatibilidad entre múltiples plataformas],
  [
    El soporte para distintos microcontroladores, componentes y configuraciones hardware puede aumentar
    significativamente la complejidad del código y dificultar su mantenimiento y depuración.
  ],
  [Medio.],
  [Alta.],
  (
    [Arquitectura diseñada para permitir este uso.],
    [Código genérico que funciona sin importar el dispositivo.],
    [Usar archivos que únicamente definen el hardware para el dispositivo para simplificar su cambio.],
  ),
)

#riesgo(
  [Falta de validación práctica con usuarios reales],
  [
    Aunque el proyecto busca resultar útil para músicos interesados en la tecnología, la ausencia de pruebas extensivas
    con usuarios puede provocar decisiones de diseño poco intuitivas o flujos de trabajo incómodos.
  ],
  [Medio.],
  [Media.],
  (
    // Mitigaciones
    [El autor del trabajo es un músico con experiencia tocando sintetizadores.],
    [Realización de pruebas manuales durante el desarrollo.],
    [Priorización de funcionalidades comunes en sintetizadores existentes.],
    [Documentación orientada a usuarios no expertos en programación.],
  ),
)
