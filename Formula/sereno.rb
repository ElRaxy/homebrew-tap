class Sereno < Formula
  include Language::Python::Shebang

  desc "See what every coding-agent session on your machine is actually doing"
  homepage "https://github.com/ElRaxy/sereno"
  # El asset suelto de la release, no el tarball del tag: el repo lleva un GIF de
  # demo de 1,7 MB que no pinta nada en una instalacion. Esto son 244 KB.
  url "https://github.com/ElRaxy/sereno/releases/download/v1.36.6/sereno"
  sha256 "7612051056b9381ceb554ef87ec1333c9416619fc2086912029be0f6590713f5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.13"

  def install
    # La v1.13.0 se publico con un asset que NO era el programa —un log de git, por una
    # expansion de zsh— y las releases de GitHub son inmutables, asi que ese fichero roto
    # sigue ahi para siempre. `release.sh` verifica lo publicado descargandolo; esto es la
    # misma comprobacion en el otro extremo del cable, porque `brew install` se traga sin
    # rechistar cualquier cosa cuyo sha256 cuadre, y el fallo no se veria hasta arrancar.
    # Dos hechos, y el veredicto compuesto encima: nada de "parece correcto".
    contenido = (buildpath/"sereno").read
    shebang_ok = contenido.start_with?("#!/usr/bin/env python3\n")
    version_ok = contenido.include?("VERSION = \"#{version}\"")
    odie <<~EOS if !shebang_ok || !version_ok
      what was downloaded is not sereno #{version}
        starts with the shebang: #{shebang_ok}
        declares VERSION = "#{version}": #{version_ok}
    EOS

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
