import 'package:test_app/data/models/story.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final int id;
  final String url;
  final MediaType media;
  final Duration duration;
  final User user;

  const Story({
    required this.id,
    required this.url,
    required this.media,
    required this.duration,
    required this.user,
  });
}
