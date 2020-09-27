#!/bin/bash

# Install pandoc and asciidoc:
# sudo apt install pandoc asciidoc

# Convert asciidoc to docbook:
asciidoctor -b docbook docs/README.adoc -o README.xml

# Convert docbook to markdown:
pandoc -f docbook -t markdown_strict README.xml -o README.md
rm README.xml