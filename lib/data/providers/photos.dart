import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PhotosAPI {
  Future<List<dynamic>> getPhotos({int? amount = 50}) async {
    // Request to website below:
    // "https://jsonplaceholder.typicode.com/photos/"

    var url = Uri.https('jsonplaceholder.typicode.com', 'photos');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    List<dynamic> _photosList = convert.jsonDecode(response.body);
    return _photosList.sublist(0, amount);
  }
}
