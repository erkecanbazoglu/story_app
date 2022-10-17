import '../../constants/sample_users.dart' as user_samples;
import '../models/user.dart';

class UserRepo {
  UserRepo();

  ///Get users data: Default: 10 (max: 10)
  List<User> getUsers({int amount = 10}) {
    List<User> users = user_samples.users;
    return users.sublist(0, amount);
  }
}
