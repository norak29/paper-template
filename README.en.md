# paper-template

A template for writing conference papers and journal articles in LaTeX.
Works with Japanese conference templates (jsarticle, jlreq) and with international ones
such as IEEE, ACM and Elsevier.

**You do not need to install TeX Live.** The typesetting environment ships as a container,
so a project made from this template builds identically on any machine.

- Works with upLaTeX, LuaLaTeX, XeLaTeX and pdfLaTeX — the engine switches per paper
- Saving rebuilds the document; the PDF next to your source updates automatically
- Pushing a git tag builds the PDF on GitHub and stores it
- Claude Code (AI assistant) is available from the start

日本語版: [README.md](README.md)

---

## 1. One-time setup on your machine

Open PowerShell and install four things.

```powershell
winget install --id Git.Git -e
winget install --id Docker.DockerDesktop -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id GitHub.cli -e
```

**Restart your PC afterwards.** Docker Desktop needs this to enable WSL2.

After the restart, **launch Docker Desktop** and wait until the bottom left reads
`Engine running` (green). To avoid starting it by hand every time, turn on
Settings → General → `Start Docker Desktop when you sign in`.

Finally, open VS Code, go to the Extensions tab (`Ctrl+Shift+X`), search for
**Dev Containers** (publisher: Microsoft, id `ms-vscode-remote.remote-containers`) and install it.

### Set your name and email

