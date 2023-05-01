class UserModel {
  String? email;
  String? name;
  String? phone;
  num? userGroup;
  String? registerDate;
  String? token;

  UserModel({
      this.email, 
      this.name, 
      this.phone, 
      this.userGroup, 
      this.registerDate, 
      this.token
  });

  UserModel.fromJson(dynamic json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    userGroup = json['userGroup'];
    registerDate = json['registerDate'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['name'] = name;
    map['phone'] = phone;
    map['userGroup'] = userGroup;
    map['registerDate'] = registerDate;
    map['token'] = token;
    return map;
  }
}