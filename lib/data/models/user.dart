import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

///USER MODEL

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String profileImage;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profileImage,
  });

  static const User empty = User(
    id: 0,
    name: "John Wick",
    username: "johnwick",
    email: "johnwick@gmail.com",
    profileImage:
        "https://i4.hurimg.com/i/hurriyet/75/750x422/600965400f25443f0406f3ab.jpg",
  );

  /// Connect the generated [_$UserFromJson] function to the `fromJson`
  /// factory.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() =>
      'User: {id: $id, name: $name, username: $username, email: $email, profileImage: $profileImage}';
}
