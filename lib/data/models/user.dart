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
}
