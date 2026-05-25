#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

== Manual
<sec_manual>

Para que Sparklet pueda ser instalado y usado por usuarios menos técnicos, incluye un manual acorde al @rnf_manual.

Se usó como referencia el sistema de estructuración de documentación propuesto por Diátaxis @ref_web_diátaxis. Se usan
dos de las cuatro categoría propuestas:

- Las guías _how-to_ son documentos cuyo objetivo "dar direcciones que guían al lector para resolver un problema o
  conseguir un resultado." Son prácticos y específicos. Está escrito, como indica Diátaxis, desde la perspectiva del
  usuario y el problema a resolver, no el sistema. A continuación, se provee una guía de instalación y uso del sistema.

- Las referencias son descripciones técnicas de la herramienta. Contienen conocimiento teórico y descriptivo. Están
  escritas con el fin de que el lector salte a la parte que le es relevante cuando tenga la necesidad, no para leerse de
  principio a fin. Sus definiciones deben ser cortas, claras, neutras y autoritativas.


Se compone de tres partes, listadas a continuación usando "guía" para referirse a guías how-to escritas según recomienda
Diátaxis y "referencia" del mismo modo:

+ Introducción, con un listado de las características de Sparklet.
+ Guía de instalación y uso.
+ Sección sobre el desarrollo.
  - Explicación de lo que se espera de las contribuciones al proyecto
  - Guía de obtención del entorno de desarrollo del proyecto.
  - Guía para añadir soporte a un nuevo dispositivo.
  - Referencia de la estructura del repositorio.
  - Referencia de las herramientas disponibles en el entorno de desarrollo.

Aparte de estar incluido en el código fuente de Sparklet como documentos Markdown en
#box[https://github.com/miniluz/sparklet/tree/main/sparklet/manual/], está disponible en línea en
#box[https://blog.miniluz.dev/sparklet/].
