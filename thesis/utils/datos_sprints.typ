#let sprint(
  id,
  start_date,
  end_date,
  hours_goal,
  hours_actual,
  objective,
  description,
) = {
  (
    id: id,
    start_date: start_date,
    end_date: end_date,
    hours_goal: hours_goal,
    hours_actual: hours_actual,
    objective: objective,
    description: [
      #set list(spacing: 0.75em, marker: text([•], size: 9pt))
      #show list: it => {
        set list(indent: 0.5em)
        it
      }
      #description
    ],
  )
}

#let sprints = (
  sprint(
    0,
    "2025-09-10",
    "2025-09-12",
    4,
    4.5,
    [Análisis inicial, planificación y planteamiento del trabajo.],
    [
      - Análisis inicial del estado del arte, de herramientas y lenguajes para el desarrollo.
      - Planificación inicial del proyecto.
      - Planteamiento del trabajo al tutor.
    ],
  ),
  sprint(
    1,
    "2025-09-15",
    "2025-09-26",
    20,
    20.5,
    [Planificación, y estudio del dominio.],
    [
      - Planificación del proyecto.
      - Estudio del estado del arte, del procesamiento de señales digitales y del desarrollo empotrado.
        - Identificación de fuentes principales y lectura de los capítulos relevantes.
        - Evaluación de usar concurrencia apropiativa o cooperativa
    ],
  ),
  sprint(
    2,
    "2025-09-29",
    "2025-10-10",
    20,
    18.5,
    [Evaluación de la viabilidad de las herramientas.],
    [
      - Evaluación de la viabilidad de embassy con Rust como lenguaje de desarrollo.
      - Ejecución de pruebas en la placa de desarrollo.
      - Realización de módulos con pruebas para el ordenador y compilables para el chip.
      - Uso de interfaces para proveer implementaciones usando CMSIS-DSP al chip y de Rust para el ordenador.
    ],
  ),
  sprint(
    3,
    "2025-10-13",
    "2025-10-24",
    20,
    17.5,
    [Lectura de MIDI por puerto DIN.],
    [
      - Primer diseño de la arquitectura del sintetizador.
      - Primera versión del banco de voces.
      - Investigación el protocolo MIDI.
      - Investigación de bibliotecas para el procesado de bytes MIDI.
      - Lectura MIDI por el puerto DIN con UART.

    ],
  ),
  sprint(
    4,
    "2025-10-27",
    "2025-11-07",
    20,
    15.5,
    [Creación del oscilador de tabla de onda.],
    [
      - Creación del oscilador por tabla de onda.
      - Interpolación mediante un UQ8.24.
      - Creación de los generadores de tablas.
    ],
  ),
  sprint(
    5,
    "2025-11-10",
    "2025-11-21",
    20,
    18.5,
    [Creación del envolvente ADSR.],
    [
      - Búsqueda de una implementación de un envolvente ADSR configurable y eficiente en coma fija.
      - Derivación matemática del envolvente ADSR.
      - Implementación del envolvente ADSR.
      - Creación de la tabla de bases y coeficientes para el ADSR.
    ],
  ),
  sprint(
    6,
    "2025-11-24",
    "2025-12-05",
    20,
    20,
    [Creación del algoritmo para el robo de voces.],
    [
      - Diseño del algoritmo para el robo de voces.
      - Modificar la implementación del sintetizador para utilizarlo.
    ],
  ),
  sprint(
    7,
    "2025-12-08",
    "2025-12-19",
    20,
    20.5,
    [Salida de audio y entrada de MIDI por USB.],
    [
      - Lectura de la especificación de USB Audio 1.0.
      - Modificación de la biblioteca `embassy-usb` para implementar un dispositivo de entrada de audio síncrona.
      - Implementación de la salida de audio del sintetizador por USB audio.
      - Implementación de la entrada de MIDI por USB.
    ],
  ),
  sprint(
    8,
    "2026-01-26",
    "2026-02-06",
    20,
    17.5,
    [Configurabilidad en ejecución de Sparklet.],
    [
      - Implementación del gestor de configuración y conexión con el resto de componentes.
      - Investigación del funcionamiento de los codificadores rotatorios.
      - Inicio del código para leer los codificadores rotatorios y botones, no funcional.
    ],
  ),
  sprint(
    9,
    "2026-02-09",
    "2026-02-20",
    20,
    18.5,
    [Final de la configurabilidad en ejecución y mejoras.],
    [
      - Implementación del gestor de configuración usando interrupciones.
      - Uso de herramientas para formato automático del código.
      - Mejoras de estilo y rendimiento generales.
      - Creación del workflow para la ejecución automática de pruebas en GitHub Actions.
      - Creación del workflow para revisar automáticamente el formato.
      - Evaluación del rendimiento del sintetizador.
    ],
  ),
  sprint(
    10,
    "2026-02-23",
    "2026-03-06",
    20,
    17,
    [Investigación para el ecualizador.],
    [
      - Investigación sobre filtros controlable en coma fija.
      - Investigación sobre ecualizadores multibanda.
      - Investigación sobre árboles de filtros perfectamente reconstructivos.
    ],
  ),
  sprint(
    11,
    "2026-03-09",
    "2026-03-20",
    20,
    18.5,
    [Creación del ecualizador.],
    [
      - Creación del ecualizador en código.
      - Experimentación con distintos filtros.
      - Creación del generador de los coeficientes de los filtros.
    ],
  ),
  sprint(
    12,
    "2026-03-23",
    "2026-04-10",
    20,
    25,
    [Primera iteración de la redacción de la memoria.],
    [
      - Inicialización de Typst.
      - Implementación de la revisión automática de ortografía.
      - Creación del workflow para la revisión de ortografía en GitHub Actions.
      - Lectura de otras memorias.
      - Redacción y revisión con el tutor de la estructura preliminar de la memoria.
      - Redacción de la metodología.
      - Redacción del análisis.
      - Redacción de la implementación del oscilador.
      - Mejoras al código:
        - Uso de un triple buffer para transmitir la configuración.
    ],
  ),
  sprint(
    13,
    "2026-04-13",
    "2026-05-01",
    20,
    28,
    [Segunda iteración de la memoria.],
    [
      - Redacción de la sección de implementación.
      - Mejoras a la legibilidad.
      - Paso de la lectura del hardware de configuración a un modelo de muestreo.
      - Uso de QEI (_timers_ hardware) para la lectura de codificadores rotatorios.
      - Eliminación del canal entre el hardware de configuración y el gestor de configuración.
      - Hacer opcional la configurabilidad en ejecución.
      - Añadir herramientas de código abierto para la prueba del sintetizador.
    ],
  ),
  sprint(
    14,
    "2026-05-04",
    "2026-05-15",
    20,
    30.5,
    [Configuración en la compilación y compatibilidad con dispositivos.],
    [
      - Mejoras a la legibilidad del código.
      - Creación del archivo de configuración Config.toml y el script para activar las feature flags en base a él.
      - Creación del _script_ de construcción `build.rs` para establecer parámetros en el código.
      - Permitir cambiar la configuración por inicial del ADSR, ecualizador, etc.
      - Aportar compatibilidad con el STM32F401RC aparte del STM32H723ZG (la placa de desarrollo).
      - Redacción de la sección de configuración del TFG.
      - Creación de imágenes para el TFG.
    ],
  ),
  sprint(
    15,
    "2026-05-18",
    "2026-05-26",
    16,
    24.5,
    [Finalización del TFG.],
    [
      - Redacción de la introducción, el abstracto, el estado del arte, la planificación y las conclusiones.
      - Revisión final de la memoria.
      - Creación de los manuales de uso del TFG.
    ],
  ),
)

#let milestone(name, date) = {
  (
    name: name,
    date: date,
  )
}

#let milestones = (
  milestone("Comienzo del desarrollo", "2025-10-10"),
  milestone("Síntesis monofónica", "2025-11-21"),
  milestone("Síntesis polifónica", "2025-12-05"),
  milestone("Usable", "2025-12-19"),
  milestone("Configurable en ejecución", "2026-02-20"),
  milestone("Ecualizador", "2026-03-20"),
  milestone("Configurable en compilación", "2026-05-15"),
  milestone("Cierre", "2026-05-26"),
)

#let horas_estimadas = sprints.map(s => s.hours_goal).sum()
#let horas_reales = sprints.map(s => s.hours_actual).sum()
