#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Configuración
<sec_configuración>

=== Durante la compilación
<sec_configuración_compilación>

Sparklet ha de cumplir el @rnf_rendimiento y el @rf_multi_dispositivos simultáneamente. Un obstáculo es que algunas
características, como el ecualizador o una polifonía alta, pueden ser demasiado pesadas para el CPU o la memoria de un
dispositivo menos capaz. Desactivar estas funcionalidades en ejecución con un `if` no es suficiente ya que su código
sigue ocupando espacio en el binario (y algunas funcionalidades ocupan mucho espacio, como la entrada de MIDI por USB
que incluye un controlador USB completo).

Debido a esto, ciertas características de Sparklet son configurables durante la compilación. Para que un usuario poco
técnico pueda configurar el sistema, todas las opciones se pueden controlar usando el archivo `Config.toml`. Un ejemplo
de este archivo se puede ver en la @cod_config_toml. Se permite:

- Activar y desactivar fácilmente las características del sistema, como la inclusión del ecualizador.
- Modificar los parámetros de la aplicación, como la cantidad de voces a usar por el motor de síntesis.
- Establecer la configuración inicial del sintetizador, como el ataque, sostenimiento, la onda usada, etc.

#figure(
  raw(read("/code/Config.toml"), block: true, lang: "toml"),
  caption: [Fragmento del archivo de configuración `Config.toml`.],
  placement: auto,
)<cod_config_toml>

Para permitir activar y desactivar las características, se usan las _feature flags_ de Rust. Las feature flags permiten
incluir o excluir ciertas secciones de código, bibliotecas, etc. @ref_web_rust_features. Se puede hacer que dependan de
si cierta feature flag está activa, de si no está activa, o de si cierta combinación está activa, como se puede ver en
el @cod_ejemplo_feature_flags. Usando feature flags, las siguientes características se pueden activar o desactivar:

- El modelo de microcontrolador a usar: qué periféricos usar y cómo configurarlos.
- La entrada de MIDI: por un pin usando el formato DIN, por USB, o desactivada.
- La inclusión del ecualizador.
- La capacidad de configurar el sintetizador en ejecución con periféricos.
- La capacidad de configurar el sintetizador en ejecución con mensajes MIDI.

#figure(
  ```rust
  #[cfg(feature = "cheat")]
  fn roll_dice() -> u8 { 6 }

  #[cfg(not(feature = "cheat"))]
  fn roll_dice() -> u8 { rand_range(1..=6) }
  ```,
  caption: [Ejemplo básico del uso de feature flags en Rust mediante atributos #[cfg] para seleccionar distintas
    implementaciones de una función en tiempo de compilación. La implementación no seleccionada no se incluye en el
    binario final.],
  placement: auto,
)<cod_ejemplo_feature_flags>

El script `run-with-flags.sh` lee los campos relevantes de `Config.toml` y activa las feature flags correspondientes,
permitiendo que se configuren fácilmente. Este toma como argumento un comando y lo llama especificando toda la
configuración, como se ve en el @cod_run_with_flags.

#figure(
  ```bash
  ./run-with-flags.sh cargo build --release
  # ejecuta
  DEFMT_LOG=off cargo build --release --no-default-features --features "midi-usb audio-usb [...]" --config "build.target = [...]" [...]
  ```,
  caption: [Ejemplo del script `run-with-flags.sh` configurando un comando más largo.],
)<cod_run_with_flags>

`Config.rs` también contiene ciertos números constantes como los valores iniciales del ADSR y la cantidad de voces,
llamados parámetros. Se configuran con un archivo `build.rs`, que se ejecuta antes de la compilación. Este lee el
`Config.toml` y genera un archivo `build_config.rs` con un `struct` que contiene todos los parámetros. `build_config.rs`
se incluye en el código en tiempo de compilación con la macro `include!()`.

==== Compatibilidad con a otros dispositivos
<sec_configuración_otros_dispositivos>

