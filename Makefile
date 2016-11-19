# project name
PROJECT_NAME=Renesas-RX-FreeRTOS

#include path for the *.h files
INCLUDE=\
	-I. \
	-ISource/include \
	-ISource/portable/GCC/RX600 \
	-Itest/board/header \
	$(END)

# source code: asm files
SOURCE_ASM=\
	test/board/code/reset_program.asm \
	$(END)

# source code: S files
SOURCE_S=\
	$(END)

# source code: c files
SOURCE_C=\
	Source/portable/GCC/RX600/port.c \
	Source/portable/GCC/MemMang/heap_4.c \
	Source/croutine.c \
	Source/event_groups.c \
	Source/list.c \
	Source/queue.c \
	Source/tasks.c \
	Source/timers.c \
	test/board/code/sbrk.c \
	test/board/code/hardware_setup.c \
	test/board/code/interrupt_handlers.c \
	test/board/code/reset_program.c \
	test/board/code/vector_table.c \
	test/FreeRTOS.c \
	$(END)

#compiler flag
CFLAGS=\
	-x c \
	-D__RX_LITTLE_ENDIAN__=1 \
	-mlittle-endian-data \
	-mcpu=rx600 \
	-Wall \
	-Werror \
	$(END)

# assembler flags with gcc
ASFLAGS=\
	-x assembler-with-cpp \
	$(END)

# linker flags
LDFLAGS=\
	-nostartfiles \
	-Wl,--gc-sections \
	-Wl,-Map=$(PROJECT_MAP) \
	-T linker.ld \
	-e_PowerON_Reset \
	$(END)


#process all the variable define above in the build.mk file
-include build.mk
