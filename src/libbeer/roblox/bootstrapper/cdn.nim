import std/httpclient, ../../logging

const
  CDN_URLS* = [
    "https://setup.rbxcdn.com",
    "https://s3.amazonaws.com/setup.roblox.com",
    "https://setup-ak.rbxcdn.com",
    "https://setup-hw.rbxcdn.com",
    "https://setup-cfly.rbxcdn.com",
    "https://roblox-setup.cachefly.net",
  ]

proc getCdn*: string =
  info "libbeer: Finding an accessible Roblox deployment mirror"
  
  let httpClient = newHTTPClient()

  for cdn in CDN_URLS:
    info "libbeer: Trying \"" & cdn & "\""
    let resp = httpClient.get(cdn & "/version")
    
    if resp.code().int == 200:
      info "libbeer: Found deployment mirror: " & cdn

      result = cdn
      break
    else:
      warn "libbeer: Could not reach \"" & cdn & "\" (" & $resp.code().int & ")"

  if result.len < 1:
    error "libbeer: Could not find an accessible Roblox deployment mirror"
