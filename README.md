# Make coffee

Setup

- `npm install make-coffee`
- Add `include node_modules/make-coffee/Makefile` to your Makefile

Then you can run the following from your project directory:

```
make coffee-clean     # clean the target output folder
make coffee-compile   # build all Coffee into JS
make coffee-watch     # rebuild JS code continuously
```

You probably want to make the following changes to your project:

- add `/target` to `.gitignore`
- add `/src` to `.npmignore`
- add the following to `package.json`

```json
{
  "scripts": {
    "prepublish": "make coffee-compile"
  }
}
```
