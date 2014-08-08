MAKECOFFEE_ROOT_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
MAKECOFFEE_SRC      = $(shell find src -name '*.coffee' -type f)
MAKECOFFEE_TARGET   = $(MAKECOFFEE_SRC:src/%.coffee=target/%.js)

# JS -> Coffee dependency
target/%.js: src/%.coffee
	@mkdir -p $(@D)
	@./node_modules/.bin/coffee -bcp $< > $@

# Clean all compiled files
coffee-clean:
	@rm -rf target

# Build all JS files
coffee-compile: node_modules $(MAKECOFFEE_TARGET)

# Rebuild JS when Coffee source changes
coffee-watch: $(MAKECOFFEE_ROOT_DIR)/node_modules coffee-compile
	@$(MAKECOFFEE_ROOT_DIR)/node_modules/.bin/nodemon --exec "make coffee-compile" --watch src --ext coffee

.PHONY: coffee-clean coffee-compile coffee-watch
