import 'dart:io';
import 'package:http/http.dart' as http;

Future<bool> uploadSourcemap({
  required String appId,
  required String token,
  required String path,
  required String uri,
}) async {
  final file = File(path);
  if (!file.existsSync()) {
    print('$path: file not found!');
    return false;
  }
  print('Uploading: $path');

  // curl -X PUT 'https://api.raygun.com/v3/applications/{your-application-identifier}/source-maps' \
  // -H 'Authorization: Bearer YOUR_PERSONAL_ACCESS_TOKEN' \
  // -H 'Content-Type: multipart/form-data' \
  // -F 'file=@path_to_your_source_map_file.map' \
  // -F 'uri=your_source_map_uri'

  final url = 'https://api.raygun.com/v3/applications/$appId/source-maps';
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
    'uri': uri,
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
