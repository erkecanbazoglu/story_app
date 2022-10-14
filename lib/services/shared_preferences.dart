import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class SharedPreferencesService {
  static late SharedPreferences _preferences;

  //Init SharedPreferences
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Story Content Seen Preferences
  static Future setStoryContentSeen(int storyContentId) async {
    String storyContent = storyContentId.toString();
    await _preferences.setBool(storyContent, true);
  }

  static bool getStoryContentSeen(int storyContentId) {
    String storyContent = storyContentId.toString();
    final bool? isStoryContentSeen = _preferences.getBool(storyContent);
    return isStoryContentSeen ?? false;
  }

  // static Future setAllStoryContentUnseen(List<int> storyContentIds) async {
  //   for (int i = 0; i < storyContentIds.length; i++) {
  //     String storyContent = storyContentIds[i].toString();
  //     await _preferences.setBool(storyContent, false);
  //   }
  // }

  //Story Content Timestamp Preferences
  static Future setStoryContentTimestamp(
      int storyContentId, int timestamp) async {
    String storyContentTime = storyContentId.toString() + "Time";
    await _preferences.setInt(storyContentTime, timestamp);
  }

  static int getStoryContentTimestamp(int storyContentId) {
    String storyContentTime = storyContentId.toString() + "Time";
    int randomNumber = math.Random().nextInt(24);
    final int storyContentTimestamp =
        _preferences.getInt(storyContentTime) ?? randomNumber;
    setStoryContentTimestamp(storyContentId, storyContentTimestamp);
    return storyContentTimestamp;
  }
}
