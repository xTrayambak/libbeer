import prefix, ../logging

const
  REG_SZ* = "REG_SZ"
  REG_MULTI_SZ* = "REG_MULTI_SZ"
  REG_EXPAND_SZ* = "REG_EXPAND_SZ"
  REG_DWORD* = "REG_DWORD"
  REG_QWORD* = "REG_QWORD"
  REG_BINARY* = "REG_BINARY"
  REG_NONE* = "REG_NONE"

proc registryAdd*(prefix: Prefix, key, value, regType, data: string): bool =
  if key.len < 1:
    error "registryAdd(): failed, key.len < 1"
    return

  prefix.wine(
    @[
      "reg", "add",
      key, "/v", value,
      "/t", regType, "/d", data, "/f"
    ]
  ).exitCode == 0
