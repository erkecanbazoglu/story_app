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
    ///Number of photo we get from the API
    ///Default: 50 (max: 5000)

    List<dynamic> photoList = await _photosAPI.getPhotos(amount: 50);
    List<StoryContent> photoStoryContent = [];
    for (int i = 0; i < photoList.length; i++) {
      StoryContent content = getStoryContentFromPhoto(photoList[i]);
      photoStoryContent.add(content);
    }
    return photoStoryContent;
  }

  ///Mapping photos to the Story Content
  StoryContent getStoryContentFromPhoto(dynamic photo) {
    StoryContent storyContent;
    storyContent = StoryContent(
      id: photo['id'],
      url: photo['url'],
      media: MediaType.image,
      duration: const Duration(seconds: 5),
    );
    return storyContent;
  }

  final VideosAPI _videosAPI = VideosAPI();

  ///Getting the videos from Pexels API
  Future<List<StoryContent>> getVideos() async {
    ///Number of video we get from the API
    ///Default: 10 (max: 80 - monthly 20.000)

    List<dynamic> videoList = await _videosAPI.getVideos(amount: 3);
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
      url: video['video_files'][0]['link'],
      media: MediaType.video,
      duration: const Duration(seconds: 0),
    );
    return storyContent;
  }

  ///Get users data (amount: 10)
  List<User> getUsers() {
    List<User> users = user_samples.users;
    return users;
  }

  ///Mixing the Story Contents
  List<StoryContent> mixStoryContents(photos, videos) {
    List<StoryContent> mixedStoryContent = List.from(photos)..addAll(videos);
    mixedStoryContent.shuffle();
    return mixedStoryContent;
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
    List<StoryContent> mixedStoryContents =
        mixStoryContents(photoList, videoList);

    ///Distributing Story Contents randomly to Users
    List<User> userList = getUsers();
    List<dynamic> userStoryContents =
        distributeStoryContents(userList, mixedStoryContents);

    ///Making ready the final stories
    List<Story> stories = prepareFinalStories(userStoryContents, userList);
    return stories;
  }
}
