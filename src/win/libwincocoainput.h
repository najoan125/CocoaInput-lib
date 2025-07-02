// #include <GLFW/glfw3.h>
#include <windows.h>
#include <stdio.h>

#include "logger.h"

void initialize(
    long hwnd,
    LogFunction log,
    LogFunction error,
    LogFunction debug
);

void set_focus(int flag);
