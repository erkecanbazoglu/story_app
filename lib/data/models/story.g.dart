// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
      stories: (json['stories'] as List<dynamic>)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
      'stories': instance.stories.map((e) => e.toJson()).toList(),
    };

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      userStories: (json['userStories'] as List<dynamic>)
          .map((e) => StoryContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      storySeen: json['storySeen'] as bool,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'userStories': instance.userStories.map((e) => e.toJson()).toList(),
      'storySeen': instance.storySeen,
    };

StoryContent _$StoryContentFromJson(Map<String, dynamic> json) => StoryContent(
      id: json['id'] as int,
      url: json['url'] as String,
      media: $enumDecode(_$MediaTypeEnumMap, json['media']),
      duration: Duration(microseconds: json['duration'] as int),
      sentTimestamp: json['sentTimestamp'] as int,
      contentSeen: json['contentSeen'] as bool,
    );

Map<String, dynamic> _$StoryContentToJson(StoryContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'media': _$MediaTypeEnumMap[instance.media]!,
      'duration': instance.duration.inMicroseconds,
      'sentTimestamp': instance.sentTimestamp,
      'contentSeen': instance.contentSeen,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
};
