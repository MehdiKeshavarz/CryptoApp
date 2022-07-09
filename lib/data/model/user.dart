class User {
  int id;
  String name;
  String username;
  String city;

  User(this.id, this.name, this.username, this.city);

  factory User.fromMapJson(Map<String, dynamic> JsonObject) {
    return User(
      JsonObject['id'],
      JsonObject['name'],
      JsonObject['username'],
      JsonObject['address']['city'],
    );
  }
}
