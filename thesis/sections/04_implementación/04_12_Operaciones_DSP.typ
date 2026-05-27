#import "/utils/tfc_template.typ": *
#import "@preview/zero:0.6.1": num, set-group, set-num
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

#set-num(decimal-separator: ",")
#set-group(
  size: 3,
  separator: sym.space.thin,
  threshold: 5,
)

#show math.equation: it => {
  show regex(`\d+(?:\.\d+)?`.text): it => {
    num(it)
  }
  it
}

== Operaciones DSP
<sec_operaciones_dsp>

Para realizar operaciones DSP de forma eficiente, como pide el @rnf_rendimiento, se usa la biblioteca CMSIS-DSP, y se
usan números en formato Q15 siempre que sea posible. En concreto, se usa la biblioteca `cmsis_dsp` de Rust, que
proporciona _bindings_ para CMSIS-DSP. Por cada función incluída en la biblioteca original, se proporciona una función
en Rust que la llama. Ya que faltaban algunas funciones necesarias para Sparklet, se hizo un fork de la biblioteca para
añadir los bindings.

Como se mencionó en la @sec_inst_dsp, Sparklet usa una interfaz llamada `CmsisOperations` con dos implementaciones: una
basada en Rust (que puede ejecutarse en cualquier plataforma compatible, incluyendo `x86_64`) y una basada en
`cmsis_dsp` (que únicamente puede ejecutarse en un chip ARM @ref_web_cmsis_dsp). Con esta interfaz, cada componente
(oscilador, ADSR, ecualizador, etc.) puede depender de `CmsisOperations` y ser ejecutable en ambas plataformas. Así
pues, casi todo el código puede ser sometido a una batería de pruebas automáticas ejecutable en el ordenador de
desarrollo automáticamente y en los workflows de GitHub Actions, permitiendo cumplir el @rnf_pruebas.

Para validar que ambas implementaciones son idénticas, se creó una batería de pruebas que se ejecuta en ambas. La
implementación en Rust usa el mecanismo estándar de pruebas del lenguaje. La que usa `cmsis_dsp` usa `embedded-test`,
una biblioteca que para ejecutar pruebas en un sistema empotrado @ref_web_rust_embedded_test. Estas pruebas están
definidas en el módulo `cmsis_interface` con una macro, para garantizar que se ejecutan las mismas pruebas en ambas.

La implementación usando una interfaz no tiene un coste de rendimiento el en sintetizador, por lo que esta abtrascción
no obstaculiza el @rnf_rendimiento. Esto se debe a que Rust permite implementar tipos genéricos usando
_monomorfización_, sin perjudicar el rendimiento (en lugar de, por ejemplo, usando una tabla de métodos virtuales). Dada
una función #box[`f<T>(arg: T)`] con un tipo genérico `T`, si se llama con los tipos concretos `A` y `B`, se generan dos
implementaciones de la función: #box[`f(arg: A)`] y #box[`f(arg: B)`] @ref_web_rust_generics. En Sparklet, si se define
una función #box[`f<CmsisOperations>()`], ya que el ejecutor de Sparklet únicamente la llama con
`CmsisNativeOperations`, el binario compilado únicamente contendrá la función `f()` usando `CmsisNativeOperations`,
generada automáticamente por el compilador, sin perjudicar el rendimiento.

#pagebreak()

=== Rendimiento

Se midió experimentalmente el tiempo que tarda el motor de síntesis en calcular un bloque de audio de un milisegundo en
el sintetizador, usando la implementación de `CmsisOperations` basada en Rust y la basada en CMSIS-DSP, con 8 voces. Se
realizaron las medidas con el sintetizador siendo ejecutado en su totalidad, como se explica en la
@sec_rendimiento_generador. Como se puede ver en la @fig_con_sin_cmsis, el cálculo de un bloque con el ecualizador sin
CMSIS-DSP toma $713 "µs"$, y con él toma $557 "µs"$. Usar CMSIS-DSP ahorra $156 "µs"$, el $#num(digits: 1, 15.6)%$ del
tiempo disponible, suponiendo una mejora del $22%$. Sin el ecualizador, el cálculo sin CMSIS-DSP toma $606 "µs"$ y con
él toma $517 "µs"$. Usarlo ahorra $89 "µs"$, el $#num(digits: 1, 8.9)%$ del tiempo disponible, suponiendo una mejora del
$15%$.

#v(1cm)

#figure(
  image("/figures/con_vs_sin_cmsis.png", width: 90%),
  caption: "Duración del cálculo de un bloque de audio con y sin CMSIS-DSP, incluyendo y sin incluir el ecualizador.",
)<fig_con_sin_cmsis>
