
#import "/utils/tfc_template.typ": *
#import "/utils/datos_sprints.typ": horas_estimadas, horas_reales

== Planificación
<sec_planificación>

Como se mencionó en la sección anterior, se ha estructurado en sprints. Sin embargo, ha sido adaptado a las necesidades
del proyecto: por ejemplo, hay un Sprint 0 para el planteamiento del proyecto, un Sprint 1 para su planificación, y un
Sprint 2 para aprender sobre el desarrollo empotrado y evaluar la viabilidad del ecosistema de desarrollo para el
proyecto. Cada sprint corresponde a dos semanas, estimando dos horas de trabajo por día, ignorando las vacaciones.
Además, se planificaron hitos, representando momentos en los que se consigue un paso en el proyecto.

Los sprints, su objetivo principal y las fechas en las que está se puede ver en la @tabla_sprints_objetivos. Se pueden
ver los hitos en la @tabla_hitos. La descripción detallada del trabajo realizado en cada sprint se puede ver en la
@tabla_sprints_descripciones. El tiempo de trabajo estimado y dedicado a cada sprint se puede ver en la
@tabla_sprints_tiempos. Finalmente, se representan los sprints como diagramas de Gantt en la @fig_gantt_antes_navidad y
@fig_gantt_después_navidad.

=== Desviaciones
<sec_desviaciones>

En general, ha habido una tendencia a no llegar a las horas estimadas en las etapas medias del proyecto y a sobrepasar
las horas estimadas en la etapa final del proyecto. Esto es debido a subestimar el esfuerzo de realizar la memoria. Se
comenta en más profundidad en la @sec_lecciones_aprendidas.

#include "/tables/tabla_sprints_objetivos.typ"
#pagebreak()
#include "/tables/tabla_hitos.typ"
#include "/tables/tabla_sprints_tiempos.typ"
#pagebreak()
#include "/tables/tabla_sprints_descripciones.typ"
#pagebreak()

#include "/figures/diagrama_gantt.typ"

#pagebreak()
