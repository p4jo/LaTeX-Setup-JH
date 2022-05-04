# LaTeX

In diesem Repo speichere ich mein LaTeX Setup, das mittlerweile recht komplex ist. 

Die Dokumentation findet sich in diesem Repository.

Es besteht aus folgenden Teilen:

 
## Befehle
Die Befehle befinden sich in `./tex/latex`. Sie sind dort zum Teil dokumentiert oder sind selbsterklärend.
=> Siehe auch `./tex/latex/Dokumentation.md`


Sie sind zum Teil in Form von Paketen, zum Teil in Form von tex-Dateien, die von der Dokumentenklasse geladen werden sollten.



## Dokumentenklasse
Um alles zusammenzufassen, gibt es eine Dokumentenklasse, `JHPreamble.cls`. 

Man bindet sie einfach mit `\documentclass[Optionen]{JHPreamble}` ein.

Für die Optionen, siehe Dokumentation.

Es werden recht viele Pakete geladen, weshalb die Kompilierzeit leider recht hoch ist (~30s für mittelgroße Dokumente).

Ein gutes Paket, das geladen wird, ist `unicode-math`, welches die Eingabe von Unicode erlaubt, wie es immer schon gewesen sein sollte! Es erfordert `lualatex` (oder `xelatex`, habe ich aber nicht getestet für mein Setup) als Compiler.

## Pakete


## Schriftarten
Da es leider nicht viele gute vollständige Mathe-Fonts für unicode-math gibt, habe ich diese schon da, man kann ein paar mit Optionen der Dokumentenklasse auswählen. 
Für den Text verwende ich die Adobe Schriftarten Minion Pro (Serifen) und Myriad Pro (sans serif). Diese gibt es zwar als gute Mathe-Fonts, die sind aber teuer!

# Installation/Verwendung

Klone dieses Repo (vgl. auch andere Tools unten) mit `git clone` irgendwohin.

Wenn du es in den Hauptordner einbinden willst:
```
git clone https://github.com/p4jo/LaTeX-Setup-JH <Hauptordner>/Setup
    oder
git submodule add https://github.com/p4jo/LaTeX-Setup-JH <Hauptordner>/Setup
```
(je nachdem, ob dein Hauptordner schon ein Repository ist)

## Bester Weg

Füge den Ordner dieses Repositorys (wo auch diese Datei liegt) als Suchpfad in deiner LaTeX-Installation hinzu.

* In `MiKTeX` geht das ganz einfach: MiKTeX-Konsole öffnen ↦ Einstellungen ↦ Verzeichnisse ↦ mit `+` `<diesen Pfad>` hinzufügen. 

* In `livetex` kenne ich mich nicht aus, da könnte das schwieriger sein! (Verwende Google)

## Alternative
Gebe die Dokumentenklasse mit `\documentclass[PackagesByPath, ...]{<dieser Pfad>/tex/latex/JHPreamble}` an und entweder 
* auch noch die Klassen-Option `SetupPath=<dieser Pfad>` (wenn er Leerzeichen enthält muss er warhscheinlich in einem Befehl gekapselt werden, vgl. Dokumentation zu `author` und `title`),
* tue nichts. Es sollte mittlerweile gehen. Im Zweifelsfall schaue, dass `<dieser Pfad>` absolut ist.

Der Pfad zu diesem Repository sollte hierfür keine LaTeX-aktiven Zeichen enthalten (`$`,`%`,`&`, ...), am besten keine doppelten Leerzeichen und was weiß ich sonst noch für Einschränkungen. 

# Weitere Teile meines Setups

## Einstellungen für Visual Studio Code als LaTeX-Editor (mit `LaTeX-Workshop`)

In [LaTeX-.vscode](https://github.com/p4jo/LaTeX-.vscode) befinden sich die entsprechenden Einstellungen. 

Einbinden in den Hauptordner mit 
```
git clone https://github.com/p4jo/LaTeX-.vscode <Hauptordner>/.vscode
    oder
git submodule add https://github.com/p4jo/LaTeX-.vscode <Hauptordner>/.vscode
```

In VSCode verwende ich die Extension [LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop) - siehe da für eine Einführung. Erwäht sei nur der SyncTex-Support (Strg+Klick im pdf bzw. Strg+Alt+j im Quellcode springt zum jeweiligen Punkt).
 
## Automation
In meinem Repository [LaTeX-Automate](https://github.com/p4jo/LaTeX-Automate.git) befindet sich ein Powershell-Skript zur Automation von \input{}.

Wenn man das Skript Automate/automate.ps1 ausführt, wird jede Datei in einem Unterordner (rekursiv) einer entsprechenden <Unterordnername>_generated.tex als import hinzugefügt und eine <Unterordnername>.tex in dem Unterordner erstellt, die als Hauptdatei verwendet werden sollte. 

Wenn man das Skript in seinen Buildvorgang mit einbaut (vorher) wird so immer der ganze Ordner (in lexikografischer Ordnung) in das Hauptdokument eingebunden, ohne, dass man sich da Gedanken machen muss. Das ist für VSCode mit Tex Workshop schon in der .vscode Config eingestellt.

Man kann Unter-Unterordner mit einer Datei namens .texignore ausnehmen (z.B. beim Erstellen von mehreren Versionen sinnvoll, oder um beim Rebuild nur das aktuelle Kapitel zu rendern).
