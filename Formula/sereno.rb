class Sereno < Formula
  include Language::Python::Shebang

  desc "See what every coding-agent session on your machine is actually doing"
  homepage "https://github.com/ElRaxy/sereno"
  # El asset suelto de la release, no el tarball del tag: el repo lleva un GIF de
  # demo de 1,7 MB que no pinta nada en una instalacion. Esto son 244 KB.
  url "https://github.com/ElRaxy/sereno/releases/download/v1.13.1/sereno"
  # La URL no lleva la version en el nombre del fichero, asi que Homebrew no puede
  # deducirla. Sin esta linea la formula se instala como version cero.
  version "1.13.1"
  sha256 "61d80f727c9cc5491dd122b1fe9e11c909a430dc54a826550832043fb48e6e82"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.13"

  def install
    bin.install "sereno"
    # El shebang de serie es `/usr/bin/env python3`, que en un Mac sin Command Line
    # Tools no resuelve a nada. Apuntarlo al python de esta formula es lo que hace
    # que la dependencia declarada sirva de algo.
    rewrite_shebang detected_python_shebang, bin/"sereno"
  end

  test do
    assert_match "sereno #{version}", shell_output("#{bin}/sereno --version")

    # Con HOME vacio no hay ni una sesion: el caso de una maquina recien instalada,
    # que es justo donde un TUI mal empaquetado revienta en vez de decir que no hay nada.
    ENV["HOME"] = testpath
    system bin/"sereno", "--list"

    # El modo demo no toca datos reales y da salida tipada: sirve de control positivo
    # de que el programa hace algo, no solo de que arranca.
    output = shell_output("SERENO_DEMO=1 #{bin}/sereno --json")
    assert_equal version.to_s, JSON.parse(output)["sereno"]
    refute_empty JSON.parse(output)["sessions"]

    # Un flag que no existe se dice, no se traga.
    assert_match "sereno", shell_output("#{bin}/sereno --noexiste 2>&1", 2)
  end
end
