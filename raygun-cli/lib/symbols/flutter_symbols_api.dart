import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<bool> uploadSymbols({
  required String appId,
  required String token,
  required String path,
  required String version,
}) async {
  final file = File(path);
  if (!file.existsSync()) {
    print('$path: file not found!');
    return false;
  }
  print('Uploading: $path');

  final url = 'https://api.raygun.com/v3/applications/$appId/flutter-symbols';
  final request = http.MultipartRequest('PUT', Uri.parse(url));
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'multipart/form-data',
  });
  request.files.add(
    http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: path.split("/").last,
    ),
  );
  request.fields.addAll({
    'version': version,
  });
  final res = await request.send();
  if (res.statusCode == 200) {
    print('File uploaded succesfully!');
    return true;
  } else {
    print('Error uploading file. Response code: ${res.statusCode}');
    return false;
  }
}

Future<bool> listSymbols({
  required String appId,
  required String token,
}) async {
  final url = 'https://api.raygun.com/v3/applications/$appId/flutter-symbols';
  final request = http.MultipartRequest('GET', Uri.parse(url));
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'multipart/form-data',
  });
  final res = await request.send();
  if (res.statusCode == 200) {
    final string = await res.stream.bytesToString();
    final listItems = jsonDecode(string) as List<dynamic>;
    print('');
    print('List of symbols:');
    print('');
    for (final item in listItems) {
      print('Symbols File: ${item['name']}');
      print('Identifier: ${item['identifier']}');
      print('App Version: ${item['version']}');
      print('');
    }
    return true;
  } else {
    print('Error getting list. Response code: ${res.statusCode}');
    return false;
  }
}

Future<bool> deleteSymbols({
  required String appId,
  required String token,
  required String id,
}) async {
  final url =
      'https://api.raygun.com/v3/applications/$appId/flutter-symbols/$id';
  final request = http.MultipartRequest('DELETE', Uri.parse(url));
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'multipart/form-data',
  });
  final res = await request.send();
  if (res.statusCode == 204) {
    print('Deleted: $id');
    return true;
  } else {
    print('Error deleting $id. Response code: ${res.statusCode}');
    return false;
  }
}
