# PROJECT_NAME must be define externally
PROJECT_ELF=$(PROJECT_NAME).elf
PROJECT_MAP=$(PROJECT_NAME).map
PROJECT_LST=$(PROJECT_NAME).lst
PROJECT_HEX=$(PROJECT_NAME).hex

# Define all the GNU Renesas RX programs being used
CC=rx-elf-gcc
AS=rx-elf-gcc
LD=rx-elf-gcc
SIZE=rx-elf-size
OBJDUMP=rx-elf-objdump
OBJCOPY=rx-elf-objcopy

# create obj list from sources
OBJ=$(SOURCE_C:.c=.o) $(SOURCE_ASM:.asm=.o) $(SOURCE_S:.S=.o)

# create dependency list from objects
DEP=$(OBJ:.o=.d)

all: $(PROJECT_ELF) $(PROJECT_HEX) $(PROJECT_LST)

$(PROJECT_ELF): $(OBJ)
	@echo "LD\t"$@
	@$(LD) $(LDFLAGS) -o $@ $^
	@echo "SIZE\t"$@
	@$(SIZE) $@

%.o: %.c
	@echo "CC\t"$@ $^
	@$(CC) $(INCLUDE) $(CFLAGS) -c -o $@ $<

%.o: %.S
	@echo "AS\t"$@ $^
	@$(AS) $(ASFLAGS) -c -o $@ $<

%.o: %.asm
	@echo "AS\t"$@ $^
	@$(AS) $(ASFLAGS) -c -o $@ $<

%.lst: %.elf
	@echo "OBJDUMP\t"$@
	@$(OBJDUMP) -DS $^ > $@

%.lst: %.o
	@echo "OBJDUMP\t"$@
	@$(OBJDUMP) -DS $^ > $@

%.hex: %.elf
	@echo "OBJCOPY\t"$@
	@$(OBJCOPY) -Oihex $^ $@

.PHONY: clean show_flags show_source show_all

# remove all the files created
clean:
	@rm -f $(OBJ) $(DEP) $(PROJECT_ELF) $(PROJECT_MAP) $(PROJECT_LST) $(PROJECT_HEX)

show_flags:
	@echo "=================" $@ "================="
	@echo "CFLAGS\t" $(CFLAGS)
	@echo "ASFLAGS\t" $(ASFLAGS)
	@echo "LDFLAGS\t" $(LDFLAGS)
	@echo

show_source:
	@echo "=================" $@ "================="
	@echo "SOURCE_C\t" $(SOURCE_C)
	@echo "SOURCE_ASM\t" $(SOURCE_ASM)
	@echo "SOURCE_S\t" $(SOURCE_S)
	@echo

show_all: show_flags show_source
	@echo "PROJECT_NAME\t" $(PROJECT_NAME)
	@echo

