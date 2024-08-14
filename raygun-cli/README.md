## Raygun CLI

Command-line tool for Raygun.com.

### Usage

Install in your system:

```
dart pub global activate -s path .
```

Then use:

```
raygun-cli <command> <arguments>
```

Note: `$HOME/.pub-cache/bin` must be in your path.

Or use directly from sources:

```
dart bin/raygun_cli.dart <command> <arguments>
```

#### Sourcemap Uploader

Upload sourcemaps to Raygun

```
Usage: raygun-cli sourcemap --uri=<uri> --app-id=<app-id> --token=<token>

-h, --help                  Print sourcemap usage information.
    --app-id (mandatory)    Raygun's application ID
    --token (mandatory)     Raygun's access token
-p, --platform              Specify project platform. Supported: [flutter, node]
                            (defaults to "flutter")
-m, --input-map             Input sourcemap file
    --uri                   Application URI (e.g. https://localhost:3000/main.dart.js)
    --base-uri              Base application URI (e.g. https://localhost:3000/)
```

For example, from your Flutter project folder:

```
raygun-cli sourcemap --uri=https://example.com/main.dart.js --app-id=APP_ID --token=TOKEN
```

## TODO

- [ ] Generate and distribute binaries
- [ ] Upload to pub.dev
- [ ] Support more platforms (node and other JS projects)
- [ ] Add more useful commands
- [ ] Support config files (e.g. `.raygun.conf` to read values like `uri` and `app-id`)
- [ ] Tests

## Development

### Compiling a binary

Compile a self-contained exec:

```
dart compile exe bin/raygun_cli.dart -o raygun-cli
```

Note: The binary is compiled for the architecture and host system. To compile for macOS and Windows we must setup CI VMs. See: https://dart.dev/tools/dart-compile#known-limitations

