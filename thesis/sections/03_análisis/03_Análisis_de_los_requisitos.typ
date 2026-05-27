#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Ecosistema de desarrollo
<sec_ecosistema>

En esta sección, se analizan los requisitos para encontrar un ecosistema de desarrollo apto para cumplirlos.

=== Lenguaje de programación

En cuanto a la selección del lenguaje, se evaluaron C, C++, Zig, SPARK y Rust, por ser lenguajes populares para el
desarrollo empotrado.

C es una de los lenguajes más populares en el desarrollo empotrado. El @rnf_rendimiento urge la integración de
CMSIS-DSP, una biblioteca de C para realizar operaciones DSP aprovechando instrucciones especiales de la arquitectura
ARM Cortex. Usar C, C++ o Zig facilitaría integrarse con ella. Sin embargo, aunque el autor ha usado C en el pasado, no
considera que tenga suficiente experiencia para garantizar que no hayan problemas de memoria o que no configure
incorrectamente el hardware, dificultando el @rnf_fiabilidad. Lo mismo ocurre con C++ y Zig.

SPARK es una opción apropiada para conseguir el @rnf_fiabilidad, ya que permite verificar formalmente los programas
@ref_web_ada_formal_proof. Sin embargo, tiene un ecosistema pequeño, en particular en lo que respecta al audio, por lo
que se tendría que implementar mucha lógica desde cero. La dificultad de esta opción no permitiría realizar el proyecto
a tiempo.

Rust proporciona un ecosistema más grande. Hay bibliotecas que cubren las necesidades del proyecto (gestión de
operaciones de coma fija, de MIDI, de USB, ejecución de pruebas, etc.), además de herramientas útiles (para leer los
mensajes del microcontrolador, encontrar el código que más memoria ocupa en el binario, etc.).

Rust también tiene funcionalidades que ayudan a conseguir la fiabilidad buscada. El _borrow checker_ contribuye a
comprobar comprobar la seguridad de memoria del programa con un análisis realizado durante la compilación
@ref_web_rust_lifetimes. Además, el comportamiento indefinido (UB) únicamente puede ocurrir en código `unsafe` (o código
seguro que depende de código `unsafe`) @ref_web_rust_undefined. Usando Rust, no es muy común escribir código `unsafe`
como parte de un programa. En su lugar, se suele depender de bibliotecas que lo usan, minimizando el riesgo de UB si han
sido probadas en profundidad.

Además, las bibliotecas HAL (_hardware abstraction layer_) en el ecosistema de Rust están construidas con una API
diseñada para validar en compilación que la configuración del hardware es correcta. Por ejemplo, no es válido activar
las interrupciones en los pines `PA5` y `PB5` simultáneamente, ya que ambos usan el canal `EXTI5`. La API modela el
comportamiento del hardware, y hace imposible usarlo incorrectamente. Crear una entrada con interrupciones para estos
pines consume un `struct` `EXTI5`, y únicamente se puede obtener uno, por lo que no se puede hacer para ambas. Si se
intenta, resulta en un error de compilación. Si se diseña una arquitectura en la que no puedan ocurrir bloqueos mutuos
(_deadlocks_), se puede tener seguridad de que el programa nunca se tendrá que reiniciar, ayudando a cumplir el
@rnf_fiabilidad.

Rust también permite realizar compilación cruzada @ref_web_rust_cross, permitiendo que el mismo código sea compilado
tanto a `x86_64`, la arquitectura del ordenador, como a `thumbv7em` (_ARM Cortex M7_), la arquitectura del
microcontrolador. El proyecto aprovecha esto moviendo todo el código posible a _crates_ (paquetes) que son
independientes del hardware. Esto permite desarrollar sin necesidad de tener el microcontrolador a mano, además de
automatizar las pruebas en workflows de GitHub Actions para que sus resultados sean visibles, cumpliendo así el
@rnf_pruebas.

Finalmente, Rust es el lenguaje con el que el autor tiene más experiencia de los evaluados. Por todos estos motivos, se
eligió usar Rust para el desarrollo.

=== Marco de aplicaciones

