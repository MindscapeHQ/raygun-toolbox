import 'dart:io';

import 'package:args/args.dart';
import 'package:raygun_cli/sourcemap/flutter/sourcemap_flutter.dart';
import 'package:raygun_cli/sourcemap/node/sourcemap_node.dart';

const kSourcemapCommand = 'sourcemap';

ArgParser buildParserSourcemap() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print sourcemap usage information.',
    )
    ..addOption(
      'app-id',
      help: 'Raygun\'s application ID',
      mandatory: true,
    )
    ..addOption(
      'token',
      help: 'Raygun\'s access token',
      mandatory: true,
    )
    ..addOption(
      'platform',
      abbr: 'p',
      help: 'Specify project platform. Supported: [flutter, node]',
      defaultsTo: 'flutter',
    )
    ..addOption(
      'uri',
      help: 'Application URI (e.g. https://localhost:3000/main.dart.js)',
    )
    ..addOption(
      'base-uri',
      help: 'Base application URI (e.g. https://localhost:3000/)',
    )
    ..addOption(
      'input-map',
      abbr: 'i',
      help: 'Single sourcemap file',
    )
    ..addOption(
      'src',
      abbr: 's',
      help: 'Source files',
    );
}

void parseSourcemapCommand(ArgResults command, bool verbose) {
  if (command.wasParsed('help')) {
    print(
        'Usage: raygun-cli sourcemap --uri=<uri> --app-id=<app-id> --token=<token>');
    print(buildParserSourcemap().usage);
    exit(0);
  }
  if (command.option('platform') == 'flutter') {
    sourcemapFlutter(command, verbose);
  } else if (command.option('platform') == 'node') {
    sourcemapNode(command, verbose);
  } else {
    print('Unsupported platform.');
    exit(1);
  }
}
