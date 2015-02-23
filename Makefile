MAKECOFFEE_SRC      = src
MAKECOFFEE_SRC_LIST = $(shell find $(MAKECOFFEE_SRC) -name "*.coffee")
MAKECOFFEE_TARGET   = target
COFFEE_BIN          = node_modules/.bin/coffee

# JS -> Coffee
$(MAKECOFFEE_TARGET): $(MAKECOFFEE_SRC_LIST) node_modules
	@echo Using `$(COFFEE_BIN) -v`
	@mkdir -p $(MAKECOFFEE_TARGET)
	@$(COFFEE_BIN) --output $(MAKECOFFEE_TARGET) --compile $(MAKECOFFEE_SRC)
	@touch $(MAKECOFFEE_TARGET)
	@echo Done!

# Clean all compiled files
coffee-clean: node_modules
	@echo Cleaning compiled coffee code
	@rm -rf $(MAKECOFFEE_TARGET)

# Build all JS files
coffee-compile: $(MAKECOFFEE_TARGET)

# Rebuild JS when Coffee source changes
coffee-watch: coffee-compile
	@echo Watching for coffee source changes
	@$(COFFEE_BIN) --output $(MAKECOFFEE_TARGET) --compile $(MAKECOFFEE_SRC) --watch

# verify that the checked-in JS matches the latest Coffee code
coffee-verify: node_modules
	@$(COFFEE_BIN) --output $(MAKECOFFEE_TARGET)-latest --compile $(MAKECOFFEE_SRC)
	@diff $(MAKECOFFEE_TARGET) $(MAKECOFFEE_TARGET)-latest

.PHONY: coffee-clean coffee-compile coffee-watch coffee-verify
