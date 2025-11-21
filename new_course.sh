#!/bin/bash

# 1. Get Course Details
echo "------------------------------------------------"
echo "🎓 Quarto Course Generator"
echo "------------------------------------------------"
read -p "Enter Course Name (e.g., Modern Control): " COURSE_NAME
read -p "Enter Course Code (e.g., 5SMC0): " COURSE_CODE
read -p "Enter Quartile (e.g., 2025-Q2): " QUARTILE

# 2. Create Slug (folder-name-style)
# Converts "Modern Control" -> "modern-control"
SLUG=$(echo "$COURSE_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "🚀 Creating project folder: $SLUG..."
mkdir -p "$SLUG"
cd "$SLUG"

# 3. Create _quarto.yml
cat <<EOF > _quarto.yml
project:
  type: website
  output-dir: docs

website:
  title: "$COURSE_CODE $COURSE_NAME"
  navbar:
    left:
      - href: index.qmd
        text: Home
    right:
      - icon: github
        href: https://github.com/YOUR_USERNAME/$SLUG

execute:
  freeze: auto

format:
  html:
    theme: cosmo
    toc: true
EOF

# 4. Create index.qmd (Landing Page)
cat <<EOF > index.qmd
---
title: "$COURSE_NAME"
subtitle: "$COURSE_CODE ($QUARTILE)"
---

## Course Overview
Welcome to the lecture notes for **$COURSE_NAME**.

* **Code:** $COURSE_CODE
* **Period:** $QUARTILE

## Lectures
EOF

# 5. Create .gitignore
cat <<EOF > .gitignore
/.quarto/
/_site/
/.DS_Store
/__pycache__/
/docs/
EOF

# 6. Create the GitHub Action (publish.yml)
mkdir -p .github/workflows
cat <<EOF > .github/workflows/publish.yml
on:
  workflow_dispatch:
  push:
    branches: main

name: Quarto Publish

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up Quarto
        uses: quarto-dev/quarto-actions/setup@v2

      - name: Render and Publish
        uses: quarto-dev/quarto-actions/publish@v2
        with:
          target: gh-pages
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
EOF

# 7. Initialize Git
git init
git add .
git commit -m "Initial setup for $COURSE_NAME"

echo "------------------------------------------------"
echo "✅ Done! Project created in folder: $SLUG"
echo ""
echo "NEXT STEPS:"
echo "1. Open VS Code:  code $SLUG"
echo "2. Create repo on GitHub: https://github.new"
echo "3. Run the commands GitHub gives you (git remote add...)"
echo "4. Add this entry to your Hub's courses.yml:"
echo ""
echo "- title: \"$COURSE_NAME\""
echo "  subtitle: \"$COURSE_CODE\""
echo "  quartile: \"$QUARTILE\""
echo "  path: https://YOUR_USERNAME.github.io/$SLUG/"
echo "  image: images/default.png"
echo "------------------------------------------------"