{ pkgs }:
pkgs.writeShellApplication {
  name = "clipboard-ocr";
  runtimeInputs = with pkgs; [ tesseract xclip wl-clipboard ];
  text = builtins.readFile ./script.sh;
} 
