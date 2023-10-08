const
  RED* = "\e[0;31m"
  BLUE* = "\e[0;34m"
  GREEN* = "\e[0;32m"
  RESET* = "\e[0m"

proc info*(msg: string) =
  echo ":: " & GREEN & msg & RESET

proc display*(msg: string) =
  echo "=> " & GREEN & msg & RESET

proc error*(msg: string) =
  echo "=> " & RED & msg & RESET

proc warn*(msg: string) =
  echo ">> " & BLUE & msg & RESET
