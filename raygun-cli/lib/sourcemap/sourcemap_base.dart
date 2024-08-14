import 'package:args/args.dart';

abstract class SourcemapBase {
  SourcemapBase({
    required this.command,
    required this.verbose,
  }) {
    appId = command.option('app-id')!;
    token = command.option('token')!;
  }

  final ArgResults command;
  final bool verbose;
  late final String appId;
  late final String token;

  Future<void> upload();
}
