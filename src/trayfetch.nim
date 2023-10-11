#[
  Trayfetch -- an alternative to Maxfetch written in Nim

  This code is licensed under the GNU General Public License v2 (not above!)
]#
import std/[strutils, times, strformat, os, posix], config

type Sysinfo* {.importc: "struct sysinfo", header: "<sys/sysinfo.h>", final, pure.} = object
  uptime*: clong
  loads*: array[0..3, culong]
  totalram*: culong
  freeram*: culong
  sharedram*: culong
  bufferram*: culong
  totalswap*: culong
  freeswap*: culong
  procs*: cushort
  totalhigh*: culong
  freehigh*: culong
  mem_unit*: cuint

proc sysinfo*(info: ptr Sysinfo): cint {.importc, header: "<sys/sysinfo.h>".}

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
  echo getTopBar()
  
  if ~"user":
    let
      uid = getuid()
      username = getpwuid(uid).pwName

    echo fmt"│ {C_RED} {C_RESET}user     │ {C_RED}{username} ({uid}){C_RESET}"

    discard uid
    discard username

  if ~"host":
    let hostname = readFile("/etc/hostname").split('\n')[0]
    echo fmt"│ {C_YELLOW} {C_RESET}host     │ {C_YELLOW}{hostname}{C_RESET}"

    discard hostname

  if ~"distro":
    let distro = getDistro()
    echo fmt"│ {C_GREEN} {C_RESET}distro   │ {C_GREEN}{distro}{C_RESET}"

    discard distro

  if ~"kernel":
    var utsName = Utsname()
    discard uname(utsName)
    
    let kernel = toString(utsName.release)
    echo fmt"│ {C_CYAN}漣{C_RESET}kernel   │ {C_CYAN}{kernel}{C_RESET}"

    discard utsName
    discard kernel

  if ~"uptime":
    var info = Sysinfo()
    discard sysinfo(info.addr)

    let uptime = genUptime(info.uptime)

    echo fmt"│ {C_PURPLE}⏲ {C_RESET}uptime   │ {C_PURPLE}{uptime}{C_RESET}" 

  if ~"de/wm":
    let environment = getEnv("XDG_CURRENT_DESKTOP") & " (" & getEnv("XDG_SESSION_TYPE") & ")"
    echo fmt"│ {C_BLUE} {C_RESET}de/wm    │ {C_BLUE}{environment}{C_RESET}"

    discard environment

  if ~"shell":
    let shell = getEnv("SHELL").split('/')
    echo fmt"│ {C_PURPLE} {C_RESET}shell    │ {C_PURPLE}{shell[shell.len-1]}{C_RESET}"

    discard shell

  echo getColorsBar()

  if ~"colors":
    echo fmt"│ {C_YELLOW} {C_RESET} colors  │ {C_RED}{UNICODE}{C_RESET}{C_YELLOW}{UNICODE}{C_RESET}{C_GREEN}{UNICODE}{C_RESET}{C_CYAN}{UNICODE}{C_RESET}"

  echo getBottomBar()


when isMainModule:
  main()
