import libbeer/wine/[
  prefix
]
import libbeer/roblox/[
  fflags
]

import std/tables

let fflagsObj = FFlags()
fflagsObj["e"] = "f"
fflagsObj.apply("0.1.0")
