% Auto generated file, created from src\JHPreamble.mcls. Will be overwritten. Change the source files instead.
\ProvidesExplClass{JHPreamble}{2022/04/08}{0.2.1}{Preamble of Johannes H. Needs LuaLaTeX or XeLaTeX}

%%% Base Path for inserts with % !TeX input set to src %%%

%%% PrePreamble

\RequirePackage{kvoptions} % key-value options

%%% Options
\DeclareStringOption[Anonymous author]{author}
\DeclareStringOption[Empty title]{title}

\DeclareStringOption{SetupPath}
\let\JHPreamble@SetupPath\relax 
% undefine the default value for easy check below. Not equivalent to [\relax]{SetupPath}
\DeclareBoolOption{PackagesByPath}

\DeclareBoolOption{Presentation}

\DeclareBoolOption{simpleTitle}

\DeclareBoolOption{KpMath}
\DeclareBoolOption{STIX}
\DeclareBoolOption{StandardMathFonts}
\DeclareBoolOption{StandardTextFonts}

\DeclareBoolOption{useAccents}
\DeclareBoolOption{useGreekLetterCommands}
\DeclareBoolOption{useSilence}
\DeclareBoolOption{useIdealSymbols}
\DeclareBoolOption{useIndex}
\DeclareBoolOption{omitFloat}
\DeclareBoolOption{omitOwnPackages}
\DeclareBoolOption{omitExternalPackages}
\DeclareBoolOption{omitUnicodeMath}
\DeclareBoolOption{omitFonts}
\DeclareBoolOption{omitAutoIndex}
\DeclareBoolOption{omitGreekLetterNames}
\DeclareBoolOption{omitAll}


\DeclareDefaultOption{ %Jede weitere Option
    \PassOptionsToClass{\CurrentOption}{scrreport}
    \PassOptionsToClass{\CurrentOption}{beamer}
}

\ProcessKeyvalOptions* %

\ifJHPreamble@omitAll
    \JHPreamble@omitOwnPackagestrue
    \JHPreamble@omitExternalPackagestrue
    % \JHPreamble@omitUnicodeMathtrue
    \JHPreamble@omitFontstrue
    % \JHPreamble@omitFloattrue
    % \JHPreamble@StandardMathFontstrue
    % \JHPreamble@StandardTextFontstrue
\fi

%%% Stuff

%%% FILE src\PackagesByPath.tex  %%%
\ifJHPreamble@PackagesByPath
    \typeout{PackagesByPath~provided}
    
    \ifx\JHPreamble@SetupPath\relax
        % If it was not provided
        \typeout{SetupPath~not~provided}
        
        % Gets the Value from \CurrentFilePath and saves it into \JHPreamble@SetupPath
        \exp_args:NNV\newcommand\JHPreamble@SetupPath{\CurrentFilePath}
        \typeout{now~using~SetupPath=\CurrentFilePath}
    \fi
    
    \newcommand\RequirePackageByPath[2][]{
        \typeout{Requiring~Package~
            \JHPreamble@SetupPath/#2
            ~by~path
        }
        \RequirePackage[#1]{
            \JHPreamble@SetupPath/#2
        }
    }
\else
    \newcommand\RequirePackageByPath\RequirePackage
\fi
%%% END OF INSERTED FILE src\PackagesByPath.tex %%%


\author{\JHPreamble@author}
\title{\JHPreamble@title}

%%%%%%%%%%%%%%
%%% Files and Packages
%%%%%%%%%%%%%% 
\RequirePackage{etoolbox} % For \AfterEndPreamble and such.

\PassOptionsToPackage{svgnames}{xcolor} % Option [svgnames] may cause option clash ↦  before first potential load 

\ifJHPreamble@Presentation

%%% FILE src\PresentationMainSetup.tex  %%%
\LoadClass[
    notheorems  % doesn't create theorems (removes compilation errors)
]{beamer}

% \MakeCharactersAlwaysUseFallbackFont{⦃,⦄}
\ifJHPreamble@simpleTitle
    \AfterEndPreamble{
        \begin{frame}[plain]
            \maketitle
        \end{frame}
    }
