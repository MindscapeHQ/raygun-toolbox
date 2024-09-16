import 'dart:io';

import 'package:args/args.dart';
import 'package:raygun_cli/symbols/flutter_symbols_api.dart';

const kSymbolsCommand = 'symbols';

void parseSymbolsCommand(ArgResults command, bool verbose) {
  if (command.wasParsed('help')) {
    print(
        'Usage: raygun-cli $kSymbolsCommand (upload|list|delete) <arguments>');
    print(buildParserSymbols().usage);
    exit(0);
  }
  if (!command.wasParsed('app-id') || !command.wasParsed('token')) {
    print('Missing mandatory arguments');
    print(buildParserSymbols().usage);
    exit(2);
  }
  _run(
    command: command,
    appId: command['app-id'],
    token: command['token'],
  ).then((result) {
    if (result) {
      exit(0);
    } else {
      exit(2);
    }
  }).catchError((e) {
    print('Error: $e');
    exit(2);
  });
}

Future<bool> _run({
  required ArgResults command,
  required appId,
  required token,
}) async {
  if (command.command?.name == 'upload') {
    if (!command.wasParsed('path') || !command.wasParsed('version')) {
      print('Missing mandatory arguments');
      print(buildParserSymbols().usage);
      return false;
    }
    final path = command['path'];
    final version = command['version'];
    return uploadSymbols(
      appId: appId,
      token: token,
      path: path,
      version: version,
    );
  }

  if (command.command?.name == 'list') {
    return listSymbols(
      appId: appId,
      token: token,
    );
  }

  if (command.command?.name == 'delete') {
    if(!command.wasParsed('id')) {
      print('Missing mandatory arguments');
      print(buildParserSymbols().usage);
      return false;
    }
    return deleteSymbols(
      appId: appId,
      token: token,
      id: command['id'],
    );
  }

  return false;
}

ArgParser buildParserSymbols() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print $kSymbolsCommand usage information.',
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
      'path',
      help: 'Path to symbols file, used in upload',
    )
    ..addOption(
      'version',
      help: 'App version, used in upload',
    )
    ..addOption(
      'id',
      help: 'Symbol ID, used in delete',
    )
    ..addCommand(
      'upload',
    )
    ..addCommand(
      'list',
    )
    ..addCommand(
      'delete',
    );
}
