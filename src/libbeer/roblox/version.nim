import std/[json, tables, options, strutils, strformat, httpclient], 
       jsony, ../logging, binarykind

const
  DEFAULT_CHANNEL = "live"
  VERSION_CHECK_URL = "https://clientsettingscdn.roblox.com/v2/client-version"

type 
  ClientVersion* = ref object of RootObj
    version*: string
    clientVersionUpload*: string
    bootstrapperVersion*: string
    nextClientVersionUpload*: string
    nextClientVersion*: string

  Version* = ref object of RootObj
    kind*: BinaryKind
    channel*: string
    guid*: string

proc `$`*(version: Version): string =
  "Kind: " & $version.kind &
  "Channel: " & version.channel &
  "GUID: " & version.guid

proc `$`*(cv: ClientVersion): string =
  "Version: " & cv.version &
  "\nClient Version Upload: " & cv.clientVersionUpload &
  "\nBootstrapper Version: " & cv.bootstrapperVersion &
  "\nNext Client Version Upload: " & cv.nextClientVersionUpload &
  "\nNext Client Version: " & cv.nextClientVersion

proc getChannelPath*(channel: string): string =
  let channel = channel.toLowerAscii()

  assert channel.len > 0

  if channel == DEFAULT_CHANNEL:
    return "/"

  "/channel/" & channel & "/"

proc getNewVersion*(bt: BinaryKind, channel, guid: string): Version =
  var channel: string = deepCopy channel
  if channel.len < 1:
    channel = DEFAULT_CHANNEL

  if guid.len < 1:
    error "libbeer: invalid GUID: \"" & guid & "\""
    quit 1

  info "Found " & $bt & " version " & guid
  
  Version(
    kind: bt,
    channel: channel,
    guid: guid
  )

proc getLatestVersion*(bt: BinaryKind, channel: string): Version =
  var 
    channel: string = deepCopy channel

  if channel.len < 1:
    channel = DEFAULT_CHANNEL

  let urlStr = VERSION_CHECK_URL & "/" & binaryName(bt) & getChannelPath(channel)
  
  info "libbeer: Fetching latest version of " & $bt & " for channel " & channel
  info "libbeer: " & urlStr

  let http = newHTTPClient(userAgent="Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0")
  
  let resp = http.getContent(urlStr).fromJson()
  info "libbeer: onReqGet(): completed request!"
  info "libbeer: " & $resp

  Version(
    kind: bt,
    channel: channel,
    guid: resp["clientVersionUpload"].getStr()
  )
