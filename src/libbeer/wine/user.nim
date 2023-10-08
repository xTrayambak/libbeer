import std/[os, posix, posix_utils], ../logging, prefix

proc getAppDataDir*(prefix: Prefix): string =
  let passwd = getpwuid(getuid())
  
  assert passwd != nil

  let username = $passwd.pwName

  prefix.dir / "drive_c" / "users" / username / "AppData"
