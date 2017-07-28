---
title: "Shitposting en español: Cómo ser menos imbécil como programador"
description: Shitposting in Spanish because I can
tags: shitpost, spanish, programming
---

_I speak Spanish, though I almost never write in it. I thought I would shitpost
a bit in my native language._

_Antes de empezar a escribir esto, tenía bastantes ideas, pero, como suele ser
el caso, se me olvida todo, así que puede que vaya expandiendo esto con el
tiempo, o cree una Part 2, o algo._

# Introducción

Llevo un tiempo (tiempazo) sin escribir, tras un año bastante movido lleno de
movidas, y también frustraciones.

De las muchas frustraciones que se tiene en esta vida, donde más me las he
encontrado ha sido trabajando en proyectos variados con muchas personas con un
alto nivel (en otras palabras: _"rock stars"_ del momento). Algunas de
estas personas demostraban patrones de comportamiento similares unos entre los
otros, y yo, pensando que les debía respeto, los aguantaba. Pero no, la gente
demuestra los siguientes comportamientos no son dignos de aguantar.
Obviamente no digo que todos los de _cracks_ sean así, pero algunos tienen
un ego que no pasa ni por puerta doble.

##  Comportamientos de un/una imbécil

_Disclaimer: En algunos momentos yo también he sido culpable de algunos de estas
cosas, así que en cierto modo lo siguiente es autorreflexivo._

### No contesta la pregunta

Situación: Estás aprendiendo algo... digamos Javascript. Y te encuentras que
la función de jQuery `$.ajax` por defecto es asíncrona (claro, de ahí la primera
A, chato/a), pero estás haciendo pruebas y no te quieres rayar pensando en
comportamiento asíncrono, Promises, y whatever the fuck, así que te vas con tus
compis y preguntas

<div class="quote">
¡Hola! ¿Cómo puedo conseguir que `$.ajax` se comporte de manera síncrona? Grax
</div>

Pregunta inocente, sí, y sin embargo nada más me pone furioso que recibir
cualquiera de las siguientes respuestas:

<div class="error">
No quieres hacer eso.
</div>

<div class="error">
¿Para qué quieres hacer eso?
</div>

<div class="error">
Está en la docu.
</div>

Responder con cualquier variación de éstas indica en cierto modo que crees que
la persona que hace la pregunta no sabe lo que hace, o que no ha mirado la
documentación, cuando la realidad es que la mayoría de las veces sólo queremos
terminar alguna tarea, y todos tenemos nuestros días donde algo que estaba en
la documentación se nos pasa totalmente por alto. Y es cierto que `$.ajax` no
ha de ser usada de manera síncrona, y es cierto que está en la docu, pero una
mejor respuesta hubiese sido[^hacemildejavascript]

<div class="success">
```
$.ajax({
  async: false
})
```

Por cierto, sabes que se sugiere en contra de esta práctica, ¿no? Referencia:
_**enlace**_.
</div>

Así consigues dos cosas: Ayudar a la persona e informarles. Es una respuesta
con _señal_, y no con _ruido_.

#### Sin embargo

