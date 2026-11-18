class User {
  int id;
  String name;
  String username;
  String email;
  String city;
  String zipcode;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.city,
    required this.zipcode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      city: json['address']['city'],
      zipcode: json['address']['zipcode'],
    );
  }
}