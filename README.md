# Quarto academic website + CV starter

This starter uses one visual system across the website and CV:

- **Spectral Bold** — name / identity
- **Source Serif 4** — long-form reading, CV body, section headings
- **Source Sans 3** — navigation, metadata, dates, contact line, page numbers

The HTML site supports Quarto's built-in **light / dark color-scheme toggle**. The PDF intentionally stays in a print-friendly light design.

## Preview website

```bash
quarto preview
```

Quarto renders the website with both a light and a dark theme. The toggle appears in the site navigation automatically when both schemes are configured.

## Render CV PDF

```bash
quarto render cv.qmd --to pdf
```

PDF output uses XeLaTeX. If TeX is not installed:

```bash
quarto install tinytex
```

## Fonts

### Web

`styles.css` currently loads Spectral, Source Serif 4, and Source Sans 3 from the Google Fonts CSS service. All three families are open-source fonts.

This gives visitors the intended typography even when those fonts are not installed on their devices.

If you prefer to self-host fonts later, replace the `@import` statement at the top of `styles.css` with local `@font-face` rules and put the appropriately licensed WOFF2 files in an assets/fonts directory.

### PDF

XeLaTeX does not read CSS web fonts. It uses installed desktop font families. `cv/cv-style.tex` therefore tries, in order:

- Source Serif 4 (fallback: Source Serif Pro → TeX Gyre Pagella)
- Spectral (fallback: TeX Gyre Pagella)
- Source Sans 3 (fallback: Source Sans Pro → TeX Gyre Heros)

For exact HTML/PDF typography on your own machine, install the three open-source font families locally as well as loading them on the web.

For completely reproducible CI builds, a later step can place licensed/open font files in the repository and point both CSS and XeLaTeX to the same local files.

## Light / dark design tokens

Site colors are defined once in `styles.css` using CSS variables such as:

```css
--page-bg
--text-primary
--text-muted
--rule
--link
```

Light values live in `:root`; dark values override them in `body.quarto-dark`. CV-specific CSS consumes the same variables, so the entire site changes scheme consistently without duplicating colors.

The dark palette intentionally uses a warm near-black background and soft off-white text instead of pure black/white, which is gentler for long serif reading.

## File roles

```text
_quarto.yml         site structure + light/dark Quarto themes
styles.css          global typography, colors, navbar, night mode
cv.qmd              single CV content source
cv/cv.css           responsive web-CV layout
cv/cv-style.tex     print/PDF typography and pagination
cv/cv.lua           semantic CV blocks → LaTeX layout
index.qmd            home page
research.qmd         research page
```

## CV behavior

On desktop, CV dates appear as a right-hand column. On smaller screens they stack underneath the entry instead of compressing the content.

The PDF keeps the A4 print layout, hanging citations, compact bullets, first-page header suppression, running header on later pages, and dynamic `Page n of N` numbering.

## Responsive homepage profile

`index.qmd` now contains a Jekyll-style academic profile area with a portrait/initials avatar, name, position, affiliation, location, contact links, and an optional short note.

- Desktop: profile rail on the left, main prose on the right; the profile stays visible while reading.
- Tablet: narrower two-column layout with more width reserved for the main text.
- Mobile: portrait and identity become a compact header card above the main content; contact links become touch-friendly pills.
- Very narrow phones: the avatar and contact controls shrink without forcing horizontal scrolling.
- Dark mode: all profile surfaces, rules, links, and controls reuse the same site color tokens and switch automatically.

To use a portrait, place an image at `images/profile.jpg` and replace the `.profile-avatar` block in `index.qmd` with the commented `.profile-photo` example. A square or 4:5 image works well; CSS crops it to a circle on the site. Keep meaningful `alt` text for accessibility.

## Navigation and dark-mode stability

This version uses the same Bootstrap base theme (`cosmo`) for both light and dark modes. The two SCSS files change only colors, so toggling appearance does not swap in a theme with different spacing/typographic metrics. The navbar and the color-scheme toggle also have fixed geometry to prevent the sun/moon icon from changing navbar height.

The CV page has a valid string title (`Curriculum Vitae`) with the title block hidden, rather than `title: false`. Its additional PDF-format link is hidden from the HTML page with `format-links: false`; the PDF can still be rendered explicitly with:

```bash
quarto render cv.qmd --to pdf
```

For website navigation testing, always run the preview from the project root (the folder containing `_quarto.yml`):

```bash
quarto preview
```

If you previously previewed the broken version, stop the preview server, delete `_site/` and `.quarto/` if present, then run `quarto preview` again so stale output does not mask the fixes.


## Hidden page headings and CV PDF download

`index.qmd` and `cv.qmd` retain a semantic H1 using the `page-heading-visually-hidden` class, so the document outline remains meaningful without showing a redundant page heading above the designed layout. The visible profile name on the Home page is a styled `div`, avoiding duplicate H1 headings.

The CV page includes an HTML-only **Download PDF** button that points to `cv.pdf`. Because `cv.qmd` defines both HTML and PDF formats, render the project normally for deployment, or generate the PDF explicitly with:

```bash
quarto render cv.qmd --to pdf
```

For local preview, if `cv.pdf` has not yet been generated, run the command above once. The button itself is excluded from the PDF output.

### Profile typography hierarchy
The home profile now uses Spectral only for the visible name. Position/program, affiliation, and location are rendered with Source Sans 3 at progressively smaller sizes so they read as profile metadata rather than as display text. Mobile breakpoints preserve the same hierarchy.


## Heading visibility fix

Home and CV now rely only on the YAML `title` metadata plus `title-block-style: none`.
The previous visually-hidden Markdown H1 elements and their CSS have been removed to avoid interfering with page content rendering.

After replacing an older copy, clear Quarto's generated files and preview again:

```bash
rm -rf _site .quarto
quarto preview
```


## Automatic page title visibility

The YAML `title` values are retained for document metadata, but the automatically
generated Quarto title block is hidden on the website with the conservative rule:

```css
#title-block-header {
  display: none;
}
```

This does not hide or reposition headings inside the page body.
