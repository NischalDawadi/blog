#!/bin/bash
set -euo pipefail

# ======== CONFIG ========
obsidianPosts="/home/codingclinician/Documents/Com-med/posts"       # Obsidian Markdown files
attachmentsPath="/home/codingclinician/Documents/Com-med/attachments" # Obsidian attachments
hugoContent="/home/codingclinician/Documents/demo/blog/content/posts"    # Hugo content folder
hugoStatic="/home/codingclinician/Documents/demo/blog/static"           # Hugo static folder
# ========================

echo "📂 Copying Markdown files from Obsidian to Hugo..."
mkdir -p "$hugoContent"
rsync -av --delete "$obsidianPosts/" "$hugoContent/"

echo "🖼 Processing image/PDF links..."
mkdir -p "$hugoStatic/images" "$hugoStatic/pdf"

# Find all Obsidian-style links ![[file]] or [[file]]
grep -rhoE '!?(\[\[[^]]+\]\])' "$hugoContent" || true | while IFS= read -r raw; do
    # Extract filename inside [[...]]
    file=$(echo "$raw" | sed 's/.*\[\[\(.*\)\]\].*/\1/')
    src="$attachmentsPath/$file"

    if [ -f "$src" ]; then
        ext="${file##*.}"

        if [[ "$ext" =~ ^(png|jpg|jpeg|gif|webp)$ ]]; then
            echo "📷 Copying image: $file"
            cp -n "$src" "$hugoStatic/images/"

            # Escape special characters for sed
            escaped=$(printf '%s\n' "$file" | sed 's/[&/\ ]/\\&/g')
            find "$hugoContent" -type f -name "*.md" -exec sed -i '' "s|!\[\[$escaped\]\]|![](/images/$file)|g" {} +

        elif [[ "$ext" == "pdf" ]]; then
            echo "📄 Copying PDF: $file"
            cp -n "$src" "$hugoStatic/pdf/"

            # Escape for sed
            escaped=$(printf '%s\n' "$file" | sed 's/[&/\ ]/\\&/g')
            find "$hugoContent" -type f -name "*.md" -exec sed -i '' "s|\[\[$escaped\]\]|[Download PDF](/pdf/$file)|g" {} +
        fi
    else
        echo "⚠ Attachment not found: $src"
    fi
done

echo "✅ Image/PDF processing complete."
