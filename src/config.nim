import std/[strutils, os], 
       toml_serialization

const
  CONFIG_DIR = getConfigDir() & "trayfetch"
  CONFIG_FILE = CONFIG_DIR & "/config.toml"
  DEFAULT_CONFIG = """
# Your default trayfetch config.
# If you don't want a stat to show up, simply remove it from this list.
# Happy fetching!
# - tray, xoxo

[config]
enabled    = ["user", "host", "distro", "kernel", "de/wm", "shell", "colors"]
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

  #[ Colors* = object
    red*: string
    green*: string
    black*: string
    blue*: string
    yellow*: string
    purple*: string
    cyan*: string
    white*: string
    unicode*: string ]#

if not dirExists(CONFIG_DIR):
  createDir(CONFIG_DIR)

var config: Config
# var colors: Colors

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

#[ proc colorOf*(color: string): string {.inline.} =
  result = case color:
  of "red": colors.red
  of "green": colors.green
  of "blue": colors.blue
  of "purple": colors.purple
  of "yellow": colors.yellow
  of "cyan": colors.cyan
  of "white": colors.white
  of "black": colors.black
  of "unicode": colors.unicode
  else:
    raise newException(ValueError, "Unhandled color: " & color)
  
let
  C_RED* = colorOf "red"
  C_GREEN* = colorOf "green"
  C_BLUE* = colorOf "blue"
  C_PURPLE* = colorOf "purple"
  C_YELLOW* = colorOf "yellow"
  C_CYAN* = colorOf "cyan"
  C_WHITE* = colorOf "white"
  C_BLACK* = colorOf "black"
  UNICODE* = colorOf "unicode" ]#
