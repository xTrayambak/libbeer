import std/[strtabs, os, osproc], ../logging

type Prefix* = ref object of RootObj
  dir*: string
  output*: File

proc initialize*(prefix: Prefix) =
  info "libbeer: initializing wine prefix"
  discard existsOrCreateDir(prefix.dir)

  echo execCmdEx("wineboot -i").output

proc setup*(prefix: Prefix) =
  if dirExists(prefix.dir / "drive_c" / "windows"):
    warn "libbeer: setup(): won't continue, prefix folders seem to exist already"
    return
  
  info "libbeer: setting up wine prefix"
  prefix.initialize()

proc kill*(prefix: Prefix) =
  info "libbeer: killing wine prefix"
  discard execCmd("wineserver -k")

proc newPrefix*(dir: string = ""): Prefix =
  let rdir = case dir.len
  of 0: getHomeDir()
  else: dir
  Prefix(
    dir: rdir,
    output: stderr
  )

proc runCommand*(prefix: Prefix, name: string, arg: seq[string]): tuple[output: string, exitCode: int] =
  var 
    args = " "
    env = newStringTable()

  for name, key in envPairs():
    env[name] = key
  
  env["WINEPREFIX"] = prefix.dir

  for a in arg:
    args &= a & " "
  
  info "Running command: " & name & args
  result = execCmdEx(
    name & args,
    env = env
  )

  if result.exitCode != 0:
    error "Command failed with non-zero exit code " & $result.exitCode & ": \"" & result.output & "\""

  discard args
  discard env

proc wine*(prefix: Prefix, exe: string, arg: seq[string]): tuple[output: string, exitCode: int] =
  prefix.runCommand("wine " & exe, arg)
