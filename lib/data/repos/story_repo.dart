import 'dart:math' as math;

import '../models/story.dart';
import '../models/user.dart';
import 'story_content_repo.dart';
import 'user_repo.dart';

///Story Repo

class StoryRepo {
  StoryRepo();

  //StoryContent repo instance is initialized
  final StoryContentRepo _storyContentRepo = StoryContentRepo();

  //User repo instance is initialized
  final UserRepo _userRepo = UserRepo();

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

      ///Ordering story contents of users according to the timestamp
      userStories.sort((a, b) => a.sentTimestamp.compareTo(b.sentTimestamp));
      userStoryContents.add(userStories);
    }
    return userStoryContents;
  }

  ///Whether Story is seen or not
  bool getStorySeen(List<StoryContent> userStories) {
    bool isStorySeen = true;
    for (int i = 0; i < userStories.length; i++) {
      if (userStories[i].contentSeen == false) {
        isStorySeen = false;
        break;
      }
    }
    return isStorySeen;
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
        storySeen: getStorySeen(userStoryContents[i]),
        storyPlayIndex: 0,
      );
      stories.add(story);
    }

    List<Story> seen = [];
    List<Story> unSeen = [];
    for (int i = 0; i < stories.length; i++) {
      if (stories[i].storySeen) {
        seen.add(stories[i]);
      } else {
        unSeen.add(stories[i]);
      }
    }

    ///Mixing the Story order
    stories.shuffle();

    ///Ordering according to seen / unseen
    stories = List.from(unSeen)..addAll(seen);

    return stories;
  }

  // ///Make all stories unseen (Use only if necessary)
  // void makeStoriesUnseen(userStoryContents) {
  //   for (int i = 0; i < userStoryContents.length; i++) {
  //     SharedPreferencesService.setAllStoryContentUnseen(userStoryContents[i]);
  //   }
  // }

  ///Prepare the Story from Story Contents
  Future<List<Story>> getStoryList() async {
    ///Getting the Story Contents from Story Content Repo
    List<StoryContent> finalStoryContents =
        await _storyContentRepo.getFinalStoryContents();

    ///Getting Users: Default: 10 (max: 10)
    List<User> userList = _userRepo.getUsers(amount: 10);

    ///Distributing Story Contents randomly to Users
    List<dynamic> userStoryContents =
        distributeStoryContents(userList, finalStoryContents);

    ///Making ready the final stories
    List<Story> stories = prepareFinalStories(userStoryContents, userList);
    return stories;
  }
}
