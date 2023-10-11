# Package

version       = "0.1.0"
author        = "xTrayambak"
description   = "bLaZiNgLy fAsT aNd MeMoRy SaFe mAxFeTcH kIlLeR"
license       = "GPL-2.0-only"
srcDir        = "src"
bin           = @["trayfetch"]


# Dependencies

requires "nim >= 1.6.14"
requires "tomlserialization"

task release, "Release build":
  exec """
nim c \
--opt:speed \
--opt:size \
-d:release \
-d:danger \
--mm: none \
--hints: off \
--outdir: "." \
src/trayfetch.nim
  """

  exec "strip ./trayfetch"
