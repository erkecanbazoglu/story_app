import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../constants/constants.dart';

class VideosAPI {
  ///Pexels Video API
  Future<List<dynamic>> getVideosFromPexels({required int amount}) async {
    // Request to website below:
    // "https://www.pexels.com/videos/search/"

    const String apiKey = API_KEY;
    final String videoAmount = amount.toString();
    const String endpointUrl = 'https://api.pexels.com/videos/search';
    final String params =
        'query=all&orientation=portrait&size=small&per_page=' + videoAmount;
    final String url = endpointUrl + '?' + params;

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': apiKey,
    });

    print('Response status: ${response.statusCode}');
    final res = convert.jsonDecode(response.body);
    return res["videos"];
  }
}
