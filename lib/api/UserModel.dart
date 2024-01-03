class UserModel {
  int? userId;
  late String username;
  late String email;
  late String phone;
  late String imagePath;
  String? password;

  UserModel(
      {this.userId,
      required this.username,
      required this.email,
      required this.phone,
      required this.imagePath,
      this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    imagePath = json['imagePath'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['imagePath'] = this.imagePath;
    data['password'] = this.password;
    return data;
  }
}