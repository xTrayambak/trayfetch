#[
  Trayfetch -- an alternative to Maxfetch written in Nim

  This code is licensed under the GNU General Public License v2 (not above!)
]#
import std/[strutils, parseopt, times, strformat, os, posix], config, utils

const 
  C_RESET* = "\e[0m"
  C_BLACK* = "\e[0;30m"
  C_RED* = "\e[0;31m"
  C_GREEN* = "\e[0;32m"
  C_YELLOW* = "\e[0;33m"
  C_BLUE* = "\e[0;34m"
  C_PURPLE* = "\e[0;35m"
  C_CYAN* = "\e[0;36m"
  C_WHITE* = "\e[0;37m"
  UNICODE* = "▅▅▅"

proc getDistro: string {.inline.} =
  let file = readFile("/etc/os-release").splitLines()

  for line in file:
    if "PRETTY_NAME" in line:
      result = line.split("PRETTY_NAME=")[1].split('"')[1].split('"')[0]

proc toString(str: array[0..64, char]): string {.inline.}  =
  result = newStringOfCap(len(str))
  for ch in str:
    add(result, ch)

proc genUptime(uSeconds: clong): string {.inline.} =
  $initDuration(seconds = cast[int](uSeconds))
  
proc main {.inline.} =
  var 
    opt = initOptParser(commandLineParams())
    targets: seq[string]
    options: seq[tuple[key, val: string]]
    flags: seq[string]
    info: Sysinfo

  stdout.write getTopBar() & '\n'
  
  when not defined(noConfig):
    if ~"user":
      let
        uid = getuid()
        username = getpwuid(uid).pwName

      stdout.write fmt"│ {C_RED} {C_RESET}user     │ {C_RED}{username} ({uid}){C_RESET}" & '\n'

    if ~"host":
      let hostname = readFile("/etc/hostname").split('\n')[0]
      stdout.write fmt"│ {C_YELLOW} {C_RESET}host     │ {C_YELLOW}{hostname}{C_RESET}" & '\n'

    if ~"distro":
      let distro = getDistro()
      stdout.write fmt"│ {C_GREEN} {C_RESET}distro   │ {C_GREEN}{distro}{C_RESET}" & '\n'

    if ~"kernel":
      var utsName = Utsname()
      discard uname(utsName)
    
      let kernel = toString(utsName.release)
      stdout.write fmt"│ {C_CYAN}漣{C_RESET}kernel   │ {C_CYAN}{kernel}{C_RESET}" & '\n'

    if ~"uptime":
      discard sysinfo(info.addr)

      let uptime = genUptime(info.uptime)

      stdout.write fmt"│ {C_PURPLE}⏲ {C_RESET}uptime   │ {C_PURPLE}{uptime}{C_RESET}" & '\n'

    if ~"de/wm":
      let environment = getEnv("XDG_CURRENT_DESKTOP") & " (" & getEnv("XDG_SESSION_TYPE") & ")"
      stdout.write fmt"│ {C_BLUE} {C_RESET}de/wm    │ {C_BLUE}{environment}{C_RESET}" & '\n'

    if ~"shell":
      let shell = getEnv("SHELL").split('/')
      stdout.write fmt"│ {C_PURPLE} {C_RESET}shell    │ {C_PURPLE}{shell[shell.len-1]}{C_RESET}" & '\n'

    if ~"memory":
      if info.totalram == 0:
        discard sysinfo(info.addr)

      let
        used = info.freeram.float32 / float32(1024 * 1024)
        total = info.totalram.float32 / float32(1024 * 1024)

      stdout.write fmt"│{C_RED}  {C_RESET}memory   │ {C_RED}{used:02g}MB / {total:02g}MB{C_RESET}" & '\n'

    stdout.write getColorsBar() & '\n'

    if ~"colors":
      stdout.write fmt"│ {C_YELLOW} {C_RESET} colors  │ {C_RED}{UNICODE}{C_RESET}{C_YELLOW}{UNICODE}{C_RESET}{C_GREEN}{UNICODE}{C_RESET}{C_CYAN}{UNICODE}{C_RESET}" & '\n'

    stdout.write getBottomBar() & '\n'
  else:
    let
      uid = getuid()
      username = getpwuid(uid).pwName

    stdout.write fmt"│ {C_RED} {C_RESET}user     │ {C_RED}{username} ({uid}){C_RESET}" & '\n'

    let hostname = readFile("/etc/hostname").split('\n')[0]
    stdout.write fmt"│ {C_YELLOW} {C_RESET}host     │ {C_YELLOW}{hostname}{C_RESET}" & '\n'

    let distro = getDistro()
    stdout.write fmt"│ {C_GREEN} {C_RESET}distro   │ {C_GREEN}{distro}{C_RESET}" & '\n'

    var utsName = Utsname()
    discard uname(utsName)
    
    let kernel = toString(utsName.release)
    stdout.write fmt"│ {C_CYAN}漣{C_RESET}kernel   │ {C_CYAN}{kernel}{C_RESET}" & '\n'

    discard sysinfo(info.addr)

    let uptime = genUptime(info.uptime)

    stdout.write fmt"│ {C_PURPLE}⏲ {C_RESET}uptime   │ {C_PURPLE}{uptime}{C_RESET}" & '\n'

    let environment = getEnv("XDG_CURRENT_DESKTOP") & " (" & getEnv("XDG_SESSION_TYPE") & ")"
    stdout.write fmt"│ {C_BLUE} {C_RESET}de/wm    │ {C_BLUE}{environment}{C_RESET}" & '\n'

    let shell = getEnv("SHELL").split('/')
    stdout.write fmt"│ {C_PURPLE} {C_RESET}shell    │ {C_PURPLE}{shell[shell.len-1]}{C_RESET}" & '\n'

    if info.totalram == 0:
      discard sysinfo(info.addr)

    let
      used = info.freeram.float32 / float32(1024 * 1024)
      total = info.totalram.float32 / float32(1024 * 1024)

    stdout.write fmt"│{C_RED}  {C_RESET}memory   │ {C_RED}{used:02g}MB / {total:02g}MB{C_RESET}" & '\n'

    stdout.write getColorsBar() & '\n'

    stdout.write fmt"│ {C_YELLOW} {C_RESET} colors  │ {C_RED}{UNICODE}{C_RESET}{C_YELLOW}{UNICODE}{C_RESET}{C_GREEN}{UNICODE}{C_RESET}{C_CYAN}{UNICODE}{C_RESET}" & '\n'

    stdout.write getBottomBar() & '\n'

when isMainModule:
  main()