Las aplicaciones complejas para sistemas empotrados generalmente se realizan usando sistemas operativos de tiempo real
(RTOS). Estos sistemas operativos generalmente son diseñados para microcontroladores, e intentan mantener consistencia
en la cantidad de tiempo que toma realizar las tareas para poder usarse en entornos de tiempo real, en los que las
demoras resultan en errores @ref_web_rtos. Rust permite integrarse con FreeRTOS, un sistema operativo de código abierto
muy usado @ref_web_rust_freertos.

FreeRTOS, y la mayoría de RTOS, suelen tener un modelo de concurrencia apropiativo: el sistema operativo quita control a
las tareas para distribuir el tiempo de ejecución entre ellas @ref_web_freertos. Sin embargo el cambio entre las tareas
tiene un coste. Se ha de reservar espacio en memoria suficiente para poder guardar la pila entera de cada tarea, que se
estima de manera conservadora. Además, cada vez que hay un cambio de contexto, se han de guardar todos los registros del
CPU en la memoria y restaurar el estado de la nueva tarea, además de actualizar las estructuras de datos que permiten
una distribución homogénea del tiempo de ejecución entre las tareas @ref_web_cooperative_multitasking.

La alternativa es usar una modelo de concurrencia cooperativo. En lugar de quitar el control a las tareas, estas han de
cederlo. Generalmente lo ceden cuando necesitan que ocurra un evento para poder continuar, como una lectura del disco.
Estas tareas generalmente se implementan usando máquinas de estado, indicando explícitamente los datos que hay que
preservar entre sus ejecuciones. Esto ahorra las reservas de memoria sobredimensionadas de los RTOS. Además, ahorra
almacenar y restaurar los registros con cada cambio de tarea, ya que esta transición efectivamente es retornar desde una
función y llamar a otra. Añadir tareas en un sistema cooperativo es muy eficiente en comparación a un RTOS
@ref_web_cooperative_multitasking. Sin embargo, puede resultar en que una tarea que nunca ceda el control detenga el
sistema entero. La multitarea cooperativa es apropiada para Sparklet, ya que el sintetizador se compone únicamente de
tareas ligadas a eventos (la generación de audio ocurre cuando se solicita un nuevo bloque, la lectura de los
periféricos cada cierto tiempo o cuando llegan datos, etc.).

Un inconveniente es que en lenguajes como C las máquinas de estado que forman las tareas cooperativas generalmente son
implementadas a mano, dificultando leer y entender las funciones, como se puede ver en el @cod_maquina_estado_manual. En
Rust, estas máquinas de estado pueden ser creadas usando funciones asíncronas que parecen funciones secuenciales
simples. Se usa la sintaxis `async` y `await`, como en el desarrollo web, como se puede ver en el
@cod_maquina_estado_async. Estas funciones son transformadas en máquinas de estados automáticamente, representadas con
la interfaz estándar `Future` de Rust. Embassy proporciona un ejecutor cooperativo ligero para plataformas empotradas
basada en los `Future`.

#figure(
  grid(
    columns: 1,
    gutter: 2.5em,
    [
      #figure(
        ```rust
        enum State { A, B }

        fn step(state: &mut State, ready: bool) {
            match state {
                State::A => {
                    println!("A");
                    *state = State::B;
                }

                State::B => {
                    if ready {
                        println!("B");
                        *state = State::A;
                    }
                }
            }
        }
        ```,
        caption: [Una tarea cooperativa que alterna entre el estado A y B, implementada a mano como una máquina de
          estados.
        ],
      )<cod_maquina_estado_manual>
    ],
    [
      #figure(
        ```rust
        async fn task() {
          loop {
              println!("A");
              wait().await;
              println!("B");
          }
        }
        ```,
        caption: [Una tarea cooperativa que alterna entre el estado A y B, implementada con la sintaxis `async` y
          convertida en una máquina de estados por el compilador.],
      )
      <cod_maquina_estado_async>
    ],
    [
      #figure(
        ```rust
        use defmt::info;

        info!("Midi note received: {}", note);
        // El texto no se envía al microchip. El mensaje únicamente contiene un identificador del mensaje y el valor de `note`
        ```,
        caption: [Ejemplo del uso de `defmt` para registrar eventos en sistemas empotrados, donde el formateo del
          mensaje se realiza en el huésped en lugar del microcontrolador.],
      )<cod_ejemplo_defmt>
    ],
  ),
  numbering: none,
  placement: auto,
)

