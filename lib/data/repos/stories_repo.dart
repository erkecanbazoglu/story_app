import 'story_repo.dart';
import '../models/story.dart';

///Stories Repo

class StoriesRepo {
  StoriesRepo();

  //Story repo instance is initialized
  final StoryRepo _storyRepo = StoryRepo();

  ///Prepare the final Stories
  Future<Stories> getFinalStories() async {
    ///Getting the final Stories from Story Repo
    List<Story> storiesList = await _storyRepo.getStoryList();

    Stories stories = Stories(
      stories: storiesList,
    );

    return stories;
  }
}
