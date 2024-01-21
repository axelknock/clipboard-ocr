let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation rec {
  pname = "clipboard-ocr";
  version = "0.1.0";
  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    cp -r $src $out/bin/clipboard-ocr
  '';

  meta = with pkgs.lib; {
    description = "Run Tesseract Optical Character Recognition (OCR) on image in clipboard and put result into clipboard.";
    homepage = "https://github.com/axelknock/clipboard-ocr";
    license = licenses.mit;
    maintainers = with maintainers; [ "axelknock" ];
    platforms = platforms.linux;
  };
}
