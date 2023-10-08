import std/tables, ../binarykind

const
  # github.com/vinegarhq/vinegar/blob/master/roblox/bootstrapper/binarydirs.go
  PLAYER_DIRECTORIES* = {
    "RobloxApp.zip":                 "",
    "shaders.zip":                   "shaders/",
    "ssl.zip":                       "ssl/",
    "WebView2.zip":                  "",
    "WebView2RuntimeInstaller.zip":  "WebView2RuntimeInstaller",
    "content-avatar.zip":            "content/avatar",
    "content-configs.zip":           "content/configs",
    "content-fonts.zip":             "content/fonts",
    "content-sky.zip":               "content/sky",
    "content-sounds.zip":            "content/sounds",
    "content-textures2.zip":         "content/textures",
    "content-models.zip":            "content/models",
    "content-textures3.zip":         "PlatformContent/pc/textures",
    "content-terrain.zip":           "PlatformContent/pc/terrain",
    "content-platform-fonts.zip":    "PlatformContent/pc/fonts",
    "extracontent-luapackages.zip":  "ExtraContent/LuaPackages",
    "extracontent-translations.zip": "ExtraContent/translations",
    "extracontent-models.zip":       "ExtraContent/models",
    "extracontent-textures.zip":     "ExtraContent/textures",
    "extracontent-places.zip":       "ExtraContent/places",
  }.toTable

  STUDIO_DIRECTORIES* = {
    "BuiltInPlugins.zip":              "BuiltInPlugins",
    "ApplicationConfig.zip":           "ApplicationConfig",
    "BuiltInStandalonePlugins.zip":    "BuiltInStandalonePlugins",
    "content-qt_translations.zip":     "content/qt_translations",
    "content-platform-fonts.zip":      "PlatformContent/pc/fonts",
    "content-terrain.zip":             "PlatformContent/pc/terrain",
    "content-textures3.zip":           "PlatformContent/pc/textures",
    "extracontent-translations.zip":   "ExtraContent/translations",
    "extracontent-luapackages.zip":    "ExtraContent/LuaPackages",
    "extracontent-textures.zip":       "ExtraContent/textures",
    "extracontent-scripts.zip":        "ExtraContent/scripts",
    "extracontent-models.zip":         "ExtraContent/models",
    "content-sky.zip":                 "content/sky",
    "content-fonts.zip":               "content/fonts",
    "content-avatar.zip":              "content/avatar",
    "content-models.zip":              "content/models",
    "content-sounds.zip":              "content/sounds",
    "content-configs.zip":             "content/configs",
    "content-api-docs.zip":            "content/api_docs",
    "content-textures2.zip":           "content/textures",
    "content-studio_svg_textures.zip": "content/studio_svg_textures",
    "Qml.zip":                         "Qml",
    "ssl.zip":                         "ssl",
    "Plugins.zip":                     "Plugins",
    "shaders.zip":                     "shaders",
    "StudioFonts.zip":                 "StudioFonts",
    "redist.zip":                      "",
    "WebView2.zip":                    "",
    "Libraries.zip":                   "",
    "LibrariesQt5.zip":                "",
    "RobloxStudio.zip":                "",
    "WebView2RuntimeInstaller.zip":    ""
  }.toTable

proc getDirectories*(bt: BinaryKind): TableRef[string, string] =
  if bt == bkPlayer:
    return PLAYER_DIRECTORIES
  
  return STUDIO_DIRECTORIES
