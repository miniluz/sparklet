#import "/utils/tfc_template.typ": *

== Metodología del desarrollo
<sec_metodología_del_desarrollo>

El proyecto comenzó con un análisis de los competidores para hacer una recogida de las funcionalidades que Sparklet
podría tener. Las funcionalidades elegidas y el resto de requisitos del proyecto fueron divididos en _sprints_,
inspirados por la metodología ágil @ref_web_manifiesto_ágil, como se explicará en detalle en la siguiente sección.

Como política de ramas, los commits se hacen directamente sobre `main`. Al ser un proyecto en el que sólo trabaja un
desarrollador, no se considera necesario usar otras ramas. Usando _workflows_ de GitHub Actions se valida cada _push_
que el código compila, que todas las pruebas pasan, que el formato del código es correcto, y que no hay errores
ortográficos en el documento.

En cuanto a la política de _commits_, se realizan commits unitarios, es decir, cada commit corresponde al paso de una
versión funcional del código a otra. El mensaje del commit es una descripción corta de los cambios realizados en él.
Nuevamente, al ser un proyecto con un sólo desarrollador, no se considera necesario usar una política más compleja.

=== Estrategia de pruebas
<sec_estrategia_de_pruebas>

Las pruebas se realizan de manera paralela al desarrollo, con las funcionalidades siendo probadas mientras se
implementan. El proyecto usa tres tipos de pruebas:

+ Los generadores de código imprimen a `stderr` comprobaciones de la validez del código que generan, que son revisadas
  manualmente al ejecutarlos. Por ejemplo, para validar la onda de seno, se muestran el nivel de algunas muestras junto
  a sus valores esperados, como que el nivel de la primera muestra es 0. Estas son revisadas manualmente al ejecutar la
  tabla.

+ La lógica de los módulos del proyecto se somete a pruebas unitarias y ocasionalmente de integración, dependiendo de la
  necesidad según el criterio del desarrollador. Se intenta generar la mínima cantidad de pruebas que garanticen la
  funcionalidad del sistema. Al momento de probar la salida de audio y otros componentes similares, se prueban las
  propiedades del sistema en lugar de la salida en sí misma. Por ejemplo, para validar el oscilador, se estima la
  frecuencia con cruces por cero y se compara con la esperada. Estas son ejecutadas automáticamente antes de hacer un
  commit, además de en un workflow de GitHub Action cada vez que se hace push.

+ Desde que el sintetizador ha sido capaz de leer MIDI y transmitir audio por USB, ha sido probado manualmente en la
  placa de desarrollo manualmente para verificar su funcionamiento continuado de forma regular. Además de hacerse de
  forma regular, Se hace de forma regular durante el desarrollo, se realiza una prueba rigurosa manual de toda la
  funcionalidad al final de cada sprint.
