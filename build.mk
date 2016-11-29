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

# create lst list from objects
SOURCES_LST=$(OBJ:.o=.lst)

all: $(PROJECT_ELF) $(PROJECT_HEX) $(PROJECT_LST) $(SOURCES_LST)

$(PROJECT_ELF): $(OBJ)
	@$(LD) $(LDFLAGS) -o $@ $^
	@echo "SIZE\t"$@
	@$(SIZE) $@
	@echo "LD\t"$$(sha1sum $@)

%.o: %.c
	@$(CC) $(INCLUDE) $(CFLAGS) -c -o $@ $<
	@echo "CC\t"$$(sha1sum $@)

%.o: %.S
	@$(AS) $(ASFLAGS) -c -o $@ $<
	@echo "AS\t"$$(sha1sum $@)

%.o: %.asm
	@$(AS) $(ASFLAGS) -c -o $@ $<
	@echo "AS\t"$$(sha1sum $@)

%.lst: %.elf
	@$(OBJDUMP) -DS $^ > $@
	@echo "OBJDUMP\t"$$(sha1sum $@)

%.lst: %.o
	@$(OBJDUMP) -DS $^ > $@
	@echo "OBJDUMP\t"$$(sha1sum $@)

%.hex: %.elf
	@$(OBJCOPY) -Oihex $^ $@
	@echo "OBJCOPY\t"$$(sha1sum $@)

.PHONY: clean show_flags show_source show_all

# remove all the files created
clean:
	@rm -f $(OBJ) $(DEP) $(PROJECT_ELF) $(PROJECT_MAP) $(PROJECT_LST) $(PROJECT_HEX) $(SOURCES_LST)

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