\fi
%%% END OF INSERTED FILE src\PresentationMainSetup.tex %%%

\else

%%% FILE src\ArticleMainSetup.tex  %%%
\PassOptionsToPackage{ footinclude=false }{typearea}

\LoadClass[
	12pt,
	DIV=13, % Bestimmt monoton fallend die Größe des Rands. 12 für Schriftgröße 12pt voreingestellt.
	% headheight=18.86pt, %temporär. Hat sich beschwert, ich glaube seit 1.3 der linespread ist. Beschwert sich auch bei lokal größerem Linespread
	% footheight=18.86pt, % ebenso
	% twoside=true,
	% BCOR=10mm, Buchinneres Correction
	toc=bibliography,
	cleardoublepage=empty,
	open=right
]{scrreprt} % Lädt KOMA-Script-Pakete (insb. typearea)

\RequirePackage[automark]{scrlayer-scrpage} %gehört zum KOMA-Script

\RequirePackage[onehalfspacing]{setspace}
% etwa äquivalent zu \linespread{1.3}

\recalctypearea

\ifJHPreamble@simpleTitle
	\AfterEndPreamble{ % AtBeginDocument schmeißt unverständlichen Fehler bei \begin{titlepage} wegen Wechselwirkung mit irgendwas mit pgf color
		\begin{titlepage}
			\maketitle
		\end{titlepage}
	}
\fi

\AfterEndPreamble{
	\pagestyle{scrheadings}
}

\AtEndDocument{
	\@ifpackageloaded{biblatex}{
		\cleardoublepage 
		\raggedright 
		\printbibliography%
	}{}
}

\newcommand\Inhaltsverzeichnis{
    \clearpage
    \pagenumbering{roman}
    \tableofcontents
    \clearpage
    \pagenumbering{arabic}
}

%%% END OF INSERTED FILE src\ArticleMainSetup.tex %%%

\fi

%%% FILE src\Index.tex  %%%

