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
