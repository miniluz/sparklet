#import "/utils/tfc_template.typ": *
#import "/utils/requirements.typ": req, req-ids, setup-reqs

#show: setup-reqs

#import "@preview/zero:0.6.1": num, set-group, set-num

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

== MIDI
<sec_midi>

El protocolo MIDI es un estándar para transmitir información de control entre dispositivos musicales @ref_web_midi
@ref_book_music_tutorial. En lugar de transmitir una señal de audio, transmite eventos, como tocar o soltar una nota, o
los mensajes de control change (CC), que como se mencionó en la @sec_configuración_ejecución permiten configurar
Sparklet.

Para gestionarlo se usa el `struct` `MidiListener`. Expone un método `process_bytes` que recibe un vector de bytes y lo
procesa usando la biblioteca `midly`. Cuando se identifica un evento MIDI, `MidiListener` lo envía al `VoiceBank` por un
canal con descarte, que este procesa como se explica en la @sec_procesado_midi.
#footnote[Una conexión MIDI por el puerto DIN puede producir como mucho $2000$ mensajes compatibles por segundo, y
  Sparklet puede consumir hasta $16000$. En la práctica la cola nunca se llena.]

Sparklet admite una conexión MIDI tanto por un puerto DIN, usando UART, como por USB, como indican el @rf_midi_din y el
@rf_midi_usb. En ambos casos, se consiguen los bytes de los mensajes MIDI y se envían a `MidiListener`. La conexión de
`MidiListener` con otros módulos se puede ver representada en la @fig_midi_listener.

#figure(
  image("/figures/MIDI.drawio.pdf", width: 75%),
  caption: [`MidiListener` recibe bytes de la entrada, sea por DIN o USB, y pasa los eventos al `VoiceBank` por una cola
    con descarte.],
  placement: auto,
)<fig_midi_listener>

`Sparklet` únicamente es compatible con los eventos MIDI `NoteOn`, `NoteOff` y `Controller` (CC). El resto de eventos se
descartan antes de ser enviados por el canal, para evitar procesamiento innecesario.
#footnote[Un dispositivo MIDI puede ignorar los mensajes con los que no es compatible @ref_web_midi.]
El protocolo MIDI acepta mensajes de extensión del sistema (SysEx) de longitud arbitraria y contenido definido por el
fabricante. Al asignar a `midly` un buffer de 4 bytes, suficiente para los eventos con los que Sparklet es compatible
@ref_web_midi, se evita procesar cualquier mensaje de tamaño superior al buffer, ahorrando memoria.

La fiabilidad del módulo de `midly` es fundamental, pues es el único módulo escrito para este proyecto que consume
directamente datos externos. La implementación ha de considerar que se puede encontrar con mensajes erróneos, con ruido,
o incluso maliciosos, y los ha de gestionar correctamente para cumplir el @rnf_fiabilidad. Por lo tanto, este fue uno de
los módulos más probados. Su resistencia a errores fue validada: funciona correctamente incluso tras haber recibido mil
bytes de datos aleatorios.
