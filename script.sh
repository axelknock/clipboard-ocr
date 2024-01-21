#!/usr/bin/env bash

# Function to check if we're running under Wayland or Xorg
is_wayland() {
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to get an image from the clipboard
get_image_from_clipboard() {
    if is_wayland; then
        if command_exists wl-paste; then
            wl-paste --type image/png
        else
            echo "Error: wl-paste is not installed. Please install wl-clipboard." >&2
            return 1
        fi
    else
        if command_exists xclip; then
            xclip -selection clipboard -t image/png -o
        else
            echo "Error: xclip is not installed. Please install xclip." >&2
            return 1
        fi
    fi
}

# Function to put text into the clipboard
put_text_into_clipboard() {
    if is_wayland; then
        if command_exists wl-copy; then
            echo "$1" | wl-copy
        else
            echo "Error: wl-copy is not installed. Please install wl-clipboard." >&2
            return 1
        fi
    else
        if command_exists xclip; then
            echo "$1" | xclip -selection clipboard
        else
            echo "Error: xclip is not installed. Please install xclip." >&2
            return 1
        fi
    fi
}

# Temporary file for storing the image from the clipboard
IMAGE_FILE=$(mktemp --suffix=.png)

# Retrieve the image from the clipboard and save to a temporary file
if ! get_image_from_clipboard > "$IMAGE_FILE"; then
    # Cleanup and exit if clipboard command fails
    rm "$IMAGE_FILE"
    exit 1
fi

# Check if Tesseract is installed
if ! command_exists tesseract; then
    echo "Error: tesseract-ocr is not installed. Please install it." >&2
    rm "$IMAGE_FILE"
    exit 1
fi

# Perform OCR on the image file using Tesseract
TEXT=$(tesseract "$IMAGE_FILE" stdout 2> /dev/null)

# Remove the temporary image file
rm "$IMAGE_FILE"

# If OCR text is not empty, put it into the clipboard
if [ -n "$TEXT" ]; then
    if ! put_text_into_clipboard "$TEXT"; then
        exit 1
    fi
    echo "OCR text has been copied to the clipboard."
else
    echo "Error: No text found by OCR." >&2
    exit 1
fi
