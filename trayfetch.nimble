# Package

version       = "0.1.0"
author        = "xTrayambak"
description   = "bLaZiNgLy fAsT aNd MeMoRy SaFe mAxFeTcH kIlLeR"
license       = "GPL-2.0-only"
srcDir        = "src"
bin           = @["trayfetch"]


# Dependencies

requires "nim >= 1.6.14"

when not defined(noConfig):
  requires "tomlserialization"

after build:
  exec "strip ./trayfetch"
