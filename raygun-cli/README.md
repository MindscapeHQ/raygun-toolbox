## Raygun CLI

Command-line tool for [raygun.com](https://raygun.com).

### Install

You can install this tool in different ways.

At the moment, a Dart SDK setup is necessary.
You can get the Dart SDK here: https://dart.dev/get-dart or as part of your Flutter SDK installation.

Note: `$HOME/.pub-cache/bin` must be in your path.

In the future, this tool will also be available as standalone binary file in other distribution channels.

**Install binary**

_Not available yet!_

**Install from pub.dev**

```
dart pub global activate raygun_cli 
```

**Install from sources**

```
dart pub global activate -s path .
```

### Usage

Call to `raygun-cli` with a command and arguments.

```
raygun-cli <command> <arguments>
```

Or use directly from sources:

```
dart bin/raygun_cli.dart <command> <arguments>
```

**Common mandatory arguments**

- `app-id` the Application ID in Raygun.com.
- `token` is an access token from https://app.raygun.com/user/tokens.

#### Sourcemap Uploader

Upload sourcemaps to [raygun.com](https://raygun.com).

```
raygun-cli sourcemap <arguments>
```

Where the arguments are:

- `uri` is the full URI where your project will be installed to.
- `input-map` is the map file to upload.

```
raygun-cli sourcemap --input-map=path/to/map/index.js.map --uri=https://example.com/index.js --app-id=APP_ID --token=TOKEN
```

The command can be used to upload any single sourcemap.

##### Flutter Sourcemaps

To upload Flutter web sourcemaps to [raygun.com](https://raygun.com), navigate to your project root and run the `sourcemap` command and set the `platform` argument (or `-p`) to `flutter`.

The `input-map` argument is optional for Flutter web projects. 
`raygun-cli` will try to find the `main.dart.js.map` file in `build/web/main.dart.js.map` automatically.

```
raygun-cli sourcemap -p flutter --uri=https://example.com/main.dart.js --app-id=APP_ID --token=TOKEN
```

##### NodeJS Sourcemaps

_Not available yet!_

#### Flutter obfuscation symbols

Manages obfuscation symbols to [raygun.com](https://raygun.com).

```
raygun-cli symbols <subcommand> <arguments>
```

**Subcommands**

- `upload`: Upload a symbols file.
- `list`: List uploaded symbols files.
- `delete`: Delete an uploaded symbols file.

**Upload subcommand**

Upload a symbols file.

Provide the path to the symbols file (e.g. `app.android-arm64.symbols`), as well as the application version (e.g. `1.0.0`).

```
raygun-cli symbols upload --path=<path to symbols file> --version=<app version> --app-id=APP_ID --token=TOKEN
```

**List subcommand**

List the uploaded symbols file.

```
raygun-cli symbols list --app-id=APP_ID --token=TOKEN
```

Example output:

```
List of symbols:

Symbols File: app.android-arm64.symbols
Identifier: 2c7a3u3
App Version: 0.0.1

Symbols File: app.android-x64.symbols
Identifier: 2c7a3u4
App Version: 0.0.1

Symbols File: app.android-arm.symbols
Identifier: 2c7a7k6
App Version: 0.0.1
```

**Delete subcommand**

Delete an uploaded symbols file.

Provide the identifier (`id`) of the symbols file (e.g. `--id=2c7a3u3`). You can obtain the identifier with the `list` subcommand.

```
raygun-cli symbols delete --id=<id> --app-id=APP_ID --token=TOKEN
```

## Development

### Compiling a binary

Compile a self-contained exec:

```
dart compile exe bin/raygun_cli.dart -o raygun-cli
```

Note: The binary is compiled for the architecture and host system. To compile for macOS and Windows we must setup CI VMs. See: https://dart.dev/tools/dart-compile#known-limitations

