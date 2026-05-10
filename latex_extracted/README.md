# FYP Report — LaTeX Source

This zip contains the full LaTeX source and the compiled PDF
(`main.pdf`) for the final-year-project report:

> **Evaluating the Security and Performance Trade-offs of Network
> Segmentation: A Comparative Study Using a Containerised Cyber Range**

The PDF is 78 pages, ~770 KB, and the body chapters total approximately
8,500 words excluding figures, tables, references and appendices.

## Layout

```
fyp_report/
├── main.tex                      # master document
├── main.pdf                      # compiled output (78 pages)
├── chapters/                     # the eight body-text chapters
│   ├── 00_abstract.tex
│   ├── 01_introduction.tex
│   ├── 02_literature.tex
│   ├── 03_methodology.tex
│   ├── 04_implementation.tex
│   ├── 05_results.tex
│   ├── 06_discussion.tex
│   ├── 07_conclusion.tex
│   └── 08_references.tex         # ~70-entry bibliography (CTR Harvard)
├── appendices/
│   ├── A_dockerfiles.tex
│   ├── B_firewall_rules.tex
│   ├── C_test_scripts.tex
│   ├── D_helper_scripts.tex
│   └── E_raw_data.tex
├── figures/                      # 8 PNG figures from the analysis pipeline
└── code/                         # source listings + raw CSV/scan data
                                  # (consumed by the appendices via
                                  # \lstinputlisting)
```

## How to compile

You need a TeX Live distribution (or MikTeX) with the standard
`texlive-latex-extra`, `texlive-pictures`, `texlive-fonts-recommended`
and `texlive-science` packages installed. If you have Overleaf,
the project will compile out of the box — upload the zip and choose
**pdfLaTeX** as the compiler.

From a local terminal:

```bash
cd fyp_report
pdflatex main          # 1st pass — generates aux/toc files
pdflatex main          # 2nd pass — resolves cross-references
pdflatex main          # 3rd pass — finalises TOC/LOF/LOT page numbers
```

Three passes are required because the document uses `\ref`/`\pageref` for
cross-references and `\addcontentsline` for several front-matter pages.

The build is silent; warnings about Computer Modern bitmap fonts can be
ignored. If you have `lmodern` installed (`apt install texlive-fonts-extra`)
the document will use scalable fonts automatically.

## Cite Them Right Harvard format

In-text citations use two custom commands defined in `main.tex`:

```latex
\parencite{Author}{Year}    →   (Author, Year)
\textcite{Author}{Year}     →   Author (Year)
```

The bibliography in `chapters/08_references.tex` is hand-formatted to
match Cite Them Right Harvard exactly. To add a new reference:

1. Cite it in the text using one of the two macros above.
2. Add a matching entry to `08_references.tex`, keeping the
   alphabetical order by surname.

## Title page

The title page in `main.tex` contains placeholder fields:
`[University Name]`, `[Your Full Name]`, `[Your ID]`,
`[Supervisor Name]`, `[Second Marker Name]`. Fill these in before
submission. Search for `[` to find them all.

## Word count

The declaration page states the word count as approximately 8,500
(body chapters only, excluding the title page, declaration,
acknowledgements, table of contents, lists of figures/tables,
references and appendices, in line with most UK FYP conventions).
Per-chapter approximate breakdown:

| Chapter | Words |
| ------- | ----: |
| Abstract | 250 |
| 1 Introduction | 1,000 |
| 2 Literature Review | 1,900 |
| 3 Methodology | 1,500 |
| 4 Implementation | 1,400 |
| 5 Results | 950 |
| 6 Discussion | 1,400 |
| 7 Conclusion | 830 |
| **Total**  | **~9,200** |

(The body slightly exceeds 8,500 to allow for trimming at proofreading.)

## Figures

All eight figures in `figures/` are produced by the `make_plots.py`
script in `code/`. They are referenced from
`chapters/05_results.tex`. Two TikZ-drawn topology diagrams (flat and
segmented) are embedded directly in `chapters/03_methodology.tex` and
do not require external image files.
