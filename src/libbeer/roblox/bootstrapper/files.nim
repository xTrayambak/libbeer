import std/os, ../../logging

proc writeAppSettings*(dir: string) =
  info "Writing AppSettings: " & dir

  let file = open(dir / "AppSettings.xml", fmWrite)
  defer: file.close()

  let appSettings = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n" &
                "<Settings>\r\n" &
                "        <ContentFolder>content</ContentFolder>\r\n" &
                "        <BaseUrl>http://www.roblox.com</BaseUrl>\r\n" &
                "</Settings>\r\n"


  file.write(appSettings)
