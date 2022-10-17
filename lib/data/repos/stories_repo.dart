import 'package:test_app/data/repos/story_repo.dart';
import '../../logic/bloc/story/story_bloc.dart';
import '../models/story.dart';

class StoriesRepo {
  StoriesRepo();

  //Story repo instance is initialized
  final StoryRepo _storyRepo = StoryRepo();

  ///Prepare the final Stories
  Future<List<Story>> getFinalStories() async {
    ///Getting the final Stories from Story Repo
    List<Story> stories = await _storyRepo.getStoryList();

    return stories;
  }
}