Como se explicó en la @sec_múltiples_dispositivos, en el módulo `hardware` cada dispositivo indica los periféricos y la
configuración hardware que le corresponde en un formato uniforme. Con feature flags se incluye en el código la
implementación del dispositivo elegido. El módulo `hardware` lo reexporta, y el resto de componentes importan lo que
exporte `hardware`. El pseudocódigo de la implementación usada se encuentra en el @cod_hardware.

Además, se usa el microcontrolador objetivo para determinar otros factores, como la arquitectura para la que se compila,
si se usa un dispositivo con un M4 o M7 para CMSIS-DSP, y el comando que se usa para transmitir el binario al chip.

#figure(
  ```rust
  // Archivo mod.rs
  #[cfg(feature = "stm32h723zg")]
  mod stm32h723zg; // Importa el módulo correspondiente al sistema
  pub use stm32h723zg::*; // Y lo exporta


  #[cfg(feature = "stm32f401rc")]
  pub use stm32f401rc::*;
  mod stm32f401rc;

  // Archivo stm32h723zg.rs
  ConfigHardware {
      button_next_page: PC14,
      button_prev_page: PC15,
      // ...
  }

  // Archivo stm32f401rc.rs
  ConfigHardware {
      button_next_page: PA3,
      button_prev_page: PC13,
      // ...
  }
  ```,
  caption: [Pseudocódigo de cómo dos dispositivos devuelven la misma estructura para la configuración eligiendo los
    periféricos adecuados a cada uno.],
  placement: auto,
)<cod_hardware>


=== Durante la ejecución
<sec_configuración_ejecución>

El módulo encargado de realizar la gestión de la configuración durante la ejecución es `ConfigManager`. Cada cierto
tiempo (por defecto, cada $5 "ms"$) procesa los eventos de configuración que van acumulando en su cola los periféricos y
la entrada MIDI, modificando el estado actual de la configuración.

Para propagar la configuración de forma eficiente, facilitando cumplir el @rnf_rendimiento, los cambios a la
configuración se transmiten al resto de módulos con una frecuencia menor a la que se usa para procesar los eventos, por
defecto cada $100 "ms"$. Se conecta al resto de módulos usando un `TripleBuffer`, permitiendo que `ConfigManager` nunca
se bloquee al escribir la nueva configuración y que el motor de síntesis nunca se bloquee al leerla.

La taza de muestreo y de actualización de la configuración son parte de los parámetros configurados con el archivo
`build.rs`, como se explica en la @sec_configuración_compilación.

==== Periféricos

Sparklet se puede configurar en la ejecución con dos botones y tres codificadores rotatorios, como indica el
@rf_configuración_periféricos. Para permitir modificar más de tres parámetros con los tres codificadores, se pagina la
configuración. Los botones permiten cambiar de página, y los codificadores modifican los valores de la página actual.

La tarea de lectura de periféricos es independiente del gestor de configuración. Lee los periféricos por muestreo, por
defecto cada $5 "ms"$ (otro parámetro configurable). Para los botones, mantiene una máquina de estado para aplicar
_debouncing_. Para los codificadores rotatorios, usa el driver `Qei` de Embassy. `Qei` configura un _timer_ del
microconrolador en modo de conteo de cuadratura, permitiendo que el hardware incremente o decremente un contador
automáticamente según la dirección de giro, sin intervención del CPU. Cuando detecta que se ha presionado un botón o que
ha habido un cambio a un codificador, envía el evento por una cola a `ConfigManager`.

==== MIDI

Sparklet también puede ser configurado en la ejecución con MIDI, como indica el @rf_configuración_midi. La lectura de
MIDI también se ejecuta en su propia tarea, como se explicará en detalle en la @sec_midi. Para esta sección es
suficiente saber que se encontrará con mensajes de _control change_ (CC), que permiten transmitir entre dispositivos 128
parámetros de control, con valores entre 0 y 127. Estos mensajes se usan directamente para controlar la configuración de
Sparklet, con el parámetro de control 102 correspondiendo al primer parámetro de la primera página, el 103 al segundo, y
así sucesivamente.
