# GEMINI Project Context

This document provides context for the Gemini AI assistant to understand the project.

## Project Overview

This is a Slidev-based presentation project for "Learn Languages 2025" conference about Python package managers. The presentation covers the history and evolution of Python package management tools.

This project is a presentation created with [Slidev](https://sli.dev/). The presentation is about the past, present, and future of Python package managers. The content is written in Markdown in the `slides.md` file. The project uses `@slidev/cli` and a custom theme `@peacock0803sz/theme-simple`.

## Building and Running

The following commands are available in `package.json`:

*   `npm run dev`: Start the development server.
*   `npm run build`: Build the presentation for production.
*   `npm run format`: Format the `slides.md` file.
*   `npm run export:pdf`: Export the presentation as a PDF.
*   `npm run export:cover`: Export the cover slide as a PNG image.

## Development Conventions

*   The presentation content is in `slides.md`.
*   The theme is located in `../../themes/simple`.
*   The project uses `vite-plugin-radar` for analytics.
