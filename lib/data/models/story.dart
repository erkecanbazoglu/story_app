import 'user.dart';

///Story Model

class Story {
  final int id;
  final User user;
  final List<StoryContent> userStories;
  bool storySeen;

  Story({
    required this.id,
    required this.user,
    required this.userStories,
    required this.storySeen,
  });
}

///Stroy Content Model

enum MediaType {
  image,
  video,
}

class StoryContent {
  final int id;
  final String url;
  final MediaType media;
  final Duration duration;
  final int sentTimestamp;
  bool contentSeen;

  StoryContent({
    required this.id,
    required this.url,
    required this.media,
    required this.duration,
    required this.sentTimestamp,
    required this.contentSeen,
  });
}
