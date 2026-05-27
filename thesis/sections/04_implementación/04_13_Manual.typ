#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Manual
<sec_manual>

Para que Sparklet pueda ser instalado y usado por usuarios menos técnicos, incluye un manual, de acuerdo al @rnf_manual.

Se usó como referencia el sistema de estructuración de documentación propuesto por Diátaxis @ref_web_diátaxis. Se usan
dos de las cuatro categoría propuestas:

- Las guías _how-to_ son documentos cuyo objetivo es "dar direcciones que guían al lector para resolver un problema o
  conseguir un resultado." Son prácticos y específicos. Está escrito, como indica Diátaxis, desde la perspectiva del
  usuario y del problema a resolver, no del sistema.

- Las referencias son descripciones técnicas de la herramienta. Contienen conocimiento teórico y descriptivo. No están
  escritas para ser leídas de principio a fin, sino para el lector salte a la parte que le es relevante cuando tenga la
  necesidad. Sus definiciones deben ser cortas, claras, neutras y autoritativas.


Se compone de tres partes, listadas a continuación. Se usa "guía" para referirse a guías how-to escritas según
recomienda Diátaxis y "referencia" del mismo modo.

+ Introducción, con un listado de las características de Sparklet.
+ Guía de instalación y uso.
+ Sección sobre el desarrollo.
  - Explicación de lo que se espera de las contribuciones al proyecto
  - Guía de obtención del entorno de desarrollo del proyecto.
  - Guía para añadir compatibilidad con nuevo dispositivo.
  - Referencia de la estructura del repositorio.
  - Referencia de las herramientas disponibles en el entorno de desarrollo.

Aparte de estar incluido en el código fuente de Sparklet en formato Markdown, disponible en
#box[https://github.com/miniluz/sparklet/tree/main/sparklet/manual/], está disponible en línea en el enlace
#box[https://blog.miniluz.dev/sparklet/].
