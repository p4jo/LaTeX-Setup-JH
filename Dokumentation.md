# Dokumentation zu JHPreamble

`\documentclass{JHPreamble}` lädt die sehr gute KOMA-Script-Klasse `scrreprt`, oder mit der Option `Presentation` die Klasse für Bildschirmpräsentationen, `beamer`.

Es verwendet `unicode-math`, damit man griechische Buchstaben, und so ziemlich alle Unicode-Symbole nativ eingeben kann (z.B. mit Tastaturmakros), was den Quellcode übersichtlicher macht. 

Es werden auch schöne Fonts (im OpenType Format, das viel übersichtlicher und moderner als das klassische `T1` Format ist (und für `unicode-math` erforderlich ist)) geladen, wobei eine kleine Auswahl besteht, siehe die Datei `src/Fonts.tex` und der Ordner `fonts/opentype`.

Es (bzw. das Paket `JHGeneralCommands`) führt ein paar vereinfachende Befehle ein, die im folgenden erklärt werden.

Leider lädt mit der Präambel LaTeX lange, da es viele Pakete schon lädt. Als Compiler muss `LuaLaTeX` oder `XeLaTeX` verwendet werden (`XeLaTeX` wird nicht regelmäßig getestet).


## Grafiken
Der `\Grafik`-Befehl
### USAGE (voll):
` \Grafik[Breite]{Label}{Text}{Dateipfad}(unterFußnote)<Seite>|LastFrame|[Framerate]`

`\autoref{Label}` erzeugt dann Link mit "Abb. 3.4" o.Ä.

Nur eines von `<Seite>` und `|LastFrame|`

BEISPIEL: `\Grafik[0.7]{F.Baum}{Foto von einem Baum}{./Bäume/Baum}(Von \url{baum.de})<3>`

BEISPIEL: `\Grafik[0.7]{F.Tree}{Picture of a tree}{./Bäume/Birken/Baum33_jwkj.jpg}(From \url{baum.de})`

### USAGE (kurz): 
`\Grafik[Breite]{Name}{Text}(unterFußnote)<Seite>|LastFrame|`

Äquivalent zu \Grafik[{Breite}]{F.{Name}}{{Text}}{/{Ordner dieses Projekts}/{Name}}({unterFußnote})<{Seite}>|{LastFrame}|`


BEISPIEL (Minimal): `\Grafik{Baum}{Foto von einem Baum}`
(äquivalent zu `\Grafik{F.Baum}{Foto von einem Baum}{/Bäume/Baum}`)

### USAGE (Bewegte Grafik):
 Wenn man den |LastFrame| Wert angibt, wird eine bewege Grafik aus den Bildern {Dateipfad}1,{Dateipfad}2, ... , {Dateipfad}{LastFrame} gemacht. (.gif s müssen erst umgewandelt werden)

 Die Framerate kann noch angepasst werden mit `|LastFrame|[Framerate]`  (Standard 12)

### USAGE (genau hier!): 
Wenn man nach allen Optionen einen Stern angibt, wird H als Platzierungsoption verwendet, KOMA-Script mag aber die Verwendung von `float`, was man dafür braucht, nicht.

Um die Warnung zu vermeiden, gibt es die Klassen-Option `omitFloat`.

## Gleichungen
### USAGE (mit Label):
```
\Gleichung{Label}$
    Formel
$ 
```
Der `\Gleichung`-Befehl erzeugt eine abgesetze Matheformel, die statt einer Nummer {Label} als Beschriftung hat und mehrzeilig sein kann (verwendet eine `split`-Umgebung). Die Zeilen werden standardmäßig rechts-aligned, aber durch `&` lässt sich die Gleichung selbst alignen.

Kommas `,` und Punkte `.` nach dem Befehl werden erkannt und in die Gleichung hereingesaugt, damit keine Zeile versehentlich mit einem Satzzeichen beginnt.

Man kann eine Inline-Matheformel also einfach mit `\Gleichung*` präfixen und schon ist sie eine abgesetze Formel und unterstützt mehrere Zeilen.

`\autoref{G.{Label}}` erzeugt dann Link mit "Gleichung {Label}", `\ref{G.{Label}}` erzeugt Link mit {Label}.

BEISPIEL: `\Gleichung{Produktregel}$    \fa{a,b \in \algstr A} D(a·b) = D(a)·b + a·D(b).$`
...
Hier verwenden wir die \ref{G.Produktregel}...


### USAGE (ohne Label): 
```
\Gleichung*$
        f(x) \gegen{x}{x_0} F 
        &\dgdw
        \fa{ε>0} \ex{δ>0} 
            B_δ^{X}(x_0)\TeilM f\invM(B_ε^{X'}(F)) 
        \\
        &\gdw 
        \fa{ε>0} \ex{δ>0} \fa{x \in X} (
            d(x,x_0) <\delta ⇒ d'(f(x),F) < ε
        )
    $
```
Man kann in der gesternten Version immer noch `{Label}` angeben, aber `\autoref{G.{Label}}` bezieht sich dann auf das Umgebende (Abschnitt etc.).

## Klassen-Optionen

* `Presentation` lädt die `beamer`-Klasse statt `scrreprt`
* `simpleTitle` erstellt eine Titel-Seite mit Titel, Autor und Datum (das jeweils aktuelle)
* `STIX` lädt die Schriftart `STIX2Math` statt `XITS-Math`
* `KpMath` lädt diese Schriftart
* `StandardMathFonts` unterdrückt das Laden von eigenen Fonts
* `StandardTextFonts` unterdrückt das Laden der `Minion Pro` und `Myriad Pro` Schriftarten für den Text
* `author` setzt den Autor (für die pdf-Metadaten und in `\author`),
* `title` setzt den Autor (für die pdf-Metadaten und in `\title`),

Für Namen mit mehr als einem Wort braucht man einen Befehl, d.h. 
```
    \newcommand\AUTHOR{Walter Heisenberg}
    \newcommand\TITLE{Die Myalgiomorphose der Cyantrophoziten}
    \documentclass[author=\AUTHOR,title=\TITLE]{JHPreamble}
```
* Optionen der Klasse `scrreport` bzw. `beamer` werden weitergereicht
## Sonstiges

Die Befehle von `JHPreamble` sind in `JHGeneralCommands`, `JHMathCommands` und `JHPhysicsCommands` definiert, Pakete, die auch ohne die Präambel geladen werden können. In den Dateien steht oft eine kurze Erläuterung der Funktion dabei, für eine Liste von Befehlen einfach durchscrollen.

Es werden weitere Pakete mitgeliefert: 
* `JHGreekLetters`, das mit `unicode-math` obsolet ist,
*  `JHIdealSymbols`, in dem `\triangleleft`-Varianten definiert sind (für Primideale, maximale Ideale, etc.),
* `JHTensors`, das verschiedene Pfeile über Buchstaben definiert, aber leider auch Probleme macht.
* `JHUnderlines`, das eigentlich nicht von mir ist, das eine interessante Unterstreichung definiert.

## TODO 
* Definition-, Satz-, Lemma-, ... Umgebungen fehlen noch.
* Vielleicht diese Dokumentation noch weiter schreiben (vielleicht TeXen)