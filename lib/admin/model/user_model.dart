class UserModel {
  final String username;
  final String fullname;

  UserModel({
    required this.username,
    required this.fullname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["username"],
      fullname: json["full_name"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$username $fullname';
  }

  /// Check equality of two models
  bool isEqual(UserModel model) {
    return username == model.username;
  }

  @override
  String toString() => fullname;
}
