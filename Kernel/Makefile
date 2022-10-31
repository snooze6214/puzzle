# Parts of this file is coppied from limine-barebones/kernel/GNUMakefile
# https://github.com/limine-bootloader/

OUT := Kernel.elf
CC := clang
LD := ld.lld

# User controllable CFLAGS.
CFLAGS ?= -g -O2 -pipe -Wall -Wextra

# User controllable nasm flags.
NASMFLAGS ?= -F dwarf -g

# User controllable linker flags. We set none by default.
LDFLAGS ?=

# Internal C flags that should not be changed by the user.
override CFLAGS +=       \
    -std=c11             \
    -ffreestanding       \
    -fno-stack-protector \
    -fno-stack-check     \
    -fno-lto             \
    -fno-pie             \
    -fno-pic             \
    -m64                 \
    -march=x86-64        \
    -mabi=sysv           \
    -mno-80387           \
    -mno-mmx             \
    -mno-sse             \
    -mno-sse2            \
    -mno-red-zone        \
    -mcmodel=kernel      \
    -MMD                 \
    -I.

# Internal linker flags that should not be changed by the user.
override LDFLAGS +=         \
    -nostdlib               \
    -static                 \
    -m elf_x86_64           \
    -z max-page-size=0x1000 \
    -T linker.ld

# Check if the linker supports -no-pie and enable it if it does
ifeq ($(shell $(LD) --help 2>&1 | grep 'no-pie' >/dev/null 2>&1; echo $$?),0)
    override LDFLAGS += -no-pie
endif

# Internal nasm flags that should not be changed by the user.
override NASMFLAGS += \
    -f elf64

# Use find to glob all *.c, *.S, and *.asm files in the directory and extract the object names.
override CFILES := $(shell find . -type f -name '*.c')
override ASFILES := $(shell find . -type f -name '*.S')
override NASMFILES := $(shell find . -type f -name '*.asm')
override OBJ := $(CFILES:.c=.o) $(ASFILES:.S=.o) $(NASMFILES:.asm=.o)
override HEADER_DEPS := $(CFILES:.c=.d) $(ASFILES:.S=.d)

.PHONY: all
all: $(OUT)

ultra_protocol.h:
	wget https://raw.githubusercontent.com/UltraOS/UltraProtocol/master/ultra_protocol.h

# Link rules for the final kernel executable.
$(OUT): $(OBJ)
	$(LD) $(OBJ) $(LDFLAGS) -o ../Meta/iso_root/$@

# Include header dependencies.
-include $(HEADER_DEPS)

# Compilation rules for *.c files.
%.o: %.c ultra_protocol.h
	$(CC) $(CFLAGS) -c $< -o $@

# Compilation rules for *.S files.
%.o: %.S ultra_protocol.h
	$(CC) $(CFLAGS) -c $< -o $@

# Compilation rules for *.asm (nasm) files.
%.o: %.asm
	nasm $(NASMFLAGS) $< -o $@

# Remove object files and the final executable.
.PHONY: clean
clean:
	rm -rf $(KERNEL) $(OBJ) $(HEADER_DEPS)

.PHONY: distclean
distclean: clean
	rm -f ultra_protocol.h
