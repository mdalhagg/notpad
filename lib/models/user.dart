class User{
  String? username;
  String? password;
  bool? isLogin;

  User({ this.username, this.password, this.isLogin = false});

   User.fromJson(Map<String, dynamic> json) {
    username = json['name'];
    password = json['password'];
    isLogin = json['isLogin'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = username;
    data['password'] = password;
    data['isLogin'] = isLogin;
    return data;
  }



}