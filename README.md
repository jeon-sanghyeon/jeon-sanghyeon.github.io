# Personal Website

Personal academic website built with Quarto.

## Workflow

After making changes:

### 1. Preview locally

```         
quarto preview 
```

### 2. Render the website

```         
quarto render
```

### 3. Render the CV PDF

```         
quarto render cv.qmd --to pdf
```

### 4. Publish the rendered site to gh-pages

```         
quarto publish gh-pages
```

### 5. Commit and push source changes to main

```         
git add .
```

```         
git commit -m "Update website"
```

```         
git push
```

In short:

**Edit → Preview → Render → Publish to gh-pages → Commit & push to main**

## Project Structure

-   index.qmd — Home
-   research.qmd — Research
-   cv.qmd — CV source
-   cv.pdf — Rendered CV
-   styles.css — Site-wide styles
-   theme-light.scss / theme-dark.scss — Light and dark themes
-   cv/cv.css — CV web styles
-   cv/cv-style.tex — CV PDF styles
-   cv/cv.lua — CV LaTeX transformations

## Notes

-   Edit CV content in cv.qmd.
-   Do not manually edit \_site/; it is regenerated on render.
-   Render cv.pdf locally before publishing.
-   PDF fonts must be installed on the local machine used for rendering.
-   gh-pages contains the published website; main contains the source files.