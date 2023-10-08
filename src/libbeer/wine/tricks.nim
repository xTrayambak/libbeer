import ../logging, registry, prefix

proc disableCrashDialogs*(prefix: Prefix) =
  info "Disabling crash dialogs!"

  if not registryAdd(
    prefix, 
    "HKEY_CURRENT_USER\\Software\\Wine\\WineDbg", 
    "ShowCrashDialog", REG_DWORD, ""
  ):
    error "disableCrashDialogs(): failed!"
  else:
    info "Disabled crash dialogs successfully!"
