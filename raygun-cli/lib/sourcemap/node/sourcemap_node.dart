import 'dart:io';

import 'package:raygun_cli/sourcemap/sourcemap_base.dart';

class SourcemapNode extends SourcemapBase {
  SourcemapNode({
    required super.command,
    required super.verbose,
  });

  @override
  Future<void> upload() {
    // final baseUri = command.option('base-uri')!;
    // final src = command.option('src')!;

    // TODO: search for all map files in source folder and upload them.

    print('Comming soon!');
    exit(2);
  }
}
