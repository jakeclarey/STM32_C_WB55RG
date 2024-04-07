##########################################################################################################################
# Makefile template rev 1.1 [12-14-23]
##########################################################################################################################

# Project folder name holder
PROJECT_NAME = 

# make target should be named "main"
TARGET = main

DEBUG = 1
OPT = -O0 # preferred optimization for edit->compile->debug

# Build path
BUILD_DIR = $(PROJECT_NAME)/build

###########################################################
# List all files (.c) here placed in Core/Src/... folder
# List all assembly (.s) files placed in project folder
###########################################################
# C sources
C_SOURCES = $(patsubst %.c,%.o,$(wildcard $(PROJECT_NAME)/Core/Src/*.c))

# C++ sources
CPP_SOURCES = $(patsubst %.cpp,%.o,$(wildcard $(PROJECT_NAME)/Core/Src/*.cpp))

# ASM sources
ASM_SOURCES = $(patsubst %.s,%.o,$(wildcard $(PROJECT_NAME)/*.s))

#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
CPP = $(GCC_PATH)/$(PREFIX)g++
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
CPP = $(PREFIX)g++
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DSTM32WB55xx

# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-I$(PROJECT_NAME)/Core/Inc \
-I$(PROJECT_NAME)/Drivers/CMSIS/Device/ST/STM32WBxx/Include \
-I$(PROJECT_NAME)/Drivers/CMSIS/Include

CPP_INCLUDES = \
-I$(PROJECT_NAME)/Core/Inc \

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CPPFLAGS = $(CPP_INCLUDES) -std=c++17 -Wno-register

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = $(PROJECT_NAME)/stm32wb55xx_flash_cm4.ld

# libraries
LIBS = -lc -lm -lnosys
LIBDIR = 
LDFLAGS = $(MCU) --specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

.PHONY: clean

#######################################
# build the application
#######################################
# list of C objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))
# list of C++ objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(CPP_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CPP_SOURCES)))

$(BUILD_DIR)/%.o: %.cpp Makefile | $(BUILD_DIR)
	$(CPP) -c $(CFLAGS) $(CPPFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.cpp=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean
#######################################
clean:
	rm -f $(BUILD_DIR)/*
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# EOF #
