#!/bin/bash

# HTML to PDF Converter Script
# Usage: ./html2pdf.sh input.html [output.pdf]

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Error: No input file specified"
    echo "Usage: $0 input.html [output.pdf]"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found"
    exit 1
fi

# Determine output filename
if [ $# -eq 2 ]; then
    OUTPUT_FILE="$2"
else
    # Remove .html extension and add .pdf
    OUTPUT_FILE="${INPUT_FILE%.html}.pdf"
fi

# Check if wkhtmltopdf is installed
if command -v wkhtmltopdf &> /dev/null; then
    echo "Converting $INPUT_FILE to $OUTPUT_FILE using wkhtmltopdf..."
    wkhtmltopdf "$INPUT_FILE" "$OUTPUT_FILE"
    
# Check if weasyprint is installed
elif command -v weasyprint &> /dev/null; then
    echo "Converting $INPUT_FILE to $OUTPUT_FILE using weasyprint..."
    weasyprint "$INPUT_FILE" "$OUTPUT_FILE"
    
# Check if pandoc is installed (with wkhtmltopdf as pdf-engine)
elif command -v pandoc &> /dev/null; then
    echo "Converting $INPUT_FILE to $OUTPUT_FILE using pandoc..."
    # Try with different PDF engines
    if command -v wkhtmltopdf &> /dev/null; then
        pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" --pdf-engine=wkhtmltopdf
    elif command -v prince &> /dev/null; then
        pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" --pdf-engine=prince
    else
        echo "Warning: pandoc found but no PDF engine available"
        echo "Trying chromium/chrome headless..."
        if command -v chromium-browser &> /dev/null; then
            chromium-browser --headless --disable-gpu --print-to-pdf="$OUTPUT_FILE" "$INPUT_FILE"
        elif command -v google-chrome &> /dev/null; then
            google-chrome --headless --disable-gpu --print-to-pdf="$OUTPUT_FILE" "$INPUT_FILE"
        elif command -v chromium &> /dev/null; then
            chromium --headless --disable-gpu --print-to-pdf="$OUTPUT_FILE" "$INPUT_FILE"
        else
            echo "Error: No suitable PDF engine found for pandoc"
            exit 1
        fi
    fi
    
else
    echo "Error: No PDF conversion tool found"
    echo "Please install one of the following:"
    echo "  - wkhtmltopdf: sudo apt install wkhtmltopdf (Debian/Ubuntu)"
    echo "  - weasyprint: pip install weasyprint"
    echo "  - chromium: sudo apt install chromium-browser (Debian/Ubuntu)"
    echo ""
    echo "Quick alternative - use browser print:"
    echo "  Open $INPUT_FILE in a browser and use Print > Save as PDF"
    exit 1
fi

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Success! PDF saved to: $OUTPUT_FILE"
else
    echo "Error: Conversion failed"
    exit 1
fi
