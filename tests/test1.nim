import unittest

import libbeer/wine/prefix
test "exec":
  let prefix = newPrefix()
  echo prefix.wine(@["core"])
