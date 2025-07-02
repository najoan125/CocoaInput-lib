CC = cl.exe
CFLAGS = /D_USRDLL /D_WINDLL /LD
FFLAGS = 
OBJS = libwincocoainput.obj logger.obj
LIBS = imm32.lib user32.lib
TARGET = libwincocoainput.dll
DISTDIR = ..\..\build\

all: $(TARGET)

install: $(TARGET)
    copy $(TARGET) $(DISTDIR)

$(TARGET): $(OBJS)
    $(CC) $(CFLAGS) $(FFLAGS) /Fe$(TARGET) $(OBJS) /link $(LIBS)

.c.obj:
    $(CC) $(CFLAGS) /c $<

clean:
    del $(TARGET) $(OBJS)
