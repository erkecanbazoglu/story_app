import 'user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

///STORIES MODEL

///Set "explicitToJson: true" for nested objects

@JsonSerializable(explicitToJson: true)
class Stories {
  final List<Story> stories;

  Stories({
    required this.stories,
  });

  /// Connect the generated [_$StoriesFromJson] function to the `fromJson`
  /// factory.
  factory Stories.fromJson(Map<String, dynamic> json) =>
      _$StoriesFromJson(json);

  /// Connect the generated [_$StoriesToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StoriesToJson(this);

  // @override
  // String toString() => 'Stories: {stories: $stories}';
}

///STORY MODEL

@JsonSerializable(explicitToJson: true)
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

  /// Connect the generated [_$StoryFromJson] function to the `fromJson`
  /// factory.
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  /// Connect the generated [_$StoryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  // @override
  // String toString() =>
  //     'Story: {id: $id, storySeen: $storySeen, user: $user, userStories: $userStories}';
}

///STORY CONTENT MODEL

enum MediaType {
  image,
  video,
}

@JsonSerializable()
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

  /// Connect the generated [_$StoryContentFromJson] function to the `fromJson`
  /// factory.
  factory StoryContent.fromJson(Map<String, dynamic> json) =>
      _$StoryContentFromJson(json);

  /// Connect the generated [_$StoryContentToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StoryContentToJson(this);

  // @override
  // String toString() =>
  //     'StoryContent: {id: $id, media: $media, duration: $duration, sentTimestamp: $sentTimestamp, contentSeen: $contentSeen, url: $url}';
}
