MAKECOFFEE_ROOT_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
MAKECOFFEE_SRC      = $(shell find src -name '*.coffee' -type f)
MAKECOFFEE_TARGET   = $(MAKECOFFEE_SRC:src/%.coffee=target/%.js)

# Our own dependencies
$(MAKECOFFEE_ROOT_DIR)/node_modules: $(MAKECOFFEE_ROOT_DIR)/package.json
	cd $(MAKECOFFEE_ROOT_DIR) && npm install

# JS -> Coffee dependency
target/%.js: src/%.coffee
	@mkdir -p $(@D)
	@coffee -bcp $< > $@

# Clean all compiled files
coffee-clean:
	@echo Cleaning compiled coffee code
	@rm -rf target

# Build all JS files
coffee-compile: node_modules $(MAKECOFFEE_TARGET)
	@echo Compiling coffee using `which coffee`
	@coffee -v

# Rebuild JS when Coffee source changes
coffee-watch: $(MAKECOFFEE_ROOT_DIR)/node_modules coffee-compile
	@echo Watching for coffee source changes
	@$(MAKECOFFEE_ROOT_DIR)/node_modules/.bin/nodemon --exec "make coffee-compile" --watch src --ext coffee

.PHONY: coffee-clean coffee-compile coffee-watch
