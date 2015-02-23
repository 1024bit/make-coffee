MAKECOFFEE_SRC      = $(shell find src -name '*.coffee' -type f)
MAKECOFFEE_TARGET   = $(MAKECOFFEE_SRC:src/%.coffee=target/%.js)
COFFEE_BIN          = node_modules/.bin/coffee

target: $(MAKECOFFEE_TARGET)

# JS -> Coffee
$(MAKECOFFEE_TARGET): $(MAKECOFFEE_SRC)
	@mkdir -p $(@D)
	@$(COFFEE_BIN) -bcp $< > $@

# Clean all compiled files
coffee-clean: node_modules
	@echo Cleaning compiled coffee code
	@rm -rf target

# Build all JS files
coffee-compile: node_modules $(MAKECOFFEE_TARGET)
	@echo Compiling coffee using $(COFFEE_BIN)
	@$(COFFEE_BIN) -v

# Rebuild JS when Coffee source changes
coffee-watch: coffee-compile
	@echo Watching for coffee source changes
	@$(COFFEE_BIN) --output target --watch --compile src

# verify that the checked-in JS matches the latest Coffee code
coffee-verify: node_modules
	@$(COFFEE_BIN) --output target-latest --compile src
	@diff target target-latest

.PHONY: coffee-clean coffee-compile coffee-watch coffee-verify
