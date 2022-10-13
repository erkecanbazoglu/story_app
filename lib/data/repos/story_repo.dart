import '../models/story.dart';
import '../../constants/sample_users.dart' as user_samples;
import '../models/user.dart';
import '../providers/photos.dart';
import '../providers/videos.dart';
import 'dart:math' as math;

class StoryRepo {
  final PhotosAPI _photosAPI = PhotosAPI();

  ///Getting the photos from JSON Placeholder
  Future<List<StoryContent>> getPhotos() async {
    ///Number of photo we get from the API: Default: 50 (max: 5000)
    // List<dynamic> photoList = await _photosAPI.getPhotosFromJsonPlaceholder(amount: 50);

    ///Number of photo we get from the API: Default: 10 (max: 80)
    List<dynamic> photoList = await _photosAPI.getVideosFromPexels(amount: 5);

    List<StoryContent> photoStoryContent = [];
    for (int i = 0; i < photoList.length; i++) {
      StoryContent content = getStoryContentFromPhoto(photoList[i]);
      photoStoryContent.add(content);
    }

    ///Also  some images from static links, not to push API limits:) Default: 15 (max: 30)
    List<dynamic> staticPhotoList =
        _photosAPI.getPhotosFromPexelsStatic(amount: 15);

    for (int i = 0; i < staticPhotoList.length; i++) {
      StoryContent content =
          getStoryContentFromStaticUrl(staticPhotoList[i], MediaType.image);
      photoStoryContent.add(content);
    }
    photoStoryContent.shuffle();

    return photoStoryContent;
  }

  ///Mapping photos to the Story Content
  StoryContent getStoryContentFromPhoto(dynamic photo) {
    StoryContent storyContent;
    storyContent = StoryContent(
      id: photo['id'],
      url: photo['src']['large'] ?? photo['src']['original'],
      media: MediaType.image,
      duration: const Duration(seconds: 5),
    );
    return storyContent;
  }

  ///Mapping static urls to the Story Content
  StoryContent getStoryContentFromStaticUrl(String url, MediaType mediaType) {
    StoryContent storyContent;
    int id = math.Random().nextInt(1000000);
    storyContent = StoryContent(
      id: id,
      url: url,
      media: mediaType,
      duration: const Duration(seconds: 5),
    );
    return storyContent;
  }

  final VideosAPI _videosAPI = VideosAPI();

  ///Getting the videos from Pexels API
  Future<List<StoryContent>> getVideos() async {
    ///Number of video we get from the API: Default: 10 (max: 80)
    List<dynamic> videoList = await _videosAPI.getVideosFromPexels(amount: 3);

    List<StoryContent> videoStoryContent = [];
    for (int i = 0; i < videoList.length; i++) {
      StoryContent content = getStoryContentFromVideo(videoList[i]);
      videoStoryContent.add(content);
    }
    return videoStoryContent;
  }

  ///Mapping videos to the Story Content
  StoryContent getStoryContentFromVideo(dynamic video) {
    StoryContent storyContent;
    storyContent = StoryContent(
      id: video['id'],
      url: video['video_files'][4]['link'] ?? video['video_files'][0]['link'],
      media: MediaType.video,
      duration: const Duration(seconds: 0),
    );
    return storyContent;
  }

  ///Get users data: Default: 10 (max: 10)
  List<User> getUsers({int amount = 10}) {
    List<User> users = user_samples.users;
    return users.sublist(0, amount);
  }

  ///Mixing two lists into one
  List<StoryContent> mixTwoLists(list1, list2) {
    List<StoryContent> mixedList = List.from(list1)..addAll(list2);
    mixedList.shuffle();
    return mixedList;
  }

  ///Distributing the Story Contents to Users
  List<dynamic> distributeStoryContents(users, storyContents) {
    ///Final - User Story Contents
    List userStoryContents = [];

    ///Temp - users of story contents
    List storyContentsUsers = [];

    for (int i = 0; i < storyContents.length; i++) {
      ///Generates random number between 0-9
      int numberOfUser = users.length;
      int randomUser = math.Random().nextInt(numberOfUser);
      storyContentsUsers.add(randomUser);
    }

    ///For every user check the matching story contents
    for (int i = 0; i < users.length; i++) {
      List<StoryContent> userStories = [];
      for (int k = 0; k < storyContentsUsers.length; k++) {
        ///If user and story contents matching add
        if (i == storyContentsUsers[k]) {
          userStories.add(storyContents[k]);
        }
      }
      userStoryContents.add(userStories);
    }
    return userStoryContents;
  }

  ///Prepare the final stories
  List<Story> prepareFinalStories(userStoryContents, usersList) {
    List<Story> stories = [];

    for (int i = 0; i < userStoryContents.length; i++) {
      ///No Story for the specified user
      if (userStoryContents[i].isEmpty) {
        continue;
      }

      ///Random story id between 0-999.999
      int id = math.Random().nextInt(1000000);
      Story story = Story(
        id: id,
        user: usersList[i],
        userStories: userStoryContents[i],
      );
      stories.add(story);
    }

    ///Mixing the Story order
    stories.shuffle();
    return stories;
  }

  ///Prepare the Story Contents from photos and videos
  Future<List<Story>> prepareStoryContents() async {
    ///Getting photos and videos in Story Content format
    List<StoryContent> photoList = await getPhotos();
    List<StoryContent> videoList = await getVideos();

    ///Mixing the photos and videos lists
    List<StoryContent> mixedStoryContents = mixTwoLists(photoList, videoList);

    ///Getting Users: Default: 10 (max: 10)
    List<User> userList = getUsers(amount: 10);

    ///Distributing Story Contents randomly to Users
    List<dynamic> userStoryContents =
        distributeStoryContents(userList, mixedStoryContents);

    ///Making ready the final stories
    List<Story> stories = prepareFinalStories(userStoryContents, userList);
    return stories;
  }
}
