# Make coffee

## Setup

- `npm install make-coffee`
- Add `include node_modules/make-coffee/Makefile` to your Makefile

Then you can run the following from your project directory:

```
make coffee-clean     # clean the target output folder
make coffee-compile   # build all Coffee into JS
make coffee-watch     # rebuild JS code continuously
```

## Source and output

This `Makefile` expects your source to live in `./src`, and will output all JavaScript to `./target`.
You probably want to make the following changes to your project:

- add `/target` to `.gitignore`
- modify your `package.json` to point to the compiled target

```json
{
  "main": "target/index.js"
  "scripts": {
    "start": "node target/server.js"
  }
}
```

## Which version of coffee-script?

It will automatically pick up the right version of `coffee-script`, as defined in your `package.json`.
It also prints this information before compiling:

```
> make coffee-compile

Compiling coffee using /Users/me/dev/my-project/node_modules/my-module/node_modules/.bin/coffee
CoffeeScript version 1.7.1
```

Depending on your setup, `coffee-script` might be deduped and run from somewhere else, for example

```
> make coffee-compile

Compiling coffee using /Users/me/dev/my-project/node_modules/.bin/coffee
CoffeeScript version 1.7.1
```

This depends on which version you specified, and how specific you are with the dependency (`1.7.1` vs `~1.7.1` vs `>1.7`, etc).

## Public and private packages

- Public packages

To make everything easier for the consumer, it's recommended to only publish JavaScript.
This means:

- 1. add `/src` to `.npmignore`
- 2. make `coffee-script` and `make-coffee` dev-only dependencies
- 3. create a `prepublish` task in `package.json`

```json
{
  "scripts": {
    "prepublish": "make coffee-compile"
  }
}
```

- Private modules

If you point to some modules straight from Github, with `https` + `oauth` for example, there is no publishing step.
The simplest way is to compile these at install time.

1. make `coffee-script` and `make-coffee` actual dependencies
2. create an `install` task in `package.json`

```json
{
  "scripts": {
    "install": "make coffee-compile"
  }
}
```
