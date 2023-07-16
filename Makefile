CC := gcc 
CFLAGS := -Wall -Wextra -g3 -Wno-unused-variable -Wno-unused-function -fsanitize=undefined

BUILD_DIR := build

SOURCES := $(wildcard src/*.c)
OBJECTS := $(addprefix $(BUILD_DIR)/, $(notdir SOURCES:.c=.o))

PROGS := argmax dot matmul runner
EXECUTABLES := $(addprefix $(BUILD_DIR)/, $(PROGS))
NOMAIN := read_matrix.o relu.o
PATRIALS := $(addprefix $(BUILD_DIR)/, $(NOMAIN))

.PHONY: default clean 

all: $(EXECUTABLES) $(PATRIALS)

$(BUILD_DIR)/runner: src/runner.c 
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/argmax: $(BUILD_DIR)/argmax.o
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/dot: $(BUILD_DIR)/dot.o 
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/matmul: $(BUILD_DIR)/matmul.o 
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: src/%.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) 
