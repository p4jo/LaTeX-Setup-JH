# Dokumentation zu JHPreamble

`\documentclass{JHPreamble}` lädt die sehr gute KOMA-Script-Klasse `scrreprt`, oder mit der Option `Presentation` die Klasse für Bildschirmpräsentationen, `beamer`.
Es verwendet `unicode-math`, damit man griechische Buchstaben, und so ziemlich alle Unicode-Symbole nativ eingeben kann (z.B. mit Tastaturmakros), was den Quellcode übersichtlicher macht. Es werden auch schöne Fonts (im OpenType Format, das viel übersichtlicher und moderner als das klassische Format ist) geladen, wobei ein kleine Auswahl besteht, siehe die Datei `Fonts.tex` und der Ordner `fonts`.

Es (bzw. das Paket `JHGeneralCommands`) führt ein paar vereinfachende Befehle ein, die im folgenden erklärt werden.

Leider lädt mit der Präambel LaTeX lange, da es viele Pakete schon lädt. Als Compiler muss `LuaLaTeX` verwendet werden (`XeLaTeX` wurde nicht getestet).


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

 Die Framerate kann noch angepasst werden mit |LastFrame|[Framerate]  (Standard 12)

### USAGE (genau hier!): 
Wenn man nach allen Optionen einen Stern angibt, wird H als Platzierungsoption verwendet, KOMA-Script mag aber die Verwendung von `float`, was man dafür braucht, nicht. Um die Warnung zu vermeiden, gibt es die Option omitFloat.

## Gleichungen
Der `\Gleichung`-Befehl
### USAGE (mit Label):
```
\Gleichung{Label}$
    Formel
$ 
```
Erzeugt abgesetze Matheformel, die statt einer Nummer {Label} als Beschriftung hat und mehrzeilig sein kann (verwendet eine `split`-Umgebung).


`\autoref{G.{Label}}` erzeugt dann Link mit "Gleichung {Label}" o.Ä.

BEISPIEL: `\Gleichung{Produktregel}$    \fa{a,b \in \algstr A} D(a·b) = D(a)·b + a·D(b).$`


### USAGE (ohne Label): 
```
\Gleichung*$
        f(x) \gegen{x}{x_0} F &\gdw \fa{ε>0} \ex{δ>0} B_δ^{X}(x_0)\TeilM f\invM(B_ε^{X'}(F)) \\
        &\gdw \fa{ε>0} \ex{δ>0} \fa{x \in X} (d(x,x_0) <\delta ⇒ d'(f(x),F) < ε)
    $
```
Man kann in der gesternten Version immer noch `{Label}` angeben, aber `\autoref{G.{Label}}` bezieht sich dann auf das Umgebende (Abschnitt etc.).

## Präambel-Optionen

* `simpleTitle`

## Sonstiges

Die Befehle von `JHPreamble` sind in `JHGeneralCommands`, `JHMathCommands` und `JHPhysicsCommands` definiert, Pakete, die auch ohne die Präambel geladen werden können. In den Dateien steht oft eine kurze Erläuterung der Funktion dabei, für eine Liste von Befehlen einfach durchscrollen.

Es werden weitere Pakete mitgeliefert: 
* `JHGreekLetters`, das mit `unicode-math` obsolet ist,
*  `JHIdealSymbols`, in dem so verzierte `\triangleleft`-Varianten definiert sind,
* `JHTensors`, das verschiedene Pfeile über Buchstaben definiert, aber leider auch Probleme macht.
* `JHUnderlines`, das eigentlich nicht von mir ist, das eine interessante Unterstreichung definiert.

## TODO 
* Definition-, Satz-, Lemma-, ... Umgebungen fehlen noch.
* Vielleicht diese Dokumentation noch weiter schreiben (vielleicht TeXen)