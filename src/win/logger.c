#if !defined(_MSC_VER)
#define _GNU_SOURCE
#endif

#include "logger.h"
#include <stdio.h>
#include <stdlib.h>

// For MSVC, we need to include this for _vscprintf and vsprintf_s
#if defined(_MSC_VER)
#include <stdarg.h>
#endif

struct {
    LogFunction log;
    LogFunction error;
    LogFunction debug;
} LogPointer;

void CILog(const char *format, ...) {
    char *msg;
    va_list args;
    va_start(args, format);

#if defined(_MSC_VER)
    int len = _vscprintf(format, args);
    if (len < 0) {
        va_end(args);
        return;
    }
    size_t size = (size_t)len + 1;
    msg = malloc(size);
    if (!msg) {
        va_end(args);
        return;
    }
    vsprintf_s(msg, size, format, args);
#else
    if (vasprintf(&msg, format, args) == -1) {
        msg = NULL; // Ensure msg is NULL on failure
    }
#endif
    va_end(args);

    if (msg) {
        LogPointer.log(msg);
        free(msg);
    }
}

void CIError(const char *format, ...) {
    char *msg;
    va_list args;
    va_start(args, format);

#if defined(_MSC_VER)
    int len = _vscprintf(format, args);
    if (len < 0) {
        va_end(args);
        return;
    }
    size_t size = (size_t)len + 1;
    msg = malloc(size);
    if (!msg) {
        va_end(args);
        return;
    }
    vsprintf_s(msg, size, format, args);
#else
    if (vasprintf(&msg, format, args) == -1) {
        msg = NULL;
    }
#endif
    va_end(args);

    if (msg) {
        LogPointer.error(msg);
        free(msg);
    }
}

void CIDebug(const char *format, ...) {
    char *msg;
    va_list args;
    va_start(args, format);

#if defined(_MSC_VER)
    int len = _vscprintf(format, args);
    if (len < 0) {
        va_end(args);
        return;
    }
    size_t size = (size_t)len + 1;
    msg = malloc(size);
    if (!msg) {
        va_end(args);
        return;
    }
    vsprintf_s(msg, size, format, args);
#else
    if (vasprintf(&msg, format, args) == -1) {
        msg = NULL;
    }
#endif
    va_end(args);

    if (msg) {
        LogPointer.debug(msg);
        free(msg);
    }
}

void initLogPointer(LogFunction log, LogFunction error, LogFunction debug) {
    LogPointer.log = log;
    LogPointer.error = error;
    LogPointer.debug = debug;
}