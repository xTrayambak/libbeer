import std/[strformat, os], zippy, ferus_sanchar/[url, http, sanchar], ../logging, prefix

const DXVK_REPO* {.strdefine.} = "https://github.com/doitsujin/dxvk"

proc setEnv* =
  info "Enabling DXVK DLL overrides"

  putEnv("WINEDLLOVERRIDES", getEnv("WINEDLLOVERRIDES") & ";d3d10core=n;d3d11=n;d3d9=n;dxgi=n")

proc removeDxvk*(prefix: Prefix) =
  info "libbeer: Removing all overriden DXVK DLLs"

  for _, dir in ["syswow64", "system32"]:
    for _, dll in ["d3d9", "d3d10core", "d3d11", "dxgi"]:
      let dllPath = prefix.dir / "drive_c" / "windows" / dir / dll & ".dll"

      info "libbeer: Removing DLL: " & dllPath

      if not tryRemoveFile(dllPath):
        warn "DLL file not found, skipping."

proc fetchDxvk*(prefix: Prefix, name, version: string) =
  error "libbeer: DXVK is still not implemented. Sorry. :("
  quit 1

  let url = DXVK_REPO & "$1/releases/download/v{version}s/dxvk-{version}s.tar.gz"

  if fileExists(name):
    info "DXVK " & version & " is already downloaded; skipping!"
    return
  
  info "libbeer: Downloading DXVK" & version & " (" & name & ")"

  let 
    urlParser = newURLParser()
    url = urlParser.parse(url)
    httpClient = newHTTPClient()

  proc onDownloadDxvk(conn: Connection, resp: Response) =
    if resp.code != 200:
      error "libbeer: onDownloadDxvk(): Non-successful response code returned!"
      error resp.body
      quit 1

    info "libbeer: onDownloadDxvk(): Sanchar has fetched DXVK!"

    let file = open(name, fmWrite)
    defer: close(file)
    file.write(resp.body)

    let 
      decompressedData = uncompress(resp.body, dfGzip)
    
    # TODO: add DXVK support further on from here

  httpClient.fetch(
    url,
    onDownloadDxvk
  )

  httpClient.process()
