import 'dart:convert';
import 'package:http/http.dart' as http;

class Networking {
  Networking({this.url, this.headers});

  final String url;
  final Map<String, String> headers;

  Future getData() async {
    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
