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
