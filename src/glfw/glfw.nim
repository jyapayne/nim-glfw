import os, strutils, strformat
import nimterop/[cimport, build, globals]

const
  ProjectCacheDir* = getProjectCacheDir("nimglfw")
  baseDir = ProjectCacheDir
  srcDir = baseDir / "glfw"
  buildDir = srcDir / "buildcache"
  symbolPluginPath = currentSourcePath.parentDir() / "cleansymbols.nim"
  defs = """
    glfw3SetVer=05dd2fa
    glfw3Git
    glfw3Static
  """

setDefines(defs.splitLines())

getHeader(
  "glfw3.h",
  giturl = "https://github.com/glfw/glfw",
  outdir = srcDir,
  altNames = "glfw,glfw3",
)

static:
  discard
  # cSkipSymbol @[]
  # cDebug()
  # cDisableCaching()

# cOverride:
#   discard

cIncludeDir(srcDir/"include"/"GLFW")
cPluginPath(symbolPluginPath)
{.passL: "-pthread".}

when isDefined(glfw3Static):
  cImport(srcDir/"include"/"GLFW"/"glfw3.h", recurse = true, flags = "-f=ast2 -E__,_ -F__,_ -H")
else:
  cImport(srcDir/"include"/"GLFW"/"glfw3.h", recurse = true, dynlib = "glfw3LPath", flags = "-f=ast2 -E__,_ -F__,_ -H")

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
  OPENGL_DEBUG_CONTEXT* = CONTEXT_DEBUG
  HRESIZE_CURSOR* = RESIZE_EW_CURSOR
  VRESIZE_CURSOR* = RESIZE_NS_CURSOR
  HAND_CURSOR* = POINTING_HAND_CURSOR
