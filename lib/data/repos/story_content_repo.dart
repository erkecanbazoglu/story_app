import 'dart:math' as math;

import '../../services/shared_preferences.dart';
import '../models/story.dart';
import '../providers/photos.dart';
import '../providers/videos.dart';

///Story Content Repo

class StoryContentRepo {
  StoryContentRepo();

  final PhotosAPI _photosAPI = PhotosAPI();

  ///Number of photo we get from the API: Default: 50 (max: 5000)
  static const jsonPlaceholderPhotoNumber = 50;

  ///Number of photo we get from the API: Default: 5 (max: 80)
  static const pexelApiPhotoNumber = 5;

  ///Also  some images from static links, not to push API limits:) Default: 15 (max: 30)
  static const pexelStaticUrlPhotoNumber = 15;

  ///Number of video we get from the API: Default: 3 (max: 80)
  static const pexelApiVideoNumber = 3;

  ///Getting the photos from JSON Placeholder
  Future<List<StoryContent>> getPhotos() async {
    // List<dynamic> photoList = await _photosAPI.getPhotosFromJsonPlaceholder(amount: jsonPlaceholderPhotoNumber);

    List<dynamic> photoList =
        await _photosAPI.getVideosFromPexels(amount: pexelApiPhotoNumber);

    List<StoryContent> photoStoryContent = [];
    for (int i = 0; i < photoList.length; i++) {
      StoryContent content = getStoryContentFromPhoto(photoList[i], i);
      photoStoryContent.add(content);
    }

    List<dynamic> staticPhotoList =
        _photosAPI.getPhotosFromPexelsStatic(amount: pexelStaticUrlPhotoNumber);

    for (int i = 0; i < staticPhotoList.length; i++) {
      StoryContent content =
          getStoryContentFromStaticUrl(staticPhotoList[i], MediaType.image, i);
      photoStoryContent.add(content);
    }
    photoStoryContent.shuffle();

    return photoStoryContent;
  }

  ///Mapping photos to the Story Content
  StoryContent getStoryContentFromPhoto(dynamic photo, int index) {
    StoryContent storyContent;
    storyContent = StoryContent(
      id: index,
      url: photo['src']['large'] ?? photo['src']['original'],
      media: MediaType.image,
      duration: const Duration(seconds: 5),
      sentTimestamp: SharedPreferencesService.getStoryContentTimestamp(index),
      contentSeen: SharedPreferencesService.getStoryContentSeen(index),
    );
    return storyContent;
  }

  ///Mapping static urls to the Story Content
  StoryContent getStoryContentFromStaticUrl(
      String url, MediaType mediaType, int index) {
    StoryContent storyContent;
    int id = math.Random().nextInt(1000000);
    storyContent = StoryContent(
      id: pexelApiPhotoNumber + index,
      url: url,
      media: mediaType,
      duration: const Duration(seconds: 5),
      sentTimestamp: SharedPreferencesService.getStoryContentTimestamp(index),
      contentSeen: SharedPreferencesService.getStoryContentSeen(index),
    );
    return storyContent;
  }

  final VideosAPI _videosAPI = VideosAPI();

  ///Getting the videos from Pexels API
  Future<List<StoryContent>> getVideos() async {
    List<dynamic> videoList =
        await _videosAPI.getVideosFromPexels(amount: pexelApiVideoNumber);

    List<StoryContent> videoStoryContent = [];
    for (int i = 0; i < videoList.length; i++) {
      StoryContent content = getStoryContentFromVideo(videoList[i], i);
      videoStoryContent.add(content);
    }
    return videoStoryContent;
  }

  ///Mapping videos to the Story Content
  StoryContent getStoryContentFromVideo(dynamic video, int index) {
    StoryContent storyContent;
    storyContent = StoryContent(
      id: pexelApiPhotoNumber + pexelStaticUrlPhotoNumber + index,
      url: video['video_files'][4]['link'] ?? video['video_files'][0]['link'],
      media: MediaType.video,
      duration: const Duration(seconds: 0),
      sentTimestamp: SharedPreferencesService.getStoryContentTimestamp(index),
      contentSeen: SharedPreferencesService.getStoryContentSeen(index),
    );
    return storyContent;
  }

  ///Mixing two lists into one
  List<StoryContent> mixTwoLists(list1, list2) {
    List<StoryContent> mixedList = List.from(list1)..addAll(list2);
    mixedList.shuffle();
    return mixedList;
  }

  ///Prepare the Story Contents from photos and videos
  Future<List<StoryContent>> getFinalStoryContents() async {
    ///Getting photos and videos in Story Content format
    List<StoryContent> photoList = await getPhotos();
    List<StoryContent> videoList = await getVideos();

    ///Mixing the photos and videos lists
    List<StoryContent> mixedStoryContents = mixTwoLists(photoList, videoList);

    return mixedStoryContents;
  }
}
