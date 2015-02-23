# Make coffee

![logo](logo.jpg)

## Setup

- `npm install make-coffee --save-dev`
- Add `include node_modules/make-coffee/Makefile` to your Makefile

Then you can run the following from your project directory:

```
make coffee-clean     # clean the target output folder
make coffee-compile   # build all Coffee into JS
make coffee-watch     # rebuild JS code continuously
make coffee-verify    # verify that the latest JS code was checked-in
```

All these targets depend on your local `node_modules` being available,
so it's a good idea to have the following target:

```Makefile
node_modules: package.json
  @npm install
  touch node_modules
```

## Source and output

This `Makefile` expects your source to live in `./src`, and will output all JavaScript to `./target`. You can override this with the `MAKECOFFEE_SRC` and `MAKECOFFEE_TARGET` variables.

Make sure that your `package.json` to point to the compiled `target` folder in the `main` or `scripts` section.

```json
{
  "main": "target/index.js",
  "scripts": {
    "start": "node target/server.js"
  }
}
```

## Which version of coffee-script?

It will automatically pick up the right version of `coffee-script`, as defined in your package's `devDependencies`. It prints this information before compiling:

```
> make coffee-compile

Compiling coffee using /Users/me/dev/my-project/node_modules/my-module/node_modules/.bin/coffee
CoffeeScript version 1.7.1
```

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

If you point to some modules straight from Github, with `https` + `oauth` for example, there is no publishing step. The simplest & most reliable way is to check-in the compiled `JavaScript` code.

*Note:* it's **not** recommended to run CoffeeScript at runtime for sub-modules, since we lose control over the runtime version. We also avoid compiling as part of the `install` step, since this forces clients to download the `coffee-script` module and `npm dedupe` can cause `PATH` issues.

- 1. make `coffee-script` and `make-coffee` dev-only dependencies
- 2. run `coffee-compile` locally. Ideally this should be a dependency of your tests target
- 3. get your CI server (e.g. [Travis](https://travis-ci.org)) to run `make coffee-verify` to ensure the latest `JS` was checked-in
