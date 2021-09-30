import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';

Future upload(String uri, String filename, dynamic file,
    {String? method, Map<String, String>? body, dynamic headers}) async {
  try {
    http.StreamedResponse response;
    List<String?>? contentType;

    if (['POST', 'PATCH', 'PUT'].contains(method) == false) {
      throw Exception("Invalid Http Method");
    }

    // infer content type from the file basename
    var fileType =
        file.toString().replaceAll("'", "").split(".").reversed.first;
    switch (fileType) {
      case 'jpg':
      case 'jpeg':
        contentType = ["image", "jpeg"];
        break;
      case 'png':
        contentType = ["image", "png"];
        break;
      case 'mp3':
        contentType = ["audio", "mp3"];
        break;
      case 'mp4':
        contentType = ["video", "mp4"];
        break;
      default:
    }

    var request = http.MultipartRequest(method!, Uri.parse(baseUrl + uri));
    if (body != null) request.fields.addAll(body);
    request.files.add(await http.MultipartFile.fromPath(filename, file.path,
        contentType: new MediaType(contentType![0]!, contentType[1]!)));
    request.headers.addAll(headers);
    response = await request.send();
    String responseBody = await response.stream.bytesToString();

    if (['POST', 'PATCH', 'PUT'].contains(method)) {
      print("\n\n" + uri + " => " + responseBody + "\n\n");

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        switch (response.statusCode) {
          case 401:
            throw Exception("Session Timed Out");
          case 403:
            throw Exception("Authorization Failed");
          case 500:
            throw Exception("Server Error");
          default:
            throw Exception("Unknown Error");
        }
      }
    }
  } on SocketException catch (e) {
    print(e);
    throw Exception("Network Error");
  } on AuthException catch (e) {
    throw AuthException(e.toString());
  } catch (e) {
    throw Exception(e);
  }
}