In a new PowerShell window, once:

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global core.autocrlf input
git config --global init.defaultBranch main
gh auth login
```

For `gh auth login`, choose GitHub.com → HTTPS → authenticate in browser.

Your email address appears in commits on public repositories. To keep it private, enable
Settings → Emails → `Keep my email addresses private` on GitHub and use the
`12345678+username@users.noreply.github.com` address shown there.

---

## 2. Start a new paper

```powershell
cd C:\research
gh repo create your-paper-name --template norak29/paper-template --private --clone
cd your-paper-name
code .
```

If you prefer the browser, use the green **Use this template** button on this repository.

**Where to put it**: avoid OneDrive folders and paths containing spaces or non-ASCII
characters. Something like `C:\research\myproject` is safe.

### Open it in the container

Once VS Code opens, press `Ctrl+Shift+P`, type
**`Dev Containers: Reopen in Container`** and run it.

The first time, downloading the typesetting environment takes 5–10 minutes.
After that it takes seconds.

When the bottom left shows `Dev Container: ...`, you are inside. Open `main.tex`
and press `Ctrl+Alt+B` to build.

---

## 3. Writing

### Show the PDF side by side

With `main.tex` open, **double-click `main.pdf` inside the `out` folder** in the explorer.
Drag that tab to the right half, and you get source on the left, PDF on the right.

From then on, **every `Ctrl+S` rebuilds and refreshes the PDF.**

| Action | Key |
|---|---|
| Build | `Ctrl+Alt+B` |
| Jump from source to the matching spot in the PDF | `Ctrl+Alt+J` |
| Jump from the PDF back to the source | `Ctrl+click` in the PDF |
| Clean auxiliary files | `Ctrl+Alt+C` |

Errors appear in the **Problems panel** (`Ctrl+Shift+M`) with line numbers.

### One sentence per line

Please follow this one rule.

```latex
Write the first sentence here.
Start the second sentence on the next line.
```

If you write a whole paragraph on one line, changing a single word is recorded as a change
to the entire paragraph, and you lose the ability to see what you actually edited.

### Splitting a long document (theses and the like)

To keep each chapter in its own file, make a folder and pull the chapters in with `\input`.

```
main.tex
chapters/
├── 01_intro.tex
├── 02_method.tex
└── 03_result.tex
```

```latex
% main.tex
\begin{document}
\input{chapters/01_intro}
\input{chapters/02_method}
\input{chapters/03_result}
\end{document}
```

**Put the location of the main file on the first line of every chapter file.**

```latex
% !TEX root = ../main.tex
\section{Introduction}
```

Without it, pressing `Ctrl+Alt+B` while a chapter is open tries to build that chapter on its own
and fails. With it, the whole of `main.tex` is built whichever chapter you are in, and jumping
between source and PDF (`Ctrl+Alt+J`) works correctly.

The main file does not have to be called `main.tex` (`thesis.tex` is fine). The file at the top
level that contains `\documentclass` is treated as the main file automatically. **Keep only one
main file at the top level.** Chapter files in a subfolder, or with a `% !TEX root` line, are never
mistaken for it.

**Per-chapter bibliographies** (the `bibunits` package) work as they are. latexmk runs bibtex on
each chapter automatically; no extra configuration is needed.

---

## 4. Adding a conference style file

Put the files supplied by the conference into the **`sty/` folder**.
They are on the search path, so `main.tex` can load them.

How you load one depends on its type.

| File | How to load it |
|---|---|
| `.sty` | `\usepackage{filename}` |
| `.cls` | `\documentclass[options]{filename}` |
| `.bst` | `\bibliographystyle{filename}` |

### A note on character encoding

This repository assumes UTF-8. Files distributed by Japanese conferences are sometimes
encoded in Shift_JIS or EUC-JP, and using them as they are produces garbled text and a
build that fails for reasons the error messages do not explain.

- If the package contains separate `UTF` / `SJIS` / `EUC` folders → **use the one in `UTF`**
- If only a Shift_JIS file is provided → convert it inside the container

```bash
iconv -f CP932 -t UTF-8 their-file.sty > sty/their-file.sty
```

The bottom right of VS Code shows the encoding of the open file. `UTF-8` means you are fine;
`Shift JIS` means it needs converting.

Be careful when extracting zips as well. If figure filenames were stored in Shift_JIS, they
come out garbled when extracted inside the container. Extract such a zip in Windows Explorer,
or use `unzip -O cp932`.

### Choosing the engine

Different conferences expect different engines. Put this on the **first line** of `main.tex`:

```latex
% !TEX engine = pdflatex
```

| Value | Typical use |
|---|---|
| `uplatex` (default) | Traditional Japanese templates (jsarticle family) |
| `platex` | Older Japanese templates |
| `lualatex` | Recent Japanese templates (jlreq + luatexja) |
| `pdflatex` | **English templates (IEEEtran, acmart, elsarticle, …)** |
| `xelatex` | Templates that require XeLaTeX |

Without this line the engine is detected from the top of `main.tex`: `jlreq` or `luatexja`
selects LuaLaTeX, `IEEEtran` and friends select pdfLaTeX. The build prints
`latexmkrc: engine = ...` so you can confirm. **When in doubt, state it explicitly.**

### International conferences and journals (IEEE and others)

English templates work as they are. **IEEEtran, acmart, elsarticle and revtex are already
part of the typesetting environment.**

If the conference ships its own `.cls` in a zip, put that file in `sty/`.
**The conference's copy takes precedence over the one in TeX Live**, which is what you want:
you should typeset with the version they specified.

```latex
% !TEX engine = pdflatex
\documentclass[conference]{IEEEtran}
```

IEEE submission systems require every font to be embedded in the PDF (the PDF eXpress check).
pdfLaTeX embeds them by default, so this is not a problem.

### When only a Word template is provided

**Do not try to reproduce it in LaTeX.** A mismatch in formatting can get the paper rejected
automatically. Write that one in Word.

The repository is still useful. You can version a `.docx` with git, and tagging still freezes
the submitted version under Releases.

On top of that, **inside the container you can read the differences in Word files as text.**
This is set up already; there is nothing to do. Click a `.docx` in the Source Control panel or run
`git diff`, and you see which sentences changed, line by line.

```
-FRA is used to detect deformation.
+FRA is widely used to detect mechanical deformation.
```

Useful when comparing your version against one a co-author sent back.
Because pandoc lives only inside the container, Windows-side git and the GitHub website still show
just "binary file changed".

---

## 5. Saving your work (Git)

Record what you wrote.

1. Open **Source Control** (`Ctrl+Shift+G`) in the sidebar
2. Press **`+`** next to the files you want to record (staging)
3. Type a message in the box and press **`Ctrl+Enter`**
4. Press **Sync Changes** to send it to GitHub

Write specific messages such as "Add formulation to Section 2". You will thank yourself later.

### From the terminal

The same thing from the terminal (`` Ctrl+` ``), which is faster once you are used to it.

```bash
git status            # see what changed
git add -A            # stage everything (or: git add main.tex)
git commit -m "Add formulation to Section 2"
git push              # send it to GitHub
```

`git add` and `git commit` are local; nothing reaches GitHub until `git push`.
It is fine to make several commits and push them together later.

```bash
git diff              # changes not staged yet
git log --oneline     # list of commits
```

### Going back to an earlier version

```bash
git log --oneline                        # find the commit to go back to
git restore --source=<ID> main.tex       # restore that version of the file
```

Nothing is deleted from the history. The fact that you reverted is recorded as well.

### Freezing a submitted version

Tag only the versions worth keeping — what you submitted, what you handed to your advisor.
Ordinary writing needs commits only.

```bash
git push                                  # send the content first
git tag -a v1.0 -m "Submitted to XXX"     # create an annotated tag
git push --tags                           # send the tag
```

