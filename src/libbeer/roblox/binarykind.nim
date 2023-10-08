type BinaryKind* = enum
  bkPlayer
  bkStudio

proc `$`*(kind: BinaryKind): string =
  result = case kind
  of bkPlayer: "Player"
  of bkStudio: "Studio64"

proc binaryName*(kind: BinaryKind): string =
  result = case kind
  of bkPlayer: "WindowsPlayer"
  of bkStudio: "WindowsStudio64"
