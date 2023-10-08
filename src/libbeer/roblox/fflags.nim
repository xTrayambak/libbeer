import std/[strutils, os, tables], jsony, ../logging

const
  DEFAULT_RENDERER* = "OpenGL"
  RENDERERS* = [
    "opengl",
    "d3d11fl10",
    "d3d11",
    "vulkan"
  ]

type FFlags* = TableRef[string, string]

proc apply*(fflags: FFlags, versionDir: string) =
  let dir = versionDir / "ClientSettings"
  let path = dir / "ClientAppSettings.json"

  if fflags.len < 1:
    return
  
  info "libbeer: Applying FFlags"
  
  discard existsOrCreateDir(versionDir)
  discard existsOrCreateDir(dir)

  let file = open(path, fmWrite)
  defer: file.close()

  let serialized = toJson(fflags)

  info "libbeer: FFlags used: " & serialized
  
  file.write(serialized)

  info "libbeer: Written FFlags successfully."

proc validRenderer*(renderer: string): bool {.inline.} =
  for rMode in RENDERERS:
    if renderer.toLowerAscii() == rMode:
      return true

  return false

proc setRenderer*(fflags: FFlags, optRenderer: string) =
  var renderer: string
  if optRenderer.len < 1:
    renderer = DEFAULT_RENDERER

  if not validRenderer(renderer):
    error "libbeer: Invalid renderer provided to setRenderer(): \"" & renderer & "\""
    error "libbeer: expected one of the following: OpenGL, Vulkan, D3D11, D3D11FL10 (it's case insensitive!)"
    quit 1
  
  info "libbeer: using renderer: " & renderer

  for rBackend in RENDERERS:
    let isRenderer = rBackend == renderer

    fflags["FFlagDebugGraphicsPrefer" & rBackend] = $isRenderer
    fflags["FFlagDebugGraphicsDisable" & rBackend] = $(not isRenderer)
