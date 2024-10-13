when not defined(noConfig):
  import std/[strutils, os]
  import toml_serialization

  let
    CONFIG_DIR = getConfigDir() & "trayfetch"
    CONFIG_FILE = CONFIG_DIR & "/config.toml"

  const
    DEFAULT_CONFIG = """
# Your default trayfetch config.
# If you don't want a stat to show up, simply remove it from this list.
# Happy fetching!
# - tray, xoxo

[config]
enabled    = ["user", "host", "distro", "kernel", "de/wm", "shell", "colors", "uptime", "memory"]
top_bar    = "┌────────────┐"
colors_bar = "├────────────┤"
bottom_bar = "└────────────┘"
"""

  type 
    Config* = object
      enabled*: seq[string]
      topBar*: string
      colorsBar*: string
      bottomBar*: string

  if not dirExists(CONFIG_DIR):
    createDir(CONFIG_DIR)

  var config: Config

  if fileExists(CONFIG_FILE):
    let contents = CONFIG_FILE.readFile()
    config = TOML.decode(contents, Config, "config", TomlCaseNim)
    # colors = TOML.decode(contents, Colors, "colors")
  else:
    config = TOML.decode(DEFAULT_CONFIG, Config, "config", TomlCaseNim)
    # colors = TOML.decode(DEFAULT_CONFIG, Colors, "colors")
    let file = open(CONFIG_FILE, fmWrite)
    defer: file.close()

    file.write(DEFAULT_CONFIG)

  proc `~`*(feature: string): bool {.inline.} =
    # FIXME: This sucks. But it's very convenient too.
    for stat in config.enabled:
      if stat.toLowerAscii() == feature.toLowerAscii():
        return true

    false

  proc getTopBar*: string {.inline.} =
    config.topBar

  proc getColorsBar*: string {.inline.} =
    config.colorsBar

  proc getBottomBar*: string {.inline.} =
    config.bottomBar
else:
  proc `~`*(feature: string): bool {.inline.} =
    true # modern problems require modern solutions

  proc getTopBar*: string {.inline.} =
    "┌────────────┐"
  
  proc getColorsBar*: string {.inline.} =
    "├────────────┤"

  proc getBottomBar*: string {.inline.} =
    "└────────────┘"
