import 'dart:io';

import 'package:args/args.dart';

void sourcemapNode(ArgResults command, bool verbose) {
  final appId = command.option('app-id')!;
  final token = command.option('token')!;
  final baseUri = command.option('base-uri')!;
  final src = command.option('src')!;

  // TODO: search for all map files in source folder and upload them.

  print('Comming soon!');
  exit(1);
}
