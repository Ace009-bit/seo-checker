#!/bin/bash

clear
echo " "
echo "@@@@@@ @@@@@@@@  @@@@@@        @@@@@@@ @@@  @@@ @@@@@@@@  @@@@@@@ @@@  @@@ @@@@@@@@ @@@@@@@"
echo "!@@     @@!      @@!  @@@      !@@      @@!  @@@ @@!      !@@      @@!  !@@ @@!      @@!  @@@"
echo " !@@!!  @!!!:!   @!@  !@!      !@!      @!@!@!@! @!!!:!   !@!      @!@@!@!  @!!!:!   @!@!!@!"
echo "    !:! !!:      !!:  !!!      :!!      !!:  !!! !!:      :!!      !!: :!!  !!:      !!: :!!"
echo " ::.: :  : :: :::  : :. :        :: :: :  :   : : : :: :::  :: :: :  :   ::: : :: :::  :   : :"
echo "-------------------------------------------------------------------------------------------"
echo "🔍 Automated SEO Checker for Linux"
echo "-------------------------------------------------------------------------------------------"

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <website_url>"
    exit 1
fi

URL=$1
echo "🔍 Analyzing SEO for: $URL"
echo "-----------------------------------"

# Fetch HTML content
HTML=$(curl -s "$URL")

# Check Title Tag
TITLE=$(echo "$HTML" | grep -oP '(?<=<title>).*?(?=</title>)')
if [ -z "$TITLE" ]; then
    echo "[❌] Title tag is missing."
    echo "💡 Suggestion: Add a title tag with relevant keywords."
else
    echo "[✅] Title: $TITLE"
    if [ ${#TITLE} -lt 40 ] || [ ${#TITLE} -gt 60 ]; then
        echo "⚠️ Warning: Title should be between 40-60 characters for best SEO."
    fi
fi

# Check Meta Description
META_DESC=$(echo "$HTML" | grep -oP '(?<=<meta name="description" content=").*?(?=")')
if [ -z "$META_DESC" ]; then
    echo "[❌] Meta description is missing."
    echo "💡 Suggestion: Add a meta description with 150-160 characters including keywords."
else
    echo "[✅] Meta Description: $META_DESC"
    if [ ${#META_DESC} -lt 150 ] || [ ${#META_DESC} -gt 160 ]; then
        echo "⚠️ Warning: Meta description should be between 150-160 characters."
    fi
fi

# Check Heading Tags
H1_TAGS=$(echo "$HTML" | grep -oP '(?<=<h1>).*?(?=</h1>)' | wc -l)
H2_TAGS=$(echo "$HTML" | grep -oP '(?<=<h2>).*?(?=</h2>)' | wc -l)

if [ "$H1_TAGS" -eq 0 ]; then
    echo "[❌] No H1 tag found."
    echo "💡 Suggestion: Use at least one H1 tag with the main keyword."
else
    echo "[✅] Found $H1_TAGS H1 tag(s)."
fi

echo "[✅] Found $H2_TAGS H2 tag(s). Consider using more H2 tags to structure content."

# Check Robots.txt
if curl -s --head "$URL/robots.txt" | grep "200 OK" > /dev/null; then
    echo "[✅] robots.txt found."
else
    echo "[❌] robots.txt missing."
    echo "💡 Suggestion: Create a robots.txt to guide search engines."
fi

# Check Sitemap
if curl -s --head "$URL/sitemap.xml" | grep "200 OK" > /dev/null; then
    echo "[✅] Sitemap found."
else
    echo "[❌] Sitemap missing."
    echo "💡 Suggestion: Create a sitemap.xml for better indexing."
fi

# Check Images for alt attributes
MISSING_ALT=$(echo "$HTML" | grep -o '<img [^>]*>' | grep -vc 'alt=')
if [ "$MISSING_ALT" -gt 0 ]; then
    echo "[❌] Found $MISSING_ALT image(s) missing alt attributes."
    echo "💡 Suggestion: Add alt text to all images for SEO and accessibility."
else
    echo "[✅] All images have alt attributes."
fi

# Check for broken links
echo "🔍 Checking for broken links..."
LINKS=$(echo "$HTML" | grep -oP '(?<=href=")[^"]*' | grep '^http')
BROKEN_COUNT=0
for LINK in $LINKS; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$LINK")
    if [ "$STATUS" -ne 200 ]; then
        echo "[❌] Broken link detected: $LINK (Status: $STATUS)"
        BROKEN_COUNT=$((BROKEN_COUNT + 1))
    fi
done

if [ "$BROKEN_COUNT" -eq 0 ]; then
    echo "[✅] No broken links found."
fi

echo "-----------------------------------"
echo "🎯 **SEO Optimization Suggestions**"
echo "-----------------------------------"

if [ -z "$TITLE" ]; then
    echo "⚡ Add a title tag with relevant keywords."
fi

if [ -z "$META_DESC" ]; then
    echo "⚡ Add a meta description (150-160 characters)."
fi

if [ "$H1_TAGS" -eq 0 ]; then
    echo "⚡ Use at least one H1 tag with main keywords."
fi

if [ "$MISSING_ALT" -gt 0 ]; then
    echo "⚡ Add alt text to all images."
fi

if [ ! curl -s --head "$URL/robots.txt" | grep "200 OK" > /dev/null ]; then
    echo "⚡ Create a robots.txt file."
fi

if [ ! curl -s --head "$URL/sitemap.xml" | grep "200 OK" > /dev/null ]; then
    echo "⚡ Create a sitemap.xml file."
fi

if [ "$BROKEN_COUNT" -gt 0 ]; then
    echo "⚡ Fix broken links to avoid negative SEO impact."
fi

echo "✅ **SEO Analysis Completed!** 🚀"
