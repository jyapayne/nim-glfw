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

const
  KEY_LAST* = KEY_MENU
  MOUSE_BUTTON_LAST* = MOUSE_BUTTON_8
  MOUSE_BUTTON_LEFT* = MOUSE_BUTTON_1
  MOUSE_BUTTON_RIGHT* = MOUSE_BUTTON_2
  MOUSE_BUTTON_MIDDLE* = MOUSE_BUTTON_3
  JOYSTICK_LAST* = JOYSTICK_16
  GAMEPAD_BUTTON_LAST* = GAMEPAD_BUTTON_DPAD_LEFT
  GAMEPAD_BUTTON_CROSS* = GAMEPAD_BUTTON_A
  GAMEPAD_BUTTON_CIRCLE* = GAMEPAD_BUTTON_B
  GAMEPAD_BUTTON_SQUARE* = GAMEPAD_BUTTON_X
  GAMEPAD_BUTTON_TRIANGLE* = GAMEPAD_BUTTON_Y
  GAMEPAD_AXIS_LAST* = GAMEPAD_AXIS_RIGHT_TRIGGER
when not defined(windows):
  const
    OPENGL_DEBUG_CONTEXT* = CONTEXT_DEBUG
    HRESIZE_CURSOR* = RESIZE_EW_CURSOR
    VRESIZE_CURSOR* = RESIZE_NS_CURSOR
    HAND_CURSOR* = POINTING_HAND_CURSOR
