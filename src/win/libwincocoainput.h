#include <windows.h>
#include <stdio.h>
#include "logger.h"

#ifdef _WIN32
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

DLL_EXPORT void initialize(
    long hwnd,
    LogFunction log,
    LogFunction error,
    LogFunction debug
);

DLL_EXPORT void set_focus(int flag);

#ifdef __cplusplus
}
#endif