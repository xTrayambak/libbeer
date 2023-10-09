import std/[httpclient, strutils, os], ../version, package, cdn, ../../logging

const MANIFEST_SUFFIX* = "-rbxPkgManifest.txt"

type Manifest* = ref object of RootObj
  version*: Version
  deployUrl*: string
  packages*: seq[Package]

proc fetch*(version: Version, downloadDir: string): Manifest =
  info "libbeer: fetch(): fetching manifest"
  discard existsOrCreateDir(downloadDir)

  let cdn = getCdn()

  if cdn.len < 1:
    error "libbeer: fetch(): failed as a valid CDN could not be contacted."
    return Manifest()
  
  let deployUrl = cdn & getChannelPath(version.channel) & version.guid

  info "libbeer: Fetching latest manifest for" & version.guid & " (" & deployUrl & MANIFEST_SUFFIX & ")"

  let 
    httpClient = newHTTPClient()
    manifest = httpClient.getContent(deployUrl & MANIFEST_SUFFIX)
    pkgs = parsePackages(manifest.split("\r\n"))

  Manifest(
    version: version,
    deployUrl: deployUrl,
    packages: pkgs
  )