\ifJHPreamble@useIndex
    \RequirePackage[imakeidx]{xindex}
    % \AtBeginDocument{\makeindex}
    \makeindex
    \AtEndDocument{\printindex}

    
    \ifJHPreamble@omitAutoIndex
    \else
        \tl_new:N\autoindex_current_tl
        \newcommand\autoindex_add_superindex:n{
            \tl_if_empty:NTF\autoindex_current_tl{
                \tl_gput_left:Nx\autoindex_current_tl
            }{
                \tl_gput_left:Nx\autoindex_current_tl!
                \tl_gput_left:Nx\autoindex_current_tl
            }
        }
        \NewDocumentCommand\autoindex_process_index:n{
            > { \SplitList{ ? } } m
            }{
                \tl_clear:N\autoindex_current_tl
                \ProcessList{#1}{\autoindex_add_superindex:n}
            }

        % \tl_new:N\autoindex_separator:
        % \newcommand\autoindex_append:n[1]{
        %     \tl_gput_right:Nx\autoindex_current_tl\autoindex_separator:
        %     \tl_gput_right:Nx\autoindex_current_tl{#1}
            
        %     \tl_if_empty:NTF\autoindex_separator:{
        %         \tl_set:Nx\autoindex_separator:{!}
        %     }{
        %         \tl_set:Nx\autoindex_separator:{~}
        %     }
        % }
        % \RenewDocumentCommand\autoindex{
        %     s % for future use
        %     o % same
        %     >{ \SplitList{ ~ } } >{\TrimSpaces} m 
        % }{
        %     \tl_clear:N\autoindex_separator:
        %     \tl_clear:N\autoindex_current_tl
        %     \ProcessList{#3}{\autoindex_append:n}
        %     \index{\autoindex_current_tl}
        % }
        %% \index{ the argument where ? is interpreted as a reverse ! (having the broader keyword behind) }
        %% \autoindex*{LaTeX3?programmer} prints "LaTeX3 programmer" and executes \index{programmer!LaTeX3} which gets grouped with \index{programmer!Python}.
        \NewDocumentCommand\autoindex{
            s % also print the text (with ? and ! replaced by a space)
            o % for future use
            m
            }{
                \autoindex_process_index:n{#3}
                \index{\autoindex_current_tl}
                \IfBooleanT{#1}{
                    \tl_set:Nn\autoindex_current_tl{#3}
                    \regex_replace_all:nnN{[!\? ]}{\~}\autoindex_current_tl
                    \tl_use:N\autoindex_current_tl
                }
        }

    \fi
\else
    \AtBeginDocument{\providecommand\index[1]{\typeout{Warning! No index package is loaded! You can provide the class option useIndex}}}
\fi
\AtBeginDocument{
    \ProvideDocumentCommand\autoindex{som}{
        \index{#1}
        \IfBooleanT{#1}{#3}
}}
%%% END OF INSERTED FILE src\Index.tex %%%

\ifJHPreamble@omitExternalPackages
\else

%%% FILE src\Packages1.tex  %%%
%before unicode-math and fonts
% non-essential

\RequirePackage[
	greek,
	english,
	ngerman
	]{babel} % Setzt Sprache des Texts, wird von vielen Paketen für Locale verwendet. (z.B. enquote oder siunitx)

% \RequirePackage{polyglossia} %funktioniert wahrsch nur mit einer TTF Schrift (XeLaTeX)
% \setdefaultlanguage[spelling=new]{german}
% \setotherlanguage{greek}

\RequirePackage[
	backend=biber,
	style=phys,
	biblabel=brackets]{biblatex} % Verwendet Referenzen.bib

\RequirePackage{hyperref}

%%%Zusatzstuff
\ifJHPreamble@useSilence
	\RequirePackage{silence} % Um Fehlermeldungen auszublenden

	% \WarningFilter{stmaryrd}{Font shape}
	\WarningFilter{latex}{Some font shapes}
	\WarningFilter{latex}{Empty bibliography}
	% \WarningFilter{latex}{Underfull }
	% \WarningFilter{fontspec}{OpenType feature}
	\WarningFilter{latex}{You have requested}

%% Kann man in LateX-Workshop auch \enquote{muten} -- ist dann noch im Log, aber nicht unten bei Problems
\fi

\RequirePackage{mathtools} % überschreibt underbrace in unicode-math, was dann nicht mehr funktioniert, muss deshalb vor unicode-math geladen werden.
%%% END OF INSERTED FILE src\Packages1.tex %%%

\fi

\ifJHPreamble@omitFonts
\else

%%% FILE src\Fonts.tex  %%%
% \RequirePackage{fontspec} % in unicode-math
\ifJHPreamble@omitUnicodeMath
    \RequirePackage{fontspec}
\else
    \RequirePackage[
        math-style=ISO, % Macht gr. Großbuchstaben kursiv
        bold-style=ISO 
        ]{unicode-math} 
\fi

\ifJHPreamble@PackagesByPath
    \newcommand{\__FontPath}{\JHPreamble@SetupPath/../../fonts/opentype/}
\else
    \newcommand{\__FontPath}{} % it will probably retry and find it in the System installation
\fi

\ifJHPreamble@StandardMathFonts
\else
    \ifJHPreamble@KpMath
        %%% kpfonts haben einige Zeichen nicht, deshalb zu STIX2Math gewechselt. Passen beide nicht wirklich zu MinionPro

        % \RequirePackage{kpfonts}
        % \RequirePackage[mathcal,bbsans,notext]{kpfonts-otf}
        \setmathfont[
            Path=\__FontPath,
            version=normal
        ]{KpMath-Regular.otf}

        \setmathfont[
            Path=\__FontPath,
            version=bold
        ]{KpMath-Bold.otf}

        % % \setmathfont{KpMath-Semibold.otf}[Path=\__FontPath,version=semibold]
        % \setmathfont{KpMath-Sans.otf}[Path=\__FontPath,version=sans]
        % \setmathfont{KpMath-Light.otf}[Path=\__FontPath,version=light]


        % \newfontfamily{\fallbackfont}{STIX2Math}[Path=\__FontPath,
        %     Extension = .otf
        % ]

        % \DeclareTextFontCommand{\usefallbackfont}{\fallbackfont}

    \else
        \setmathfont[
            Path=\__FontPath,
            version=bold
        ]{XITSMath-Bold.otf}

        %%% STIX2Math und XITS (STIX)
        \ifJHPreamble@STIX
            \setmathfont[
                Path=\__FontPath,
                version=normal
            ]{STIX2Math.otf}
        \else
            \setmathfont[
                Path=\__FontPath,
                version=normal
            ]{XITSMath.otf} 
        \fi
    \fi


    % \setmathfont[
    %     Path=\__FontPath,
    %     version=sans
    % ]{GFSNeohellenicMath.otf}
    
    % \setmathfont[
    %     Path=\__FontPath,
    %     range={"2983-"29FC},
    %     version=sans
    % ]{XITSMath.otf}
    
    \setmathfont[
        Path=\__FontPath,
        % range={up, it, bb, frak, cal, scr, sfup, sfit, bfup,bfit, bfcal},
        version=sans
    ]{KpMath-Sans.otf}
    % \setmathfont[
    %     Path=\__FontPath,
    %     range={it,up, bb},
    %     version=sans
    % ]{FiraMath-Regular.otf}
    %%%



    \mathversion{normal}
\fi

%%% Text Fonts

\ifJHPreamble@StandardTextFonts
\else
    % \IfFontExistsTF{MinionPro}{
    \setmainfont{MinionPro}[
        Path=\__FontPath,
        Extension = .otf,
        UprightFont = *-Medium,
        BoldFont = *-Bold, %SemiBold
        ItalicFont = *-It, %
        BoldItalicFont = *-BoldIt, %SemiboldIt
        Language = German
    ] % Minion Pro und Myriad Pro sind anscheinend zur privaten Verwendung legal (aus der Installation von Adobe Acrobat Reader zu bekommen)
    % }{}

    %   \IfFontExistsTF{Myriad-Pro}{
    \setsansfont{Myriad-Pro}[ %SansSerif 
        Path=\__FontPath, 
        UprightFont = *-Regular.ttf,
        BoldFont = *-Bold.ttf, %SemiBold
        ItalicFont = *-It.otf, %
        Language = German,
        % Script = Default, % Seems to be on CustomDefault although that doesn't exist in the documentaion
        Contextuals = ResetAll
    ]
    % }{}

    %%% Braucht kompliziert konvertierte und installierte Myriad und Minion Type 1 Schriften mit Paketen. (Für pdflatex)

    % \RequirePackage{alphabeta}
    % \RequirePackage[Path=\__FontPath,lf]{MinionPro}
    % \RequirePackage[Path=\__FontPath,
    % 	scale=1,
    % 	lf,
    % 	sansmath]{MyriadPro}

\fi

\newfontfamily\codeFont{CascadiaCode}[
    Path=\__FontPath, 
    UprightFont = *-Regular.ttf,
    BoldFont = *-Bold.ttf
]


% icomoon.io, boxy-svg.com
\newfontfamily\JHSymbolFont[Path=\__FontPath]{divides_multipleOf.ttf}
\newcommand\teilt{\mathbin{\text{\JHSymbolFont{d}}}}
\newcommand\assoz{\mathbin{\text{\JHSymbolFont{a}}}}
\newcommand\vielf{\mathbin{\text{\JHSymbolFont{m}}}}

%%%% FallbackFont
% Mit Kp-Math notwendig, weil die das nicht hatten.
% Diese Kommandos könnte man wahrscheinlich auch durch \setmathfont{STIXMath2}[Unicode-range] irgendwie weglassen.

% \RequirePackage{newunicodechar}
% \newunicodechar{Δ}{\increment} % Könnte man machen, aber unnötig. Es gibt das Zeichen ∆, das ist dasselbe wie \increment, aber verschieden von Δ (\Delta)

% \newcommand{\MakeCharAlwaysUseFont}[2][\fallbackfont]{\newunicodechar{#2}{#1{#2}}}
% \newcommand{\MakeCharAlwaysUseFontAndTextMode}[2][\fallbackfont]{\newunicodechar{#2}{\text{#1{#2}}}}

% \NewDocumentCommand\MakeCharactersAlwaysUseFallbackFont{ > { \SplitList {,} } m }{ \ProcessList{#1}{\MakeCharAlwaysUseFont} }
% \NewDocumentCommand\MakeCharactersAlwaysUseFallbackFontAndTextMode{ > { \SplitList {,} } m }{ \ProcessList{#1}{\MakeCharAlwaysUseFontAndTextMode} }


% \MakeCharactersAlwaysUseFallbackFontAndTextMode{𝟙}

% \MakeCharactersAlwaysUseFallbackFontAndTextMode{⥎,⥋,⥊,⥐}
%%% END OF INSERTED FILE src\Fonts.tex %%%

\fi

\ifJHPreamble@omitExternalPackages
\else

%%% FILE src\Packages2.tex  %%%
% After unicode-math and fonts
% non-essential
%     \RequirePackage{microtype} % sorgt für besseres Schriftbild, indem es micro-Anpassungen macht. 
\RequirePackage[autostyle=true]{csquotes} % \enquote{...} statt "...". Lokalisierbare Anführungszeichen 

\RequirePackage{graphicx} % für \Grafik
\RequirePackage{animate} % für gif-\Grafik 

\RequirePackage{pdfpages} %Um pdfs anzuhängen 
\RequirePackage[export]{adjustbox} %Um Bilder nur eingeschränkt anzuhängen

\RequirePackage{listings} % Um code anzuhängen. Einstellungen in GeneralSetup


\ifJHPreamble@omitFloat
\else
    \RequirePackage{float} % Um \begin{figure}[H] zu machen
\fi


\RequirePackage{amsmath} % in kpfonts

% \RequirePackage{breqn} % Verändert equation parsing, sodass sie automatische Zeilenumbrüche haben.

\RequirePackage{siunitx} %\si{\kilo\metre\per\second\squared} \num{3,14(7)E-4} \SI{8,7+-2.3}\ampere\
% Einstellungen in GeneralSetup

% \RequirePackage{ziffer} %macht Kommas in Zahlen zu ,\! oder so, aber besser wäre \num aus siunitx


\RequirePackage{physics} %\bra, \ket, \qty (macht Klammern zu \left \right Paaren)

\RequirePackage{interval} % um Intervalle gut zu setzen. Einstellungen in format.

% \RequirePackage{titling} % Um Titelseite zu verändern, müsste man aber mit der KOMA-Script Klasse eh können

% \RequirePackage{pgffor} % Funktionalität wahrscheinlich in etoolbox oder lua oder xparse (-> LaTeX3) enthalten

\RequirePackage{cancel} % Durchstreichen in Mathe

\RequirePackage{xspace} % Ein Leerzeichen, das man ans Ende von Befehlen bauen kann, das keines wird, wenn da ein Satzzeichen steht
\RequirePackage{xfrac} % für \sfrac, ein schräger Bruch mit kleinerer Schrift. Leider etwas seltsam

% \RequirePackage{amssymb} % geht nicht gescheit. Geht nicht zusammen mit unicode-math % Inhalt eh in kpfonts-otf drin

% \RequirePackage{stmaryrd} % Eigentlich nur für \llbracket, das gibts in kpfonts (als \lBrack) und in unicode-math
% \RequirePackage{bm} % braucht es auch mit kpfonts nicht
%\RequirePackage{upgreek} % braucht's mit unicode-math natürlich auch nicht

\RequirePackage{tensind} 
%%% END OF INSERTED FILE src\Packages2.tex %%%


%%% FILE src\GeneralSetup.tex  %%%
% ignored on option omitExternalPackages

% xspace
\xspaceaddexceptions{“ "-}

% interval
% \intervalconfig{soft open fences} %kann man verwenden, um Intervalle (a,b] zu erzeugen
% \intervalconfig{separator symbol=;} %kann man verwenden, um Intervalle ]a;b] zu erzeugen

% siunitx
\sisetup
{
	detect-all, %Alle äußeren Font-Veränderungen werden übernommen
	locale=DE, %insb. , statt .
	range-phrase={\ bis\ }, %in \SIrange
	separate-uncertainty=true, % (1,32 \pm 0, 22) statt 1,32(22) in Ausgabe
	%table-figures-uncertainty = 1, % reserves space for one \pm sign (use as \tabular{S[tab..]})
	% EITHER
		% per-mode=symbol-or-fraction,
	% OR
		per-mode=fraction, %
		fraction-function=\sfrac,
	% ENDEITHER
	% round-integer-to-decimal=true,
	% quotient-mode=fraction, % Option wurde entfernt
	% literal-superscript-as-power=true % Option nicht mehr notwendig
}

\shorthandoff{"} % Würde normalerweise "a zu ä machen.

% hyperref
\hypersetup
{
	colorlinks	= true,
	linkcolor   = dunkelblau, 
	citecolor   = dunkelblau,
	bookmarksnumbered = true,
	urlcolor    = dunkelblau,
	pdfauthor   = {\JHPreamble@author},
	pdftitle    = {\JHPreamble@title}%,
	% pdfsubject  = {<set this yourself using \hypersetup>},
	% pdfkeywords = {<same>}
}

% lstlisting

\lstset{
    basicstyle=\scriptsize\codeFont,
    keywordstyle=\bfseries\color{lila},
    emphstyle=\color{dunkelrot},
    stringstyle=\color{dunkelgrün},
    commentstyle=\color{dunkelgrau},
    identifierstyle=\color{dunkelblau},
    numbers=left,
    stepnumber=5,
    frame=tb,
    showstringspaces=false,
    showspaces=false,
    showtabs=false,
    breaklines=true,
    tabsize=2
}

\lstdefinelanguage
    [JH]{Python} % dialect JH of Python
    []{Python} % based on standard dialect of Python
{
    morekeywords={self,True,False,as,assert},           
    emph={__init__,__str__,__repr__,\#\#\#\#\#\#\#}
}

% tensind
% \tensordelimiter{§} % Funktioniert nicht, da unicode-math so normale Zeichen überschreibt, auf eine Art und Weise, die tensind nicht überschreibt
\tensordelimiter{￭}
\tensorformat{}

% \hyphenation{Hoch-tem-pera-tur-su-pra-lei-tern Ku-pfer-atomen}


\usepackage{amsthm}
\usepackage{thmtools}

\declaretheoremstyle[
    bodyfont=\upshape,
    headfont={\sffamily\bfseries},
    notefont={\sffamily\bfseries},
    headpunct={:},
]{JHDefinition}

\declaretheoremstyle[
    bodyfont={\color{dunkelgrau}}
]{JHProof}

\declaretheoremstyle[
    bodyfont={\upshape%\color{dunkelgrau}
        },
    headfont=\itshape,
    notefont=\itshape,
    headpunct={:},
]{JHRemark}

\cs_if_exist:NTF\chapter{
    \newcommand\__numberwithin{chapter}
}{
    \newcommand\__numberwithin{section}
}

\declaretheorem[
    style=JHDefinition,
    shaded={
        bgcolor=blasshellblau
    },
    numberwithin=\__numberwithin
]{definition}
\declaretheorem[
    style=JHDefinition,
    shaded={
        bgcolor=hellgrün
    },
    numberwithin=\__numberwithin
]{Satz}
\declaretheorem[
    style=JHDefinition,
    shaded={
        bgcolor=hellgrün
    },
    numberlike=Satz
]{Lemma}
\declaretheorem[
    style=JHDefinition,
    shaded={
        bgcolor=blasstürkis
    },
    name=Definierendes\ Lemma,
    numberlike=Satz
]{DefLemma}
\declaretheorem[
    style=JHDefinition,
    shaded={
        bgcolor=hellgrau
    },
    numberlike=Satz
]{Korollar}
\declaretheorem[
    style=JHDefinition,
    numbered=no,
    name=Beispiel
]{Beispiel}

\declaretheorem[
    style=JHProof,
    numbered=no
]{Beweis}

\declaretheorem[
    style=JHRemark,
    name=Bemerkung,
    numbered=no
]{remark}
\declaretheorem[
    style=JHRemark,
    name=Bemerkung,
    numbered=no
]{bem}
\declaretheorem[
    style=JHRemark,
    name=Bemerkung,
    numbered=no
]{Bemerkung}

%%% END OF INSERTED FILE src\GeneralSetup.tex %%%


%%% FILE src\BibliographySettings.tex  %%%
\DeclareFieldFormat{journaltitle}{\textsl{#1}\isdot} 
\DeclareFieldFormat{titlecase}{{#1}}
\ExecuteBibliographyOptions
{
    articletitle = true,
    autocite  = inline, %superscript,
    autopunct = false,
    sorting   = none,
    url=true
}  
\renewbibmacro*{journal+issuetitle}{%
\mbox{\printfield{journaltitle}~\usebibmacro{volume+number+eid}}%
\setunit*{\addnbspace}%
}

%%% END OF INSERTED FILE src\BibliographySettings.tex %%%

\fi


%%% FILE src\Colors.tex  %%%

% \RequirePackage{color}
\RequirePackage{xcolor} % Option [svgnames] may cause option clash ↦ \PassOptionsToPackage before first potential load 

\ifdef{\mathcolor}{

}{

    \def\mathcolor#1#{\@mathcolor{#1}}
    \def\@mathcolor#1#2#3{%
        \protect\leavevmode
        \begingroup
           \color#1{#2}#3%
        \endgroup
    }
}

\definecolor{dunkelblau}{rgb}{0, 0, 0.5}
\definecolor{dunkelgrau}{rgb}{0.4, 0.4, 0.4}
\definecolor{grau}{rgb}{0.5, 0.5, 0.5}
\definecolor{hellgrau}{rgb}{0.9, 0.9, 0.9}
\definecolor{türkis}{rgb}{0, 0.5, 0.5}
\definecolor{blasstürkis}{rgb}{0.5, 0.9., 0.9}
\definecolor{blassblau}{rgb}{0.9,0.9,1}
\definecolor{blasshellblau}{rgb}{0.76,0.97,1}
\definecolor{hellblau}{rgb}{0.31,0.87,1}
\definecolor{hellgrün}{rgb}{0.9,1,0.9}
\definecolor{lila}{rgb}{0.5,0,0.5}
\definecolor{dunkelgrün}{rgb}{0,0.5,0}
\definecolor{dunkelrot}{rgb}{0.5,0.05,0.05}
\definecolor{dunkeltürkis}{HTML}{2A7B88}
%%% END OF INSERTED FILE src\Colors.tex %%%


\ifJHPreamble@Presentation

%%% FILE src\PresentationFormatSettings.tex  %%%
\usetheme{Madrid}
% \usetheme{Warsaw}
\mathversion{sans}

\AtBeginSection{
    \begin{frame}
        \frametitle{}
        \tableofcontents[currentsection]
    \end{frame}
}
%%% END OF INSERTED FILE src\PresentationFormatSettings.tex %%%

\else

%%% FILE src\ArticleFormatSettings.tex  %%%
\addtokomafont{sectioning}{\rmfamily\boldmath\color{dunkelblau}}
%\addtokomafont{sectioning}{\mathversion{sansbold}}
\addtokomafont{pagehead}{\normalfont\color{dunkelgrau}}
\addtokomafont{caption}{\sffamily\mathversion{sans}\footnotesize}
\addtokomafont{captionlabel}{\sffamily\bfseries\footnotesize}
\setcapindent{0cm}
%\addtokomafont{pagenumber}{\sffamily}
\setkomafont{pagenumber}{\normalfont}

\@ifpackageloaded{babel}{
    \renewcaptionname{ngerman}{\figurename}{Abb.}
    \@ifpackageloaded{hyperref}{
        \renewcaptionname{ngerman}{\figureautorefname}{Abb.}
        \renewcaptionname{ngerman}{\tableautorefname}{Tabelle} %War auf 'Abschnitt' ?
    }{}
}{}


% \linespread{1.3}

% \renewcommand{\topfraction}{0.85}
% \renewcommand{\bottomfraction}{0.85}
% \renewcommand{\textfraction}{0.1}
% \renewcommand{\floatpagefraction}{0.8}


\clubpenalty9998
\widowpenalty9999
\displaywidowpenalty=9999



\apptocmd\normalsize{%
 \abovedisplayskip=9pt plus 3pt minus 7pt
 \abovedisplayshortskip=0pt plus 3pt
 \belowdisplayskip=4pt plus 3pt minus 2pt
 \belowdisplayshortskip=6pt plus 3pt minus 3pt
}{}{}
%%% END OF INSERTED FILE src\ArticleFormatSettings.tex %%%

\fi


%%% FILE src\AutomationSetup.tex  %%%

\usepackage{iftex}
\ifLuaTeX
    \NewDocumentCommand{\getenv}{m}{
        \directlua{
            result = os.getenv('#1')~
            if~result == nil~then~result = "UNDEFINED"~end~
            tex.sprint(
                string.char(92) .. "tl_set:cn" .. string.char(123) .. "#1" .. string.char(125) .. string.char(123) .. result .. string.char(125))
         }
    }     % 92 = \, 123 = {, 125 = }
\else
    % \NewDocumentCommand{\getenv}{m}
    % {
    %     \tl_set:cv{#1}{\@@input"|~echo~$Env:#1"}
    % }

    % % Uses sys_get_shell, but we would have to know the system. this is powershell specific
    % \NewDocumentCommand{\getenv}{m}
    % {
    %     \sys_get_shell:nnN{echo~$Env:#1 } { } \getenv_result 
    %     \tl_trim_spaces:N \getenv_result
    %     \tl_set:cN {#1} \getenv_result
    % }

    \NewDocumentCommand{\getenv}{m}
    {\tl_set:cn{#1}{USE_LUALATEX}}
\fi

% \cs_new:cx{LATEX_ALLOW_PAUSE_EXECUTION:}{\getenv{LATEX_ALLOW_PAUSE_EXECUTION}}
% \exp_args:NNe
% \newcommand\LATEX_ALLOW_PAUSE_EXECUTION{
\getenv{LATEX_ALLOW_PAUSE_EXECUTION}%}
\newcommand\true_string{true}

\newcommand\pauseExecution{
    % \exp_after:wN
    \str_if_eq:NNTF\LATEX_ALLOW_PAUSE_EXECUTION\true_string{
        \chardef\previous_interactionmode=\interactionmode
        \errorstopmode % stopping at \show
        \typeout{PAUSED~EXECUTION!}
        \show\show
        \interactionmode=\previous_interactionmode
    }
    {
        \typeout{DID~NOT~PAUSE~EXECUTION~BECAUSE~THE~ENVIRONMENT~VARIABLE~LATEX_ALLOW_PAUSE_EXECUTION~IS~"\LATEX_ALLOW_PAUSE_EXECUTION",~NOT~"true"}
    }
}
\AfterEndPreamble{\pauseExecution}
%%% END OF INSERTED FILE src\AutomationSetup.tex %%%



\ifJHPreamble@omitOwnPackages
\else
    \RequirePackageByPath{JHGeneralCommands}
    \RequirePackageByPath{JHMathCommands}
    \RequirePackageByPath{JHPhysicsCommands}
\fi

\ifJHPreamble@omitGreekLetterNames
\else

%%% FILE src\GreekLetterNames.tex  %%%


\ifJHPreamble@useGreekLetterCommands
    \RequirePackageByPath{JHGreekLetters}
\else 
    \newcommand\ita η
    \newcommand\Ita Η
    \newcommand\alfa α
    \newcommand\Alfa Α
    \newcommand\eps ε
    \newcommand\ro ϱ
    \newcommand\vita β
    \newcommand\Vita Β
    \newcommand\fii φ %varphi
    \newcommand\ffi ϕ %phi symb
    \newcommand\Fii Φ
    \newcommand\lamda λ
    \newcommand\Lamda Λ
    \newcommand\taf τ
    \newcommand\Taf Τ
    \newcommand\ny ν
    \newcommand\my μ
    \newcommand\teta ϑ
\fi
%%% END OF INSERTED FILE src\GreekLetterNames.tex %%%

\fi

\ifJHPreamble@useAccents
    \RequirePackageByPath{JHTensors}
\fi
\ifJHPreamble@useIdealSymbols
    \RequirePackageByPath{JHIdealSymbols}
\fi