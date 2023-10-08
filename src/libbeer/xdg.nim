#[
  Freedesktop.org stuff
]#

import std/osproc, logging

proc xdgOpen*(file: string): int =
  info "libbeer: asking freedesktop utils to act on file: \"" & file & "\""
  execCmd("xdg-open " & file)
