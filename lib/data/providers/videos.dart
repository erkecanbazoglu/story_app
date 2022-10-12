import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class VideosAPI {
  Future<List<dynamic>> getVideos({int amount = 10}) async {
    // Request to website below:
    // "https://www.pexels.com/videos/search/"

    const String API_KEY =
        '563492ad6f91700001000001f6d98ef7e7fd4a2db20b78c06e74ac7d';
    final String videoAmount = amount.toString();
    const String endpointUrl = 'https://api.pexels.com/videos/search';
    final String params =
        'query=nature&orientation=portrait&per_page=' + videoAmount;
    final String url = endpointUrl + '?' + params;

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': API_KEY,
    });

    print('Response status: ${response.statusCode}');
    final res = convert.jsonDecode(response.body);
    return res["videos"];
  }
}
