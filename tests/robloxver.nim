import libbeer/roblox/[binarykind, version], std/options

let v = getLatestVersion(bkPlayer, "zintegration")

if v.isSome:
  echo $v.get()
