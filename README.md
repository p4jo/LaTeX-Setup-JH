# LaTeX

In this repo I store my LaTeX setup, which is now quite complex.

The documentation can be found in this repository.

It consists of the following parts:

 
## Commands
The commands are in `./tex/latex`. Some of them are documented there or are self-explanatory.
=> See also `Documentation.md`


They are partly in packages, partly in the document class.



## Document class
To wrap it all up, there is a document class, `JHPreamble.cls`.

You just include them with `\documentclass[options]{JHPreamble}`.

For the options, see the documentation.
## Packages

Quite a lot of packages are loaded, which is why the compilation time is unfortunately quite high (~30s for medium-sized documents). See the script `processPool.py` located in the submodule [LaTeX-Automate](https://github.com/p4jo/LaTeX-Automate.git).

A good package that gets loaded is `unicode-math`, which allows unicode input as it always should have been! It requires `lualatex` (or `xelatex`, but I haven't tested it for my setup) as a compiler.


## Fonts
Unfortunately, since there aren't many good full math fonts for unicode-math, I already have them with you, you can choose a few with document class options.
For the text I use the Adobe fonts Minion Pro (serif) and Myriad Pro (sans serif). These are available as good math fonts, but they are expensive!

# Installation/Use

Clone this repo (also see other tools below) somewhere using `git clone`.

If you want to include it in the main folder:
```
git clone https://github.com/p4jo/LaTeX-Setup-JH <main folder>/Setup
     or
git submodule add https://github.com/p4jo/LaTeX-Setup-JH <main folder>/Setup
```
(depending on whether your main folder is already a repository)

## Best way

Add the folder of this repository (where this file is located) as a search path in your LaTeX installation.

* It's very easy in `MiKTeX`: Open the MiKTeX console ↦ Settings ↦ Directories ↦ add `+` `<this path>`.

* I'm not familiar with `livetex`, it could be more difficult! (Use Google)

## Alternate
Specify the document class with `\documentclass[PackagesByPath, ...]{<this path>/tex/latex/JHPreamble}` and either
* also the class option `SetupPath=<this path>` (if it contains spaces it probably needs to be wrapped in a command, see the `author` and `title` documentation),
* do nothing. It should work now. If in doubt, make sure `<this path>` is absolute.

The path to this repository should not contain any LaTeX-active characters (`$`,`%`,`&`, ...), preferably no double spaces and whatever other restrictions.

# More parts of my setup

## Settings for Visual Studio Code as LaTeX Editor (with `LaTeX-Workshop`)

The corresponding settings can be found in [LaTeX-.vscode](https://github.com/p4jo/LaTeX-.vscode).

Include in the main folder with
```
git clone https://github.com/p4jo/LaTeX-.vscode <main folder>/.vscode
     or
git submodule add https://github.com/p4jo/LaTeX-.vscode <main folder>/.vscode
```

In VSCode I use the extension [LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop) - lo and behold for an introduction. Only the SyncTex support should be mentioned (Ctrl+click in the pdf or Ctrl+Alt+j in the source code jumps to the respective point).
 
## Automation
In my repository [LaTeX-Automate](https://github.com/p4jo/LaTeX-Automate.git) there is a Powershell script for automating \input{}. (highly optional)

Running the Automate/automate.ps1 script will add each file in a subfolder (recursively) to a corresponding <subfoldername>_generated.tex as import and create a <subfoldername>.tex in the subfolder that should be used as the main file.

If you include the script in your build process (before), the whole folder (in lexicographical order) is always included in the main document without you having to worry about it. This is already set for VSCode with Tex Workshop in the .vscode config.

You can exclude sub-subfolders with a file called .texignore (e.g. useful when creating multiple versions, or to only render the current chapter when rebuilding).