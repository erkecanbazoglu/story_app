import 'user.dart';

class Story {
  final int id;
  final User user;
  final List<StoryContent> userStories;

  const Story({
    required this.id,
    required this.user,
    required this.userStories,
  });
}

enum MediaType {
  image,
  video,
}

class StoryContent {
  final int id;
  final String url;
  final MediaType media;
  final Duration duration;

  const StoryContent({
    required this.id,
    required this.url,
    required this.media,
    required this.duration,
  });
}
