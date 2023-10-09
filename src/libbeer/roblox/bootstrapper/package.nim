import std/[os, times, httpclient, strutils], zippy/ziparchives, checksums/md5, ../../logging

const
  EXCLUDED_PACKAGES* = [
    "RobloxPlayerLauncher.exe",
    "WebView2RuntimeInstaller.zip",
  ]

type Package* = ref object of RootObj
  name*: string
  checksum*: string
  size*: int64

proc isPackageExcluded*(name: string): bool {.inline.} =
  name in EXCLUDED_PACKAGES

proc perform*(packages: seq[Package], fn: proc(package: Package): bool): bool =
  for _, pkg in packages:
    result = fn(pkg)

    if result != true: break

proc verify*(package: Package, src: string): bool =
  info "libbeer: Verifying package " & package.name & " (" & package.checksum & ")"
  
  assert fileExists(src)
  let pkgFile = readFile(src)
  
  if package.checksum != getMd5(pkgFile):
    error "libbeer: Package " & package.name & " is corrupted, hashes do not match."
    return false
  
  info "libbeer: Package verified successfully!"
  true

proc download*(package: Package, httpClient: HTTPClient, dest, deployUrl: string): bool =
  if fileExists(dest):
    info "libbeer: Package " & package.name & " already exists."
    return true

  info "libbeer: Downloading package " & package.name
  
  try:
    let content = httpClient.getContent(deployUrl & '-' & package.name)

    let file = open(dest, fmWrite)
    defer: file.close()

    file.write(content)
  except HttpRequestError:
    error "libbeer: Could not download package: " & deployUrl & '-' & package.name
    return false
  except IOError:
    error "libbeer: Encountered IOError whilst saving package."
    return false

  package.verify(dest)

proc fetch*(package: Package, httpClient: HTTPClient, dest, deployUrl: string, numRetry: int = 0): bool =
  var numRetry = deepCopy numRetry
  inc numRetry
  var verified = package.download(httpClient, dest, deployUrl)
  
  if not verified:
    if numRetry > 16:
      error "libbeer: Download seems to be corrupted or maliciously modified during transfer, retrying, attempt #" & $numRetry
      verified = package.fetch(httpClient, dest, deployUrl, numRetry)
    else:
      error "libbeer: Failed to download and verify package successfully in 16 runs."
  
  verified

proc extract*(package: Package, src, dest: string) =
  info "libbeer: Extracting package " & package.name
  let startTime = cpuTime()
  extractAll(src, dest)
  info "libbeer: Extracted package " & package.name & " in " & $((cpuTime() - startTime)*1000) & "s"

proc parsePackages*(manifest: seq[string]): seq[Package] =
  var pkgs: seq[Package] = @[]

  if manifest.len < 5:
    error "libbeer: Invalid manifest, length is lesser than 5"
    return pkgs
  
  if manifest[0] != "v0":
    error "libbeer: Unhandled manifest version!"
    return pkgs
  
  info "libbeer: " & $manifest
  var i: int = 1
  var totalSize: int = 0
  while i < manifest.len - 4:
    let pkg = manifest[i]
    if isPackageExcluded(pkg):
      i += 4
      continue

    let pkgSize = manifest[i + 3].parseInt()
    totalSize += pkgSize
    info "libbeer: Handle package \"" & pkg & "\" (" & $(pkgSize/1024/1024) & " MB)"

    pkgs.add(
      Package(
        name: pkg,
        checksum: manifest[i + 1],
        size: pkgSize
      )
    )

    i += 4
  
  info "libbeer: Downloading packages (" & $(totalSize/1024/1024) & " MB)"
  pkgs
