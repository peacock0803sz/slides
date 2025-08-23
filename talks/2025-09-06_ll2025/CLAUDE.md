# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Slidev-based presentation project for "Learn Languages 2025" conference about Python package managers. The presentation covers the history and evolution of Python package management tools.

## Key Files Structure

- `slides.md` - Main presentation content in Slidev markdown format
- `package.json` - Node.js dependencies and build scripts
- `vite.config.js` - Vite configuration with Google Analytics integration
- `styles/` - Custom CSS and layout files
- `public/` - Static assets (images, logos, QR codes)
- `slides-export/` - Generated slide images from export process

## Common Development Commands

**Development server:**
```bash
npm run dev
```

**Build for production:**
```bash
npm run build
```
This builds with base path `/ll2025/` and moves output to `../../dist/ll2025/`

**Format slides:**
```bash
npm run format
```

**Export to PDF:**
```bash
npm run export:pdf
```
Creates `dist/ll2025.pdf`

**Export cover image:**
```bash
npm run export:cover
```
Generates slide images and moves first slide to `public/cover.png`

## Architecture Notes

- Built with Slidev framework for markdown-based presentations
- Uses custom theme `@peacock0803sz/theme-simple` from workspace
- Configured for deployment with `/ll2025/` base path
- Includes Google Analytics integration via vite-plugin-radar
- Presentation content is entirely in Japanese about Python packaging history
- Supports QR code generation for slide URLs
- Uses Playwright for slide export functionality

## Theme and Styling

- Custom theme located at workspace package `@peacock0803sz/theme-simple`
- Custom styles in `styles/layout.css` imported via `styles/index.ts`
- Inherits from Slidev base layouts with custom overrides

## Deployment Configuration

The build process is configured for a specific deployment structure:
- Base path: `/ll2025/`
- Output moved to `../../dist/ll2025/` after build
- Optimized for web deployment with proper asset paths