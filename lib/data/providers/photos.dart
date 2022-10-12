import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PhotosAPI {
  Future<void> getPhotos() async {
    // Request to website below:
    // "https://jsonplaceholder.typicode.com/photos/"

    var url = Uri.https('jsonplaceholder.typicode.com', 'photos');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    List<dynamic> _photosList = convert.jsonDecode(response.body);
    print(_photosList.length);
  }
}
