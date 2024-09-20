import 'package:args/args.dart';
import 'package:raygun_cli/sourcemap/sourcemap_command.dart';
import 'package:raygun_cli/symbols/flutter_symbols.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addCommand(
      kSourcemapCommand,
      buildParserSourcemap(),
    )
    ..addCommand(
      kSymbolsCommand,
      buildParserSymbols(),
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: raygun-cli <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    if (results.wasParsed('help') || arguments.isEmpty) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('raygun-cli version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    if (results.command?.name == kSourcemapCommand) {
      parseSourcemapCommand(results.command!, verbose);
      return;
    }

    if (results.command?.name == kSymbolsCommand) {
      parseSymbolsCommand(results.command!, verbose);
      return;
    }

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
