## Raygun CLI

Command-line tool for Raygun.com.

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

#### Sourcemap Uploader

Upload sourcemaps to Raygun.

```
raygun-cli sourcemap <arguments>
```

##### Flutter Sourcemaps

To upload Flutter web sourcemaps to Raygun.com, navigate to your project root and run the following command:

```
raygun-cli sourcemap --uri=https://example.com/main.dart.js --app-id=APP_ID --token=TOKEN
```

- `uri` is the full URI where your project will be installed to.
- `app-id` the Application ID in Raygun.com.
- `token` is an access token from https://app.raygun.com/user/tokens.

`raygun-cli` will try to find the `main.dart.js.map` file in `build/web/main.dart.js.map`.
You can also specify a different path with the `input-map` argument.

##### NodeJS Sourcemaps

_Not available yet!_

## Development

### Compiling a binary

Compile a self-contained exec:

```
dart compile exe bin/raygun_cli.dart -o raygun-cli
```

Note: The binary is compiled for the architecture and host system. To compile for macOS and Windows we must setup CI VMs. See: https://dart.dev/tools/dart-compile#known-limitations

