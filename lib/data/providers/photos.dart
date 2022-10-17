import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../constants/sample_images.dart';

///Photo Provider

class PhotosAPI {
  ///Later not used due to image quality
  Future<List<dynamic>> getPhotosFromJsonPlaceholder(
      {required int amount}) async {
    // Request to website below:
    // "https://jsonplaceholder.typicode.com/photos/"

    var url = Uri.https('jsonplaceholder.typicode.com', 'photos');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    List<dynamic> _photosList = convert.jsonDecode(response.body);
    return _photosList.sublist(0, amount);
  }

  ///Pexels Image API
  Future<List<dynamic>> getVideosFromPexels({required int amount}) async {
    // Request to website below:
    // "https://www.pexels.com/v1/search/"

    const String apiKey = API_KEY;
    final String photoAmount = amount.toString();
    const String endpointUrl = 'https://api.pexels.com/v1/search';
    final String params =
        'query=all&orientation=portrait&size=small&per_page=' + photoAmount;
    final String url = endpointUrl + '?' + params;

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': apiKey,
    });

    print('Response status: ${response.statusCode}');
    final res = convert.jsonDecode(response.body);
    return res["photos"];
  }

  ///Pexels images from static urls
  List<dynamic> getPhotosFromPexelsStatic({required int amount}) {
    List<String> pexelImages = photoList;
    return pexelImages.sublist(0, amount);
  }
}