Lo que también es cierto es que a veces no hacemos las preguntas correctas,
y para ello creo que lo mejor es seguir [las recomendaciones de StackOverflow](https://stackoverflow.com/help/how-to-answer),
ellos saben cómo va lo de Q&A mejor que el 99% del resto del mundo.

### Piensa que todo el mundo ha de pasarlo igual de mal que él/ella alguna vez lo pasó

Situación: En mi primer trabajo, cuando entré, un mozo de 21 años, iluso
e inocente, teníamos un sistema ya complejo que había crecido a base de
necesidad y no de planificación. Creo que sólo las personas que lo han pasado
mal pueden entender esa última frase.

Cuestión: El primer día abro un flamante iMac de miles de euros, y me dicen

<div class="quote">
Sí, instala jEdit y el plugin de FTP, te contectas a esta URL y ya comienzas
a escribir.
</div>

Correcto: Con cada _Save_, subíamos el código **a producción**. El lejano oeste
nunca llegó a conocer este tipo de pistoleo. Claro que la cosa mejoró al poco
tiempo: instalando _svn_ y trabajando en un solo branch: _master_. Algo es algo,
supongo.

Tardaron años en llegar a escribir código en branches y a usar algo más sensato
como _git_, pero durante años lo pasamos mal, y al pasarlo mal algunos
comenzamos a adoptar una postura de "si yo lo he pasado mal, entonces todos
los nuevos que entren también han de pasarlo mal, porque mira qué bien salí
yo..."

**Incorrecto**. No fue hasta después de un tiempo y madurez que llegué a darme
cuenta que el trabajo que hacemos con el tiempo, lo pasemos mal o no, ha de
ayudar a quien viene detrás nuestro. Creo que el comportamiento descrito
anteriormente fomenta la exclusividad y no ayuda a la industria por un lado,
y a nuestros equipos por otro.

Cosas como documentación, código de pruebas, code reviews, _pair programmings_,
meetups donde enseñamos a los demás lo que hemos hecho y les contamos nuestras
batallas, etc, son todas cosas que dicen "Yo ya me peleé con esto para que
ustedes no tengan que hacerlo." Así vamos todos para adelante más rápido
y mejor.

... y más relajados, que están muy nerviosos todos:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I&#39;m excited to report working w/ good people who aren&#39;t pretending to be heros has chilled me the fuck out. Tech startup culture was toxic. <a href="https://t.co/avVuHeDHYR">pic.twitter.com/avVuHeDHYR</a></p>&mdash; Susan Potter (@SusanPotter) <a href="https://twitter.com/SusanPotter/status/875053968329760769">June 14, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

### Se cree estar por encima de estándares de la industria

Lo típico: Existe un fallo un tanto rarito por ahí pero que tiene solución
fácil a priori. Entonces viene el pistolero de turno con acceso de superusuario
y decide que va a cambiar el código de tal modo:

- Sin consultar con los autores del código
- Sin escribir pruebas para verificar
- Hacerlo a las 3am
- Subir directo a master
- Actualizar producción, porque seguro seguro no podía esperar

Y al siguiente día te encuentras una oficina de gente corriendo y gritando,
y te encuentras ahí modo

<img title="it's fine" src="/images/its-fine.jpg" width="100%" />

Este tipo de comportamiento es inaceptable y demuestra varios síntomas
bastante preocupantes:

- ¿Por qué alguien pudo en primer lugar hacer eso? Nadie es demasiado bueno
para un sistema de staging.
- ¿Por qué alguien pudo subir directo a master? Por defecto este branch ha
de ser protegido, nadie es demasiado bueno como para cambiar un sistema del que
depende nuestro salario así como así.
- Si alguien tenía derechos para subir a master, ¿no tenía mejor juicio?
Las versiones de producción son como son, con sus fallos y todo. Cuando vamos
a subir a producción tenemos que tener una certeza máxima de lo que hacemos y
de lo que cambiamos.

La lista no termina ahí, pero creo que queda claro.

## Fin del rant

_Hasta aquí llego hoy. Quizás después actualice. Maybe._

## Apuntes mierdecitas random

- Me he pasado a Emacs. It happened. Aunque seguiré considerándome _vimmer_
porque uso evil mode. O sea que estoy haciendo trampa. Hasta que no me duelan
los meñiques no diré que uso Emacs de manera seria.
- Estoy usando NixOS y es bastante divertido -- aunque a veces poco práctico, y
la documentación está regular. A veces el precio de ser hipster es caro :) -
Pero hey, que estoy contento.
- Me compré un monitor Ultrawide de 34 pulgadas. Es enorme. Demasiado. Pero,
¿y lo bonito que queda en un escritorio?
- Me terminé el último Zelda (Breath of the Wild) tras haber consumido los
últimos dos meses de mi vida. Juegazo: 100% recomendado.

## Escuchando

Esta gente es de Sydney... _¡Sydney!_, y parece un grupo de los 80 en Manchester
que viajó al futuro para salvarnos de la basura actual. Cracks. A veces uno que
otro guitarreo me recuerda a R.E.M. y a veces a The Smiths... no sé, movidas
mías.

<iframe src="https://embed.spotify.com/?uri=spotify%3Aalbum%3A2sDDN9iE5uBjtrujYHC1KL" width="100%" height="400" frameborder="0" allowtransparency="true"></iframe>

## Cambios a este post

Como siempre, pongo un enlace al historial de este fichero. [Aquí](https://github.com/carlosdagos/blog/commits/master/posts/2017-06-17-shitposting-en-espanol.markdown).

## Footnotes

[^hacemildejavascript]: Lo mismo me confundo con esto porque no soy mucho de
JS y hace mil que no lo escribo. Estoy intentando dar un ejemplo, relax.