**`git push` and `git push --tags` are different.** The first sends commits, the second
sends tags. Push the content first so the tag never points at something GitHub does not have.

Pushing a tag triggers a build on GitHub. A few minutes later, `main.pdf` is attached to
the matching entry under **Releases**, along with an automatic archive of the source
(zip / tar.gz) at that point. Anyone who does not use git can simply download that zip.
Files excluded by `.gitignore` (`out/`, `_inbox/`) are not included.

```bash
git tag                                   # list your tags
```

To remove a tag you named wrongly, delete it in both places:

```bash
git tag -d v1.0                           # locally
git push origin :refs/tags/v1.0           # on GitHub
```

---

## 6. Claude Code

Type `claude` in the container terminal, or use the **Claude Code** tab in VS Code.

Useful for paper work:

- Formatting `cite.bib`, turning reference details into BibTeX entries
- Turning numbers into LaTeX tables
- Proofreading ("point out sentences where subject and verb do not agree")
- Reading build logs and explaining errors
- Renaming figures and updating every `\includegraphics` accordingly

`CLAUDE.md` describes the conventions of this project and Claude Code reads it automatically.
Add anything specific to your paper there and the answers get better.

**Requires a Pro plan or above.** Usage is shared with Claude chat.

---

## 7. Scratch folder

`_inbox/` is for throwaway files — zips, notes, anything you do not want in the repository.
It is excluded from git, so nothing there is ever committed.

A typical use: drop a zip sent by the conference there and ask Claude Code to
"extract this and sort the files into `sty/` and `fig/`".

---

## 8. When a package is missing

### In a hurry (seconds)

Add one line to `.devcontainer/Dockerfile` and run `Dev Containers: Rebuild Container`.

```dockerfile
RUN tlmgr install package-name
```

### Permanently

Edit `texlive.profile` in [texlive-ja](https://github.com/norak29/texlive-ja) and push;
a new environment is built automatically. Then update two places in this project to the
new date tag:

```
.devcontainer/Dockerfile       the FROM line
.github/workflows/release.yml  the container: line
```

**These two must match.** If they differ, your local build works but CI fails.

---

## 9. Troubleshooting

| Symptom | What to do |
|---|---|
| No `Reopen in Container` command | The Dev Containers extension is not installed |
| A Docker error when opening | Docker Desktop is not running — check the whale is green |
| Still fails to open | Run `wsl --update` in PowerShell, then restart the PC |
| "`.devcontainer` not found" | You opened a parent folder; open the project folder itself |
| `EACCES` or "file is newer" when saving | `Ctrl+Shift+P` → `Developer: Reload Window` |
| References show as `[?]` | `cite.bib` is empty. Fill it, then `Ctrl+Alt+C` and rebuild |
| The PDF does not update | `Ctrl+Alt+C` to clean, then rebuild |
| Photo colours look washed out | Convert to sRGB: `convert in.jpg -colorspace sRGB -strip out.jpg` |
| Only CI fails | The two tags above do not match |
| An older paper stops with `Command \xxx already defined` | See "Inheriting an older paper" below |

### Inheriting an older paper

When you build a paper written with a TeX Live from several years ago — a senior student's thesis,
say — it may stop with `LaTeX Error: Command \xxx already defined`.

The paper is not wrong. **A command it defined for itself has since been added to TeX Live as a
standard command**, and the names collide. Add one line just before the definition
(`\newcommand{\xxx}`) and the paper's own definition wins, so it builds as before.

```latex
\let\xxx\relax
\newcommand{\xxx}{...}
```

This template pins the environment to a fixed version, so **papers written with it will not run
into this problem later.** That is exactly why the version is pinned.

---

## 10. How it works (you do not need this to use it)

Three repositories work together.

```
texlive-ja          Recipe for the TeX environment. Touched a few times a year
   │ built automatically by GitHub Actions
   ▼
ghcr.io/norak29/texlive-ja:2026.11.24     environment frozen under a date tag
   │ referenced by that exact tag
   ▼
paper-template      this repository — the skeleton of a paper
   │ Use this template
   ▼
your paper          what you touch every day
```

Because the environment is pinned to a date tag, **the output does not change when you
reopen the project months later for revisions.** TeX Live is updated continuously and the
same source can otherwise produce different output.

| File | Purpose |
|---|---|
| `.latexmkrc` | Engine selection and the search path for `sty/` |
| `.devcontainer/` | Which environment to use, and VS Code settings |
| `.github/workflows/` | Builds the PDF when you push a tag |
| `CLAUDE.md` | Project conventions, read by Claude Code |
| `sty/` | Conference style files |
| `fig/` | Figures |
| `cite.bib` | References |
| `_inbox/` | Scratch space (not tracked by git) |
