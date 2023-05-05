# Documentation for JHPreamble

`\documentclass{JHPreamble}` loads the very good KOMA-Script class `scrreprt`, or with the option `Presentation` the class for slide shows, `beamer`.

It uses `unicode-math` so that you can type Greek letters and pretty much any Unicode symbol natively (e.g. with keyboard macros), making the source code cleaner.

Nice fonts (in OpenType format, which is much cleaner and more modern than the classic `T1` format (and required for `unicode-math`)) are also loaded, with a small selection, see the `src/Fonts .tex` and the `fonts/opentype` folder.

It (or the `JHGeneralCommands` package) introduces a few simplifying commands, which are explained below.

Unfortunately, LaTeX takes a long time to load with the preamble because it already loads many packages. `LuaLaTeX` or `XeLaTeX` must be used as compiler (`XeLaTeX` is not regularly tested).


## graphics
The `\Graphics` command
### USAGE (full):
` \graphic[width]{label}{text}{filepath}(below footnote)<page>|lastframe|[framerate]`

`\autoref{Label}` then creates a link with "Fig. 3.4" or similar.

Just one of `<Page>` and `|LastFrame|`

EXAMPLE: `\Graphics[0.7]{F.Tree}{Photo of a tree}{./Trees/Tree}(From \url{tree.de})<3>`

EXAMPLE: `\Graphic[0.7]{F.Tree}{Picture of a tree}{./Bäume/Birken/Baum33_jwkj.jpg}(From \url{baum.de})`

### USAGE (short):
`\Graphic[width]{name}{text}(below footnote)<page>|LastFrame|`

Equivalent to `\Graphic[{width}]{F.{name}}{{text}}{/{folder of this project}/{name}}({below footnote})<{page}>|{LastFrame}|`


EXAMPLE (Minimal): `\Graphics{tree}{photo of a tree}`
(equivalent to `\Graphic{F.Tree}{photo of a tree}{/trees/tree}`)

### USAGE (Motion Graphics):
  If you use the |LastFrame| value, a motion graphic is made from frames {filepath}1,{filepath}2, ... , {filepath}{LastFrame}. (.gif s have to be converted first)

  The framerate can still be adjusted with `|LastFrame|[Framerate]` (default 12)

### USAGE (right here!):
If you put an asterisk after all options, H is used as the placement option, but KOMA-Script doesn't like using `float`, which is what you need for that.

To avoid the warning there is a class option `omitFloat`.

## equations
### USAGE (with label):
```
\Equation{Label}$
     formula
$
```
The `\Equation` command creates a separate math formula, which has a label of {Label} instead of a number and can be multi-line (uses a `split` environment). The rows are right-aligned by default, but you can use `&` to align the equation itself.

Commas `,` and periods `.` after the command are recognized and sucked into the equation so that no line accidentally begins with a punctuation mark.

So you can just prefix an inline math formula with `\Equation*` and it's a remote formula and supports multiple lines.

`\autoref{G.{Label}}` then creates link with "equation {label}", `\ref{G.{Label}}` creates link with {label}.

EXAMPLE: `\Equation{product rule}$ \fa{a,b \in \algstr A} D(a b) = D(a) b + a D(b).$`
...
Here we use the \ref{G.product rule}...


### USAGE (unlabeled):
```
\Equation*$
         f(x) \vs{x}{x_0} F
         &\dgdw
         \fa{ε>0} \ex{δ>0}
             B_δ^{X}(x_0)\PartM f\invM(B_ε^{X'}(F))
         \\
         &\possibly
         \fa{ε>0} \ex{δ>0} \fa{x \in X} (
             d(x,x_0) <\delta ⇒ d'(f(x),F) < ε
         )
     $
```
You can still specify `{Label}` in the yesterday's version, but `\autoref{G.{Label}}` then refers to the surrounding (section etc.).

## class options

* `Presentation` loads the `beamer` class instead of `scrreprt`
* `simpleTitle` creates a title page with title, author and date (whichever is current)
* `STIX` loads the font `STIX2Math` instead of `XITS-Math`
* `KpMath` loads this font
* `StandardMathFonts` suppresses the loading of custom fonts
* `StandardTextFonts` suppresses loading of the `Minion Pro` and `Myriad Pro` fonts for the text
* `author` sets the author (for the pdf metadata and in `\author`),
* `title` sets the title (for the pdf metadata and in `\title`),

For names with more than one word you need a command, i.e.
```
     \newcommand\AUTHOR{Walter Heisenberg}
     \newcommand\TITLE{The Myalgiomorphosis of Cyantrophocites}
     \documentclass[author=\AUTHOR,title=\TITLE]{JHPreamble}
```
* Options of the class `scrreport` or `beamer` are passed on
## Miscellaneous

The commands of `JHPreamble` are defined in `JHGeneralCommands`, `JHMathCommands` and `JHPhysicsCommands`, packages which can also be loaded without the preamble. The files often come with a brief explanation of the function, just scroll through for a list of commands.

Additional packages are included:
* `JHGreekLetters`, which is obsolete with `unicode-math`,
* `JHIdealSymbols`, in which `\triangleleft` variants are defined (for prime ideals, maximal ideals, etc.) - originally by A.W.,
* `JHTensors`, which defines different arrows over letters, but unfortunately also causes problems.
* `JHUnderlines`, not actually mine, which defines an interesting underline.

## TO DO
* Document definition, sentence, lemma, ... environments
* Translate names - currently almost exclusively in German
* Maybe continue writing this documentation (maybe TeXify it)