Debido a la popularidad de Embassy, su ecosistema es bastante maduro. Ofrece _hardware abstraction layers_, APIs de Rust
que abstraen las características del hardware (p. ej. entrada, salida, _pull-ups_). Provee HALs para casi todos los
microcontroladores de la familia STM32, permitiendo cumplir el @rf_multi_dispositivos. También incluye `embassy_sync`,
que ofrece primitivas de sincronización compatibles con `async` (p. ej. `Channel`, `Signal`) para la comunicación entre
tareas @ref_web_embassy_sync, y `embassy_usb`, que ofrece un controlador USB @ref_web_embassy_usb.

=== Bibliotecas principales

Sparklet usa múltiples bibliotecas fuera del ecosistema de Embassy. A continuación se explican las principales.

`defmt` es una biblioteca de _logging_ que permite enviar mensajes de la placa de desarrollo a la computadora sin
almacenar el texto en la memoria del dispositivo @ref_web_defmt. Transforma los mensajes automáticamente, asignando al
microcontrolador enviar una representación compacta del mensaje (generalmente con un identificador del tipo de mensaje y
sus argumentos), y al ordenador huésped darle formato. El texto de los mensajes se almacena en las secciones de
depuración del binario, que no se envían al microcontrolador. Un ejemplo de su uso se puede ver en el
@cod_ejemplo_defmt.


`fixed` proporciona tipos para operar con números de coma fija en Rust sin un coste de rendimiento @ref_web_fixed.
`bytemuck` a su vez permite hacer conversiones de tipo que no conllevan modificar la representación en bits de los
datos, como convertir un `Q15` a un `i16` o convertir un vector de `Q15` al vector de `u8` compuesto por sus bytes
@ref_web_bytemuck.


=== Utilidades

Se usa Nix para gestionar los programas usados por el proyecto de forma reproducible @ref_web_nix_main. Se usa para
formar el entorno de desarrollo, el entorno mímimo para la instalación de Sparklet y el entorno de usado por GitHub
Actions para ejecutar las pruebas automáticas. Gestiona todos los programas usadas en el desarrollo, incluyendo Rust,
Octave, Typst y todas las utilidades, y fija sus versiones. Garantiza que el entorno de desarrollo, de instalación y de
ejecución de pruebas usan exactamente las mismas versiones de los programas.

El manual de Sparklet está escrito en documentos Markdown para facilitar la edición de otras personas. A partir de esto
se generan los archivos HTML y etc. de un sitio web estático usando `mdbook`, un software estándar en la comunidad de
Rust. Estos archivos se alojan en GitHub Pages, que los sirve de forma gratuita @ref_web_gh_pages.

Se usa _just_ como gestor de comandos, una alternativa al `Makefile` más utilizada por la comunidad de Rust. Este
proporciona comandos fáciles (p. ej. `just test`) que ejecutan secuencias más complejas usadas para el desarrollo. Para
unificar el uso de las distintas herramientas de formato (`typstyle`, `cargo-fmt`) y _linting_ (`clippy`, `cspell`) se
usa `prek`.

Para calcular los coeficientes de los filtros IIR usados en el ecualizador, se usa el paquete `signal` de GNU Octave.

Como herramientas auxiliares, se usan `cargo-nextest` como ejecutor de pruebas en el ordenador, `cargo-binutils` y
`cargo-bloat` para medir el tamaño del binario compilado con el fin de optimizarlo, `probe-rs` para escribir el código a
la placa de desarrollo y leer sus mensajes, y `lldb` como debugger.

Para probar el funcionamiento del sistema completo, se usa `vmpk` como teclado virtual y `qpwgraph` para conectar la
entrada del audio del sintetizador a los altavoces.

Finalmente, para escribir la memoria, se usó Typst como sistema de composición tipográfica, Draw.io para la creación de
diversos diagramas, y Python con la biblioteca Matplotlib para la generación de los gráficos.
