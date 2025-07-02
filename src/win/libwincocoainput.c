#include "libwincocoainput.h"
#include <imm.h>

HWND hwnd;
HIMC himc;

void initialize(
    long hwndp,
    LogFunction log,
    LogFunction error,
    LogFunction debug
) {
    initLogPointer(log, error, debug);
    CILog("CocoaInput Windows Clang Initializer start. library compiled at  %s %s", __DATE__, __TIME__);

    hwnd = (HWND)hwndp;

    himc = ImmGetContext(hwnd);
    if (!himc) {
        himc = ImmCreateContext();
    }

    ImmReleaseContext(hwnd, himc);
    ImmAssociateContext(hwnd, 0);
    CIDebug("CocoaInput Windows initializer done!");
}

void set_focus(int flag) {
    CIDebug("setFocused:%d", flag);
    if (flag) {
        ImmAssociateContext(hwnd, himc);
    } else {
        himc = ImmAssociateContext(hwnd, 0);
    }
}