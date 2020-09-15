import macros
import os, strutils, strformat
import nimterop/[cimport, build, globals]

const
  ProjectCacheDir* = getProjectCacheDir("nimglfw")
  baseDir = ProjectCacheDir
  srcDir = baseDir / "glfw"
  buildDir = srcDir / "buildcache"
  currentPath = getProjectPath().parentDir().sanitizePath
  generatedPath = (currentPath / "generated" / "glfw").replace("\\", "/")
  symbolPluginPath = currentSourcePath.parentDir() / "cleansymbols.nim"

when defined(windows):
  const defs = """
    glfw3SetVer=3.3.2
    glfw3DL
    glfw3Static
  """
else:
  const defs = """
    glfw3SetVer=05dd2fa
    glfw3Git
    glfw3Static
  """

setDefines(defs.splitLines())

when defined(amd64):
  const dlUrl = "https://github.com/glfw/glfw/releases/download/$1/glfw-$1.bin.WIN64.zip"
else:
  const dlUrl = "https://github.com/glfw/glfw/releases/download/$1/glfw-$1.bin.WIN32.zip"

proc glfw3PreBuild(outdir, other: string) =
  rmDir(outdir/"lib-vc2012")
  rmDir(outdir/"lib-vc2013")
  rmDir(outdir/"lib-vc2015")
  rmDir(outdir/"lib-vc2017")
  rmDir(outdir/"lib-vc2019")
  rmFile(outdir/"lib-mingw-w64"/"libglfw3.a")

getHeader(
  "glfw3.h",
  giturl = "https://github.com/glfw/glfw",
  dlUrl = dlUrl,
  outdir = srcDir,
  altNames = "glfw3dll,glfw,glfw3",
)

static:
  discard
  # cSkipSymbol @[]
  # cDebug()
  # cDisableCaching()

# cOverride:
#   discard

const inclDir = srcDir / "include" / "GLFW"

cIncludeDir(inclDir)
cPluginPath(symbolPluginPath)

when defined(macosx):
  {.passL: "-m64 -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo -framework Carbon -framework CoreAudio -lm -pthread".}
else:
  {.passL: "-pthread".}

when isDefined(glfw3Static):
  cImport(inclDir/"glfw3.h", recurse = true, flags = "-f=ast2 -E__,_ -F__,_ -H", nimFile = generatedPath / "glfw.nim")
else:
  cImport(inclDir/"glfw3.h", recurse = true, dynlib = "glfw3LPath", flags = "-f=ast2 -E__,_ -F__,_ -H", nimFile = generatedPath / "glfw.nim")

include extra
