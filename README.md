# LaTeX

In diesem Repo speichere ich mein LaTeX Setup, das mittlerweile recht komplex ist. Es besteht aus folgenden Teilen:

## Automation
Wenn man das Skript Automate/automate.ps1 ausführt, wird jede Datei in einem Unterordner (z.B. VersuchE1; rekursiv) einer entsprechenden Unterordnername_generated.tex als import hinzugefügt und eine Unterorndername.tex auf dem Hauptordner erstellt, die als Hauptdatei verwendet werden sollte. 
 
 Wenn man das Skript in seinen Buildvorgang mit einbaut (vorher) wird so immer der ganze Ordner (in lexikografischer Ordnung) in das Hauptdokument eingebunden, ohne, dass man sich da Gedanken machen muss. Das ist für VSCode mit Tex Workshop schon in der .vscode Config eingestellt.
 
 Man kann Unterordner mit einer Datei namens .texignore ausnehmen (z.B. beim Erstellen von mehreren Versionen sinnvoll, oder um beim Rebuild nur das aktuelle Kapitel zu rendern)
 
 ## Befehle
 Die Befehle befinden sich in `./tex/latex`. Sie sind dort zum Teil dokumentiert oder sind selbsterklärend.
 => Siehe auch `./tex/latex/Dokumentation.md`
 
 
 Sie sind zum Teil in Form von Paketen, zum Teil in Form von tex-Dateien, die von der Dokumentenklasse geladen werden sollten.
 
 Der Einfachheit halber könnte man in seine MikTex-Installation (oder wahrscheinlich auch livetex) diesen Hauptornder als Quelle für Pakete festlegen.
 Ansonsten muss man bei der Dokumentenklasse die Option `PackagesByPath` angeben (was zu ignorierende Warnungen des Compilers erzeugen wird).
 
 
 ## Dokumentenklasse
 Um alles zusammenzufassen, gibt es eine Dokumentenklasse, `JHPreamble.cls`. Man bindet sie einfach mit `\documentclass[Optionen]{JHPreamble}` ein.
 Die Optionen, die definiert sind, kann man sich da anschauen.
 
 ## Pakete
 Es werden recht viele Pakete geladen, weshalb die Kompilierzeit leider recht hoch ist (~30s für mittelgroße Dokumente).
 Ein gutes Paket, das geladen wird, ist `unicode-math`, welches die Eingabe von Unicode erlaubt, wie es immer schon gewesen sein sollte! Es erfordert `lualatex` (oder `xelatex`, habe ich aber nicht getestet für mein Setup) als Compiler (schon eingestellt in VSCode).
 
 ## Schriftarten
 Da es leider nicht viele gute vollständige Mathe-Fonts für unicode-math gibt, habe ich diese schon da, man kann ein paar mit Optionen der Dokumentenklasse auswählen. 
 Für den Text verwende ich die Adobe Schriftarten Minion Pro (Serifen) und Myriad Pro (sans serif). Diese gibt es zwar als gute Mathe-Fonts, die sind aber teuer!
 
 
 
