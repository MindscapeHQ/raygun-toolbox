import 'dart:io';

import 'package:args/args.dart';
import 'package:raygun_cli/sourcemap/sourcemap_api.dart';

void sourcemapFlutter(ArgResults command, bool verbose) async {
  final appId = command.option('app-id')!;
  final token = command.option('token')!;
  if (command.option('uri') == null && command.option('base-uri') == null) {
    print('Provide either "uri" or "base-uri"');
    exit(1);
  }
  final uri =
      command.option('uri') ?? '${command.option('base-uri')}main.dart.js';
  final path = command.option('input-map') ?? 'build/web/main.dart.js.map';
  if (verbose) {
    print('app-id: $appId');
    print('token: $token');
    print('input-map: $path');
    print('uri: $uri');
  }
  final out =
      await uploadSourcemap(appId: appId, token: token, path: path, uri: uri);
  if (out) {
    exit(0);
  } else {
    exit(1);
  }
}
