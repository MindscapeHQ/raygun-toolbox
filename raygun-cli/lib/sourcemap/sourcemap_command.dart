import 'dart:io';

import 'package:args/args.dart';
import 'package:raygun_cli/sourcemap/flutter/sourcemap_flutter.dart';
import 'package:raygun_cli/sourcemap/node/sourcemap_node.dart';
import 'package:raygun_cli/sourcemap/sourcemap_single_file.dart';

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
    print('Usage: raygun-cli sourcemap <arguments>');
    print(buildParserSourcemap().usage);
    exit(0);
  }
  if (!command.wasParsed('app-id') || !command.wasParsed('token')) {
    print('Missing mandatory arguments');
    print(buildParserSourcemap().usage);
    exit(2);
  }
  switch (command.option('platform')) {
    case null:
      SourcemapSingleFile(command: command, verbose: verbose).upload();
    case 'flutter':
      SourcemapFlutter(command: command, verbose: verbose).upload();
    case 'node':
      SourcemapNode(command: command, verbose: verbose).upload();
    default:
      print('Unsupported platform');
      exit(1);
  }
}
