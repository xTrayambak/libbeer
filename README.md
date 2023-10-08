# libbeer - the ultra-minimalist Roblox-on-Linux wrapper library
Libbeer is a library meant to handle and manage Roblox on Linux using WINE. It's mostly a rewrite of the [Vinegar](https://github.com/vinegarhq/vinegar) project's `roblox/` and `wine/` libraries in Nim.

It has a complete bootstrapper, fflags manager, WINE wrapper and basically almost everything Vinegar has, so it does most of the heavy-lifting for you if you want to write a Roblox launcher.

Keep in mind that libbeer is still a work-in-progress library. Report bugs, it'd be appreciated!

# How do I use it?
Libbeer is not a standalone program, it's a library. You have to build your own CLI or GUI tools on top of it, allowing for a greater amount of flexibility.

# Incomplete features
- DXVK
