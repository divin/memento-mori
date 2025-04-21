# Playdate development Makefile

# Define paths based on environment variables
SOURCE_DIR=$(ZED_WORKTREE_ROOT)/source
BUILD_DIR=$(ZED_WORKTREE_ROOT)/publish/build.pdx
CONFIG_FILE=~/.Playdate/config

# Default target
.PHONY: all
all: check build run

# Check SDK configuration
.PHONY: check
check:
	@if [ -z "$(PLAYDATE_SDK)" ]; then \
		echo "Error: PLAYDATE_SDK environment variable is not set"; \
		exit 1; \
	fi
	@if [ ! -f "$(PLAYDATE_SDK)/bin/pdc" ]; then \
		echo "Error: pdc tool not found at $(PLAYDATE_SDK)/bin/pdc"; \
		echo "Please check your Playdate SDK installation path"; \
		exit 1; \
	fi
	@echo SDKRoot $(PLAYDATE_SDK) > $(CONFIG_FILE)

# Build the project
.PHONY: build
build: check
	$(PLAYDATE_SDK)/bin/pdc -v -sdkpath $(PLAYDATE_SDK) $(SOURCE_DIR) $(BUILD_DIR)

# Run the simulator
.PHONY: run
run: build
	@SIMULATOR_PATH="$(PLAYDATE_SDK)/bin/Playdate Simulator.app"; \
	if [ -d "$$SIMULATOR_PATH" ]; then \
		open -a "$$SIMULATOR_PATH" "$(BUILD_DIR)"; \
	else \
		echo "Error: Playdate Simulator not found at $$SIMULATOR_PATH"; \
		echo "Please check your Playdate SDK installation"; \
		exit 1; \
	fi
